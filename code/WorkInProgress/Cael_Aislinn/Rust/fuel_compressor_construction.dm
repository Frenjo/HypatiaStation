
//frame assembly

/obj/item/rust_fuel_compressor_frame
	name = "Fuel Compressor frame"
	icon = 'code/WorkInProgress/Cael_Aislinn/Rust/rust.dmi'
	icon_state = "fuel_compressor0"
	w_class = 4
	flags = CONDUCT

/obj/item/rust_fuel_compressor_frame/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/wrench))
		new /obj/item/stack/sheet/plasteel(get_turf(src.loc), 12)
		qdel(src)
		return
	..()

/obj/item/rust_fuel_compressor_frame/proc/try_build(turf/on_wall)
	if(get_dist(on_wall, usr) > 1)
		return
	var/ndir = get_dir(usr, on_wall)
	if(!(ndir in GLOBL.cardinal))
		return
	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if(!istype(loc, /turf/simulated/floor))
		to_chat(usr, SPAN_WARNING("Compressor cannot be placed on this spot."))
		return
	if(!A.requires_power || istype(A, /area/space))
		to_chat(usr, SPAN_WARNING("Compressor cannot be placed in this area."))
		return
	new /obj/machinery/rust_fuel_assembly_port(loc, ndir, 1)
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

/obj/machinery/rust_fuel_compressor/attackby(obj/item/W, mob/user)
	if(issilicon(user) && !in_range(src, user))
		return src.attack_hand(user)
	if(istype(W, /obj/item/crowbar))
		if(opened)
			if(has_electronics & 1)
				playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
				user << "You begin removing the circuitboard" //lpeters - fixed grammar issues
				if(do_after(user, 50))
					user.visible_message(
						SPAN_WARNING("[user.name] has removed the circuitboard from [src.name]!"),
						SPAN_INFO("You remove the circuitboard board.")
					)
					has_electronics = 0
					new /obj/item/module/rust_fuel_compressor(loc)
					has_electronics &= ~1
			else
				opened = 0
				icon_state = "fuel_compressor0"
				to_chat(user, SPAN_INFO("You close the maintenance cover."))
		else
			if(compressed_matter > 0)
				to_chat(user, SPAN_WARNING("You cannot open the cover while there is compressed matter inside."))
			else
				opened = 1
				to_chat(user, SPAN_INFO("You open the maintenance cover."))
				icon_state = "fuel_compressor1"
		return

	else if(istype(W, /obj/item/card/id) || istype(W, /obj/item/pda))			// trying to unlock the interface with an ID card
		if(opened)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else
			if(src.allowed(usr))
				locked = !locked
				to_chat(user, "You [ locked ? "lock" : "unlock"] the compressor interface.")
				update_icon()
			else
				FEEDBACK_ACCESS_DENIED(user)
		return

	else if(istype(W, /obj/item/card/emag) && !emagged)		// trying to unlock with an emag card
		if(opened)
			to_chat(user, "You must close the cover to swipe an ID card.")
		else
			flick("apc-spark", src)
			if(do_after(user, 6))
				if(prob(50))
					emagged = 1
					locked = 0
					to_chat(user, "You emag the port interface.")
				else
					to_chat(user, "You fail to [ locked ? "unlock" : "lock"] the compressor interface.")
		return

	else if(istype(W, /obj/item/stack/cable_coil) && opened && !(has_electronics & 2))
		var/obj/item/stack/cable_coil/C = W
		if(C.amount < 10)
			to_chat(user, SPAN_WARNING("You need more wires."))
			return
		to_chat(user, "You start adding cables to the compressor frame...")
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 20) && C.amount >= 10)
			C.use(10)
			user.visible_message(
				SPAN_WARNING("[user.name] has added cables to the compressor frame!"),
				"You add cables to the port frame."
			)
			has_electronics &= 2
		return

	else if(istype(W, /obj/item/wirecutters) && opened && (has_electronics & 2))
		to_chat(user, "You begin to cut the cables...")
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 50))
			new /obj/item/stack/cable_coil(loc,10)
			user.visible_message(
				SPAN_WARNING("[user.name] cut the cabling inside the compressor."),
				"You cut the cabling inside the port."
			)
			has_electronics &= ~2
		return

	else if(istype(W, /obj/item/module/rust_fuel_compressor) && opened && !(has_electronics & 1))
		to_chat(user, "You trying to insert the circuitboard into the frame...")
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 10))
			has_electronics &= 1
			to_chat(user, "You place the circuitboard inside the frame.")
			qdel(W)
		return

	else if(istype(W, /obj/item/weldingtool) && opened && !has_electronics)
		var/obj/item/weldingtool/WT = W
		if(WT.get_fuel() < 3)
			to_chat(user, SPAN_INFO("You need more welding fuel to complete this task."))
			return
		user << "You start welding the compressor frame..."
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, 50))
			if(!src || !WT.remove_fuel(3, user))
				return
			new /obj/item/rust_fuel_assembly_port_frame(loc)
			user.visible_message(
				SPAN_WARNING("[src] has been cut away from the wall by [user.name]."),
				"You detached the compressor frame.",
				SPAN_WARNING("You hear welding.")
			)
			qdel(src)
		return
	..()