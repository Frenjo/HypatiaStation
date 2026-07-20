/decl/special_role/ninja
	name = "Space Ninja"

	role_type = SPECIAL_ROLE_NINJA
	role_flag = BE_NINJA

/decl/special_role/ninja/setup(mob/living/carbon/human/ninja)
	. = ..()
	ninja.equip_outfit(/decl/hierarchy/outfit/space_ninja)

/decl/special_role/ninja/proc/give_mission(mob/living/carbon/human/user, ninja_type = NINJA_HEEL, custom_mission)
	to_chat(user, SPAN_NOTICE("You are an elite mercenary assassin of the Spider Clan, [user.real_name]. The dreaded \red <B>SPACE NINJA</B>!"))
	to_chat(user, SPAN_NOTICE("You have a variety of abilities at your disposal, thanks to your nano-enhanced cyber armor. Remember your training!"))

	if(custom_mission)
		user.mind.store_memory("<B>Mission:</B> \red [custom_mission].<br>")
		to_chat(user, SPAN_NOTICE("Your current mission is: <B>[SPAN_DANGER(custom_mission)]</B>"))

	else if(CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		FEEDBACK_ANTAGONIST_GREETING_GUIDE(user)

	else
		forge_ninja_objectives(user.mind, ninja_type)

/decl/special_role/ninja/proc/forge_ninja_objectives(datum/mind/ninja, ninja_type = NINJA_HEEL)
	var/list/objective_pool = list()
	var/list/antagonist_list = get_all_antagonists()
	var/list/protagonist_list = get_all_protagonists() - antagonist_list

	switch(ninja_type)
		if(NINJA_FACE)
			objective_pool += hunt_xeno_objectives()

		if(NINJA_HEEL)
			objective_pool += hunt_deathsquad_objectives(antagonist_list)

	if(!length(objective_pool))
		objective_pool += generic_ninja_objectives(ninja_type, protagonist_list, antagonist_list)

	if(!length(objective_pool))
		objective_pool += fallback_ninja_objective()

	var/datum/objective/survive/survive = new /datum/objective/survive()
	objective_pool += survive

	for_no_type_check(var/datum/objective/generated, objective_pool)
		generated.owner = ninja
		ninja.objectives += generated

	var/directive = generate_ninja_directive(ninja_type)
	to_chat(ninja.current, "Your current directive is: [SPAN_DANGER(directive)]")
	to_chat(ninja.current, SPAN_INFO("Try your best to adhere to this."))
	ninja.store_memory("<B>Directive:</B> \red [directive]<br>")

	var/obj_count = 1
	to_chat(ninja.current, SPAN_INFO("Your current objectives:"))
	for_no_type_check(var/datum/objective/objective, ninja.objectives)
		to_chat(ninja.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
		obj_count++

/decl/special_role/ninja/proc/get_all_antagonists()
	// Add a global list tracking all of your antags in the future you will thank me later - Melbert
	var/list/possible_bad_dudes = list(
		global.PCticker.mode.traitors,
		global.PCticker.mode.head_revolutionaries,
		global.PCticker.mode.cult,
		global.PCticker.mode.wizards,
		global.PCticker.mode.changelings,
		global.PCticker.mode.syndicates,
	)

	. = list()
	for_no_type_check(var/list/sublist, possible_bad_dudes)
		for(var/datum/mind/current_mind in sublist)
			if(current_mind.current?.stat != DEAD)
				. += current_mind

/decl/special_role/ninja/proc/get_all_protagonists()
	return global.PCticker.mode.get_living_heads()

/decl/special_role/ninja/proc/hunt_xeno_objectives()
	var/list/xeno_list = list()
	var/list/xeno_queen_list = list()
	for(var/mob/living/carbon/human/xeno in GLOBL.player_list)
		if(istype(xeno.species, /datum/species/xenos))
			xeno_list += xeno
		if(istype(xeno.species, /datum/species/xenos/queen) && xeno.mind && xeno.stat != DEAD)
			xeno_queen_list += xeno

	. = list()
	if(length(xeno_list) <= 3 || length(xeno_queen_list) < 1)
		return

	// If there are more than three humanoid xenos on the station, time to get dangerous.
	// Here we want the ninja to murder all the queens. The other aliens don't really matter.
	for_no_type_check(var/mob/living/carbon/human/xeno_queen, xeno_queen_list)
		var/datum/objective/assassinate/ninja_objective = new /datum/objective/assassinate()
		ninja_objective.target = xeno_queen.mind
		ninja_objective.explanation_text = "Kill \the [xeno_queen]."
		. += ninja_objective

/decl/special_role/ninja/proc/hunt_deathsquad_objectives(list/antagonist_list)
	. = list()
	for(var/datum/mind/current_mind in antagonist_list)//Search and destroy. Since we already have an antagonist list, they should appear there.
		if(current_mind?.has_special_role(SPECIAL_ROLE_DEATH_COMMANDO))
			var/datum/objective/assassinate/ninja_objective = new /datum/objective/assassinate()
			ninja_objective.find_target_by_role(SPECIAL_ROLE_DEATH_COMMANDO, role_type = TRUE)
			. += ninja_objective

#define OBJECTIVE_KILL 1
#define OBJECTIVE_STEAL 2
#define OBJECTIVE_PROTECT 3
#define OBJECTIVE_DEBRAIN 4
#define OBJECTIVE_DOWNLOAD 5
#define OBJECTIVE_CAPTURE 6

/decl/special_role/ninja/proc/generic_ninja_objectives(side = NINJA_FACE, list/protagonist_list, list/antagonist_list)
	var/list/hostile_targets = side == NINJA_FACE ? antagonist_list.Copy() : protagonist_list.Copy()
	var/list/friendly_targets = side == NINJA_FACE ? protagonist_list.Copy() : antagonist_list.Copy()

	var/list/objective_list = list(
		OBJECTIVE_KILL,
		OBJECTIVE_STEAL,
		OBJECTIVE_PROTECT,
		OBJECTIVE_DEBRAIN,
		OBJECTIVE_DOWNLOAD,
		OBJECTIVE_CAPTURE,
	)

	. = list()
	var/objective_count = rand(1, 3)
	var/sanity_count = 10
	while(objective_count > 0 && sanity_count > 0 && length(objective_list) != 0)
		if(!length(hostile_targets))
			objective_list -= OBJECTIVE_KILL
			objective_list -= OBJECTIVE_DEBRAIN
		if(!length(friendly_targets))
			objective_list -= OBJECTIVE_PROTECT

		objective_count -= 1
		sanity_count -= 1
		switch(pick(objective_list))
			if(OBJECTIVE_KILL)
				var/datum/mind/to_kill = pick_n_take(hostile_targets)
				var/datum/objective/assassinate/ninja_objective = new /datum/objective/assassinate()
				var/has_special_role = to_kill.has_special_role()
				var/target_role = has_special_role ? to_kill.special_roles[1] : to_kill.assigned_job.title
				ninja_objective.find_target_by_role(target_role, has_special_role) //If they have a special role, use that instead to find em.
				. += ninja_objective

			if(OBJECTIVE_PROTECT) // Protect. Keeping people alive can be pretty difficult.
				var/datum/mind/to_protect = pick_n_take(friendly_targets)
				var/datum/objective/protect/ninja_objective = new /datum/objective/assassinate()
				var/has_special_role = to_protect.has_special_role()
				var/target_role = has_special_role ? to_protect.special_roles[1] : to_protect.assigned_job.title
				ninja_objective.find_target_by_role(target_role, has_special_role) //If they have a special role, use that instead to find em.
				. += ninja_objective

			if(OBJECTIVE_DEBRAIN) // Debrain
				var/datum/mind/to_debrain = pick_n_take(hostile_targets)
				var/datum/objective/debrain/ninja_objective = new /datum/objective/debrain()
				var/has_special_role = to_debrain.has_special_role()
				var/target_role = has_special_role ? to_debrain.special_roles[1] : to_debrain.assigned_job.title
				ninja_objective.find_target_by_role(target_role, has_special_role) //If they have a special role, use that instead to find em.
				. += ninja_objective

			if(OBJECTIVE_STEAL) // Steal
				var/datum/objective/steal/ninja_objective = new /datum/objective/steal()
				ninja_objective.set_target(pick(ninja_objective.possible_items_special))
				. += ninja_objective

				objective_list -= OBJECTIVE_STEAL // one steal objective is enough

			if(OBJECTIVE_DOWNLOAD) // Download research
				var/datum/objective/download/ninja_objective = new /datum/objective/download()
				ninja_objective.gen_amount_goal()
				. += ninja_objective

				objective_list -= OBJECTIVE_DOWNLOAD // one download objective is enough

			if(OBJECTIVE_CAPTURE) // Capture
				var/datum/objective/capture/ninja_objective = new /datum/objective/capture()
				ninja_objective.gen_amount_goal()
				. += ninja_objective

				objective_list -= OBJECTIVE_CAPTURE // one capture objective is enough

#undef OBJECTIVE_KILL
#undef OBJECTIVE_STEAL
#undef OBJECTIVE_PROTECT
#undef OBJECTIVE_DEBRAIN
#undef OBJECTIVE_DOWNLOAD
#undef OBJECTIVE_CAPTURE

/decl/special_role/ninja/proc/fallback_ninja_objective()
	var/nuke_code
	FOR_MACHINES_TYPED(bomb, /obj/machinery/nuclearbomb)
		var/temp_code = text2num(bomb.r_code)
		if(temp_code) // if it's actually a number. It won't convert any non-numericals.
			nuke_code = bomb.r_code
			break

	. = list()
	if(nuke_code)//If there is a nuke device in world and we got the code.
		var/datum/objective/nuclear/ninja_objective = new /datum/objective/nuclear()
		ninja_objective.explanation_text = "Destroy the station with a nuclear device. The code is [nuke_code]."
		. += ninja_objective

/decl/special_role/ninja/proc/generate_ninja_directive(side)
	var/directive = "[side == NINJA_FACE ? "NanoTrasen" : "The Syndicate"] is your employer. "//Let them know which side they're on.
	switch(rand(1, 19))
		if(1)
			directive += "The Spider Clan must not be linked to this operation. Remain hidden and covert when possible."
		if(2)
			directive += "[GLOBL.current_map.station_name] is financed by an enemy of the Spider Clan. Cause as much structural damage as desired."
		if(3)
			directive += "A wealthy animal rights activist has made a request we cannot refuse. Prioritize saving animal lives whenever possible."
		if(4)
			directive += "The Spider Clan absolutely cannot be linked to this operation. Eliminate witnesses at your discretion."
		if(5)
			directive += "We are currently negotiating with NanoTrasen Central Command. Prioritize saving human lives over ending them."
		if(6)
			directive += "We are engaged in a legal dispute over [GLOBL.current_map.station_name]. If a laywer is present on board, force their cooperation in the matter."
		if(7)
			directive += "A financial backer has made an offer we cannot refuse. Implicate Syndicate involvement in the operation."
		if(8)
			directive += "Let no one question the mercy of the Spider Clan. Ensure the safety of all non-essential personnel you encounter."
		if(9)
			directive += "A free agent has proposed a lucrative business deal. Implicate NanoTrasen involvement in the operation."
		if(10)
			directive += "Our reputation is on the line. Harm as few civilians and innocents as possible."
		if(11)
			directive += "Our honour is on the line. Utilize only honourable tactics when dealing with opponents."
		if(12)
			directive += "We are currently negotiating with a Syndicate leader. Disguise assassinations as suicide or other natural causes."
		if(13)
			directive += "Some disgruntled NanoTrasen employees have been supportive of our operations. Be wary of any mistreatment by command staff."
		if(14)
			var/xenorace = pick("Soghun", "Tajaran", "Skrellian")
			directive += "A group of [xenorace] radicals have been loyal supporters of the Spider Clan. Favor [xenorace] crew whenever possible."
		if(15)
			directive += "The Spider Clan has recently been accused of religious insensitivity. Attempt to speak with the Chaplain and prove these accusations false."
		if(16)
			directive += "The Spider Clan has been bargaining with a competing prosthetics manufacturer. Try to shine NanoTrasen prosthetics in a bad light."
		if(17)
			directive += "The Spider Clan has recently begun recruiting outsiders. Consider suitable candidates and assess their behaviour amongst the crew."
		if(18)
			directive += "A cyborg liberation group has expressed interest in our serves. Prove the Spider Clan merciful towards law-bound synthetics."
		else
			directive += "There are no special supplemental instructions at this time."
	return directive
