/datum/alarm
	var/area/area		//the area associated with the alarm. Used to identify the alarm
	var/list/sources	//list of things triggering the alarm. Used to determine when the alarm should be cleared.
	var/list/cameras	//list of cameras that can be switched to, if the player has that capability.

/datum/alarm/New(area/A, list/sourcelist=list(), list/cameralist=list())
	area = A
	sources = sourcelist
	cameras = cameralist

/mob/living/silicon
	var/alarms = list("Motion" = list(), "Fire" = list(), "Atmosphere" = list(), "Power" = list(), "Camera" = list())	//each sublist stores alarms keyed by the area name
	var/list/alarms_to_show = list()
	var/list/alarms_to_clear = list()
	var/list/alarm_types_show = list("Motion" = 0, "Fire" = 0, "Atmosphere" = 0, "Power" = 0, "Camera" = 0)
	var/list/alarm_types_clear = list("Motion" = 0, "Fire" = 0, "Atmosphere" = 0, "Power" = 0, "Camera" = 0)

/mob/living/silicon/proc/triggerAlarm(class, area/A, list/cameralist, source)
	var/list/alarmlist = alarms[class]

	//see if there is already an alarm of this class for this area
	if(A.name in alarmlist)
		var/datum/alarm/existing = alarmlist[A.name]
		existing.sources.Add(source)
		existing.cameras |= cameralist
	else
		alarmlist[A.name] = new /datum/alarm(A, list(source), cameralist)

/mob/living/silicon/proc/cancelAlarm(class, area/A, source)
	var/cleared = FALSE
	var/list/alarmlist = alarms[class]

	if(A.name in alarmlist)
		var/datum/alarm/alarm = alarmlist[A.name]
		alarm.sources.Remove(source)

		if(!length(alarm.sources))
			cleared = TRUE
			alarmlist -= A.name

	return !cleared

/mob/living/silicon/proc/queueAlarm(message, type, incoming = 1)
	var/in_cooldown = length(alarms_to_show) || length(alarms_to_clear)
	if(incoming)
		alarms_to_show.Add(message)
		alarm_types_show[type] += 1
	else
		alarms_to_clear.Add(message)
		alarm_types_clear[type] += 1

	if(!in_cooldown)
		spawn(10 * 10) // 10 seconds

			if(length(alarms_to_show) < 5)
				for(var/msg in alarms_to_show)
					to_chat(src, msg)
			else if(length(alarms_to_show))
				var/msg = "--- "

				if(alarm_types_show["Motion"])
					msg += "MOTION: [alarm_types_show["Motion"]] alarms detected. - "

				if(alarm_types_show["Fire"])
					msg += "FIRE: [alarm_types_show["Fire"]] alarms detected. - "

				if(alarm_types_show["Atmosphere"])
					msg += "ATMOSPHERE: [alarm_types_show["Atmosphere"]] alarms detected. - "

				if(alarm_types_show["Power"])
					msg += "POWER: [alarm_types_show["Power"]] alarms detected. - "

				if(alarm_types_show["Camera"])
					msg += "CAMERA: [alarm_types_show["Power"]] alarms detected. - "

				msg += "<A href='byond://?src=\ref[src];showalerts=1'>\[Show Alerts\]</a>"
				to_chat(src, msg)

			if(length(alarms_to_clear) < 3)
				for(var/msg in alarms_to_clear)
					to_chat(src, msg)

			else if(length(alarms_to_clear))
				var/msg = "--- "

				if(alarm_types_clear["Motion"])
					msg += "MOTION: [alarm_types_clear["Motion"]] alarms cleared. - "

				if(alarm_types_clear["Fire"])
					msg += "FIRE: [alarm_types_clear["Fire"]] alarms cleared. - "

				if(alarm_types_clear["Atmosphere"])
					msg += "ATMOSPHERE: [alarm_types_clear["Atmosphere"]] alarms cleared. - "

				if(alarm_types_clear["Power"])
					msg += "POWER: [alarm_types_clear["Power"]] alarms cleared. - "

				if(alarm_types_show["Camera"])
					msg += "CAMERA: [alarm_types_show["Power"]] alarms detected. - "

				msg += "<A href='byond://?src=\ref[src];showalerts=1'>\[Show Alerts\]</a>"
				to_chat(src, msg)

			alarms_to_show = list()
			alarms_to_clear = list()
			for(var/i = 1; i < length(alarm_types_show); i++)
				alarm_types_show[i] = 0
			for(var/i = 1; i < length(alarm_types_clear); i++)
				alarm_types_clear[i] = 0