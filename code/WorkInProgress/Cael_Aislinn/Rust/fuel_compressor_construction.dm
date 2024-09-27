
//frame assembly

/obj/item/rust_fuel_compressor_frame
	name = "Fuel Compressor frame"
	icon = 'code/WorkInProgress/Cael_Aislinn/Rust/rust.dmi'
	icon_state = "fuel_compressor0"
	w_class = 4
	obj_flags = OBJ_FLAG_CONDUCT

/obj/item/rust_fuel_compressor_frame/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		new /obj/item/stack/sheet/plasteel(GET_TURF(loc), 12)
		qdel(src)
		return TRUE

	return ..()

/obj/item/rust_fuel_compressor_frame/proc/try_build(turf/on_wall)
	if(get_dist(on_wall, usr) > 1)
		return
	var/ndir = get_dir(usr, on_wall)
	if(!(ndir in GLOBL.cardinal))
		return
	var/turf/T = GET_TURF(usr)
	var/area/A = GET_AREA(usr)
	if(!istype(T, /turf/open/floor))
		to_chat(usr, SPAN_WARNING("Compressor cannot be placed on this spot."))
		return
	if(!A.requires_power || istype(A, /area/space))
		to_chat(usr, SPAN_WARNING("Compressor cannot be placed in this area."))
		return
	new /obj/machinery/rust_fuel_assembly_port(T, ndir, 1)
	qdel(src)

//construction steps
/obj/machinery/rust_fuel_compressor/New(turf/loc, ndir, building = 0)
	..()

	// offset 24 pixels in direction of dir
	// this allows the APC to be embedded in a wall, yet still inside an area
	if(building)
		dir = ndir
	else
		has_electronics = 3
		opened = 0
		locked = 0
		icon_state = "fuel_compressor1"

	//20% easier to read than apc code
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? 32 : -32)
	pixel_y = (dir & 3) ? (dir == 1 ? 32 : -32) : 0

/obj/machinery/rust_fuel_compressor/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE
	if(opened)
		to_chat(user, SPAN_WARNING("You must close the cover to swipe an ID card."))
		return FALSE

	flick("apc-spark", src)
	if(do_after(user, 6))
		if(prob(50))
			FEEDBACK_EMAG_GENERIC(user)
			emagged = TRUE
			locked = FALSE
		else
			to_chat(user, SPAN_WARNING("You fail to [locked ? "unlock" : "lock"] \the [src]."))
	return TRUE

/obj/machinery/rust_fuel_compressor/attack_tool(obj/item/tool, mob/user)
	if(iscrowbar(tool))
		if(opened)
			if(has_electronics & 1)
				to_chat(user, SPAN_NOTICE("You begin removing the circuit board from \the [src].")) //lpeters - fixed grammar issues
				playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
				if(do_after(user, 5 SECONDS))
					user.visible_message(
						SPAN_NOTICE("[user] removes the circuit board from \the [src]."),
						SPAN_NOTICE("You remove the circuit board from \the [src]."),
						SPAN_INFO("You hear something being pried apart.") // TODO: Possibly change this once all the tool sound messages are standardised.
					)
					has_electronics = 0
					new /obj/item/module/rust_fuel_compressor(loc)
					has_electronics &= ~1
			else
				to_chat(user, SPAN_NOTICE("You close the maintenance cover on \the [src]."))
				opened = FALSE
				icon_state = "fuel_compressor0"
		else
			if(compressed_matter > 0)
				to_chat(user, SPAN_WARNING("You cannot open the cover while there is compressed matter inside!"))
			else
				to_chat(user, SPAN_NOTICE("You open the maintenance cover on \the [src]."))
				opened = TRUE
				icon_state = "fuel_compressor1"
		return TRUE

	if(iscable(tool) && opened && !(has_electronics & 2))
		var/obj/item/stack/cable_coil/C = tool
		if(C.amount < 10)
			to_chat(user, SPAN_WARNING("You need more wires."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You start adding cables to \the [src]..."))
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 2 SECONDS) && C.amount >= 10)
			C.use(10)
			user.visible_message(
				SPAN_NOTICE("[user] adds cables to \the [src]."),
				SPAN_NOTICE("You add cables to \the [src].")
			)
			has_electronics &= 2
		return TRUE

	if(iswirecutter(tool) && opened && (has_electronics & 2))
		to_chat(user, SPAN_NOTICE("You begin to cut the cables from \the [src]..."))
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 5 SECONDS))
			new /obj/item/stack/cable_coil(loc, 10)
			user.visible_message(
				SPAN_NOTICE("[user] cuts the cabling inside \the [src]."),
				SPAN_NOTICE("You cut the cabling inside \the [src].")
			)
			has_electronics &= ~2
		return TRUE

	if(iswelder(tool) && opened && !has_electronics)
		var/obj/item/weldingtool/welder = tool
		if(welder.get_fuel() < 3)
			FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
			return
		to_chat(user, SPAN_NOTICE("You start welding \the [src]..."))
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, 5 SECONDS))
			if(isnull(src) || !welder.remove_fuel(3, user))
				return TRUE
			new /obj/item/rust_fuel_assembly_port_frame(loc)
			user.visible_message(
				SPAN_NOTICE("[user] cuts \the [src] away from the wall."),
				SPAN_NOTICE("You cut \the [src] away from the wall."),
				SPAN_WARNING("You hear welding.")
			)
			qdel(src)
		return TRUE

	return ..()

/obj/machinery/rust_fuel_compressor/attack_by(obj/item/I, mob/user)
	if(issilicon(user) && !in_range(src, user))
		attack_hand(user)
		return TRUE

	if(istype(I, /obj/item/card/id) || istype(I, /obj/item/pda)) // trying to unlock the interface with an ID card
		if(opened)
			to_chat(user, SPAN_WARNING("You must close the cover to swipe an ID card."))
		else
			if(allowed(usr))
				locked = !locked
				FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
				update_icon()
			else
				FEEDBACK_ACCESS_DENIED(user)
		return TRUE

	if(istype(I, /obj/item/module/rust_fuel_compressor) && opened && !(has_electronics & 1))
		to_chat(user, SPAN_NOTICE("You begin inserting the circuit board into \the [src]."))
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 1 SECOND))
			has_electronics &= 1
			to_chat(user, SPAN_NOTICE("You insert the circuit board into \the [src]."))
			qdel(I)
		return TRUE

	return ..()