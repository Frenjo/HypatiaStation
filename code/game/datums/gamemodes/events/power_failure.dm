/proc/power_failure(announce = TRUE)
	if(announce)
		priority_announce(
			"Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.",
			"Critical Power Failure", 'sound/AI/poweroff.ogg'
		)

	var/list/skipped_areas = list(/area/station/engineering/engine, /area/turret_protected/ai_chamber)

	for(var/obj/machinery/power/smes/S in GLOBL.machines)
		var/area/current_area = GET_AREA(S)
		if(current_area.type in skipped_areas || isnotstationlevel(S.z))
			continue
		S.last_charge			= S.charge
		S.last_output_attempt	= S.output_attempt
		S.last_input_attempt 	= S.input_attempt
		S.charge = 0
		S.input_attempt = 0
		S.output_attempt = 0
		S.update_icon()
		S.power_change()

	for(var/obj/machinery/power/apc/C in GLOBL.machines)
		if(C.cell && isstationlevel(C.z))
			var/area/A = GET_AREA(C)
			var/skip = 0
			for(var/area_type in skipped_areas)
				if(istype(A, area_type))
					skip = 1
					break
			if(skip)
				continue

			C.cell.charge = 0

/proc/power_restore(announce = TRUE)
	if(announce)
		priority_announce(
			"Power has been restored to [station_name()]. We apologize for the inconvenience.", "Power Systems Nominal", 'sound/AI/poweron.ogg'
		)

	var/list/skipped_areas = list(/area/station/engineering/engine, /area/turret_protected/ai_chamber)

	for(var/obj/machinery/power/apc/C in GLOBL.machines)
		if(C.cell && isstationlevel(C.z))
			C.cell.charge = C.cell.maxcharge

	for(var/obj/machinery/power/smes/S in GLOBL.machines)
		var/area/current_area = GET_AREA(S)
		if(current_area.type in skipped_areas || isnotstationlevel(S.z))
			continue
		S.charge = S.last_charge
		S.output_attempt = S.last_output_attempt
		S.input_attempt = S.last_input_attempt
		S.update_icon()
		S.power_change()

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

	for(var/obj/machinery/power/smes/S in GLOBL.machines)
		if(isnotstationlevel(S.z))
			continue
		S.charge = S.capacity
		S.output_level = 200000
		S.output_attempt = 1
		S.input_attempt = 1
		S.update_icon()
		S.power_change()
