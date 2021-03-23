/obj/machinery/recharge_station
	name = "cyborg recharging station"
	icon = 'icons/obj/objects.dmi'
	icon_state = "borgcharger0"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 5 //internal circuitry
	//active_power_usage = 1000
	active_power_usage = 75000	//75 kW charging station
	var/mob/occupant = null

	New()
		..()
		build_icon()

	process()
		if(!(NOPOWER|BROKEN))
			return

		if(src.occupant)
			process_occupant()
		return 1


	allow_drop()
		return 0


	relaymove(mob/user as mob)
		if(user.stat)
			return
		src.go_out()
		return

	emp_act(severity)
		if(stat & (BROKEN|NOPOWER))
			..(severity)
			return
		if(occupant)
			occupant.emp_act(severity)
			go_out()
		..(severity)

	Bumped(var/mob/AM)
		move_inside(AM)

	proc
		build_icon()
			if(NOPOWER|BROKEN)
				if(src.occupant)
					icon_state = "borgcharger1"
				else
					icon_state = "borgcharger0"
			else
				icon_state = "borgcharger0"

		process_occupant()
			if(src.occupant)
				if (istype(occupant, /mob/living/silicon/robot))
					var/mob/living/silicon/robot/R = occupant
					if(R.module)
						R.module.respawn_consumable(R)
					if(!R.cell)
						return
					/*else if(R.cell.charge >= R.cell.maxcharge)
						R.cell.charge = R.cell.maxcharge
						return
					else
						R.cell.charge = min(R.cell.charge + 200, R.cell.maxcharge)
						return
					*/
					R.cell.give(active_power_usage*CELLRATE)

		go_out()
			if(!( src.occupant ))
				return
			//for(var/obj/O in src)
			//	O.loc = src.loc
			if (src.occupant.client)
				src.occupant.client.eye = src.occupant.client.mob
				src.occupant.client.perspective = MOB_PERSPECTIVE
			src.occupant.loc = src.loc
			src.occupant = null
			build_icon()
			src.use_power = 1
			use_power(0)	//update area power usage
			return


	verb
		move_eject()
			set category = "Object"
			set src in oview(1)
			if (usr.stat != 0)
				return
			src.go_out()
			add_fingerprint(usr)
			return

		move_inside(var/mob/user = usr)
			set category = "Object"
			set src in oview(1)
			if(!user)
				return

			if(!(istype(user, /mob/living/silicon/robot)))
				user << "<span class='notice'>Only non-organics may enter the recharger!</span>"
				return
			var/mob/living/silicon/robot/R = user

			if(R.stat == 2)
				//Whoever had it so that a borg with a dead cell can't enter this thing should be shot. --NEO
				return
			if(src.occupant)
				R << "<span class='notice'>The cell is already occupied!</span>"
				return
			if(!R.cell)
				R << "<span class='notice'>Without a powercell, you can't be recharged.</span>"
				//Make sure they actually HAVE a cell, now that they can get in while powerless. --NEO
				return
				R.stop_pulling()
			if(R.client)
				R.client.perspective = EYE_PERSPECTIVE
				R.client.eye = src
			R.loc = src
			occupant = R
			/*for(var/obj/O in src)
				O.loc = src.loc*/
			add_fingerprint(R)
			build_icon()
			src.use_power = 2
			use_power(0)	//update area power usage
			return