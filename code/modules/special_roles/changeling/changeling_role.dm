/decl/special_role/changeling
	name = "Changeling"

	role_type = SPECIAL_ROLE_CHANGELING
	role_flag = BE_CHANGELING

	restricted_jobs = list(/datum/job/ai, /datum/job/robot)
	protected_jobs = list(
		/datum/job/officer, /datum/job/warden, /datum/job/detective,
		/datum/job/hos, /datum/job/captain
	)

/decl/special_role/changeling/setup(mob/living/carbon/changeling)
	. = ..()
	global.PCticker.mode.changelings.Add(changeling)
	grant_changeling_powers(changeling)
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		forge_changeling_objectives(changeling)
	greet_changeling(changeling)

/decl/special_role/changeling/proc/grant_changeling_powers(mob/living/carbon/changeling)
	if(!istype(changeling))
		return
	changeling.make_changeling()

/decl/special_role/changeling/proc/forge_changeling_objectives(mob/living/carbon/changeling)
	//OBJECTIVES - Always absorb 5 genomes, plus random traitor objectives.
	//If they have two objectives as well as absorb, they must survive rather than escape
	//No escape alone because changelings aren't suited for it and it'd probably just lead to rampant robusting
	//If it seems like they'd be able to do it in play, add a 10% chance to have to escape alone
	var/datum/mind/changeling_mind = changeling.mind

	var/datum/objective/absorb/absorb_objective = new /datum/objective/absorb()
	absorb_objective.owner = changeling_mind
	absorb_objective.gen_amount_goal(2, 3)
	changeling_mind.objectives += absorb_objective

	var/datum/objective/assassinate/kill_objective = new /datum/objective/assassinate()
	kill_objective.owner = changeling_mind
	kill_objective.find_target()
	changeling_mind.objectives += kill_objective

	var/datum/objective/steal/steal_objective = new /datum/objective/steal()
	steal_objective.owner = changeling_mind
	steal_objective.find_target()
	changeling_mind.objectives += steal_objective

	switch(rand(1, 100))
		if(1 to 80)
			if(!(locate(/datum/objective/escape) in changeling_mind.objectives))
				var/datum/objective/escape/escape_objective = new /datum/objective/escape()
				escape_objective.owner = changeling_mind
				changeling_mind.objectives += escape_objective
		else
			if(!(locate(/datum/objective/survive) in changeling_mind.objectives))
				var/datum/objective/survive/survive_objective = new /datum/objective/survive()
				survive_objective.owner = changeling_mind
				changeling_mind.objectives += survive_objective

/decl/special_role/changeling/proc/greet_changeling(mob/living/carbon/changeling)
	to_chat(changeling, SPAN_DANGER("<font size=3>You are a changeling!</font>"))
	to_chat(changeling, SPAN_DANGER("Use say \":g message\" to communicate with your fellow changelings. Remember: you get all of their absorbed DNA if you absorb them."))

	if(istype(changeling.mind.assigned_job.type, /datum/job/clown))
		to_chat(changeling, "You have evolved beyond your clownish nature, allowing you to wield weapons without harming yourself.")
		changeling.mutations.Remove(MUTATION_CLUMSY)

	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		to_chat(changeling, "<B>You must complete the following tasks:</B>")
		show_objectives(changeling)