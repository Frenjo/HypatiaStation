GLOBAL_GLOBL_INIT(sent_aliens_to_station, FALSE)

/datum/round_event/alien_infestation
	announceWhen	= 400
	oneShot			= TRUE

	var/spawncount = 1
	var/successSpawn = FALSE	// So we don't make a command report if nothing gets spawned.

/datum/round_event/alien_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 50)
	spawncount = rand(1, 2)
	GLOBL.sent_aliens_to_station = TRUE

/datum/round_event/alien_infestation/announce()
	if(successSpawn)
		command_alert("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert")
		world << sound('sound/AI/aliens.ogg')

/datum/round_event/alien_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in GLOBL.machines)
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