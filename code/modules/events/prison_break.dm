/datum/event/prison_break
	announceWhen = 50
	oneShot = TRUE

	var/releaseWhen = 25
	var/list/area/prisonAreas = list()

/datum/event/prison_break/setup()
	announceWhen = rand(50, 60)
	releaseWhen = rand(20, 30)

	startWhen = releaseWhen - 1
	endWhen = releaseWhen + 1

/datum/event/prison_break/announce()
	if(length(prisonAreas))
		command_alert("[pick("Gr3y.T1d3 virus", "Malignant trojan")] detected in [station_name()] imprisonment subroutines. Recommend station AI involvement.", "Security Alert")
	else
		world.log << "ERROR: Could not initate grey-tide. Unable find prison or brig area."
		kill()

/datum/event/prison_break/start()
	for_no_type_check(var/area/A, GLOBL.area_list)
		if(istype(A, /area/security/brig) || istype(A, /area/prison))
			prisonAreas += A

	if(length(prisonAreas))
		for(var/area/A in prisonAreas)
			for(var/obj/machinery/light/L in A)
				L.flicker(10)

/datum/event/prison_break/tick()
	if(activeFor == releaseWhen)
		if(length(prisonAreas))
			for(var/area/A in prisonAreas)
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