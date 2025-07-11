//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/datum/game_mode
	var/list/datum/mind/cult = list()
	var/list/allwords = list(
		"travel", "self", "see", "hell", "blood",
		"join", "tech", "destroy", "other", "hide"
	)

/proc/iscultist(mob/living/M)
	return istype(M) && M.mind && (M.mind in global.PCticker?.mode?.cult)

/proc/is_convertable_to_cult(datum/mind/mind)
	if(!istype(mind))
		return 0
	if(ishuman(mind.current) && (mind.assigned_role in list("Captain", "Chaplain")))
		return 0
	for(var/obj/item/implant/loyalty/L in mind.current)
		if(L && (L.imp_in == mind.current))	//Checks to see if the person contains an implant, then checks that the implant is actually inside of them
			return 0
	return 1

/datum/game_mode/cult
	name = "cult"
	config_tag = "cult"
	restricted_jobs = list("Chaplain", "AI", "Cyborg", "Security Officer", "Warden", "Detective", "Head of Security", "Captain")
	protected_jobs = list()
	required_players = 5
	required_players_secret = 15
	required_enemies = 3
	recommended_enemies = 4

	uplink_welcome = "Nar-Sie Uplink Console:"
	uplink_uses = 10

	var/datum/mind/sacrifice_target = null
	var/finished = 0

	var/list/startwords = list("blood", "join", "self", "hell")

	var/list/objectives = list()

	var/eldergod = 1 //for the summon god objective

	var/const/acolytes_needed = 5 //for the survive objective
	var/const/min_cultists_to_start = 3
	var/const/max_cultists_to_start = 4
	var/acolytes_survived = 0

/datum/game_mode/cult/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Cult!</B>"
	. += "<B>Some crewmembers are attempting to start a cult!</B>"
	. += "<B>Cultists:</B> Complete your objectives. Convert crewmembers to your cause by using the convert rune. Remember - there is no you, there is only the cult."
	. += "<B>Personnel:</B> Do not let the cult succeed in its mission. Brainwashing them with the chaplain's bible reverts them to whatever CentCom-allowed faith they had."

/datum/game_mode/cult/pre_setup()
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		if(prob(50))
			objectives += "survive"
			objectives += "sacrifice"
		else
			objectives += "eldergod"
			objectives += "sacrifice"

	if(CONFIG_GET(/decl/configuration_entry/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	var/list/datum/mind/cultists_possible = get_players_for_role(BE_CULTIST)
	for_no_type_check(var/datum/mind/player, cultists_possible)
		for(var/job in restricted_jobs)//Removing heads and such from the list
			if(player.assigned_role == job)
				cultists_possible -= player

	for(var/cultists_number = 1 to max_cultists_to_start)
		if(!length(cultists_possible))
			break
		var/datum/mind/cultist = pick(cultists_possible)
		cultists_possible -= cultist
		cult += cultist

	return length(cult)

/datum/game_mode/cult/post_setup()
	. = ..()

	modePlayer += cult
	if("sacrifice" in objectives)
		var/list/possible_targets = get_unconvertables()

		if(!length(possible_targets))
			for(var/mob/living/carbon/human/player in GLOBL.player_list)
				if(player.mind && !(player.mind in cult))
					possible_targets += player.mind

		if(length(possible_targets))
			sacrifice_target = pick(possible_targets)

	for_no_type_check(var/datum/mind/cult_mind, cult)
		equip_cultist(cult_mind.current)
		grant_runeword(cult_mind.current)
		update_cult_icons_added(cult_mind)
		to_chat(cult_mind.current, SPAN_INFO("You are a member of the cult!"))
		if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
			memoize_cult_objectives(cult_mind)
		else
			FEEDBACK_ANTAGONIST_GREETING_GUIDE(cult_mind.current)
		cult_mind.special_role = "Cultist"

/datum/game_mode/cult/proc/memoize_cult_objectives(datum/mind/cult_mind)
	for(var/obj_count = 1, obj_count <= length(objectives), obj_count++)
		var/explanation
		switch(objectives[obj_count])
			if("survive")
				explanation = "Our knowledge must live on. Make sure at least [acolytes_needed] acolytes escape on the shuttle to spread their work on an another station."
			if("sacrifice")
				if(sacrifice_target)
					explanation = "Sacrifice [sacrifice_target.name], the [sacrifice_target.assigned_role]. You will need the sacrifice rune (Hell blood join) and three acolytes to do so."
				else
					explanation = "Free objective."
			if("eldergod")
				explanation = "Summon Nar-Sie via the use of the appropriate rune (Hell join self). It will only work if nine cultists stand on and around it."
		to_chat(cult_mind.current, "<B>Objective #[obj_count]</B>: [explanation]")
		cult_mind.memory += "<B>Objective #[obj_count]</B>: [explanation]<BR>"
	to_chat(cult_mind.current, "The convert rune is join blood self")
	cult_mind.memory += "The convert rune is join blood self<BR>"

/datum/game_mode/proc/equip_cultist(mob/living/carbon/human/mob)
	if(!istype(mob))
		return

	if(mob.mind)
		if(mob.mind.assigned_role == "Clown")
			to_chat(mob, "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself.")
			mob.mutations.Remove(MUTATION_CLUMSY)

	var/obj/item/paper/talisman/supply/T = new(mob)
	var/list/slots = list(
		"backpack" = SLOT_ID_IN_BACKPACK,
		"left pocket" = SLOT_ID_L_POCKET,
		"right pocket" = SLOT_ID_R_POCKET,
		"left hand" = SLOT_ID_L_HAND,
		"right hand" = SLOT_ID_R_HAND,
	)
	var/where = mob.equip_in_one_of_slots(T, slots)
	if(!where)
		to_chat(mob, "Unfortunately, you weren't able to get a talisman. This is very bad and you should adminhelp immediately.")
	else
		to_chat(mob, "You have a talisman in your [where], one that will help you start the cult on this station. Use it well and remember - there are others.")
		mob.update_icons()
		return 1

/datum/game_mode/cult/grant_runeword(mob/living/carbon/human/cult_mob, word)
	if(!word)
		if(length(startwords))
			word = pick(startwords)
			startwords -= word
	return ..(cult_mob, word)

/datum/game_mode/proc/grant_runeword(mob/living/carbon/human/cult_mob, word)
	if(!cultwords["travel"])
		runerandom()
	if(!word)
		word = pick(allwords)
	var/wordexp = "[cultwords[word]] is [word]..."
	to_chat(cult_mob, SPAN_WARNING("You remember one thing from the dark teachings of your master... [wordexp]"))
	cult_mob.mind.store_memory("<B>You remember that</B> [wordexp]", 0, 0)

/datum/game_mode/proc/add_cultist(datum/mind/cult_mind) //BASE
	if(!istype(cult_mind))
		return 0
	if(!(cult_mind in cult) && is_convertable_to_cult(cult_mind))
		cult += cult_mind
		update_cult_icons_added(cult_mind)
		return 1

/datum/game_mode/cult/add_cultist(datum/mind/cult_mind) //INHERIT
	if(!..(cult_mind))
		return
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		memoize_cult_objectives(cult_mind)

/datum/game_mode/proc/remove_cultist(datum/mind/cult_mind, show_message = TRUE)
	if(cult_mind in cult)
		cult -= cult_mind
		to_chat(cult_mind.current, SPAN_DANGER("<FONT size = 3>An unfamiliar white light flashes through your mind, cleansing the taint of the dark-one and the memories of your time as his servant with it.</FONT>"))
		cult_mind.memory = ""
		update_cult_icons_removed(cult_mind)
		if(show_message)
			cult_mind.current.visible_message("<FONT size = 3>[cult_mind.current] looks like they just reverted to their old faith!</FONT>")

/datum/game_mode/proc/update_all_cult_icons()
	spawn(0)
		for_no_type_check(var/datum/mind/cultist, cult)
			if(cultist.current)
				if(cultist.current.client)
					for_no_type_check(var/image/I, cultist.current.client.images)
						if(I.icon_state == "cult")
							qdel(I)

		for_no_type_check(var/datum/mind/cultist, cult)
			if(cultist.current)
				if(cultist.current.client)
					for_no_type_check(var/datum/mind/cultist_1, cult)
						if(cultist_1.current)
							var/I = image('icons/mob/mob.dmi', loc = cultist_1.current, icon_state = "cult")
							cultist.current.client.images += I

/datum/game_mode/proc/update_cult_icons_added(datum/mind/cult_mind)
	spawn(0)
		for_no_type_check(var/datum/mind/cultist, cult)
			if(cultist.current)
				if(cultist.current.client)
					var/I = image('icons/mob/mob.dmi', loc = cult_mind.current, icon_state = "cult")
					cultist.current.client.images += I
			if(cult_mind.current)
				if(cult_mind.current.client)
					var/image/J = image('icons/mob/mob.dmi', loc = cultist.current, icon_state = "cult")
					cult_mind.current.client.images += J

/datum/game_mode/proc/update_cult_icons_removed(datum/mind/cult_mind)
	spawn(0)
		for_no_type_check(var/datum/mind/cultist, cult)
			if(cultist.current)
				if(cultist.current.client)
					for_no_type_check(var/image/I, cultist.current.client.images)
						if(I.icon_state == "cult" && I.loc == cult_mind.current)
							qdel(I)

		if(cult_mind.current)
			if(cult_mind.current.client)
				for_no_type_check(var/image/I, cult_mind.current.client.images)
					if(I.icon_state == "cult")
						qdel(I)

/datum/game_mode/cult/proc/get_unconvertables()
	. = list()
	for(var/mob/living/carbon/human/player in GLOBL.mob_list)
		if(!is_convertable_to_cult(player.mind))
			. += player.mind

/datum/game_mode/cult/proc/check_cult_victory()
	var/cult_fail = 0
	if(objectives.Find("survive"))
		cult_fail += check_survive() //the proc returns 1 if there are not enough cultists on the shuttle, 0 otherwise
	if(objectives.Find("eldergod"))
		cult_fail += eldergod //1 by default, 0 if the elder god has been summoned at least once
	if(objectives.Find("sacrifice"))
		if(sacrifice_target && !sacrificed.Find(sacrifice_target)) //if the target has been sacrificed, ignore this step. otherwise, add 1 to cult_fail
			cult_fail++

	return cult_fail //if any objectives aren't met, failure

/datum/game_mode/cult/proc/check_survive()
	acolytes_survived = 0
	for_no_type_check(var/datum/mind/cult_mind, cult)
		if(cult_mind.current && cult_mind.current.stat != DEAD)
			var/area/mind_area = GET_AREA(cult_mind.current)
			if(HAS_AREA_FLAGS(mind_area, AREA_FLAG_IS_CENTCOM))
				acolytes_survived++
	if(acolytes_survived >= acolytes_needed)
		return 0
	else
		return 1

/datum/game_mode/cult/declare_completion()
	if(CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		return 1
	if(!check_cult_victory())
		feedback_set_details("round_end_result", "win - cult win")
		feedback_set("round_end_result", acolytes_survived)
		to_world(SPAN_DANGER("<FONT size = 3>The cult wins! It has succeeded in serving its dark masters!"))
	else
		feedback_set_details("round_end_result", "loss - staff stopped the cult")
		feedback_set("round_end_result", acolytes_survived)
		to_world(SPAN_DANGER("<FONT size = 3>The staff managed to stop the cult!</FONT>"))

	var/text = "<b>Cultists escaped:</b> [acolytes_survived]"
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		if(length(objectives))
			text += "<br><b>The cultists' objectives were:</b>"
			for(var/obj_count = 1, obj_count <= length(objectives), obj_count++)
				var/explanation
				switch(objectives[obj_count])
					if("survive")
						if(!check_survive())
							explanation = "Make sure at least [acolytes_needed] acolytes escape on the shuttle. <font color='green'><B>Success!</B></font>"
							feedback_add_details("cult_objective", "cult_survive|SUCCESS|[acolytes_needed]")
						else
							explanation = "Make sure at least [acolytes_needed] acolytes escape on the shuttle. <font color='red'>Fail.</font>"
							feedback_add_details("cult_objective", "cult_survive|FAIL|[acolytes_needed]")
					if("sacrifice")
						if(sacrifice_target)
							if(sacrifice_target in sacrificed)
								explanation = "Sacrifice [sacrifice_target.name], the [sacrifice_target.assigned_role]. <font color='green'><B>Success!</B></font>"
								feedback_add_details("cult_objective", "cult_sacrifice|SUCCESS")
							else if(sacrifice_target && sacrifice_target.current)
								explanation = "Sacrifice [sacrifice_target.name], the [sacrifice_target.assigned_role]. <font color='red'>Fail.</font>"
								feedback_add_details("cult_objective", "cult_sacrifice|FAIL")
						else
							explanation = "Sacrifice [sacrifice_target.name], the [sacrifice_target.assigned_role]. <font color='red'>Fail (Gibbed).</font>"
							feedback_add_details("cult_objective", "cult_sacrifice|FAIL|GIBBED")
					if("eldergod")
						if(!eldergod)
							explanation = "Summon Nar-Sie. <font color='green'><B>Success!</B></font>"
							feedback_add_details("cult_objective", "cult_narsie|SUCCESS")
						else
							explanation = "Summon Nar-Sie. <font color='red'>Fail.</font>"
						feedback_add_details("cult_objective", "cult_narsie|FAIL")
				text += "<br><B>Objective #[obj_count]</B>: [explanation]"

	to_world(text)
	..()
	return 1

/datum/game_mode/proc/auto_declare_completion_cult()
	if(!length(cult) && !IS_GAME_MODE(/datum/game_mode/cult))
		return

	var/text = "<FONT size = 2><B>The cultists were:</B></FONT>"
	for_no_type_check(var/datum/mind/cultist, cult)
		text += "<br>[cultist.key] was [cultist.name] ("
		if(isnotnull(cultist.current))
			if(cultist.current.stat == DEAD)
				text += "died"
			else
				text += "survived"
			if(cultist.current.real_name != cultist.name)
				text += " as [cultist.current.real_name]"
		else
			text += "body destroyed"
		text += ")"
	to_world(text)