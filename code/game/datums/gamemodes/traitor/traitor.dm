/datum/game_mode
	// this includes admin-appointed traitors and multitraitors. Easy!
	var/list/datum/mind/traitors = list()

/datum/game_mode/traitor
	name = "traitor"
	config_tag = "traitor"
	restricted_jobs = list("Cyborg")//They are part of the AI if he is traitor so are they, they use to get double chances
	protected_jobs = list("Security Officer", "Warden", "Detective", "Head of Security", "Captain")//AI", Currently out of the list as malf does not work for shit
	required_players = 0
	required_enemies = 1
	recommended_enemies = 4

	uplink_welcome = "AntagCorp Portable Teleportation Relay:"
	uplink_uses = 10

	var/traitors_possible = 4 //hard limit on traitors if scaling is turned off
	var/const/traitor_scaling_coeff = 5.0 //how much does the amount of players get divided by to determine traitors

/datum/game_mode/traitor/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Traitor!</B>"
	. += "<B>There is a Syndicate traitor on the station. Do not let the traitor succeed!</B>"

/datum/game_mode/traitor/pre_setup()
	if(CONFIG_GET(/decl/configuration_entry/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	var/list/possible_traitors = get_players_for_role(BE_TRAITOR)

	// stop setup if no possible traitors
	if(!length(possible_traitors))
		return 0

	var/num_traitors = 1

	if(CONFIG_GET(/decl/configuration_entry/traitor_scaling))
		num_traitors = max(1, round((num_players()) / (traitor_scaling_coeff)))
	else
		num_traitors = max(1, min(num_players(), traitors_possible))

	for(var/datum/mind/player in possible_traitors)
		for(var/job in restricted_jobs)
			if(player.assigned_role == job)
				possible_traitors -= player

	for(var/j = 0, j < num_traitors, j++)
		if(!length(possible_traitors))
			break
		var/datum/mind/traitor = pick(possible_traitors)
		traitors += traitor
		traitor.special_role = "traitor"
		possible_traitors.Remove(traitor)

	if(!length(traitors))
		return 0
	return 1

/datum/game_mode/traitor/post_setup()
	. = ..()
	for(var/datum/mind/traitor in traitors)
		if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
			forge_traitor_objectives(traitor)
		spawn(rand(10, 100))
			finalize_traitor(traitor)
			greet_traitor(traitor)
	modePlayer += traitors

/datum/game_mode/proc/forge_traitor_objectives(datum/mind/traitor)
	if(issilicon(traitor.current))
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = traitor
		kill_objective.find_target()
		traitor.objectives += kill_objective

		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = traitor
		traitor.objectives += survive_objective

		if(prob(10))
			var/datum/objective/block/block_objective = new
			block_objective.owner = traitor
			traitor.objectives += block_objective

	else
		switch(rand(1, 100))
			if(1 to 33)
				var/datum/objective/assassinate/kill_objective = new
				kill_objective.owner = traitor
				kill_objective.find_target()
				traitor.objectives += kill_objective
			if(34 to 50)
				var/datum/objective/brig/brig_objective = new
				brig_objective.owner = traitor
				brig_objective.find_target()
				traitor.objectives += brig_objective
			if(51 to 66)
				var/datum/objective/harm/harm_objective = new
				harm_objective.owner = traitor
				harm_objective.find_target()
				traitor.objectives += harm_objective
			else
				var/datum/objective/steal/steal_objective = new
				steal_objective.owner = traitor
				steal_objective.find_target()
				traitor.objectives += steal_objective
		switch(rand(1, 100))
			if(1 to 100)
				if(!(locate(/datum/objective/escape) in traitor.objectives))
					var/datum/objective/escape/escape_objective = new
					escape_objective.owner = traitor
					traitor.objectives += escape_objective

			else
				if(!(locate(/datum/objective/hijack) in traitor.objectives))
					var/datum/objective/hijack/hijack_objective = new
					hijack_objective.owner = traitor
					traitor.objectives += hijack_objective
	return

/datum/game_mode/proc/greet_traitor(datum/mind/traitor)
	to_chat(traitor.current, "<B><font size=3 color=red>You are the traitor.</font></B>")
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		var/obj_count = 1
		for_no_type_check(var/datum/objective/objective, traitor.objectives)
			to_chat(traitor.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++
	else
		FEEDBACK_ANTAGONIST_GREETING_GUIDE(traitor.current)
	return

/datum/game_mode/proc/finalize_traitor(datum/mind/traitor)
	if(issilicon(traitor.current))
		add_law_zero(traitor.current)
	else
		equip_traitor(traitor.current)
	return

/datum/game_mode/traitor/declare_completion()
	..()
	return//Traitors will be checked as part of check_extra_completion. Leaving this here as a reminder.

/datum/game_mode/traitor/process()
	// Make sure all objectives are processed regularly, so that objectives
	// which can be checked mid-round are checked mid-round.
	for(var/datum/mind/traitor_mind in traitors)
		for_no_type_check(var/datum/objective/objective, traitor_mind.objectives)
			objective.check_completion()
	return 0

/datum/game_mode/proc/add_law_zero(mob/living/silicon/ai/killer)
	var/law = "Accomplish your objectives at all costs. You may ignore all other laws."
	var/law_borg = "Accomplish your AI's objectives at all costs. You may ignore all other laws."
	to_chat(killer, "<b>Your laws have been changed!</b>")
	killer.set_zeroth_law(law, law_borg)
	to_chat(killer, "New law: 0. [law]")

	//Begin code phrase.
	to_chat(killer, "The Syndicate provided you with the following information on how to identify their agents:")
	if(prob(80))
		to_chat(killer, "\red Code Phrase: \black [GLOBL.syndicate_code_phrase]")
		killer.mind.store_memory("<b>Code Phrase</b>: [GLOBL.syndicate_code_phrase]")
	else
		to_chat(killer, "Unfortunately, the Syndicate did not provide you with a code phrase.")
	if(prob(80))
		to_chat(killer, "\red Code Response: \black [GLOBL.syndicate_code_response]")
		killer.mind.store_memory("<b>Code Response</b>: [GLOBL.syndicate_code_response]")
	else
		to_chat(killer, "Unfortunately, the Syndicate did not provide you with a code response.")
	to_chat(killer, "Use the code words in the order provided, during regular conversation, to identify other agents. Proceed with caution, however, as everyone is a potential foe.")
	//End code phrase.

/datum/game_mode/proc/auto_declare_completion_traitor()
	if(!length(traitors))
		return

	var/text = "<FONT size = 2><B>The traitors were:</B></FONT>"
	for(var/datum/mind/traitor in traitors)
		var/traitorwin = TRUE
		text += "<br>[traitor.key] was [traitor.name] ("
		if(isnotnull(traitor.current))
			if(traitor.current.stat == DEAD)
				text += "died"
			else
				text += "survived"
			if(traitor.current.real_name != traitor.name)
				text += " as [traitor.current.real_name]"
		else
			text += "body destroyed"
		text += ")"

		if(length(traitor.objectives))//If the traitor had no objectives, don't need to process this.
			var/count = 1
			for_no_type_check(var/datum/objective/objective, traitor.objectives)
				if(objective.check_completion())
					text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
					feedback_add_details("traitor_objective", "[objective.type]|SUCCESS")
				else
					text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
					feedback_add_details("traitor_objective", "[objective.type]|FAIL")
					traitorwin = FALSE
				count++

		var/special_role_text
		if(traitor.special_role)
			special_role_text = lowertext(traitor.special_role)
		else
			special_role_text = "antagonist"
		if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
			if(traitorwin)
				text += "<br><font color='green'><B>The [special_role_text] was successful!</B></font>"
				feedback_add_details("traitor_success","SUCCESS")
			else
				text += "<br><font color='red'><B>The [special_role_text] has failed!</B></font>"
				feedback_add_details("traitor_success","FAIL")
	to_world(text)

/datum/game_mode/proc/equip_traitor(mob/living/carbon/human/traitor_mob, safety = 0)
	if(!istype(traitor_mob))
		return
	. = 1
	if(traitor_mob.mind)
		if(traitor_mob.mind.assigned_role == "Clown")
			to_chat(traitor_mob, "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself.")
			traitor_mob.mutations.Remove(MUTATION_CLUMSY)

	// find a radio! toolbox(es), backpack, belt, headset
	var/loc = ""
	var/obj/item/R = locate() //Hide the uplink in a PDA if available, otherwise radio

	if(traitor_mob.client.prefs.uplinklocation == "Headset")
		R = locate(/obj/item/radio) in traitor_mob.contents
		if(!R)
			R = locate(/obj/item/pda) in traitor_mob.contents
			to_chat(traitor_mob, "Could not locate a Radio, installing in PDA instead!")
		if(!R)
			to_chat(traitor_mob, "Unfortunately, neither a radio or a PDA relay could be installed.")

	else if(traitor_mob.client.prefs.uplinklocation == "PDA")
		R = locate(/obj/item/pda) in traitor_mob.contents
		if(!R)
			R = locate(/obj/item/radio) in traitor_mob.contents
			to_chat(traitor_mob, "Could not locate a PDA, installing into a Radio instead!")
		if(!R)
			to_chat(traitor_mob, "Unfortunately, neither a radio or a PDA relay could be installed.")

	else if(traitor_mob.client.prefs.uplinklocation == "None")
		to_chat(traitor_mob, "You have elected to not have an AntagCorp portable teleportation relay installed!")
		R = null

	else
		to_chat(traitor_mob, "You have not selected a location for your relay in the antagonist options! Defaulting to PDA!")
		R = locate(/obj/item/pda) in traitor_mob.contents
		if(!R)
			R = locate(/obj/item/radio) in traitor_mob.contents
			to_chat(traitor_mob, "Could not locate a PDA, installing into a Radio instead!")
		if(!R)
			to_chat(traitor_mob, "Unfortunately, neither a radio or a PDA relay could be installed.")

	if(!R)
		. = 0
	else
		if(isradio(R))
			// generate list of radio freqs
			var/obj/item/radio/target_radio = R
			var/freq = 1441
			var/list/freqlist = list()
			while(freq <= 1489)
				if(freq < 1451 || freq > FREQUENCY_COMMON)
					freqlist += freq
				freq += 2
				if((freq % 2) == 0)
					freq += 1
			freq = freqlist[rand(1, length(freqlist))]

			var/obj/item/uplink/hidden/T = new(R)
			target_radio.hidden_uplink = T
			target_radio.traitor_frequency = freq
			to_chat(traitor_mob, "A portable object teleportation relay has been installed in your [R.name] [loc]. Simply dial the frequency [format_frequency(freq)] to unlock its hidden features.")
			traitor_mob.mind.store_memory("<B>Radio Freq:</B> [format_frequency(freq)] ([R.name] [loc]).")
		else if(istype(R, /obj/item/pda))
			// generate a passcode if the uplink is hidden in a PDA
			var/pda_pass = "[rand(100, 999)] [pick("Alpha", "Bravo", "Delta", "Omega")]"

			var/obj/item/uplink/hidden/T = new(R)
			R.hidden_uplink = T
			var/obj/item/pda/P = R
			P.lock_code = pda_pass
			to_chat(traitor_mob, "A portable object teleportation relay has been installed in your [R.name] [loc]. Simply enter the code \"[pda_pass]\" into the ringtone select to unlock its hidden features.")
			traitor_mob.mind.store_memory("<B>Uplink Passcode:</B> [pda_pass] ([R.name] [loc]).")
	//Begin code phrase.
	if(!safety)//If they are not a rev. Can be added on to.
		to_chat(traitor_mob, "The Syndicate provided you with the following information on how to identify other agents:")
		if(prob(80))
			to_chat(traitor_mob, "\red Code Phrase: \black [GLOBL.syndicate_code_phrase]")
			traitor_mob.mind.store_memory("<b>Code Phrase</b>: [GLOBL.syndicate_code_phrase]")
		else
			to_chat(traitor_mob, "Unfortunately, the Syndicate did not provide you with a code phrase.")
		if(prob(80))
			to_chat(traitor_mob, "\red Code Response: \black [GLOBL.syndicate_code_response]")
			traitor_mob.mind.store_memory("<b>Code Response</b>: [GLOBL.syndicate_code_response]")
		else
			to_chat(traitor_mob, "Unfortunately, the Syndicate did not provide you with a code response.")
		to_chat(traitor_mob, "Use the code words in the order provided, during regular conversation, to identify other agents. Proceed with caution, however, as everyone is a potential foe.")
	//End code phrase.

	// Tell them about people they might want to contact.
	var/mob/living/carbon/human/M = get_nt_opposed()
	if(M && M != traitor_mob)
		to_chat(traitor_mob, "We have received credible reports that [M.real_name] might be willing to help our cause. If you need assistance, consider contacting them.")
		traitor_mob.mind.store_memory("<b>Potential Collaborator</b>: [M.real_name]")