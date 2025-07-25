/obj/structure/door_assembly
	icon = 'icons/obj/doors/door_assembly.dmi'

	name = "airlock assembly"
	icon_state = "door_as_0"
	anchored = FALSE
	density = TRUE
	var/state = 0
	var/base_icon_state = ""
	var/base_name = "Airlock"
	var/obj/item/airlock_electronics/electronics = null
	var/airlock_type = /obj/machinery/door/airlock //the type path of the airlock once completed
	var/glass_type = /obj/machinery/door/airlock/glass
	var/glass = 0 // 0 = glass can be installed. -1 = glass can't be installed. 1 = glass is already installed. Text = mineral plating is installed instead.
	var/created_name = null

/obj/structure/door_assembly/initialise()
	. = ..()
	update_state()

/obj/structure/door_assembly/door_assembly_com
	base_icon_state = "com"
	base_name = "Command Airlock"
	airlock_type = /obj/machinery/door/airlock/command
	glass_type = /obj/machinery/door/airlock/glass/command

/obj/structure/door_assembly/door_assembly_sec
	base_icon_state = "sec"
	base_name = "Security Airlock"
	airlock_type = /obj/machinery/door/airlock/security
	glass_type = /obj/machinery/door/airlock/glass/security

/obj/structure/door_assembly/door_assembly_eng
	base_icon_state = "eng"
	base_name = "Engineering Airlock"
	airlock_type = /obj/machinery/door/airlock/engineering
	glass_type = /obj/machinery/door/airlock/glass/engineering

/obj/structure/door_assembly/door_assembly_min
	base_icon_state = "min"
	base_name = "Mining Airlock"
	airlock_type = /obj/machinery/door/airlock/mining
	glass_type = /obj/machinery/door/airlock/glass/mining

/obj/structure/door_assembly/door_assembly_atmo
	base_icon_state = "atmo"
	base_name = "Atmospherics Airlock"
	airlock_type = /obj/machinery/door/airlock/atmos
	glass_type = /obj/machinery/door/airlock/glass/atmos

/obj/structure/door_assembly/door_assembly_research
	base_icon_state = "res"
	base_name = "Research Airlock"
	airlock_type = /obj/machinery/door/airlock/research
	glass_type = /obj/machinery/door/airlock/glass/research

/obj/structure/door_assembly/door_assembly_science
	base_icon_state = "sci"
	base_name = "Science Airlock"
	airlock_type = /obj/machinery/door/airlock/science
	glass_type = /obj/machinery/door/airlock/glass/science

/obj/structure/door_assembly/door_assembly_med
	base_icon_state = "med"
	base_name = "Medical Airlock"
	airlock_type = /obj/machinery/door/airlock/medical
	glass_type = /obj/machinery/door/airlock/glass/medical

/obj/structure/door_assembly/door_assembly_mai
	base_icon_state = "mai"
	base_name = "Maintenance Airlock"
	airlock_type = /obj/machinery/door/airlock/maintenance
	glass = -1

/obj/structure/door_assembly/door_assembly_ext
	base_icon_state = "ext"
	base_name = "External Airlock"
	airlock_type = /obj/machinery/door/airlock/external
	glass = -1

/obj/structure/door_assembly/door_assembly_fre
	base_icon_state = "fre"
	base_name = "Freezer Airlock"
	airlock_type = /obj/machinery/door/airlock/freezer
	glass = -1

/obj/structure/door_assembly/door_assembly_hatch
	base_icon_state = "hatch"
	base_name = "Airtight Hatch"
	airlock_type = /obj/machinery/door/airlock/hatch
	glass = -1

/obj/structure/door_assembly/door_assembly_mhatch
	base_icon_state = "mhatch"
	base_name = "Airtight Maintenance Hatch"
	airlock_type = /obj/machinery/door/airlock/hatch/maintenance
	glass = -1

/obj/structure/door_assembly/door_assembly_highsecurity // Borrowing this until WJohnston makes sprites for the assembly
	base_icon_state = "highsec"
	base_name = "High-Tech Security Airlock"
	airlock_type = /obj/machinery/door/airlock/highsecurity
	glass = -1

/obj/structure/door_assembly/multi_tile
	icon = 'icons/obj/doors/door_assembly2x1.dmi'
	dir = EAST
	var/width = 1

/*Temporary until we get sprites.
	glass_type = "/multi_tile/glass"
	airlock_type = "/multi_tile/maint"
	glass = 1*/
	base_icon_state = "g" //Remember to delete this line when reverting "glass" var to 1.
	airlock_type = /obj/machinery/door/airlock/multi_tile/glass
	glass = -1 //To prevent bugs in deconstruction process.

/obj/structure/door_assembly/multi_tile/initialise()
	. = ..()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

/obj/structure/door_assembly/multi_tile/Move()
	. = ..()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

/obj/structure/door_assembly/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/pen))
		var/t = copytext(stripped_input(user, "Enter the name for the door.", src.name, src.created_name),1,MAX_NAME_LEN)
		if(!t)	return
		if(!in_range(src, usr) && src.loc != usr)	return
		created_name = t
		return

	if(iswelder(W) && ( (istext(glass)) || (glass == 1) || (!anchored) ))
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			playsound(src, 'sound/items/Welder2.ogg', 50, 1)
			if(istext(glass))
				user.visible_message("[user] welds the [glass] plating off the airlock assembly.", "You start to weld the [glass] plating off the airlock assembly.")
				if(do_after(user, 40))
					if(!src || !WT.isOn()) return
					user << "\blue You welded the [glass] plating off!"
					var/M = text2path("/obj/item/stack/sheet/[glass]")
					new M(src.loc, 2)
					glass = 0
			else if(glass == 1)
				user.visible_message("[user] welds the glass panel out of the airlock assembly.", "You start to weld the glass panel out of the airlock assembly.")
				if(do_after(user, 40))
					if(!src || !WT.isOn()) return
					user << "\blue You welded the glass panel out!"
					new /obj/item/stack/sheet/glass/reinforced(src.loc)
					glass = 0
			else if(!anchored)
				user.visible_message("[user] dissassembles the airlock assembly.", "You start to dissassemble the airlock assembly.")
				if(do_after(user, 40))
					if(!src || !WT.isOn()) return
					user << "\blue You dissasembled the airlock assembly!"
					new /obj/item/stack/sheet/steel(src.loc, 4)
					qdel (src)
		else
			return

	else if(iswrench(W) && state == 0)
		playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
		if(anchored)
			user.visible_message("[user] unsecures the airlock assembly from the floor.", "You start to unsecure the airlock assembly from the floor.")
		else
			user.visible_message("[user] secures the airlock assembly to the floor.", "You start to secure the airlock assembly to the floor.")

		if(do_after(user, 40))
			if(!src) return
			user << "\blue You [anchored? "un" : ""]secured the airlock assembly!"
			anchored = !anchored

	else if(iscable(W) && state == 0 && anchored )
		var/obj/item/stack/cable_coil/coil = W
		user.visible_message("[user] wires the airlock assembly.", "You start to wire the airlock assembly.")
		if(do_after(user, 40))
			if(!src) return
			coil.use(1)
			src.state = 1
			user << "\blue You wire the Airlock!"

	else if(iswirecutter(W) && state == 1 )
		playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
		user.visible_message("[user] cuts the wires from the airlock assembly.", "You start to cut the wires from airlock assembly.")

		if(do_after(user, 40))
			if(!src) return
			user << "\blue You cut the airlock wires.!"
			new/obj/item/stack/cable_coil(src.loc, 1)
			src.state = 0

	else if(istype(W, /obj/item/airlock_electronics) && state == 1 && W:icon_state != "door_electronics_smoked")
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		user.visible_message("[user] installs the electronics into the airlock assembly.", "You start to install electronics into the airlock assembly.")
		user.drop_item()
		W.forceMove(src)

		if(do_after(user, 40))
			if(!src) return
			user << "\blue You installed the airlock electronics!"
			src.state = 2
			src.name = "Near finished Airlock Assembly"
			src.electronics = W
		else
			W.forceMove(loc)

	else if(iscrowbar(W) && state == 2 )
		playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
		user.visible_message("[user] removes the electronics from the airlock assembly.", "You start to install electronics into the airlock assembly.")

		if(do_after(user, 40))
			if(!src) return
			user << "\blue You removed the airlock electronics!"
			src.state = 1
			src.name = "Wired Airlock Assembly"
			var/obj/item/airlock_electronics/ae
			if (!electronics)
				ae = new/obj/item/airlock_electronics( src.loc )
			else
				ae = electronics
				electronics = null
				ae.forceMove(loc)

	else if(istype(W, /obj/item/stack/sheet) && !glass)
		var/obj/item/stack/sheet/S = W
		if (S)
			if (S.amount>=1)
				if(istype(S, /obj/item/stack/sheet/glass/reinforced))
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					user.visible_message("[user] adds [S.name] to the airlock assembly.", "You start to install [S.name] into the airlock assembly.")
					if(do_after(user, 40))
						user << "\blue You installed reinforced glass windows into the airlock assembly!"
						S.use(1)
						glass = 1
				else if(istype(S, /obj/item/stack/sheet) && S.material?.can_make_airlock)
					if(S.amount >= 2)
						playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
						user.visible_message(
							"[user] adds [S.name] to the airlock assembly.",
							"You start to install [S.name] into the airlock assembly."
						)
						if(do_after(user, 4 SECONDS))
							user << "\blue You installed the [lowertext(S.material.name)] plating into the airlock assembly!"
							S.use(2)
							glass = "[lowertext(S.material.name)]"

	else if(isscrewdriver(W) && state == 2 )
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		user << "\blue Now finishing the airlock."

		if(do_after(user, 40))
			if(!src) return
			user << "\blue You finish the airlock!"
			var/path
			if(istext(glass))
				path = text2path("/obj/machinery/door/airlock/[glass]")
			else if(glass == 1)
				path = glass_type
			else
				path = airlock_type
			var/obj/machinery/door/airlock/door = new path(src.loc)
			door.assembly_type = type
			door.electronics = src.electronics
			if(src.electronics.one_access)
				door.req_access = null
				door.req_one_access = src.electronics.conf_access
			else
				door.req_access = src.electronics.conf_access
			if(created_name)
				door.name = created_name
			else
				door.name = "[istext(glass) ? "[glass] airlock" : base_name]"
			electronics.forceMove(door)
			qdel(src)
	else
		..()
	update_state()

/obj/structure/door_assembly/proc/update_state()
	icon_state = "door_as_[glass == 1 ? "g" : ""][istext(glass) ? glass : base_icon_state][state]"
	name = ""
	switch (state)
		if(0)
			if (anchored)
				name = "Secured "
		if(1)
			name = "Wired "
		if(2)
			name = "Near Finished "
	name += "[glass == 1 ? "Window " : ""][istext(glass) ? "[glass] Airlock" : base_name] Assembly"