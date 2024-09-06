
//frame assembly

/obj/item/rust_fuel_assembly_port_frame
	name = "Fuel Assembly Port frame"
	icon = 'code/WorkInProgress/Cael_Aislinn/Rust/rust.dmi'
	icon_state = "port2"
	w_class = 4
	obj_flags = OBJ_FLAG_CONDUCT

/obj/item/rust_fuel_assembly_port_frame/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		new /obj/item/stack/sheet/plasteel(get_turf(src), 12)
		qdel(src)
		return TRUE

	return ..()

/obj/item/rust_fuel_assembly_port_frame/proc/try_build(turf/on_wall)
	if (get_dist(on_wall,usr)>1)
		return
	var/ndir = get_dir(usr,on_wall)
	if (!(ndir in GLOBL.cardinal))
		return
	var/turf/loc = get_turf(usr)
	var/area/A = loc.loc
	if (!istype(loc, /turf/open/floor))
		usr << "\red Port cannot be placed on this spot."
		return
	if (!A.requires_power || istype(A, /area/space))
		usr << "\red Port cannot be placed in this area."
		return
	new /obj/machinery/rust_fuel_assembly_port(loc, ndir, 1)
	qdel(src)

//construction steps
/obj/machinery/rust_fuel_assembly_port/New(turf/loc, var/ndir, var/building=0)
	..()

	// offset 24 pixels in direction of dir
	// this allows the APC to be embedded in a wall, yet still inside an area
	if (building)
		dir = ndir
	else
		has_electronics = 3
		opened = 0
		icon_state = "port0"

	//20% easier to read than apc code
	pixel_x = (dir & 3)? 0 : (dir == 4 ? 32 : -32)
	pixel_y = (dir & 3)? (dir ==1 ? 32 : -32) : 0

/obj/machinery/rust_fuel_assembly_port/attackby(obj/item/W, mob/user)

	if (issilicon(user) && get_dist(src,user)>1)
		return src.attack_hand(user)
	if(iscrowbar(W))
		if(opened)
			if(has_electronics & 1)
				playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
				user << "You begin removing the circuitboard" //lpeters - fixed grammar issues
				if(do_after(user, 50))
					user.visible_message(\
						"\red [user.name] has removed the circuitboard from [src.name]!",\
						"\blue You remove the circuitboard.")
					has_electronics = 0
					new /obj/item/module/rust_fuel_port(loc)
					has_electronics &= ~1
			else
				opened = 0
				icon_state = "port0"
				user << "\blue You close the maintenance cover."
		else
			if(cur_assembly)
				user << "\red You cannot open the cover while there is a fuel assembly inside."
			else
				opened = 1
				user << "\blue You open the maintenance cover."
				icon_state = "port2"
		return

	else if(iscable(W) && opened && !(has_electronics & 2))
		var/obj/item/stack/cable_coil/C = W
		if(C.amount < 10)
			user << "\red You need more wires."
			return
		user << "You start adding cables to the frame..."
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 20) && C.amount >= 10)
			C.use(10)
			user.visible_message(\
				"\red [user.name] has added cables to the port frame!",\
				"You add cables to the port frame.")
			has_electronics &= 2
		return

	else if(iswirecutter(W) && opened && (has_electronics & 2))
		user << "You begin to cut the cables..."
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 50))
			new /obj/item/stack/cable_coil(loc,10)
			user.visible_message(\
				"\red [user.name] cut the cabling inside the port.",\
				"You cut the cabling inside the port.")
			has_electronics &= ~2
		return

	else if (istype(W, /obj/item/module/rust_fuel_port) && opened && !(has_electronics & 1))
		user << "You trying to insert the port control board into the frame..."
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		if(do_after(user, 10))
			has_electronics &= 1
			user << "You place the port control board inside the frame."
			qdel(W)
		return

	else if(iswelder(W) && opened && !has_electronics)
		var/obj/item/weldingtool/WT = W
		if (WT.get_fuel() < 3)
			FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
			return
		user << "You start welding the port frame..."
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		if(do_after(user, 50))
			if(!src || !WT.remove_fuel(3, user)) return
			new /obj/item/rust_fuel_assembly_port_frame(loc)
			user.visible_message(
				SPAN_WARNING("[src] has been cut away from the wall by [user.name]."),
				"You detached the port frame.",
				SPAN_WARNING("You hear welding.")
			)
			qdel(src)
		return

	..()
