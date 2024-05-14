/datum/game_mode/var/list/datum/mind/ninjas = list()
// Keep in mind ninja-procs that aren't here will be where the event's defined
/datum/game_mode/ninja
	name = "ninja"
	config_tag = "ninja"
	required_players = 10 //Can be adjusted later, should suffice for now.
	required_players_secret = 10
	required_enemies = 1
	recommended_enemies = 1
	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)
	var/finished = 0

/datum/game_mode/ninja/announce()
	to_world("<B>The current game mode is Ninja!</B>")

/datum/game_mode/ninja/can_start()
	if(!..())
		return 0
	var/list/datum/mind/possible_ninjas = get_players_for_role(BE_NINJA)
	if(!length(possible_ninjas))
		return 0
	var/datum/mind/ninja = pick(possible_ninjas)
	ninjas += ninja
	modePlayer += ninja
	ninja.assigned_role = "MODE" //So they aren't chosen for other jobs.
	ninja.special_role = "Ninja"
	ninja.original = ninja.current

	/*
	if(!length(global.ninjastart))
		to_chat(ninja.current, SPAN_DANGER("A proper starting location for you could not be found, please report this bug!"))
		to_chat(ninja.current, SPAN_DANGER("Attempting to place at a carpspawn."))
	*/

	//Until such a time as people want to place ninja spawn points, carpspawn will do fine.
	for_no_type_check(var/obj/effect/landmark/L, GLOBL.landmark_list)
		if(L.name == "carpspawn")
			GLOBL.ninjastart.Add(L)
	if(!length(GLOBL.ninjastart) && length(GLOBL.latejoin))
		to_chat(ninja.current, SPAN_DANGER("No spawnable locations could be found. Defaulting to latejoin."))
		return 1
	else if(!length(GLOBL.ninjastart))
		to_chat(ninja.current, SPAN_DANGER("No spawnable locations could be found. Aborting."))
		return 0

	return 1

/datum/game_mode/ninja/pre_setup()
	for_no_type_check(var/datum/mind/ninja, ninjas)
		ninja.current << browse(null, "window=playersetup")
		ninja.current = create_space_ninja(pick(length(GLOBL.ninjastart) ? GLOBL.ninjastart : GLOBL.latejoin))
		ninja.current.ckey = ninja.key
	return 1

/datum/game_mode/ninja/post_setup()
	for_no_type_check(var/datum/mind/ninja, ninjas)
		if(ninja.current && !(ishuman(ninja.current)))
			return 0
		if(!CONFIG_GET(objectives_disabled))
			forge_ninja_objectives(ninja)
		else
			FEEDBACK_ANTAGONIST_GREETING_GUIDE(ninja.current)
		var/mob/living/carbon/human/N = ninja.current
		N.internal = N.suit_store
		N.internals.icon_state = "internal1"
		if(N.wear_suit && istype(N.wear_suit, /obj/item/clothing/suit/space/space_ninja))
			var/obj/item/clothing/suit/space/space_ninja/S = N.wear_suit
			S:randomize_param()
	spawn (rand(waittime_l, waittime_h))
		send_intercept()
	return ..()

/datum/game_mode/ninja/check_finished()
	if(CONFIG_GET(continous_rounds))
		return ..()
	var/ninjas_alive = 0
	for_no_type_check(var/datum/mind/ninja, ninjas)
		if(!ishuman(ninja.current))
			continue
		if(ninja.current.stat==2)
			continue
		ninjas_alive++
	if(ninjas_alive)
		return ..()
	else
		finished = 1
		return 1

/datum/game_mode/ninja/proc/forge_ninja_objectives(datum/mind/ninja)
	var/objective_list = list(1, 2, 3, 4, 5)
	for(var/i = rand(2, 4), i > 0, i--)
		switch(pick(objective_list))
			if(1)	//Kill
				var/datum/objective/assassinate/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.target = ninja_objective.find_target()
				if(ninja_objective.target != "Free Objective")
					ninja.objectives += ninja_objective
				else
					i++
				objective_list -= 1 // No more than one kill objective
			if(2)	//Steal
				var/datum/objective/steal/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.target = ninja_objective.find_target()
				ninja.objectives += ninja_objective
			if(3)	//Protect
				var/datum/objective/protect/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.target = ninja_objective.find_target()
				if(ninja_objective.target != "Free Objective")
					ninja.objectives += ninja_objective
				else
					i++
					objective_list -= 3
			if(4)	//Download
				var/datum/objective/download/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.gen_amount_goal()
				ninja.objectives += ninja_objective
				objective_list -= 4
			if(5)	//Harm
				var/datum/objective/harm/ninja_objective = new
				ninja_objective.owner = ninja
				ninja_objective.target = ninja_objective.find_target()
				if(ninja_objective.target != "Free Objective")
					ninja.objectives += ninja_objective
				else
					i++
					objective_list -= 5

	var/datum/objective/survive/ninja_objective = new
	ninja_objective.owner = ninja
	ninja.objectives += ninja_objective
	ninja.current.mind = ninja

	var/directive = generate_ninja_directive("heel")//Only hired by antags, not NT
	to_chat(ninja.current, "You are an elite mercenary assassin of the Spider Clan, [ninja.current.real_name]. You have a variety of abilities at your disposal, thanks to your nano-enhanced cyber armor.\nYour current directive is: \red <B>[directive]</B>\n \blue Try your best to adhere to this.")
	ninja.store_memory("<B>Directive:</B> \red [directive]<br>")

	var/obj_count = 1
	to_chat(ninja.current, SPAN_INFO("Your current objectives:"))
	for(var/datum/objective/objective in ninja.objectives)
		to_chat(ninja.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
		obj_count++

/datum/game_mode/proc/auto_declare_completion_ninja()
	if(!length(ninjas))
		return

	var/text = "<FONT size = 2><B>The ninjas were:</B></FONT>"
	for_no_type_check(var/datum/mind/ninja, ninjas)
		var/ninjawin = TRUE
		text += "<br>[ninja.key] was [ninja.name] ("
		if(ninja.current)
			if(ninja.current.stat == DEAD)
				text += "died"
			else
				text += "survived"
			if(ninja.current.real_name != ninja.name)
				text += " as [ninja.current.real_name]"
		else
			text += "body destroyed"
		text += ")"

		if(length(ninja.objectives))//If the ninja had no objectives, don't need to process this.
			var/count = 1
			for(var/datum/objective/objective in ninja.objectives)
				if(objective.check_completion())
					text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
					feedback_add_details("traitor_objective","[objective.type]|SUCCESS")
				else
					text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
					feedback_add_details("traitor_objective","[objective.type]|FAIL")
					ninjawin = FALSE
				count++

		var/special_role_text
		if(ninja.special_role)
			special_role_text = lowertext(ninja.special_role)
		else
			special_role_text = "antagonist"

		if(!CONFIG_GET(objectives_disabled))
			if(ninjawin)
				text += "<br><font color='green'><B>The [special_role_text] was successful!</B></font>"
				feedback_add_details("traitor_success","SUCCESS")
			else
				text += "<br><font color='red'><B>The [special_role_text] has failed!</B></font>"
				feedback_add_details("traitor_success","FAIL")
	to_world(text)