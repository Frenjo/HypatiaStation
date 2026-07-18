/datum/game_mode/var/list/datum/mind/ninjas = list()
// Keep in mind ninja-procs that aren't here will be where the event's defined
/datum/game_mode/ninja
	name = "ninja"
	config_tag = "ninja"
	required_players = 10 //Can be adjusted later, should suffice for now.
	required_players_secret = 10
	required_enemies = 1
	recommended_enemies = 1

	var/finished = 0

/datum/game_mode/ninja/get_announce_content()
	. = list()
	. += "<B>The current game mode is Ninja!</B>"

/datum/game_mode/ninja/pre_setup()
	. = ..()
	var/list/datum/mind/possible_ninjas = get_players_for_role(/decl/special_role/ninja)
	if(!length(possible_ninjas))
		return FALSE

	// create_space_ninja gives the suit and whatnot, objectives are handled in post setup
	var/mob/living/new_ninja = create_space_ninja()
	if(isnull(new_ninja))
		return FALSE

	var/datum/mind/ninja = pick(possible_ninjas)
	ninjas += ninja
	ninja.original = ninja.current
	ninja.current = new_ninja
	ninja.current.key = ninja.key

/datum/game_mode/ninja/post_setup()
	. = ..()
	for_no_type_check(var/datum/mind/ninja, ninjas)
		if(ninja.current && !ishuman(ninja.current))
			continue

		var/decl/special_role/ninja/ninja_role = GET_DECL_INSTANCE(__IMPLIED_TYPE__)
		ninja_role.give_mission(ninja.current, NINJA_HEEL) // always assigns to heel

/datum/game_mode/ninja/check_finished()
	if(CONFIG_GET(/decl/configuration_entry/continous_rounds))
		return ..()

	var/ninjas_alive = 0
	for_no_type_check(var/datum/mind/ninja, ninjas)
		if(!ishuman(ninja.current))
			continue
		if(ninja.current.stat == DEAD)
			continue
		ninjas_alive++
	if(ninjas_alive)
		return ..()

	finished = TRUE
	return TRUE

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
			for_no_type_check(var/datum/objective/objective, ninja.objectives)
				if(objective.check_completion())
					text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
					feedback_add_details("traitor_objective","[objective.type]|SUCCESS")
				else
					text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
					feedback_add_details("traitor_objective","[objective.type]|FAIL")
					ninjawin = FALSE
				count++

		var/special_role_text
		if(ninja.has_special_role())
			special_role_text = lowertext(jointext(ninja.special_roles, ", "))
		else
			special_role_text = "antagonist"

		if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
			if(ninjawin)
				text += "<br><font color='green'><B>The [special_role_text] was successful!</B></font>"
				feedback_add_details("traitor_success","SUCCESS")
			else
				text += "<br><font color='red'><B>The [special_role_text] has failed!</B></font>"
				feedback_add_details("traitor_success","FAIL")
	to_world(text)
