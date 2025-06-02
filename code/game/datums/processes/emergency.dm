/*
 * Emergency Process
 *
 * This is a funky hybrid of TG's emergency shuttle controller, the emergency section of the shuttle module from Heaven's Gate...
 * ... with Bay's optimisations but also running on the GoonPS.
 */
PROCESS_DEF(emergency)
	name = "Emergency"
	schedule_interval = 2 SECONDS

	var/datum/shuttle/ferry/emergency/shuttle
	var/list/datum/shuttle/ferry/escape_pod/escape_pods

	var/launch_time				// The time at which the shuttle will be launched.
	var/auto_recall = FALSE		// Whether the shuttle will be auto-recalled.
	var/auto_recall_time		// The time at which the shuttle will be auto-recalled.
	var/evac = FALSE			// Whether it's an evacuation or a crew transfer.
	var/wait_for_launch = FALSE	// Whether the shuttle is waiting to launch.
	var/autopilot = TRUE		// Whether the shuttle will automatically launch.

	var/deny_shuttle = FALSE	// Allows admins to prevent the shuttle from being called.
	var/departed = FALSE		// If the shuttle has left the station at least once.

	/*var/datum/announcement/priority/emergency_shuttle_docked = new(0, new_sound = sound('sound/AI/shuttledock.ogg'))
	var/datum/announcement/priority/emergency_shuttle_called = new(0, new_sound = sound('sound/AI/shuttlecalled.ogg'))
	var/datum/announcement/priority/emergency_shuttle_recalled = new(0, new_sound = sound('sound/AI/shuttlerecalled.ogg'))*/

/datum/process/emergency/do_work()
	if(wait_for_launch)
		if(auto_recall && world.time >= auto_recall_time)
			recall()
		if(world.time >= launch_time)	//time to launch the shuttle
			stop_launch_countdown()

			if(!shuttle.location)	//leaving from the station
				//launch the pods!
				for_no_type_check(var/datum/shuttle/ferry/escape_pod/pod, escape_pods)
					if(isnull(pod.arming_controller) || pod.arming_controller.armed)
						pod.launch(src)

			if(autopilot)
				shuttle.launch(src)

// Called when the shuttle has arrived.
/datum/process/emergency/proc/shuttle_arrived()
	if(!shuttle.location)	//at station
		if(autopilot)
			set_launch_countdown(SHUTTLE_LEAVETIME)	//get ready to return

			if(evac)
				priority_announce(
					"The emergency shuttle has docked with the station. You have approximately [round(estimate_launch_time() / 60, 1)] minutes to board the emergency shuttle.",
					null, 'sound/AI/shuttledock.ogg', ANNOUNCEMENT_TYPE_PRIORITY
				)
			else
				priority_announce(
					"The scheduled crew transfer shuttle has docked with the station. It will depart in approximately [round(estimate_launch_time() / 60, 1)] minutes.",
					null, 'sound/AI/shuttledock2.ogg', ANNOUNCEMENT_TYPE_PRIORITY
				)

		//arm the escape pods
		if(evac)
			for_no_type_check(var/datum/shuttle/ferry/escape_pod/pod, escape_pods)
				pod.arming_controller?.arm()

// Begins the launch countdown and sets the amount of time left until launch.
/datum/process/emergency/proc/set_launch_countdown(seconds)
	wait_for_launch = TRUE
	launch_time = world.time + seconds * 10

/datum/process/emergency/proc/stop_launch_countdown()
	wait_for_launch = FALSE

// Calls the shuttle for an emergency evacuation.
/datum/process/emergency/proc/call_evac()
	if(!can_call())
		return

	//set the launch timer
	autopilot = TRUE
	set_launch_countdown(get_shuttle_prep_time())
	auto_recall_time = rand(world.time + 300, launch_time - 300)

	//reset the shuttle transit time if we need to
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION

	evac = TRUE
	priority_announce(
		"An emergency evacuation shuttle has been called. It will arrive in approximately [round(estimate_arrival_time() / 60)] minutes.",
		null, 'sound/AI/shuttlecalled.ogg', ANNOUNCEMENT_TYPE_PRIORITY
	)
	for_no_type_check(var/area/station/hallway/hall, GLOBL.contactable_hallway_areas)
		hall.evac_alert()

	set_status_displays()

// Calls the shuttle for a routine crew transfer.
/datum/process/emergency/proc/call_transfer()
	if(!can_call())
		return

	//set the launch timer
	autopilot = TRUE
	set_launch_countdown(get_shuttle_prep_time())
	auto_recall_time = rand(world.time + 300, launch_time - 300)

	//reset the shuttle transit time if we need to
	shuttle.move_time = SHUTTLE_TRANSIT_DURATION

	priority_announce(
		"A crew transfer has been scheduled. The shuttle has been called. It will arrive in approximately [round(estimate_arrival_time() / 60)] minutes.",
		null, 'sound/AI/crewtransfer2.ogg', ANNOUNCEMENT_TYPE_PRIORITY
	)

	set_status_displays()

// Recalls the shuttle.
/datum/process/emergency/proc/recall()
	if(!can_recall())
		return

	wait_for_launch = FALSE
	shuttle.cancel_launch(src)

	if(evac)
		priority_announce("The emergency shuttle has been recalled.", null, 'sound/AI/shuttlerecalled.ogg', ANNOUNCEMENT_TYPE_PRIORITY)
		for_no_type_check(var/area/station/hallway/hall, GLOBL.contactable_hallway_areas)
			hall.evac_reset()
		evac = FALSE
	else
		priority_announce("The scheduled crew transfer has been cancelled.", null, 'sound/AI/shuttlerecall2.ogg', ANNOUNCEMENT_TYPE_PRIORITY)

	set_status_displays(TRUE)

// Sets the status displays.
/datum/process/emergency/proc/set_status_displays(recalled = FALSE)
	var/obj/machinery/computer/communications/comms = pick(GLOBL.communications_consoles)
	comms?.post_status(recalled ? "blank" : "shuttle")

/datum/process/emergency/proc/can_call()
	if(deny_shuttle)
		return FALSE
	if(shuttle.moving_status != SHUTTLE_IDLE || !shuttle.location)	//must be idle at centcom
		return FALSE
	if(wait_for_launch)	//already launching
		return FALSE
	return TRUE

/*
 * Only returns FALSE if it would absolutely make no sense to recall...
 * ... e.g. the shuttle is already at the station or wasn't called to begin with.
 * Other reasons for the shuttle not being recallable should be handled elsewhere
 */
/datum/process/emergency/proc/can_recall()
	if(shuttle.moving_status == SHUTTLE_INTRANSIT)	//if the shuttle is already in transit then it's too late
		return FALSE
	if(!shuttle.location)	//already at the station.
		return FALSE
	if(!wait_for_launch)	//we weren't going anywhere, anyways...
		return FALSE
	return TRUE

/datum/process/emergency/proc/get_shuttle_prep_time()
	// During mutiny rounds, the shuttle takes twice as long.
	//if(ticker && istype(ticker.mode,/datum/game_mode/mutiny))
	//	return SHUTTLE_PREPTIME * 3		//15 minutes
	return SHUTTLE_PREPTIME

/*
 * These procs are not really used by the process itself, but are for other parts of the...
 * ... game whose logic depends on the emergency shuttle.
 */
// Returns TRUE if the shuttle is docked at the station and waiting to leave.
/datum/process/emergency/proc/waiting_to_leave()
	if(shuttle.location)
		return FALSE	//not at station
	return (wait_for_launch || shuttle.moving_status != SHUTTLE_INTRANSIT)

// Helper proc so we don't have emergency_controller.shuttle.location everywhere.
/datum/process/emergency/proc/location()
	if(isnull(shuttle))
		return TRUE // If we dont have a shuttle datum, just act like it's at CentCom.
	return shuttle.location

// Returns the time left until the shuttle arrives at it's destination, in seconds.
/datum/process/emergency/proc/estimate_arrival_time()
	var/eta
	if(shuttle.has_arrive_time())
		//we are in transition and can get an accurate ETA
		eta = shuttle.arrive_time
	else
		//otherwise we need to estimate the arrival time using the scheduled launch time
		eta = launch_time + shuttle.move_time * 10 + shuttle.warmup_time * 10
	return (eta - world.time) / 10

// Returns the time left until the shuttle launches, in seconds.
/datum/process/emergency/proc/estimate_launch_time()
	return (launch_time - world.time) / 10

/datum/process/emergency/proc/has_eta()
	return (wait_for_launch || shuttle.moving_status != SHUTTLE_IDLE)

// Returns TRUE if the shuttle has gone to the station and come back at least once.
// Used for game completion checking purposes.
/datum/process/emergency/proc/returned()
	return (departed && shuttle.moving_status == SHUTTLE_IDLE && shuttle.location)	//we've gone to the station at least once, no longer in transit and are idle back at centcom

// Returns TRUE if the shuttle is not idle at centcom.
/datum/process/emergency/proc/online()
	if(!shuttle.location)	//not at centcom
		return TRUE
	if(wait_for_launch || shuttle.moving_status != SHUTTLE_IDLE)
		return TRUE
	return FALSE

// Returns TRUE if the shuttle is currently in transit (or just leaving) to the station.
/datum/process/emergency/proc/going_to_station()
	return (!shuttle.direction && shuttle.moving_status != SHUTTLE_IDLE)

// Returns TRUE if the shuttle is currently in transit (or just leaving) to centcom.
/datum/process/emergency/proc/going_to_centcom()
	return (shuttle.direction && shuttle.moving_status != SHUTTLE_IDLE)

/datum/process/emergency/proc/get_status_panel_eta()
	if(online())
		if(shuttle.has_arrive_time())
			var/timeleft = estimate_arrival_time()
			return "ETA-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]"

		if(waiting_to_leave())
			if(shuttle.moving_status == SHUTTLE_WARMUP)
				return "Departing..."

			var/timeleft = estimate_launch_time()
			return "ETD-[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]"

	return ""