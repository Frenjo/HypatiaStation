/datum/event/disease_outbreak
	announceWhen	= 15
	oneShot			= TRUE

/datum/event/disease_outbreak/announce()
	command_alert("Confirmed outbreak of level 7 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert")
	world << sound('sound/AI/outbreak7.ogg')

/datum/event/disease_outbreak/setup()
	announceWhen = rand(15, 30)

/datum/event/disease_outbreak/start()
	var/virus_type = pick(/datum/disease/dnaspread, /datum/disease/advance/flu, /datum/disease/advance/cold, /datum/disease/brainrot, /datum/disease/magnitis)

	for(var/mob/living/carbon/human/H in shuffle(GLOBL.living_mob_list))
		var/foundAlready = FALSE	// don't infect someone that already has the virus
		var/turf/T = GET_TURF(H)
		if(isnull(T))
			continue
		if(isnotstationlevel(T.z))
			continue
		for_no_type_check(var/datum/disease/D, H.viruses)
			foundAlready = TRUE
		if(H.stat == DEAD || foundAlready)
			continue

		if(virus_type == /datum/disease/dnaspread)		//Dnaspread needs strain_data set to work.
			if(isnull(H.dna) || (H.sdisabilities & BLIND))	//A blindness disease would be the worst.
				continue
			var/datum/disease/dnaspread/D = new /datum/disease/dnaspread()
			D.strain_data["name"] = H.real_name
			D.strain_data["UI"] = H.dna.UI.Copy()
			D.strain_data["SE"] = H.dna.SE.Copy()
			D.carrier = TRUE
			D.holder = H
			D.affected_mob = H
			H.viruses.Add(D)
			break
		else
			var/datum/disease/D = new virus_type()
			D.carrier = TRUE
			D.holder = H
			D.affected_mob = H
			H.viruses.Add(D)
			break