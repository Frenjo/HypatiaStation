/datum/round_event/viral_infection
	var/severity = 1

/datum/round_event/viral_infection/setup()
	announceWhen = rand(0, 3000)
	endWhen = announceWhen + 1
	severity = rand(1, 3)

/datum/round_event/viral_infection/announce()
	command_alert("Confirmed outbreak of level five biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert")
	world << sound('sound/AI/outbreak5.ogg')

/datum/round_event/viral_infection/start()
	var/list/mob/living/carbon/human/candidates = list()	//list of candidate keys
	for(var/mob/living/carbon/human/G in GLOBL.player_list)
		if(isnotnull(G.client) && G.stat != DEAD)
			candidates.Add(G)
	if(!length(candidates))
		return
	candidates = shuffle(candidates)//Incorporating Donkie's list shuffle

	while(severity > 0 && length(candidates))
		infect_mob_random_lesser(candidates[1])
		candidates.Remove(candidates[1])
		severity--