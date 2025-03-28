/*
VOX HEIST ROUNDTYPE
*/
/datum/game_mode/
	var/list/datum/mind/raiders = list()  //Antags.

/datum/game_mode/heist
	name = "heist"
	config_tag = "heist"
	required_players = 15
	required_players_secret = 25
	required_enemies = 4
	recommended_enemies = 6

	var/list/raid_objectives = list()	//Raid objectives.
	var/list/obj/item/implant/cortical/cortical_stacks = list()	//Stacks for 'leave nobody behind' objective.

/datum/game_mode/heist/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Heist!</B>"
	. += "<B>An unidentified bluespace signature has slipped past the Icarus and is approaching [station_name()]!</B>"
	. += "Whoever they are, they're likely up to no good. Protect the crew and station resources against this dastardly threat!"
	. += "<B>Raiders:</B> Loot [station_name()] for anything and everything you need."
	. += "<B>Personnel:</B> Repel the raiders and their low, low prices and/or crossbows."

/datum/game_mode/heist/can_start()
	if(!..())
		return 0

	var/list/candidates = get_players_for_role(BE_RAIDER)
	var/raider_num = 0

	//Check that we have enough vox.
	if(length(candidates) < required_enemies)
		return 0
	else if(length(candidates) < recommended_enemies)
		raider_num = length(candidates)
	else
		raider_num = recommended_enemies

	//Grab candidates randomly until we have enough.
	while(raider_num > 0)
		var/datum/mind/new_raider = pick(candidates)
		raiders += new_raider
		candidates -= new_raider
		raider_num--

	for_no_type_check(var/datum/mind/raider, raiders)
		raider.assigned_role = "MODE"
		raider.special_role = "Vox Raider"
	return 1

/datum/game_mode/heist/post_setup()
	. = ..()

	//Build a list of spawn points.
	var/list/turf/raider_spawn = list()

	for_no_type_check(var/obj/effect/landmark/L, GLOBL.landmark_list)
		if(L.name == "voxstart")
			raider_spawn += GET_TURF(L)
			qdel(L)
			continue

	//Generate objectives for the group.
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		raid_objectives = forge_vox_objectives()

	var/index = 1

	//Spawn the vox!
	for_no_type_check(var/datum/mind/raider, raiders)
		if(index > length(raider_spawn))
			index = 1

		raider.current.forceMove(raider_spawn[index])
		index++

		var/sounds = rand(2, 8)
		var/i = 0
		var/newname = ""

		while(i <= sounds)
			i++
			newname += pick(list("ti", "hi", "ki", "ya", "ta", "ha", "ka", "ya", "chi", "cha", "kah"))

		var/mob/living/carbon/human/vox = raider.current

		vox.real_name = capitalize(newname)
		vox.name = vox.real_name
		raider.name = vox.name
		vox.age = rand(12, 20)
		vox.dna.mutantrace = "vox"
		vox.set_species(SPECIES_VOX)
		vox.languages = list() // Removing language from chargen.
		vox.flavor_text = ""
		vox.add_language("Vox-Pidgin")
		vox.h_style = "Short Vox Quills"
		vox.f_style = "Shaved"
		for(var/datum/organ/external/limb in vox.organs)
			limb.status &= ~(ORGAN_DESTROYED | ORGAN_ROBOT)
		vox.equip_vox_raider()
		vox.regenerate_icons()

		raider.objectives = raid_objectives
		greet_vox(raider)

/datum/game_mode/heist/proc/is_raider_crew_safe()
	if(!length(cortical_stacks))
		return 0

	for_no_type_check(var/obj/item/implant/cortical/stack, cortical_stacks)
		if(GET_AREA(stack) != locate(/area/shuttle/vox/start))
			return 0
	return 1

/datum/game_mode/heist/proc/is_raider_crew_alive()
	for_no_type_check(var/datum/mind/raider, raiders)
		if(raider.current)
			if(ishuman(raider.current) && raider.current.stat != DEAD)
				return 1
	return 0

/datum/game_mode/heist/proc/forge_vox_objectives()
	var/i = 1
	var/max_objectives = pick(2, 2, 2, 2, 3, 3, 3, 4)
	var/list/objs = list()
	while(i <= max_objectives)
		var/list/goals = list("kidnap", "loot", "salvage")
		var/goal = pick(goals)
		var/datum/objective/heist/O

		if(goal == "kidnap")
			goals -= "kidnap"
			O = new /datum/objective/heist/kidnap()
		else if(goal == "loot")
			O = new /datum/objective/heist/loot()
		else
			O = new /datum/objective/heist/salvage()
		O.choose_target()
		objs += O

		i++

	//-All- vox raids have these two objectives. Failing them loses the game.
	objs += new /datum/objective/heist/inviolate_crew
	objs += new /datum/objective/heist/inviolate_death

	return objs

/datum/game_mode/heist/proc/greet_vox(datum/mind/raider)
	to_chat(raider.current, SPAN_INFO_B("You are a Vox Raider, fresh from the Shoal!"))
	to_chat(raider.current, SPAN_INFO("The Vox are a race of cunning, sharp-eyed nomadic raiders and traders endemic to Tau Ceti and much of the unexplored galaxy. You and the crew have come to the [GLOBL.current_map.short_name] for plunder, trade or both."))
	to_chat(raider.current, SPAN_INFO("Vox are cowardly and will flee from larger groups, but corner one or find them en masse and they are vicious."))
	to_chat(raider.current, SPAN_INFO("Use :V to voxtalk, :H to talk on your encrypted channel, and don't forget to turn on your nitrogen internals!"))
	to_chat(raider.current, SPAN_WARNING("IF YOU HAVE NOT PLAYED A VOX BEFORE, REVIEW THIS THREAD: http://baystation12.net/forums/viewtopic.php?f=6&t=8657.")) // TODO: Do some research into this, maybe use the wayback machine or just talk to Loaf?
	var/obj_count = 1
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		for(var/datum/objective/objective in raider.objectives)
			to_chat(raider.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++
	else
		FEEDBACK_ANTAGONIST_GREETING_GUIDE(raider.current)

/datum/game_mode/heist/declare_completion()
	//No objectives, go straight to the feedback.
	if(!length(raid_objectives))
		return ..()

	var/win_type = "Major"
	var/win_group = "Crew"
	var/win_msg = ""

	var/success = length(raid_objectives)

	//Decrease success for failed objectives.
	for(var/datum/objective/O in raid_objectives)
		if(!(O.check_completion()))
			success--

	//Set result by objectives.
	if(success == length(raid_objectives))
		win_type = "Major"
		win_group = "Vox"
	else if(success > 2)
		win_type = "Minor"
		win_group = "Vox"
	else
		win_type = "Minor"
		win_group = "Crew"

	//Now we modify that result by the state of the vox crew.
	if(!is_raider_crew_alive())
		win_type = "Major"
		win_group = "Crew"
		win_msg += "<B>The Vox Raiders have been wiped out!</B>"

	else if(!is_raider_crew_safe())
		if(win_group == "Crew" && win_type == "Minor")
			win_type = "Major"

		win_group = "Crew"
		win_msg += "<B>The Vox Raiders have left someone behind!</B>"

	else
		if(win_group == "Vox")
			if(win_type == "Minor")

				win_type = "Major"
			win_msg += "<B>The Vox Raiders escaped the station!</B>"
		else
			win_msg += "<B>The Vox Raiders were repelled!</B>"

	to_world("\red <FONT size = 3><B>[win_type] [win_group] victory!</B></FONT>")
	to_world("[win_msg]")
	feedback_set_details("round_end_result","heist - [win_type] [win_group]")

	var/count = 1
	for(var/datum/objective/objective in raid_objectives)
		if(objective.check_completion())
			to_world("<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>")
			feedback_add_details("traitor_objective","[objective.type]|SUCCESS")
		else
			to_world("<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>")
			feedback_add_details("traitor_objective","[objective.type]|FAIL")
		count++

	..()

/datum/game_mode/proc/auto_declare_completion_heist()
	if(!length(raiders))
		return

	var/check_return = FALSE
	if(IS_GAME_MODE(/datum/game_mode/heist))
		check_return = TRUE

	var/text = "<FONT size = 2><B>The vox raiders were:</B></FONT>"
	for_no_type_check(var/datum/mind/vox, raiders)
		text += "<br>[vox.key] was [vox.name] ("
		if(check_return)
			var/obj/stack = raiders[vox]
			if(GET_AREA(stack) != locate(/area/shuttle/vox/start))
				text += "left behind)"
				continue
		if(isnotnull(vox.current))
			if(vox.current.stat == DEAD)
				text += "died"
			else
				text += "survived"
			if(vox.current.real_name != vox.name)
				text += " as [vox.current.real_name]"
		else
			text += "body destroyed"
		text += ")"
	to_world(text)

/datum/game_mode/heist/check_finished()
	var/datum/shuttle/multi_shuttle/vox_shuttle = global.PCshuttle.shuttles["Vox Skipjack"]
	if(!is_raider_crew_alive() || vox_shuttle?.returned_home)
		return TRUE
	return ..()