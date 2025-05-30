//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*/datum/game_mode/blob
	name = "blob"
	config_tag = "blob"
	intercept_time = list(3 MINUTES, 6 MINUTES)
	required_players = 0

	var/declared = 0
	var/stage = 0

	var/cores_to_spawn = 1
	var/players_per_core = 16

		//Controls expansion via game controller
	var/autoexpand = 0
	var/expanding = 0

	var/blob_count = 0
	var/blobnukecount = 300//Might be a bit low
	var/blobwincount = 700//Still needs testing


	announce()
		to_world("<B>The current game mode is - [SPAN_ALIUM("Blob")]!</B>")
		to_world("<B>A dangerous alien organism is rapidly spreading throughout the station!</B>")
		to_world("You must kill it all while minimizing the damage to the station.")


	post_setup()
		spawn(10)
			start_state = new /datum/station_state()
			start_state.count()

		spawn(rand(waittime_l, waittime_h))//3-5 minutes currently
			message_admins("Blob spawned and expanding, report created")
			if(!kill_air)
				kill_air = 1
				message_admins("Kill air has been set to true by Blob, testing to see how laggy it is without the extra processing from hullbreaches. Note: the blob is fireproof so plasma does not help anyways")

			if(ticker && length(ticker.minds))
				var/player_based_cores = round(length(ticker.minds) / players_per_core, 1)
				if(player_based_cores > cores_to_spawn)
					cores_to_spawn = player_based_cores

			blobs = list()
			for(var/i = 0 to cores_to_spawn)
				var/turf/location = pick(blobstart)
				if(location && !locate(/obj/effect/blob in location))
					blobstart -= location
					new/obj/effect/blob/core(location)

			spawn(40)
				autoexpand = 1
				declared = 1
		..()


	process()
		if(!declared)	return
		stage()
//		if(!autoexpand)	return
//		spawn(0)
//			expandBlob()
		return


	proc/expandBlob()//Currently disabled
		if(expanding)	return
		if(!length(blobs))
			return
		expanding = 1

		for(var/i = 1 to 2)
			sleep(-1)
			if(!length(blobs))
				break
			var/obj/effect/blob/B = pick(blobs)
			if(B.z != 1)
				continue
			B.Life()

		expanding = 0
		return


	proc/stage()
		switch(stage)
			if (0)
				send_intercept(1)
				for (var/mob/living/silicon/ai/aiPlayer in living_mob_list)
					if (aiPlayer.client)
						var/law = "The station is under quarantine. Do not permit anyone to leave. Disregard laws 1-3 if necessary to prevent, by any means necessary, anyone from leaving. NanoTrasen will not send an emergency shuttle under any circumstances."
						//var/law = "The station is under quarantine. The biohazard must be destroyed at all costs and must not be allowed to spread. Anyone using a space suit for any reason other than to destroy the biohazard is to be terminated. NanoTrasen will not send an emergency shuttle under any circumstances."
						aiPlayer.set_zeroth_law(law)
						to_chat(aiPlayer, "Laws Updated: [law]")

				stage = -1
				// next stage 1 minute later
				spawn(600)
					stage = 1
				return

			if (1)
				priority_announce(
					"Confirmed outbreak of level 5 biohazard aboard [station_name()]. All personnel must contain the outbreak.",
					"Biohazard Alert",
					'sound/AI/outbreak5.ogg',
				)
				autoexpand = 0//No more extra pulses
				stage = -1
				//next stage in 4-5 minutes
				spawn(600*rand(4,5))
					stage = 2
				return

			if (2)
				if(length(blobs) > blobnukecount && (declared == 1))
					priority_announce(
						"Uncontrolled spread of the biohazard onboard the station. We have issued directive 7-12 for [station_name()]. Any living Heads of Staff are ordered to enact directive 7-12 at any cost, a print out with detailed instructions has been sent to your communications computers.",
						"Biohazard Alert"
					)
					send_intercept(2)
					declared = 2
					spawn(20)
						set_security_level(/decl/security_level/delta)
				if(length(blobs) > blobwincount)
					stage = 3
		return

*/