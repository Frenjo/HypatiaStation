/datum/round_event/viral_outbreak
	var/severity = 1

/datum/round_event/viral_outbreak/setup()
	announceWhen = rand(0, 3000)
	endWhen = announceWhen + 1
	severity = rand(2, 4)

/datum/round_event/viral_outbreak/announce()
	priority_announce(
		"Confirmed outbreak of level 7 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.",
		"Biohazard Alert", 'sound/AI/outbreak7.ogg'
	)

/datum/round_event/viral_outbreak/start()
	var/list/mob/living/carbon/human/candidates = list()	//list of candidate keys
	for(var/mob/living/carbon/human/G in GLOBL.player_list)
		if(isnotnull(G.client) && G.stat != DEAD)
			candidates.Add(G)
	if(!length(candidates))
		return
	candidates = shuffle(candidates)//Incorporating Donkie's list shuffle

	while(severity > 0 && length(candidates))
		if(prob(33))
			infect_mob_random_lesser(candidates[1])
		else
			infect_mob_random_greater(candidates[1])

		candidates.Remove(candidates[1])
		severity--