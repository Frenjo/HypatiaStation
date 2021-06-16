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

/obj/machinery/recharge_station/New()
	..()
	build_icon()

/obj/machinery/recharge_station/process()
	if(!(NOPOWER|BROKEN))
		return

	if(src.occupant)
		process_occupant()
	return 1

/obj/machinery/recharge_station/allow_drop()
	return 0

/obj/machinery/recharge_station/relaymove(mob/user as mob)
	if(user.stat)
		return
	src.go_out()
	return

/obj/machinery/recharge_station/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(occupant)
		occupant.emp_act(severity)
		go_out()
	..(severity)

/obj/machinery/recharge_station/Bumped(mob/AM)
	move_inside(AM)

/obj/machinery/recharge_station/proc/build_icon()
	if(NOPOWER|BROKEN)
		if(src.occupant)
			icon_state = "borgcharger1"
		else
			icon_state = "borgcharger0"
	else
		icon_state = "borgcharger0"

/obj/machinery/recharge_station/proc/process_occupant()
	if(src.occupant)
		if(isrobot(occupant))
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
			R.cell.give(active_power_usage * CELLRATE)

/obj/machinery/recharge_station/proc/go_out()
	if(!(src.occupant))
		return
	//for(var/obj/O in src)
	//	O.loc = src.loc
	if(src.occupant.client)
		src.occupant.client.eye = src.occupant.client.mob
		src.occupant.client.perspective = MOB_PERSPECTIVE
	src.occupant.loc = src.loc
	src.occupant = null
	build_icon()
	src.use_power = 1
	use_power(0)	//update area power usage
	return


/obj/machinery/recharge_station/verb/move_eject()
	set category = "Object"
	set src in oview(1)
	if(usr.stat != 0)
		return
	src.go_out()
	add_fingerprint(usr)
	return

/obj/machinery/recharge_station/verb/move_inside(mob/user = usr)
	set category = "Object"
	set src in oview(1)
	if(!user)
		return

	if(!(isrobot(user)))
		to_chat(user, SPAN_NOTICE("Only non-organics may enter the recharger!"))
		return

	var/mob/living/silicon/robot/R = user
	if(R.stat == 2)
		//Whoever had it so that a borg with a dead cell can't enter this thing should be shot. --NEO
		return
	if(src.occupant)
		to_chat(R, SPAN_NOTICE("The cell is already occupied!"))
		return
	if(!R.cell)
		to_chat(R, SPAN_NOTICE("Without a powercell, you can't be recharged."))
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