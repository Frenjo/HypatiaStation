// A sort of anti-revolution where the heads are given objectives to mess with the crew

/datum/game_mode/anti_revolution
	name = "anti-revolution"
	config_tag = "anti-revolution"
	required_players = 5

	var/finished = 0
	var/checkwin_counter = 0

	var/required_execute_targets = 1
	var/required_brig_targets = 0

	var/recommended_execute_targets = 1
	var/recommended_brig_targets = 3
	var/recommended_demote_targets = 3

	var/list/datum/mind/heads = list()
	var/list/datum/mind/execute_targets = list()
	var/list/datum/mind/brig_targets = list()
	var/list/datum/mind/demote_targets = list()

///////////////////////////
//Announces the game type//
///////////////////////////
/datum/game_mode/anti_revolution/announce()
	to_world("<B>The current game mode is - Anti-Revolution!</B>")
	to_world("<B>Looks like CentCom has given a few new orders..</B>")

///////////////////////////////////////////////////////////////////////////////
//Gets the round setup, cancelling if there's not enough players at the start//
///////////////////////////////////////////////////////////////////////////////
/datum/game_mode/anti_revolution/pre_setup()
	for(var/mob/dead/new_player/player in GLOBL.dead_mob_list)
		if(player.mind?.assigned_role in command_positions)
			heads += player.mind
		else
			if(length(execute_targets) < recommended_execute_targets)
				execute_targets += player.mind
			else if(length(brig_targets) < recommended_brig_targets)
				brig_targets += player.mind
			else if(length(demote_targets) < recommended_demote_targets)
				demote_targets += player.mind


	if(!length(heads))
		return 0

	if(length(execute_targets) < required_execute_targets || length(brig_targets) < required_brig_targets)
		return 0

	return 1


/datum/game_mode/anti_revolution/proc/add_head_objectives(datum/mind/head)
	for(var/datum/mind/target in execute_targets)
		var/datum/objective/anti_revolution/execute/obj = new
		obj.owner = head
		obj.target = target
		obj.explanation_text = "[target.current.real_name], the [target.assigned_role] has extracted confidential information above their clearance. Execute them."
		head.objectives += obj
	for(var/datum/mind/target in brig_targets)
		var/datum/objective/anti_revolution/brig/obj = new
		obj.owner = head
		obj.target = target
		obj.explanation_text = "Brig [target.current.real_name], the [target.assigned_role] for 20 minutes to set an example."
		head.objectives += obj
	for(var/datum/mind/target in demote_targets)
		var/datum/objective/anti_revolution/demote/obj = new
		obj.owner = head
		obj.target = target
		obj.explanation_text = "[target.current.real_name], the [target.assigned_role]  has been classified as harmful to NanoTrasen's goals. Demote them to assistant."
		head.objectives += obj


/datum/game_mode/anti_revolution/post_setup()
	. = ..()
	for(var/datum/mind/head_mind in heads)
		add_head_objectives(head_mind)
	for(var/datum/mind/head_mind in heads)
		greet_head(head_mind)
	modePlayer += heads


/datum/game_mode/anti_revolution/process()
	checkwin_counter++
	if(checkwin_counter >= 5)
		if(!finished)
			ticker.mode.check_win()
		checkwin_counter = 0
	return 0


/datum/game_mode/proc/greet_head(var/datum/mind/head_mind, var/you_are=1)
	var/obj_count = 1
	if (you_are)
		to_chat(head_mind.current, SPAN_INFO("It looks like this shift CentCom has some special orders for you.. check your objectives."))
		to_chat(head_mind.current, SPAN_INFO("Note that you can ignore these objectives, but resisting NT's orders probably means demotion or worse."))
	for_no_type_check(var/datum/objective/objective, head_mind.objectives)
		to_chat(head_mind.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
		head_mind.special_role = "Corrupt Head"
		obj_count++

	head_mind.current.verbs += /mob/proc/ResignFromHeadPosition

//////////////////////////////////////
//Checks if the revs have won or not//
//////////////////////////////////////
/datum/game_mode/anti_revolution/check_win()
	if(check_head_victory())
		finished = 1
	else if(check_crew_victory())
		finished = 2
	return

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/anti_revolution/check_finished()
	if(finished != 0)
		return 1
	else
		return 0


//////////////////////////
//Checks for crew victory//
//////////////////////////
/datum/game_mode/anti_revolution/proc/check_crew_victory()
	for(var/datum/mind/head_mind in heads)
		if(isnotnull(head_mind) && head_mind.current?.stat != DEAD && isstationlevel(GET_TURF_Z(head_mind.current)) && !head_mind.is_brigged(600))
			if(ishuman(head_mind.current))
				return 0
	return 1

/////////////////////////////
//Checks for a head victory//
/////////////////////////////
/datum/game_mode/anti_revolution/proc/check_head_victory()
	for(var/datum/mind/head_mind in heads)
		for_no_type_check(var/datum/objective/objective, head_mind.objectives)
			if(!(objective.check_completion()))
				return 0

		return 1


/datum/game_mode/anti_revolution/declare_completion()

	var/text = ""
	if(finished == 2)
		to_world(SPAN_DANGER("<FONT size = 3>The heads of staff were relieved of their posts! The crew wins!</FONT>"))
	else if(finished == 1)
		to_world(SPAN_DANGER("<FONT size = 3>The heads of staff managed to meet the goals set for them by CentCom!</FONT>"))



	to_world("<FONT size = 2><B>The heads of staff were: </B></FONT>")
	var/list/heads = list()
	heads = get_all_heads()
	for(var/datum/mind/head_mind in heads)
		text = ""
		if(head_mind.current)
			text += "[head_mind.current.real_name]"
			if(head_mind.current.stat == 2)
				text += " (Dead)"
			else
				text += " (Survived!)"
		else
			text += "[head_mind.key] (character destroyed)"

		to_world(text)


	to_world("<FONT size = 2><B>Their objectives were: </B></FONT>")
	for(var/datum/mind/head_mind in heads)
		if(length(head_mind.objectives))//If the traitor had no objectives, don't need to process this.
			var/count = 1
			for_no_type_check(var/datum/objective/objective, head_mind.objectives)
				if(objective.check_completion())
					text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='green'><B>Success!</B></font>"
					feedback_add_details("head_objective","[objective.type]|SUCCESS")
				else
					text += "<br><B>Objective #[count]</B>: [objective.explanation_text] <font color='red'>Fail.</font>"
					feedback_add_details("head_objective","[objective.type]|FAIL")
				count++
		break // just print once
	return 1


/datum/game_mode/anti_revolution/latespawn(mob/living/carbon/human/character)
	..()
	if(emergency_shuttle.departed)
		return

	if(character.mind.assigned_role in command_positions)
		heads += character.mind
		modePlayer += character.mind
		add_head_objectives(character.mind)
		greet_head(character.mind)

/mob/proc/ResignFromHeadPosition()
	set category = PANEL_IC
	set name = "Resign From Head Position"

	if(!istype(ticker.mode, /datum/game_mode/anti_revolution))
		return

	ticker.mode:heads -= src.mind
	src.mind.objectives = list()
	ticker.mode.modePlayer -= src.mind
	src.mind.special_role = null

	src.verbs -= /mob/proc/ResignFromHeadPosition

	to_chat(src, SPAN_WARNING("You resigned from your position, now you have the consequences."))