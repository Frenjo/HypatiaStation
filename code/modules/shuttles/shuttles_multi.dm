// Ported 'shuttles' module from Heaven's Gate - NSS Eternal, 22/11/2019...
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo

//This is a holder for things like the Vox and Nuke shuttle.
/datum/shuttle/multi_shuttle
	var/cloaked = 1
	var/at_origin = 1
	var/returned_home = FALSE
	var/move_time = 240
	var/cooldown = 20
	var/last_move = 0	//the time at which we last moved

	var/announcer
	var/arrival_message
	var/departure_message

	var/area/interim
	var/area/last_departed
	var/list/destinations
	var/area/origin
	var/return_warning = FALSE

/datum/shuttle/multi_shuttle/New()
	. = ..()
	if(isnotnull(origin))
		last_departed = origin

/datum/shuttle/multi_shuttle/move(area/origin, area/destination)
	. = ..()
	last_move = world.time
	if(destination == src.origin)
		returned_home = TRUE

/datum/shuttle/multi_shuttle/proc/announce_departure()
	if(cloaked || isnull(departure_message))
		return

	command_alert(departure_message, (announcer ? announcer : "Central Command"))

/datum/shuttle/multi_shuttle/proc/announce_arrival()
	if(cloaked || isnull(arrival_message))
		return

	command_alert(arrival_message, (announcer ? announcer : "Central Command"))


/obj/machinery/computer/shuttle_control/multi
	icon_state = "syndishuttle"

/obj/machinery/computer/shuttle_control/multi/attack_hand(user as mob)
	if(..(user))
		return
	add_fingerprint(user)

	var/datum/shuttle/multi_shuttle/shuttle = global.PCshuttle.shuttles[shuttle_tag]
	if(!istype(shuttle))
		return

	var/dat
	dat = "<center>[shuttle_tag] Ship Control<hr>"

	if(shuttle.moving_status != SHUTTLE_IDLE)
		dat += "Location: <font color='red'>Moving</font> <br>"
	else
		var/area/areacheck = get_area(src)
		dat += "Location: [areacheck.name]<br>"

	if((shuttle.last_move + shuttle.cooldown*10) > world.time)
		dat += "<font color='red'>Engines charging.</font><br>"
	else
		dat += "<font color='green'>Engines ready.</font><br>"

	dat += "<br><b><A href='byond://?src=\ref[src];toggle_cloak=[1]'>Toggle cloaking field</A></b><br>"
	dat += "<b><A href='byond://?src=\ref[src];move_multi=[1]'>Move ship</A></b><br>"
	dat += "<b><A href='byond://?src=\ref[src];start=[1]'>Return to base</A></b></center>"

	user << browse("[dat]", "window=[shuttle_tag]shuttlecontrol;size=300x600")

/obj/machinery/computer/shuttle_control/multi/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	var/datum/shuttle/multi_shuttle/shuttle = global.PCshuttle.shuttles[shuttle_tag]
	if(!istype(shuttle))
		return

	//to_world("multi_shuttle: last_departed=[shuttle.last_departed], origin=[shuttle.origin], interim=[shuttle.interim], travel_time=[shuttle.move_time]")

	if(shuttle.moving_status != SHUTTLE_IDLE)
		to_chat(usr, SPAN_INFO("[shuttle_tag] vessel is moving."))
		return

	if(href_list["start"])
		if(shuttle.at_origin)
			to_chat(usr, SPAN_WARNING("You are already at your home base."))
			return

		if(!shuttle.return_warning)
			to_chat(usr, SPAN_WARNING("Returning to your home base will end your mission. If you are sure, press the button again."))
			//TODO: Actually end the mission.
			shuttle.return_warning = TRUE
			return

		shuttle.long_jump(shuttle.last_departed, shuttle.origin, shuttle.interim, shuttle.move_time)
		shuttle.last_departed = shuttle.origin
		shuttle.at_origin = 1

	if(href_list["toggle_cloak"])
		shuttle.cloaked = !shuttle.cloaked
		to_chat(usr, SPAN_WARNING("Ship stealth systems have been [(shuttle.cloaked ? "activated. The station will not" : "deactivated. The station will")] be warned of our arrival."))

	if(href_list["move_multi"])
		if((shuttle.last_move + shuttle.cooldown * 10) > world.time)
			to_chat(usr, SPAN_WARNING("The ship's drive is inoperable while the engines are charging."))
			return

		var/choice = input("Select a destination.") as null | anything in shuttle.destinations
		if(isnull(choice))
			return

		to_chat(usr, SPAN_INFO("[shuttle_tag] main computer recieved message."))

		if(shuttle.at_origin)
			shuttle.announce_arrival()
			shuttle.last_departed = shuttle.origin
			shuttle.at_origin = 0

			shuttle.long_jump(shuttle.last_departed, shuttle.destinations[choice], shuttle.interim, shuttle.move_time)
			shuttle.last_departed = shuttle.destinations[choice]
			return

		else if(choice == shuttle.origin)
			shuttle.announce_departure()

		shuttle.short_jump(shuttle.last_departed, shuttle.destinations[choice])
		shuttle.last_departed = shuttle.destinations[choice]

	updateUsrDialog()