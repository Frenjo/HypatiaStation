GLOBAL_GLOBL_INIT(sent_aliens_to_station, FALSE)

/datum/round_event/alien_infestation
	announce_when = 400
	one_shot = TRUE

	var/spawncount
	var/successSpawn = FALSE	// So we don't make a command report if nothing gets spawned.

/datum/round_event/alien_infestation/New(spawn_count = 1)
	. = ..()
	spawncount = spawn_count

/datum/round_event/alien_infestation/setup()
	announce_when = rand(announce_when, announce_when + 50)
	spawncount = rand(1, 2)
	GLOBL.sent_aliens_to_station = TRUE

/datum/round_event/alien_infestation/announce()
	if(successSpawn)
		priority_announce(
			"Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.",
			"Lifesign Alert", 'sound/AI/aliens.ogg'
		)

/datum/round_event/alien_infestation/start()
	var/list/vents = list()
	FOR_MACHINES_TYPED(temp_vent, /obj/machinery/atmospherics/unary/vent_pump)
		if(!temp_vent.welded && temp_vent.network && isstationlevel(temp_vent.loc.z))
			if(length(temp_vent.network.normal_members) > 50)	//Stops Aliens getting stuck in small networks. See: Security, Virology
				vents.Add(temp_vent)

	var/list/candidates = get_alien_candidates()

	while(spawncount > 0 && length(vents) && length(candidates))
		var/obj/vent = pick(vents)
		var/candidate = pick(candidates)

		var/mob/living/carbon/alien/larva/new_xeno = new /mob/living/carbon/alien/larva(vent.loc)
		new_xeno.key = candidate

		candidates.Remove(candidate)
		vents.Remove(vent)
		spawncount--
		successSpawn = TRUE