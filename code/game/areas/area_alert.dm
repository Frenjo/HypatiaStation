/*
 * Alert-related /area procs
 */

// Power
/area/proc/power_alert(state, obj/source)
	if(state != power_alarm)
		power_alarm = state
		if(istype(source)) // Only report power alarms on the z-level where the source is located.
			var/list/cameras = list()
			for(var/obj/machinery/camera/C in machines_list)
				cameras.Add(C)
				if(state == 1)
					C.network.Remove("Power Alarms")
				else
					C.network.Add("Power Alarms")
			for(var/mob/living/silicon/aiPlayer in GLOBL.player_list)
				if(aiPlayer.z == source.z)
					if(state == 1)
						aiPlayer.cancelAlarm("Power", src, source)
					else
						aiPlayer.triggerAlarm("Power", src, cameras, source)
			for_no_type_check(var/obj/machinery/computer/station_alert/a, GET_MACHINES_TYPED(/obj/machinery/computer/station_alert))
				if(a.z == source.z)
					if(state == 1)
						a.cancelAlarm("Power", src, source)
					else
						a.triggerAlarm("Power", src, cameras, source)

// Atmos
/area/proc/atmos_alert(danger_level)
	if(danger_level != atmos_alarm)
		if(danger_level == 2)
			var/list/cameras = list()
			for(var/obj/machinery/camera/C in machines_list)
				cameras.Add(C)
				C.network.Add("Atmosphere Alarms")
			for(var/mob/living/silicon/aiPlayer in GLOBL.player_list)
				aiPlayer.triggerAlarm("Atmosphere", src, cameras, src)
			for_no_type_check(var/obj/machinery/computer/station_alert/a, GET_MACHINES_TYPED(/obj/machinery/computer/station_alert))
				a.triggerAlarm("Atmosphere", src, cameras, src)
		else if(atmos_alarm == 2)
			for(var/obj/machinery/camera/C in machines_list)
				C.network.Remove("Atmosphere Alarms")
			for(var/mob/living/silicon/aiPlayer in GLOBL.player_list)
				aiPlayer.cancelAlarm("Atmosphere", src, src)
			for_no_type_check(var/obj/machinery/computer/station_alert/a, GET_MACHINES_TYPED(/obj/machinery/computer/station_alert))
				a.cancelAlarm("Atmosphere", src, src)
		atmos_alarm = danger_level
		return TRUE
	return FALSE

// Fire
/area/proc/fire_alert()
	if(!fire_alarm)
		fire_alarm = TRUE
		updateicon()
		mouse_opacity = FALSE
		for(var/obj/machinery/door/firedoor/D in doors_list)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = DOOR_CLOSED
				else if(!D.density)
					spawn()
						D.close()
		var/list/cameras = list()
		for(var/obj/machinery/camera/C in machines_list)
			cameras.Add(C)
			C.network.Add("Fire Alarms")
		for(var/mob/living/silicon/ai/aiPlayer in GLOBL.player_list)
			aiPlayer.triggerAlarm("Fire", src, cameras, src)
		for_no_type_check(var/obj/machinery/computer/station_alert/a, GET_MACHINES_TYPED(/obj/machinery/computer/station_alert))
			a.triggerAlarm("Fire", src, cameras, src)

/area/proc/fire_reset()
	if(fire_alarm)
		fire_alarm = FALSE
		mouse_opacity = FALSE
		updateicon()
		for(var/obj/machinery/door/firedoor/D in doors_list)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = OPEN
				else if(D.density)
					spawn()
						D.open()
		for(var/obj/machinery/camera/C in machines_list)
			C.network.Remove("Fire Alarms")
		for(var/mob/living/silicon/ai/aiPlayer in GLOBL.player_list)
			aiPlayer.cancelAlarm("Fire", src, src)
		for_no_type_check(var/obj/machinery/computer/station_alert/a, GET_MACHINES_TYPED(/obj/machinery/computer/station_alert))
			a.cancelAlarm("Fire", src, src)

// Evac
/area/proc/evac_alert()
	if(!evac_alarm)
		evac_alarm = TRUE
		updateicon()

/area/proc/evac_reset()
	if(evac_alarm)
		evac_alarm = FALSE
		updateicon()

// Party
/area/proc/party_alert()
	if(!party_alarm)
		party_alarm = TRUE
		updateicon()
		mouse_opacity = FALSE

/area/proc/party_reset()
	if(party_alarm)
		party_alarm = FALSE
		mouse_opacity = FALSE
		updateicon()
		for(var/obj/machinery/door/firedoor/D in doors_list)
			if(!D.blocked)
				if(D.operating)
					D.nextstate = OPEN
				else if(D.density)
					spawn()
						D.open()

// Destruct
// Added these to make use of unused sprites. -Frenjo
/area/proc/destruct_alert()
	if(!destruct_alarm)
		destruct_alarm = TRUE
		updateicon()

/area/proc/destruct_reset()
	if(destruct_alarm)
		destruct_alarm = FALSE
		updateicon()