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

	var/list/selected_changelings = list()

/datum/game_mode/changeling/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Changeling!</B>"
	. += "<B>There are alien changelings on the station. Do not let the changelings succeed!</B>"

/datum/game_mode/changeling/pre_setup()
	. = ..()
	var/list/datum/mind/possible_changelings = get_players_for_role(/decl/special_role/changeling)
	if(!length(possible_changelings))
		return 0

	changeling_amount = 1 + round(num_players() / 10)

	for(var/i = 0, i < changeling_amount, i++)
		if(!length(possible_changelings))
			break
		var/datum/mind/changeling = pick(possible_changelings)
		selected_changelings.Add(changeling)
		possible_changelings.Remove(changeling)

/datum/game_mode/changeling/post_setup()
	. = ..()
	var/decl/special_role/changeling/changeling_role = GET_DECL_INSTANCE(__IMPLIED_TYPE__)
	for_no_type_check(var/datum/mind/changeling, selected_changelings)
		changeling_role.setup(changeling.current)

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
		if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
			if(length(changeling.objectives))
				var/count = 1
				for_no_type_check(var/datum/objective/objective, changeling.objectives)
					if(objective.check_completion())
						text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
						feedback_add_details("changeling_objective", "[objective.type]|SUCCESS")
					else
						text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
						feedback_add_details("changeling_objective", "[objective.type]|FAIL")
						changelingwin = FALSE
					count++
			if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
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