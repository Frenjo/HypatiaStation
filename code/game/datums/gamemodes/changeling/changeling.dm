var/list/possible_changeling_IDs = list(
	"Alpha", "Beta", "Gamma", "Delta",
	"Epsilon", "Zeta", "Eta", "Theta",
	"Iota", "Kappa", "Lambda", "Mu",
	"Nu", "Xi", "Omicron", "Pi",
	"Rho", "Sigma", "Tau", "Upsilon",
	"Phi", "Chi", "Psi", "Omega"
)

/datum/game_mode
	var/list/datum/mind/changelings = list()

/datum/game_mode/changeling
	name = "changeling"
	config_tag = "changeling"
	restricted_jobs = list("AI", "Cyborg")
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	required_players = 2
	required_players_secret = 10
	required_enemies = 1
	recommended_enemies = 4

	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

	var/const/prob_int_murder_target = 50 // intercept names the assassination target half the time
	var/const/prob_right_murder_target_l = 25 // lower bound on probability of naming right assassination target
	var/const/prob_right_murder_target_h = 50 // upper bound on probability of naimg the right assassination target

	var/const/prob_int_item = 50 // intercept names the theft target half the time
	var/const/prob_right_item_l = 25 // lower bound on probability of naming right theft target
	var/const/prob_right_item_h = 50 // upper bound on probability of naming the right theft target

	var/const/prob_int_sab_target = 50 // intercept names the sabotage target half the time
	var/const/prob_right_sab_target_l = 25 // lower bound on probability of naming right sabotage target
	var/const/prob_right_sab_target_h = 50 // upper bound on probability of naming right sabotage target

	var/const/prob_right_killer_l = 25 //lower bound on probability of naming the right operative
	var/const/prob_right_killer_h = 50 //upper bound on probability of naming the right operative
	var/const/prob_right_objective_l = 25 //lower bound on probability of determining the objective correctly
	var/const/prob_right_objective_h = 50 //upper bound on probability of determining the objective correctly

	var/changeling_amount = 4

/datum/game_mode/changeling/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Changeling!</B>"
	. += "<B>There are alien changelings on the station. Do not let the changelings succeed!</B>"

/datum/game_mode/changeling/pre_setup()
	if(CONFIG_GET(protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	var/list/datum/mind/possible_changelings = get_players_for_role(BE_CHANGELING)

	for(var/datum/mind/player in possible_changelings)
		for(var/job in restricted_jobs)	//Removing robots from the list
			if(player.assigned_role == job)
				possible_changelings -= player

	changeling_amount = 1 + round(num_players() / 10)

	if(length(possible_changelings))
		for(var/i = 0, i < changeling_amount, i++)
			if(!length(possible_changelings))
				break
			var/datum/mind/changeling = pick(possible_changelings)
			possible_changelings -= changeling
			changelings += changeling
			modePlayer += changelings
		return 1
	else
		return 0

/datum/game_mode/changeling/post_setup()
	. = ..()
	for_no_type_check(var/datum/mind/changeling, changelings)
		grant_changeling_powers(changeling.current)
		changeling.special_role = "Changeling"
		if(!CONFIG_GET(objectives_disabled))
			forge_changeling_objectives(changeling)
		greet_changeling(changeling)

/datum/game_mode/proc/forge_changeling_objectives(datum/mind/changeling)
	//OBJECTIVES - Always absorb 5 genomes, plus random traitor objectives.
	//If they have two objectives as well as absorb, they must survive rather than escape
	//No escape alone because changelings aren't suited for it and it'd probably just lead to rampant robusting
	//If it seems like they'd be able to do it in play, add a 10% chance to have to escape alone

	var/datum/objective/absorb/absorb_objective = new
	absorb_objective.owner = changeling
	absorb_objective.gen_amount_goal(2, 3)
	changeling.objectives += absorb_objective

	var/datum/objective/assassinate/kill_objective = new
	kill_objective.owner = changeling
	kill_objective.find_target()
	changeling.objectives += kill_objective

	var/datum/objective/steal/steal_objective = new
	steal_objective.owner = changeling
	steal_objective.find_target()
	changeling.objectives += steal_objective


	switch(rand(1, 100))
		if(1 to 80)
			if(!(locate(/datum/objective/escape) in changeling.objectives))
				var/datum/objective/escape/escape_objective = new
				escape_objective.owner = changeling
				changeling.objectives += escape_objective
		else
			if(!(locate(/datum/objective/survive) in changeling.objectives))
				var/datum/objective/survive/survive_objective = new
				survive_objective.owner = changeling
				changeling.objectives += survive_objective
	return

/datum/game_mode/proc/greet_changeling(datum/mind/changeling, you_are = 1)
	if(you_are)
		to_chat(changeling.current, SPAN_DANGER("You are a changeling!"))
	to_chat(changeling.current, SPAN_DANGER("Use say \":g message\" to communicate with your fellow changelings. Remember: you get all of their absorbed DNA if you absorb them."))

	if(CONFIG_GET(objectives_disabled))
		FEEDBACK_ANTAGONIST_GREETING_GUIDE(changeling.current)

	if(!CONFIG_GET(objectives_disabled))
		to_chat(changeling.current, "<B>You must complete the following tasks:</B>")

	if(changeling.current.mind)
		if(changeling.current.mind.assigned_role == "Clown")
			to_chat(changeling.current, "You have evolved beyond your clownish nature, allowing you to wield weapons without harming yourself.")
			changeling.current.mutations.Remove(CLUMSY)

	if(!CONFIG_GET(objectives_disabled))
		var/obj_count = 1
		for(var/datum/objective/objective in changeling.objectives)
			to_chat(changeling.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++
		return

/*/datum/game_mode/changeling/check_finished()
	var/changelings_alive = 0
	for_no_type_check(var/datum/mind/changeling, changelings)
		if(!iscarbon(changeling.current))
			continue
		if(changeling.current.stat==2)
			continue
		changelings_alive++

	if (changelings_alive)
		changelingdeath = 0
		return ..()
	else
		if (!changelingdeath)
			changelingdeathtime = world.time
			changelingdeath = 1
		if(world.time-changelingdeathtime > TIME_TO_GET_REVIVED)
			return 1
		else
			return ..()
	return 0*/

/datum/game_mode/proc/grant_changeling_powers(mob/living/carbon/changeling_mob)
	if(!istype(changeling_mob))
		return
	changeling_mob.make_changeling()

/datum/game_mode/proc/auto_declare_completion_changeling()
	if(!length(changelings))
		return

	var/text = "<FONT size = 2><B>The changelings were:</B></FONT>"
	for_no_type_check(var/datum/mind/changeling, changelings)
		var/changelingwin = TRUE
		text += "<br>[changeling.key] was [changeling.name] ("
		if(changeling.current)
			if(changeling.current.stat == DEAD)
				text += "died"
			else
				text += "survived"
			if(changeling.current.real_name != changeling.name)
				text += " as [changeling.current.real_name]"
		else
			text += "body destroyed"
			changelingwin = FALSE
		text += ")"

		//Removed sanity if(changeling) because we -want- a runtime to inform us that the changelings list is incorrect and needs to be fixed.
		text += "<br><b>Changeling ID:</b> [changeling.changeling.changelingID]."
		text += "<br><b>Genomes Absorbed:</b> [changeling.changeling.absorbedcount]"
		if(!CONFIG_GET(objectives_disabled))
			if(length(changeling.objectives))
				var/count = 1
				for(var/datum/objective/objective in changeling.objectives)
					if(objective.check_completion())
						text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
						feedback_add_details("changeling_objective", "[objective.type]|SUCCESS")
					else
						text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
						feedback_add_details("changeling_objective", "[objective.type]|FAIL")
						changelingwin = FALSE
					count++
			if(!CONFIG_GET(objectives_disabled))
				if(changelingwin)
					text += "<br><font color='green'><B>The changeling was successful!</B></font>"
					feedback_add_details("changeling_success", "SUCCESS")
				else
					text += "<br><font color='red'><B>The changeling has failed.</B></font>"
					feedback_add_details("changeling_success", "FAIL")
	to_world(text)

/datum/changeling //stores changeling powers, changeling recharge thingie, changeling absorbed DNA and changeling ID (for changeling hivemind)
	var/list/absorbed_dna = list()
	var/absorbedcount = 0
	var/chem_charges = 20
	var/chem_recharge_rate = 0.5
	var/chem_storage = 50
	var/sting_range = 1
	var/changelingID = "Changeling"
	var/geneticdamage = 0
	var/isabsorbing = 0
	var/geneticpoints = 5
	var/purchasedpowers = list()
	var/mimicing = ""

/datum/changeling/New(gender = FEMALE)
	..()
	var/honorific
	if(gender == FEMALE)
		honorific = "Ms."
	else
		honorific = "Mr."
	if(length(possible_changeling_IDs))
		changelingID = pick(possible_changeling_IDs)
		possible_changeling_IDs -= changelingID
		changelingID = "[honorific] [changelingID]"
	else
		changelingID = "[honorific] [rand(1, 999)]"

/datum/changeling/proc/regenerate()
	chem_charges = min(max(0, chem_charges + chem_recharge_rate), chem_storage)
	geneticdamage = max(0, geneticdamage - 1)

/datum/changeling/proc/GetDNA(dna_owner)
	var/datum/dna/chosen_dna
	for(var/datum/dna/DNA in absorbed_dna)
		if(dna_owner == DNA.real_name)
			chosen_dna = DNA
			break
	return chosen_dna