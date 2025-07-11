/datum/round_event/prison_break
	announce_when = 50
	one_shot = TRUE

	var/releaseWhen = 25
	var/list/area/external/prisonAreas = list()

/datum/round_event/prison_break/setup()
	announce_when = rand(50, 60)
	releaseWhen = rand(20, 30)

	start_when = releaseWhen - 1
	end_when = releaseWhen + 1

/datum/round_event/prison_break/announce()
	if(length(prisonAreas))
		priority_announce(
			"[pick("Gr3y.T1d3 virus", "Malignant trojan")] detected in [station_name()] imprisonment subroutines. Recommend station AI involvement.",
			"Security Alert"
		)
	else
		world.log << "ERROR: Could not initate grey-tide. Unable find prison or brig area."
		kill()

/datum/round_event/prison_break/start()
	for_no_type_check(var/area/A, GLOBL.area_list)
		if(istype(A, /area/station/security/brig) || istype(A, /area/external/prison))
			prisonAreas.Add(A)

	if(length(prisonAreas))
		for_no_type_check(var/area/A, prisonAreas)
			for(var/obj/machinery/light/L in A)
				L.flicker(10)

/datum/round_event/prison_break/tick()
	if(active_for == releaseWhen)
		if(length(prisonAreas))
			for_no_type_check(var/area/A, prisonAreas)
				for(var/obj/machinery/power/apc/temp_apc in A)
					temp_apc.overload_lighting()

				for(var/obj/structure/closet/secure/brig/temp_closet in A)
					temp_closet.locked = 0
					temp_closet.icon_state = temp_closet.icon_closed

				for(var/obj/machinery/door/airlock/security/temp_airlock in A)
					temp_airlock.prison_open()

				for(var/obj/machinery/door/airlock/glass/security/temp_glassairlock in A)
					temp_glassairlock.prison_open()

				for(var/obj/machinery/door_timer/temp_timer in A)
					temp_timer.releasetime = 1