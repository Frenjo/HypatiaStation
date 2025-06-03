// Ported 'shuttles' module from Heaven's Gate - NSS Eternal, 22/11/2019...
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo

/datum/shuttle/ferry/emergency
	//pass

/datum/shuttle/ferry/emergency/arrived()
	if(istype(in_use, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = in_use
		C.reset_authorisation()

	global.PCemergency.shuttle_arrived()

/datum/shuttle/ferry/emergency/long_jump(area/departing, area/destination, area/interim, travel_time, direction)
	//to_world("shuttle/ferry/emergency/long_jump: departing=[departing], destination=[destination], interim=[interim], travel_time=[travel_time]")
	if(!location)
		travel_time = SHUTTLE_TRANSIT_DURATION_RETURN
	else
		travel_time = SHUTTLE_TRANSIT_DURATION

	//update move_time and launch_time so we get correct ETAs
	move_time = travel_time
	global.PCemergency.launch_time = world.time

	..()

/datum/shuttle/ferry/emergency/move(area/origin, area/destination)
	..(origin, destination)

	if(origin == area_station)	//leaving the station
		global.PCemergency.departed = TRUE

		if(global.PCemergency.evac)
			priority_announce(
				"The emergency shuttle has left the station. Estimate [round(global.PCemergency.estimate_arrival_time() / 60, 1)] minutes until the shuttle docks at Central Command.",
				type = ANNOUNCEMENT_TYPE_PRIORITY
			)
		else
			priority_announce(
				"The crew transfer shuttle has left the station. Estimate [round(global.PCemergency.estimate_arrival_time() / 60, 1)] minutes until the shuttle docks at Central Command.",
				type = ANNOUNCEMENT_TYPE_PRIORITY
			)

/datum/shuttle/ferry/emergency/can_launch(user)
	if(istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user
		if(!C.has_authorisation())
			return 0
	return ..()

/datum/shuttle/ferry/emergency/can_force(user)
	if(istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user

		//initiating or cancelling a launch ALWAYS requires authorisation, but if we are already set to launch anyways than forcing does not.
		//this is so that people can force launch if the docking controller cannot safely undock without needing X heads to swipe.
		if(!(process_state == WAIT_LAUNCH || C.has_authorisation()))
			return 0
	return ..()

/datum/shuttle/ferry/emergency/can_cancel(user)
	if(istype(user, /obj/machinery/computer/shuttle_control/emergency))
		var/obj/machinery/computer/shuttle_control/emergency/C = user
		if(!C.has_authorisation())
			return 0
	return ..()

/datum/shuttle/ferry/emergency/launch(user)
	if(!can_launch(user))
		return

	if(istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if(global.PCemergency.autopilot)
			global.PCemergency.autopilot = FALSE
			to_world(SPAN_INFO_B("Alert: The shuttle autopilot has been overridden. Launch sequence initiated!"))

	..(user)

/datum/shuttle/ferry/emergency/force_launch(user)
	if(!can_force(user))
		return

	if(istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if(global.PCemergency.autopilot)
			global.PCemergency.autopilot = FALSE
			to_world(SPAN_INFO_B("Alert: The shuttle autopilot has been overridden. Bluespace drive engaged!"))

	..(user)

/datum/shuttle/ferry/emergency/cancel_launch(user)
	if(!can_cancel(user))
		return

	if(istype(user, /obj/machinery/computer/shuttle_control/emergency))	//if we were given a command by an emergency shuttle console
		if(global.PCemergency.autopilot)
			global.PCemergency.autopilot = FALSE
			to_world(SPAN_INFO_B("Alert: The shuttle autopilot has been overridden. Launch sequence aborted!"))

	..(user)