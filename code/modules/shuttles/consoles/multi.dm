/obj/machinery/computer/shuttle_control/multi
	icon_state = "syndishuttle"

/obj/machinery/computer/shuttle_control/multi/attack_hand(mob/user)
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
		var/area/areacheck = GET_AREA(src)
		dat += "Location: [areacheck.name]<br>"

	if((shuttle.last_move + shuttle.cooldown*10) > world.time)
		dat += "<font color='red'>Engines charging.</font><br>"
	else
		dat += "<font color='green'>Engines ready.</font><br>"

	dat += "<br><b><A href='byond://?src=\ref[src];toggle_cloak=[1]'>Toggle cloaking field</A></b><br>"
	dat += "<b><A href='byond://?src=\ref[src];move_multi=[1]'>Move ship</A></b><br>"
	dat += "<b><A href='byond://?src=\ref[src];start=[1]'>Return to base</A></b></center>"

	SHOW_BROWSER(user, dat, "window=[shuttle_tag]shuttlecontrol;size=300x600")

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