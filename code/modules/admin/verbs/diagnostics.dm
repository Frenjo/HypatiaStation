/client/proc/air_report()
	set category = PANEL_DEBUG
	set name = "Show Air Report"

	if(!global.CTmaster || !global.PCair)
		alert(usr, "Master_controller or air_master not found.", "Air Report")
		return

	var/active_groups = global.PCair.active_zones
	var/inactive_groups = length(global.PCair.zones) - active_groups

	var/hotspots = 0
	for(var/obj/fire/hotspot in GLOBL.movable_atom_list)
		hotspots++

	var/active_on_main_station = 0
	var/inactive_on_main_station = 0
	for_no_type_check(var/zone/zone, global.PCair.zones)
		var/turf/open/turf = locate() in zone.contents
		if(turf && isstationlevel(turf.z))
			if(zone.needs_update)
				active_on_main_station++
			else
				inactive_on_main_station++

	var/output = {"<B>AIR SYSTEMS REPORT</B><HR>
<B>General Processing Data</B><BR>
	Cycle: [global.PCair.current_cycle]<br>
	Groups: [length(global.PCair.zones)]<BR>
---- <I>Active:</I> [active_groups]<BR>
---- <I>Inactive:</I> [inactive_groups]<BR><br>
---- <I>Active on station:</i> [active_on_main_station]<br>
---- <i>Inactive on station:</i> [inactive_on_main_station]<br>
<BR>
<B>Special Processing Data</B><BR>
	Hotspot Processing: [hotspots]<BR>
<br>
<B>Geometry Processing Data</B><BR>
	Tile Update: [length(global.PCair.tiles_to_update)]<BR>
"}

	usr << browse(output,"window=airreport")

/client/proc/fix_next_move()
	set category = PANEL_DEBUG
	set name = "Unfreeze Everyone"

	var/largest_move_time = 0
	var/largest_click_time = 0
	var/mob/largest_move_mob = null
	var/mob/largest_click_mob = null
	for_no_type_check(var/mob/M, GLOBL.mob_list)
		if(!M.client)
			continue
		if(M.next_move >= largest_move_time)
			largest_move_mob = M
			if(M.next_move > world.time)
				largest_move_time = M.next_move - world.time
			else
				largest_move_time = 1
		if(M.next_click >= largest_click_time)
			largest_click_mob = M
			if(M.next_click > world.time)
				largest_click_time = M.next_click - world.time
			else
				largest_click_time = 0
		log_admin("DEBUG: [key_name(M)]  next_move = [M.next_move]  next_click = [M.next_click]  world.time = [world.time]")
		M.next_move = 1
		M.next_click = 0
	message_admins("[key_name_admin(largest_move_mob)] had the largest move delay with [largest_move_time] frames / [largest_move_time/10] seconds!", 1)
	message_admins("[key_name_admin(largest_click_mob)] had the largest click delay with [largest_click_time] frames / [largest_click_time/10] seconds!", 1)
	message_admins("world.time = [world.time]", 1)
	feedback_add_details("admin_verb", "UFE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/radio_report()
	set category = PANEL_DEBUG
	set name = "Radio report"

	var/filters = list(
		RADIO_TO_AIRALARM = "RADIO_TO_AIRALARM",
		RADIO_FROM_AIRALARM = "RADIO_FROM_AIRALARM",
		RADIO_CHAT = "RADIO_CHAT",
		RADIO_ATMOSIA = "RADIO_ATMOSIA",
		RADIO_NAVBEACONS = "RADIO_NAVBEACONS",
		RADIO_AIRLOCK = "RADIO_AIRLOCK",
		RADIO_SECBOT = "RADIO_SECBOT",
		RADIO_MULEBOT = "RADIO_MULEBOT",
		RADIO_MAGNETS = "RADIO_MAGNETS",
		"_default" = "NO_FILTER"
	)

	var/output = "<b>Radio Report</b><hr>"
	for(var/fq in global.CTradio.frequencies)
		output += "<b>Freq: [fq]</b><br>"
		var/datum/radio_frequency/fqs = global.CTradio.frequencies[fq]
		if(!fqs)
			output += "&nbsp;&nbsp;<b>ERROR</b><br>"
			continue
		for(var/filter in fqs.devices)
			var/list/f = fqs.devices[filter]
			if(!f)
				output += "&nbsp;&nbsp;[filters[filter]]: ERROR<br>"
				continue
			output += "&nbsp;&nbsp;[filters[filter]]: [length(f)]<br>"
			for(var/device in f)
				if(isobj(device))
					output += "&nbsp;&nbsp;&nbsp;&nbsp;[device] ([device:x],[device:y],[device:z] in area [GET_AREA(device)])<br>"
				else
					output += "&nbsp;&nbsp;&nbsp;&nbsp;[device]<br>"

	usr << browse(output,"window=radioreport")
	feedback_add_details("admin_verb", "RR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/reload_admins()
	set category = PANEL_DEBUG
	set name = "Reload Admins"

	if(!check_rights(R_SERVER))
		return

	message_admins("[usr] manually reloaded admins")
	load_admins()
	feedback_add_details("admin_verb", "RLDA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

//todo:
/client/proc/jump_to_dead_group()
	set category = PANEL_DEBUG
	set name = "Jump to dead group"
	/*
	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	if(!air_master)
		usr << "Cannot find air_system"
		return
	var/datum/air_group/dead_groups = list()
	for(var/datum/air_group/group in air_master.air_groups)
		if (!group.group_processing)
			dead_groups += group
	var/datum/air_group/dest_group = pick(dead_groups)
	usr.forceMove(pick(dest_group.members))
	feedback_add_details("admin_verb","JDAG") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return
	*/

/client/proc/kill_airgroup()
	set category = PANEL_DEBUG
	set name = "Kill Local Airgroup"
	set desc = "Use this to allow manual manupliation of atmospherics."
	/*
	if(!holder)
		FEEDBACK_COMMAND_ADMIN_ONLY(src)
		return

	if(!air_master)
		usr << "Cannot find air_system"
		return

	var/turf/T = GET_TURF(usr)
	if(isopenturf(T))
		var/datum/air_group/AG = T:parent
		AG.next_check = 30
		AG.group_processing = 0
	else
		usr << "Local airgroup is unsimulated!"
	feedback_add_details("admin_verb", "KLAG") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	*/

/client/proc/print_jobban_old()
	set category = PANEL_DEBUG
	set name = "Print Jobban Log"
	set desc = "This spams all the active jobban entries for the current round to standard output."

	to_chat(usr, "<b>Jobbans active in this round.</b>")
	for(var/t in jobban_keylist)
		to_chat(usr, "[t]")

/client/proc/print_jobban_old_filter()
	set category = PANEL_DEBUG
	set name = "Search Jobban Log"
	set desc = "This searches all the active jobban entries for the current round and outputs the results to standard output."

	var/filter = input("Contains what?", "Filter") as text | null
	if(!filter)
		return

	to_chat(usr, "<b>Jobbans active in this round.</b>")
	for(var/t in jobban_keylist)
		if(findtext(t, filter))
			to_chat(usr, "[t]")