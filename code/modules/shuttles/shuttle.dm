// Ported 'shuttles' module from Heaven's Gate - NSS Eternal...
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo

//These lists are populated in /datum/shuttle_controller/New()
//Shuttle controller is instantiated in master_controller.dm.

//shuttle moving state defines are in setup.dm

/datum/shuttle
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE

	var/docking_controller_tag	= null//tag of the controller used to coordinate docking
	var/datum/computer/file/embedded_program/docking/docking_controller	//the controller itself. (micro-controller, not game controller)

	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping

/datum/shuttle/proc/short_jump(area/origin, area/destination)
	if(moving_status != SHUTTLE_IDLE)
		return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time * 10)
		if(moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		moving_status = SHUTTLE_INTRANSIT //shouldn't matter but just to be safe
		move(origin, destination)
		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/long_jump(area/departing, area/destination, area/interim, travel_time, direction)
	//to_world("shuttle/long_jump: departing=[departing], destination=[destination], interim=[interim], travel_time=[travel_time]")
	if(moving_status != SHUTTLE_IDLE)
		return

	//it would be cool to play a sound here
	moving_status = SHUTTLE_WARMUP
	spawn(warmup_time * 10)
		if(moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		arrive_time = world.time + travel_time * 10
		moving_status = SHUTTLE_INTRANSIT
		move(departing, interim, direction)

		while(world.time < arrive_time)
			sleep(5)

		move(interim, destination, direction)
		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/dock()
	if(isnull(docking_controller))
		return

	var/dock_target = current_dock_target()
	if(isnull(dock_target))
		return

	docking_controller.initiate_docking(dock_target)

/datum/shuttle/proc/undock()
	if(isnull(docking_controller))
		return
	docking_controller.initiate_undocking()

/datum/shuttle/proc/current_dock_target()
	return null

/datum/shuttle/proc/skip_docking_checks()
	if(isnull(docking_controller) || isnull(current_dock_target()))
		return 1	//shuttles without docking controllers or at locations without docking ports act like old-style shuttles
	return 0

//just moves the shuttle from A to B, if it can be moved
//A note to anyone overriding move in a subtype. move() must absolutely not, under any circumstances, fail to move the shuttle.
//If you want to conditionally cancel shuttle launches, that logic must go in short_jump() or long_jump()
/datum/shuttle/proc/move(area/origin, area/destination, direction = null)
	//to_world("move_shuttle() called for [shuttle_tag] leaving [origin] en route to [destination].")

	//to_world("area_coming_from: [origin]")
	//to_world("destination: [destination]")

	if(origin == destination)
		//to_world("cancelling move, shuttle will overlap.")
		return

	if(isnotnull(docking_controller) && !docking_controller.undocked())
		docking_controller.force_undock()

	var/list/turf/dstturfs = list()
	var/throwy = world.maxy

	for_no_type_check(var/turf/T, destination.turf_list)
		dstturfs.Add(T)
		if(T.y < throwy)
			throwy = T.y

	for_no_type_check(var/turf/T, dstturfs)
		var/turf/D = locate(T.x, throwy - 1, 1)
		for_no_type_check(var/atom/movable/mover, T)
			if(!HAS_ATOM_FLAGS(mover, ATOM_FLAG_UNSIMULATED))
				mover.Move(D)

	for(var/mob/living/carbon/bug in destination)
		bug.gib()

	for(var/mob/living/simple/pest in destination)
		pest.gib()

	origin.move_contents_to(destination, direction = direction)

	for(var/mob/M in destination)
		if(isnotnull(M.client))
			spawn(0)
				if(isnotnull(M.buckled))
					to_chat(M, SPAN_WARNING("Sudden acceleration presses you into your chair!"))
					shake_camera(M, 3, 1)
				else
					to_chat(M, SPAN_WARNING("The floor lurches beneath you!"))
					shake_camera(M, 10, 1)
		if(iscarbon(M))
			if(isnull(M.buckled))
				M.Weaken(3)

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)