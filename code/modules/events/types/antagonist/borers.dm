//Cortical borer spawn event - care of RobRichards1997 with minor editing by Zuhayr.
/datum/round_event/borer_infestation
	announce_when = 400
	one_shot = TRUE

	var/spawncount = 1
	var/successSpawn = FALSE	// So we don't make a command report if nothing gets spawned.

/datum/round_event/borer_infestation/setup()
	announce_when = rand(announce_when, announce_when + 50)
	spawncount = rand(1, 3)

/datum/round_event/borer_infestation/announce()
	if(successSpawn)
		priority_announce(
			"Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.",
			"Lifesign Alert", 'sound/AI/aliens.ogg'
		)

/datum/round_event/borer_infestation/start()
	var/list/vents = list()
	FOR_MACHINES_TYPED(temp_vent, /obj/machinery/atmospherics/unary/vent_pump)
		if(!temp_vent.welded && temp_vent.network && isstationlevel(temp_vent.loc.z))
			//Stops cortical borers getting stuck in small networks. See: Security, Virology
			if(length(temp_vent.network.normal_members) > 50)
				vents.Add(temp_vent)

	var/list/candidates = get_alien_candidates()
	while(spawncount > 0 && length(vents) && length(candidates))
		var/obj/vent = pick_n_take(vents)
		var/client/C = pick_n_take(candidates)

		var/mob/living/simple/borer/new_borer = new /mob/living/simple/borer(vent.loc)
		new_borer.key = C.key

		spawncount--
		successSpawn = TRUE