/*
 * Silicon Verbs
 *
 * These are verbs common to all silicon types unless explicitly removed.
 */
GLOBAL_GLOBL_LIST_INIT(silicon_verbs_default, list(
	/mob/living/silicon/verb/show_station_manifest,
	/mob/living/silicon/verb/set_sensor_augmentation,
	/mob/living/silicon/verb/show_laws_verb
))

/mob/living/silicon/proc/add_silicon_verbs()
	verbs |= GLOBL.silicon_verbs_default

/mob/living/silicon/proc/remove_silicon_verbs()
	verbs.Remove(GLOBL.silicon_verbs_default)

/*
 * Show Alerts
 */
// AI
/mob/living/silicon/ai/verb/ai_alerts()
	set category = PANEL_SILICON_COMMANDS
	set name = "Show Alerts"

	var/dat = "<HEAD><TITLE>Current Station Alerts</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A href='byond://?src=\ref[src];mach_close=aialerts'>Close</A><BR><BR>"
	for(var/cat in alarms)
		dat += text("<B>[]</B><BR>\n", cat)
		var/list/alarmlist = alarms[cat]
		if(length(alarmlist))
			for(var/area_name in alarmlist)
				var/datum/alarm/alarm = alarmlist[area_name]
				dat += "<NOBR>"
				var/cameratext = ""
				if(alarm.cameras)
					for(var/obj/machinery/camera/I in alarm.cameras)
						cameratext += "[cameratext == "" ? "" : " | "]<A href=byond://?src=\ref[src];switchcamera=\ref[I]>[I.c_tag]</A>"
				dat += "-- [alarm.area.name] ([cameratext ? cameratext : "No Camera"])"

				if(length(alarm.sources) > 1)
					dat += " - [length(alarm.sources)] sources"
				dat += "</NOBR><BR>\n"
		else
			dat += "-- All Systems Nominal<BR>\n"
		dat += "<BR>\n"

	viewalerts = 1
	src << browse(dat, "window=aialerts&can_close=0")

// Robot
/mob/living/silicon/robot/verb/robot_alerts()
	set category = PANEL_SILICON_COMMANDS
	set name = "Show Alerts"

	var/dat = "<HEAD><TITLE>Current Station Alerts</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'></HEAD><BODY>\n"
	dat += "<A href='byond://?src=\ref[src];mach_close=robotalerts'>Close</A><BR><BR>"
	for(var/cat in alarms)
		dat += text("<B>[cat]</B><BR>\n")
		var/list/alarmlist = alarms[cat]
		if(length(alarmlist))
			for(var/area_name in alarmlist)
				var/datum/alarm/alarm = alarmlist[area_name]
				dat += "<NOBR>"
				dat += text("-- [area_name]")
				if(length(alarm.sources) > 1)
					dat += "- [length(alarm.sources)] sources"
				dat += "</NOBR><BR>\n"
		else
			dat += "-- All Systems Nominal<BR>\n"
		dat += "<BR>\n"

	viewalerts = 1
	src << browse(dat, "window=robotalerts&can_close=0")

/*
 * Show Station Manifest
 *
 * This verb lets silicons see the station's manifest.
 */
/mob/living/silicon/verb/show_station_manifest()
	set category = PANEL_SILICON_COMMANDS
	set name = "Show Station Manifest"

	var/dat
	dat += "<h4>Crew Manifest</h4>"
	if(isnotnull(GLOBL.data_core))
		dat += GLOBL.data_core.get_manifest(1) // make it monochrome
	dat += "<br>"
	src << browse(dat, "window=airoster")
	onclose(src, "airoster")

/*
 * Set Sensor Augmentation
 *
 * Medical/Security HUD controller for silicons.
 */
/mob/living/silicon/verb/set_sensor_augmentation()
	set category = PANEL_SILICON_COMMANDS
	set name = "Set Sensor Augmentation"
	set desc = "Augment visual feed with internal sensor overlays."

	var/sensor_type = input("Please select sensor type.", "Sensor Integration", null) in list("Security", "Medical", "Disable")
	switch(sensor_type)
		if("Security")
			sensor_mode = SILICON_HUD_SECURITY
			to_chat(src, SPAN_NOTICE("Security records overlay enabled."))
		if("Medical")
			sensor_mode = SILICON_HUD_MEDICAL
			to_chat(src, SPAN_NOTICE("Life signs monitor overlay enabled."))
		if("Disable")
			sensor_mode = 0
			to_chat(src, "Sensor augmentations disabled.")

/*
 * Show Laws
 */
/mob/living/silicon/verb/show_laws_verb()
	set category = PANEL_SILICON_COMMANDS
	set name = "Show Laws"

	show_laws()

/*
 * State Laws
 */
/mob/living/silicon/verb/state_laws_verb() // Gives you a link-driven interface for deciding what laws the state_laws() proc will share with the crew. --NeoFite
	set category = PANEL_SILICON_COMMANDS
	set name = "State Laws"

	var/list = "<b>Which laws do you want to include when stating them for the crew?</b><br><br>"

	if(isnotnull(laws.zeroth))
		if(!lawcheck[1])
			lawcheck[1] = "No" // Given Law 0's usual nature, it defaults to NOT getting reported. --NeoFite
		list += {"<A href='byond://?src=\ref[src];lawc=0'>[lawcheck[1]] 0:</A> [laws.zeroth]<BR>"}

	for(var/index = 1, index <= length(laws.ion), index++)
		var/law = laws.ion[index]
		if(length(law) > 0)
			if(!ioncheck[index])
				ioncheck[index] = "Yes"
			list += {"<A href='byond://?src=\ref[src];lawi=[index]'>[ioncheck[index]] [ionnum()]:</A> [law]<BR>"}
			ioncheck.len += 1

	var/number = 1
	for(var/index = 1, index <= length(laws.inherent), index++)
		var/law = laws.inherent[index]
		if(length(law) > 0)
			lawcheck.len += 1
			if(!lawcheck[number + 1])
				lawcheck[number + 1] = "Yes"
			list += {"<A href='byond://?src=\ref[src];lawc=[number]'>[lawcheck[number + 1]] [number]:</A> [law]<BR>"}
			number++

	for(var/index = 1, index <= length(laws.supplied), index++)
		var/law = laws.supplied[index]
		if(length(law) > 0)
			lawcheck.len += 1
			if(!lawcheck[number + 1])
				lawcheck[number + 1] = "Yes"
			list += {"<A href='byond://?src=\ref[src];lawc=[number]'>[lawcheck[number + 1]] [number]:</A> [law]<BR>"}
			number++
	list += {"<br><br><A href='byond://?src=\ref[src];laws=1'>State Laws</A>"}
	usr << browse(list, "window=laws")