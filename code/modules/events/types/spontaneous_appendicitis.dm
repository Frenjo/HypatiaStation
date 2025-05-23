/datum/round_event/spontaneous_appendicitis/start()
	for(var/mob/living/carbon/human/H in shuffle(GLOBL.living_mob_list))
		if(isnotnull(H.client) && H.stat != DEAD)
			var/foundAlready = FALSE	//don't infect someone that already has the virus
			for_no_type_check(var/datum/disease/D, H.viruses)
				foundAlready = TRUE
			if(H.stat == DEAD || foundAlready)
				continue

		var/datum/disease/D = new /datum/disease/appendicitis()
		D.holder = H
		D.affected_mob = H
		H.viruses.Add(D)
		break