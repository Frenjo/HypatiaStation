
/**********************Shuttle Computer**************************/

//copy paste from the mining shuttle

var/research_shuttle_tickstomove = 80
var/research_shuttle_moving = 0
var/research_shuttle_location = 0 // 0 = station 13, 1 = research station

proc/move_research_shuttle()
	if(research_shuttle_moving)
		return

	research_shuttle_moving = 1
	spawn(research_shuttle_tickstomove * 10)
		var/area/fromArea
		var/area/toArea
		if (research_shuttle_location == 1)
			fromArea = locate(/area/shuttle/research/outpost)
			toArea = locate(/area/shuttle/research/station)
		else
			fromArea = locate(/area/shuttle/research/station)
			toArea = locate(/area/shuttle/research/outpost)


		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/turf/T in toArea)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		// hey you, get out of the way!
		for(var/turf/T in dstturfs)
			// find the turf to move things to
			var/turf/D = locate(T.x, throwy - 1, 1)
			//var/turf/E = get_step(D, SOUTH)
			for(var/atom/movable/AM as mob|obj in T)
				AM.Move(D)
				// NOTE: Commenting this out to avoid recreating mass driver glitch
				/*
				spawn(0)
					AM.throw_at(E, 1, 1)
					return
				*/

			if(issimulated(T))
				qdel(T)

		for(var/mob/living/carbon/bug in toArea) // If someone somehow is still in the shuttle's docking area...
			bug.gib()

		for(var/mob/living/simple_animal/pest in toArea) // And for the other kind of bug...
			pest.gib()

		fromArea.move_contents_to(toArea)
		if (research_shuttle_location)
			research_shuttle_location = 0
		else
			research_shuttle_location = 1
		research_shuttle_moving = 0
	return

/obj/machinery/computer/research_shuttle
	name = "Research Shuttle Console"
	icon_state = "shuttle"
	req_access = list(access_research)
	circuit = "/obj/item/circuitboard/research_shuttle"

	var/hacked = 0
	var/location = 0 //0 = station, 1 = research base

	// Adding ability for research shuttle to close it's airlock before it leaves a place. -Frenjo
	var/airlock_tag_station
	var/airlock_tag_outpost
	var/airlock_tag_shuttle // Added this to reflect docking controller port. -Frenjo
	var/frequency = 1379
	var/datum/radio_frequency/radio_connection //= radio_controller.add_object(src, frequency, RADIO_AIRLOCK)

// More research shuttle airlock interaction. -Frenjo
/*/obj/machinery/computer/research_shuttle/New()
	radio_controller.remove_object(src, frequency)
	radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)
	return ..()*/

/obj/machinery/computer/research_shuttle/attack_hand(user as mob)
	// Time to start praying this works. -Frenjo
	radio_controller.remove_object(src, frequency)
	radio_connection = radio_controller.add_object(src, frequency, RADIO_AIRLOCK)

	src.add_fingerprint(usr)
	var/dat = "<center>Research Shuttle: <b><A href='byond:://?src=\ref[src];move=1'>Send</A></b></center><br>"

	user << browse("[dat]", "window=researchshuttle;size=200x100")

/obj/machinery/computer/research_shuttle/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)
	if(href_list["move"])
		//if(ticker.mode.name == "blob")
		//	if(ticker.mode:declared)
		//		usr << "Under directive 7-10, [station_name()] is quarantined until further notice."
		//		return

		if(!research_shuttle_moving)
			usr << "\blue Shuttle recieved message and will arrive in [(research_shuttle_tickstomove / 10)] seconds."

			// EVEN MORE research shuttle airlock interaction.
			// Shameless port from door access buttons. -Frenjo
			var/datum/signal/signal = new
			signal.transmission_method = TRANSMISSION_RADIO
			if(research_shuttle_location == 0)
				signal.data["tag"] = airlock_tag_station
				signal.data["command"] = "cycle_interior"
				radio_connection.post_signal(src, signal, range = 10, filter = RADIO_AIRLOCK)

				signal.data["tag"] = airlock_tag_shuttle
				signal.data["command"] = "force_door"
			else
				signal.data["tag"] = airlock_tag_outpost
				signal.data["command"] = "secure_close"
				radio_connection.post_signal(src, signal, range = 10, filter = RADIO_AIRLOCK)

				signal.data["tag"] = airlock_tag_shuttle
				signal.data["command"] = "force_door"

			radio_connection.post_signal(src, signal, range = 10, filter = RADIO_AIRLOCK)

			move_research_shuttle()

			// And hopefully open an airlock when we arrive. -Frenjo
			sleep((research_shuttle_tickstomove + 2) * 10)
			if(research_shuttle_location == 0)
				signal.data["tag"] = airlock_tag_station
				signal.data["command"] = "force_exterior"
				radio_connection.post_signal(src, signal, range = 10, filter = RADIO_AIRLOCK)

				signal.data["tag"] = airlock_tag_shuttle
				signal.data["command"] = "force_door"
			else
				signal.data["tag"] = airlock_tag_outpost
				signal.data["command"] = "secure_open"
				radio_connection.post_signal(src, signal, range = 10, filter = RADIO_AIRLOCK)

				signal.data["tag"] = airlock_tag_shuttle
				signal.data["command"] = "force_door"

			radio_connection.post_signal(src, signal, range = 10, filter = RADIO_AIRLOCK)
		else
			usr << "\blue Shuttle is already moving."

/obj/machinery/computer/research_shuttle/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(hacked)
		FEEDBACK_ALREADY_EMAGGED(user)
		return FALSE
	req_access = list()
	hacked = TRUE
	to_chat(user, SPAN_WARNING("You fry the console's ID checking system. It's now available to everyone!"))
	return TRUE