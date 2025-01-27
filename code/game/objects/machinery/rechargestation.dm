/obj/machinery/recharge_station
	name = "cyborg recharging station"
	icon = 'icons/obj/machines/rechargers.dmi'
	icon_state = "borgcharger0"
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 5, // Internal circuitry.
		USE_POWER_ACTIVE = 75000 // 75 kW charging station.
	)

	var/mob/occupant = null

/obj/machinery/recharge_station/New()
	. = ..()
	build_icon()

/obj/machinery/recharge_station/process()
	if(stat & (BROKEN | NOPOWER))
		return

	if(occupant)
		process_occupant()
	return 1

/obj/machinery/recharge_station/allow_drop()
	return 0

/obj/machinery/recharge_station/relaymove(mob/user)
	if(user.stat)
		return
	go_out()

/obj/machinery/recharge_station/emp_act(severity)
	if(stat & (BROKEN | NOPOWER))
		..(severity)
		return
	if(isnotnull(occupant))
		occupant.emp_act(severity)
		go_out()
	..(severity)

/obj/machinery/recharge_station/Bumped(mob/AM)
	move_inside(AM)

/obj/machinery/recharge_station/proc/build_icon()
	if(stat & (BROKEN | NOPOWER))
		if(isnotnull(occupant))
			icon_state = "borgcharger1"
		else
			icon_state = "borgcharger0"
	else
		icon_state = "borgcharger0"

/obj/machinery/recharge_station/proc/process_occupant()
	if(occupant)
		if(isrobot(occupant))
			var/mob/living/silicon/robot/R = occupant
			R.module?.respawn_consumable(R)
			if(isnull(R.cell))
				return
			/*else if(R.cell.charge >= R.cell.maxcharge)
				R.cell.charge = R.cell.maxcharge
				return
			else
				R.cell.charge = min(R.cell.charge + 200, R.cell.maxcharge)
				return
			*/
			R.cell.give(power_usage[USE_POWER_ACTIVE] * CELLRATE)

/obj/machinery/recharge_station/proc/go_out()
	if(isnull(occupant))
		return
	//for(var/obj/O in src)
	//	O.forceMove(loc)
	if(isnotnull(occupant.client))
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.forceMove(loc)
	occupant = null
	build_icon()
	update_power_state(USE_POWER_IDLE) //update area power usage

/obj/machinery/recharge_station/verb/move_eject()
	set category = PANEL_OBJECT
	set src in oview(1)

	if(usr.stat != 0)
		return
	go_out()
	add_fingerprint(usr)

/obj/machinery/recharge_station/verb/move_inside(mob/user = usr)
	set category = PANEL_OBJECT
	set src in oview(1)

	if(isnull(user))
		return

	if(!isrobot(user))
		to_chat(user, SPAN_INFO_B("Only non-organics may enter the recharger!"))
		return

	var/mob/living/silicon/robot/R = user
	if(R.stat == DEAD)
		//Whoever had it so that a borg with a dead cell can't enter this thing should be shot. --NEO
		return
	if(isnotnull(occupant))
		to_chat(R, SPAN_INFO_B("The cell is already occupied!"))
		return
	if(isnull(R.cell))
		to_chat(R, SPAN_INFO("Without a powercell, you can't be recharged."))
		//Make sure they actually HAVE a cell, now that they can get in while powerless. --NEO
		return
	R.stop_pulling()
	if(isnotnull(R.client))
		R.client.perspective = EYE_PERSPECTIVE
		R.client.eye = src
	R.forceMove(src)
	occupant = R
	/*for(var/obj/O in src)
		O.forceMove(loc)*/
	add_fingerprint(R)
	build_icon()
	update_power_state(USE_POWER_ACTIVE) //update area power usage