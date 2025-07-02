/proc/power_failure(announce = TRUE)
	if(announce)
		priority_announce(
			"Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.",
			"Critical Power Failure", 'sound/AI/poweroff.ogg'
		)

	var/list/skipped_areas = list(/area/station/engineering/engine, /area/turret_protected/ai_chamber)

	FOR_MACHINES_TYPED(smes, /obj/machinery/power/smes)
		var/area/current_area = GET_AREA(smes)
		if(current_area.type in skipped_areas || isnotstationlevel(smes.z))
			continue
		smes.last_charge = smes.charge
		smes.last_output_attempt = smes.output_attempt
		smes.last_input_attempt = smes.input_attempt
		smes.charge = 0
		smes.input_attempt = 0
		smes.output_attempt = 0
		smes.update_icon()
		smes.power_change()

	FOR_MACHINES_TYPED(apc, /obj/machinery/power/apc)
		if(apc.cell && isstationlevel(apc.z))
			var/area/A = GET_AREA(apc)
			var/skip = 0
			for(var/area_type in skipped_areas)
				if(istype(A, area_type))
					skip = 1
					break
			if(skip)
				continue

			apc.cell.charge = 0

/proc/power_restore(announce = TRUE)
	if(announce)
		priority_announce(
			"Power has been restored to [station_name()]. We apologize for the inconvenience.", "Power Systems Nominal", 'sound/AI/poweron.ogg'
		)

	var/list/skipped_areas = list(/area/station/engineering/engine, /area/turret_protected/ai_chamber)

	FOR_MACHINES_TYPED(apc, /obj/machinery/power/apc)
		if(apc.cell && isstationlevel(apc.z))
			apc.cell.charge = apc.cell.maxcharge

	FOR_MACHINES_TYPED(smes, /obj/machinery/power/smes)
		var/area/current_area = GET_AREA(smes)
		if(current_area.type in skipped_areas || isnotstationlevel(smes.z))
			continue
		smes.charge = smes.last_charge
		smes.output_attempt = smes.last_output_attempt
		smes.input_attempt = smes.last_input_attempt
		smes.update_icon()
		smes.power_change()

	/*
	for_no_type_check(var/area/A, GLOBL.area_list)
		if(A.name != "Space" && A.name != "Engine Walls" && A.name != "Chemical Lab Test Chamber" && A.name != "space" && A.name != "Escape Shuttle" && A.name != "Arrival Area" && A.name != "Arrival Shuttle" && A.name != "start area" && A.name != "Engine Combustion Chamber")
			A.power_light = 1
			A.power_equip = 1
			A.power_environ = 1
			A.power_change()
	*/

/proc/power_restore_quick(announce = TRUE)
	if(announce)
		priority_announce(
			"All SMESs on [station_name()] have been recharged. We apologize for the inconvenience.", "Power Systems Nominal", 'sound/AI/poweron.ogg'
		)

	FOR_MACHINES_TYPED(smes, /obj/machinery/power/smes)
		if(isnotstationlevel(smes.z))
			continue
		smes.charge = smes.capacity
		smes.output_level = 200000
		smes.output_attempt = 1
		smes.input_attempt = 1
		smes.update_icon()
		smes.power_change()