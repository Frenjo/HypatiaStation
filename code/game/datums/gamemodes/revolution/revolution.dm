// To add a rev to the list of revolutionaries, make sure it's rev (with if(IS_GAME_MODE(/datum/game_mode/revolution))),
// then call ticker.mode:add_revolutionary(_THE_PLAYERS_MIND_)
// nothing else needs to be done, as that proc will check if they are a valid target.
// Just make sure the converter is a head before you call it!
// To remove a rev (from brainwashing or w/e), call ticker.mode:remove_revolutionary(_THE_PLAYERS_MIND_),
// this will also check they're not a head, so it can just be called freely
// If the rev icons start going wrong for some reason, ticker.mode:update_all_rev_icons() can be called to correct them.
// If the game somtimes isn't registering a win properly, then ticker.mode.check_win() isn't being called somewhere.

/datum/game_mode
	var/list/datum/mind/head_revolutionaries = list()
	var/list/datum/mind/revolutionaries = list()

/datum/game_mode/revolution
	name = "revolution"
	config_tag = "revolution"
	restricted_jobs = list("Security Officer", "Warden", "Detective", "AI", "Cyborg","Captain", "Head of Personnel", "Head of Security", "Chief Engineer", "Research Director", "Chief Medical Officer")
	required_players = 4
	required_players_secret = 15
	required_enemies = 3
	recommended_enemies = 3

	uplink_welcome = "AntagCorp Uplink Console:"
	uplink_uses = 10

	var/finished = 0
	var/checkwin_counter = 0
	var/max_headrevs = 3

///////////////////////////
//Announces the game type//
///////////////////////////
/datum/game_mode/revolution/get_announce_content()
	. = list()
	. += "<B>The current game mode is - Revolution!</B>"
	. += "<B>Some crewmembers are attempting to start a revolution!</B>"
	. += "<B>Revolutionaries:</B> Kill the Captain, HoP, HoS, CE, RD and CMO. Convert other crewmembers (excluding heads of staff and security officers) to your cause by flashing them. Protect your leaders."
	. += "<B>Personnel:</B> Protect the heads of staff. Kill the leaders of the revolution, and brainwash the other revolutionaries (by beating them in the head)."


///////////////////////////////////////////////////////////////////////////////
//Gets the round setup, cancelling if there's not enough players at the start//
///////////////////////////////////////////////////////////////////////////////
/datum/game_mode/revolution/pre_setup()
	if(CONFIG_GET(/decl/configuration_entry/protect_roles_from_antagonist))
		restricted_jobs += protected_jobs

	var/list/datum/mind/possible_headrevs = get_players_for_role(BE_REV)

	var/head_check = 0
	for(var/mob/dead/new_player/player in GLOBL.dead_mob_list)
		if(player.mind.assigned_role in GLOBL.command_positions)
			head_check = 1
			break

	for_no_type_check(var/datum/mind/player, possible_headrevs)
		for(var/job in restricted_jobs)//Removing heads and such from the list
			if(player.assigned_role == job)
				possible_headrevs -= player

	for(var/i = 1 to max_headrevs)
		if(!length(possible_headrevs))
			break
		var/datum/mind/lenin = pick(possible_headrevs)
		possible_headrevs -= lenin
		head_revolutionaries += lenin

	if(!length(head_revolutionaries) || !head_check)
		return 0
	return 1


/datum/game_mode/revolution/post_setup()
	. = ..()
	var/list/heads = get_living_heads()
	for(var/datum/mind/rev_mind in head_revolutionaries)
		if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
			for(var/datum/mind/head_mind in heads)
				var/datum/objective/mutiny/rev_obj = new
				rev_obj.owner = rev_mind
				rev_obj.target = head_mind
				rev_obj.explanation_text = "Assassinate [head_mind.name], the [head_mind.assigned_role]."
				rev_mind.objectives += rev_obj

	//	equip_traitor(rev_mind.current, 1) //changing how revs get assigned their uplink so they can get PDA uplinks. --NEO
	//	Removing revolutionary uplinks.	-Pete
		equip_revolutionary(rev_mind.current)
		update_rev_icons_added(rev_mind)

	for(var/datum/mind/rev_mind in head_revolutionaries)
		greet_revolutionary(rev_mind)
	modePlayer += head_revolutionaries
	if(global.PCemergency)
		global.PCemergency.auto_recall = TRUE


/datum/game_mode/revolution/process()
	checkwin_counter++
	if(checkwin_counter >= 5)
		if(!finished)
			global.PCticker.mode.check_win()
		checkwin_counter = 0
	return 0


/datum/game_mode/proc/forge_revolutionary_objectives(datum/mind/rev_mind)
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		var/list/heads = get_living_heads()
		for(var/datum/mind/head_mind in heads)
			var/datum/objective/mutiny/rev_obj = new
			rev_obj.owner = rev_mind
			rev_obj.target = head_mind
			rev_obj.explanation_text = "Assassinate [head_mind.name], the [head_mind.assigned_role]."
			rev_mind.objectives += rev_obj

/datum/game_mode/proc/greet_revolutionary(datum/mind/rev_mind, you_are = 1)
	var/obj_count = 1
	if(you_are)
		to_chat(rev_mind.current, SPAN_INFO("You are a member of the revolutionaries' leadership!"))
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		for_no_type_check(var/datum/objective/objective, rev_mind.objectives)
			to_chat(rev_mind.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			rev_mind.special_role = "Head Revolutionary"
			obj_count++
	else
		FEEDBACK_ANTAGONIST_GREETING_GUIDE(rev_mind.current)

/////////////////////////////////////////////////////////////////////////////////
//This are equips the rev heads with their gear, and makes the clown not clumsy//
/////////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/equip_revolutionary(mob/living/carbon/human/mob)
	if(!istype(mob))
		return

	if(mob.mind)
		if(mob.mind.assigned_role == "Clown")
			to_chat(mob, "Your training has allowed you to overcome your clownish nature, allowing you to wield weapons without harming yourself.")
			mob.mutations.Remove(MUTATION_CLUMSY)

	var/obj/item/flash/T = new(mob)

	var/list/slots = list (
		"backpack" = SLOT_ID_IN_BACKPACK,
		"left pocket" = SLOT_ID_L_POCKET,
		"right pocket" = SLOT_ID_R_POCKET,
		"left hand" = SLOT_ID_L_HAND,
		"right hand" = SLOT_ID_R_HAND,
	)
	var/where = mob.equip_in_one_of_slots(T, slots)
	if(!where)
		to_chat(mob, "The Syndicate were unfortunately unable to get you a flash.")
	else
		to_chat(mob, "The flash in your [where] will help you to persuade the crew to join your cause.")
		mob.update_icons()
		return 1

//////////////////////////////////////
//Checks if the revs have won or not//
//////////////////////////////////////
/datum/game_mode/revolution/check_win()
	if(check_rev_victory())
		finished = 1
	else if(check_heads_victory())
		finished = 2
	return

///////////////////////////////
//Checks if the round is over//
///////////////////////////////
/datum/game_mode/revolution/check_finished()
	if(CONFIG_GET(/decl/configuration_entry/continous_rounds))
		if(finished != 0)
			if(global.PCemergency)
				global.PCemergency.auto_recall = TRUE
		return ..()
	if(finished != 0)
		return 1
	else
		return 0

///////////////////////////////////////////////////
//Deals with converting players to the revolution//
///////////////////////////////////////////////////
/datum/game_mode/proc/add_revolutionary(datum/mind/rev_mind)
	if(rev_mind.assigned_role in GLOBL.command_positions)
		return 0
	var/mob/living/carbon/human/H = rev_mind.current//Check to see if the potential rev is implanted
	if(H.is_mindshield_implanted() || H.is_loyalty_implanted())
		return FALSE
	if((rev_mind in revolutionaries) || (rev_mind in head_revolutionaries))
		return 0
	revolutionaries += rev_mind
	to_chat(rev_mind.current, SPAN_WARNING("<FONT size = 3> You are now a revolutionary! Help your cause. Do not harm your fellow freedom fighters. You can identify your comrades by the red \"R\" icons, and your leaders by the blue \"R\" icons. Help them kill the heads to win the revolution!</FONT>"))
	rev_mind.special_role = "Revolutionary"
	if(CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		FEEDBACK_ANTAGONIST_GREETING_GUIDE(rev_mind.current)
	update_rev_icons_added(rev_mind)
	return 1
//////////////////////////////////////////////////////////////////////////////
//Deals with players being converted from the revolution (Not a rev anymore)//  // Modified to handle borged MMIs.  Accepts another var if the target is being borged at the time  -- Polymorph.
//////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/remove_revolutionary(datum/mind/rev_mind, beingborged)
	if(rev_mind in revolutionaries)
		revolutionaries -= rev_mind
		rev_mind.special_role = null
		BITSET(rev_mind.current.hud_updateflag, SPECIALROLE_HUD)

		if(beingborged)
			to_chat(rev_mind.current, SPAN_DANGER("<FONT size = 3>The frame's firmware detects and deletes your neural reprogramming!  You remember nothing from the moment you were flashed until now.</FONT>"))

		else
			to_chat(rev_mind.current, SPAN_DANGER("<FONT size = 3>You have been brainwashed! You are no longer a revolutionary! Your memory is hazy from the time you were a rebel...the only thing you remember is the name of the one who brainwashed you...</FONT>"))

		update_rev_icons_removed(rev_mind)
		for(var/mob/living/M in view(rev_mind.current))
			if(beingborged)
				to_chat(M, "The frame beeps contentedly, purging the hostile memory engram from the MMI before initalizing it.")

			else
				to_chat(M, "[rev_mind.current] looks like they just remembered their real allegiance!")


/////////////////////////////////////////////////////////////////////////////////////////////////
//Keeps track of players having the correct icons////////////////////////////////////////////////
//CURRENTLY CONTAINS BUGS:///////////////////////////////////////////////////////////////////////
//-PLAYERS THAT HAVE BEEN REVS FOR AWHILE OBTAIN THE BLUE ICON WHILE STILL NOT BEING A REV HEAD//
// -Possibly caused by cloning of a standard rev/////////////////////////////////////////////////
//-UNCONFIRMED: DECONVERTED REVS NOT LOSING THEIR ICON PROPERLY//////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/datum/game_mode/proc/update_all_rev_icons()
	spawn(0)
		for(var/datum/mind/head_rev_mind in head_revolutionaries)
			if(head_rev_mind.current)
				if(head_rev_mind.current.client)
					for_no_type_check(var/image/I, head_rev_mind.current.client.images)
						if(I.icon_state == "rev" || I.icon_state == "rev_head")
							qdel(I)

		for(var/datum/mind/rev_mind in revolutionaries)
			if(rev_mind.current)
				if(rev_mind.current.client)
					for_no_type_check(var/image/I, rev_mind.current.client.images)
						if(I.icon_state == "rev" || I.icon_state == "rev_head")
							qdel(I)

		for(var/datum/mind/head_rev in head_revolutionaries)
			if(head_rev.current)
				if(head_rev.current.client)
					for(var/datum/mind/rev in revolutionaries)
						if(rev.current)
							var/I = image('icons/mob/mob.dmi', loc = rev.current, icon_state = "rev")
							head_rev.current.client.images += I
					for(var/datum/mind/head_rev_1 in head_revolutionaries)
						if(head_rev_1.current)
							var/I = image('icons/mob/mob.dmi', loc = head_rev_1.current, icon_state = "rev_head")
							head_rev.current.client.images += I

		for(var/datum/mind/rev in revolutionaries)
			if(rev.current)
				if(rev.current.client)
					for(var/datum/mind/head_rev in head_revolutionaries)
						if(head_rev.current)
							var/I = image('icons/mob/mob.dmi', loc = head_rev.current, icon_state = "rev_head")
							rev.current.client.images += I
					for(var/datum/mind/rev_1 in revolutionaries)
						if(rev_1.current)
							var/I = image('icons/mob/mob.dmi', loc = rev_1.current, icon_state = "rev")
							rev.current.client.images += I

////////////////////////////////////////////////////
//Keeps track of converted revs icons///////////////
//Refer to above bugs. They may apply here as well//
////////////////////////////////////////////////////
/datum/game_mode/proc/update_rev_icons_added(datum/mind/rev_mind)
	spawn(0)
		for(var/datum/mind/head_rev_mind in head_revolutionaries)
			if(head_rev_mind.current)
				if(head_rev_mind.current.client)
					var/I = image('icons/mob/mob.dmi', loc = rev_mind.current, icon_state = "rev")
					head_rev_mind.current.client.images += I
			if(rev_mind.current)
				if(rev_mind.current.client)
					var/image/J = image('icons/mob/mob.dmi', loc = head_rev_mind.current, icon_state = "rev_head")
					rev_mind.current.client.images += J

		for(var/datum/mind/rev_mind_1 in revolutionaries)
			if(rev_mind_1.current)
				if(rev_mind_1.current.client)
					var/I = image('icons/mob/mob.dmi', loc = rev_mind.current, icon_state = "rev")
					rev_mind_1.current.client.images += I
			if(rev_mind.current)
				if(rev_mind.current.client)
					var/image/J = image('icons/mob/mob.dmi', loc = rev_mind_1.current, icon_state = "rev")
					rev_mind.current.client.images += J

///////////////////////////////////
//Keeps track of deconverted revs//
///////////////////////////////////
/datum/game_mode/proc/update_rev_icons_removed(datum/mind/rev_mind)
	spawn(0)
		for(var/datum/mind/head_rev_mind in head_revolutionaries)
			if(head_rev_mind.current)
				if(head_rev_mind.current.client)
					for_no_type_check(var/image/I, head_rev_mind.current.client.images)
						if((I.icon_state == "rev" || I.icon_state == "rev_head") && I.loc == rev_mind.current)
							qdel(I)

		for(var/datum/mind/rev_mind_1 in revolutionaries)
			if(rev_mind_1.current)
				if(rev_mind_1.current.client)
					for_no_type_check(var/image/I, rev_mind_1.current.client.images)
						if((I.icon_state == "rev" || I.icon_state == "rev_head") && I.loc == rev_mind.current)
							qdel(I)

		if(rev_mind.current)
			if(rev_mind.current.client)
				for_no_type_check(var/image/I, rev_mind.current.client.images)
					if(I.icon_state == "rev" || I.icon_state == "rev_head")
						qdel(I)

//////////////////////////
//Checks for rev victory//
//////////////////////////
/datum/game_mode/revolution/proc/check_rev_victory()
	for(var/datum/mind/rev_mind in head_revolutionaries)
		for_no_type_check(var/datum/objective/objective, rev_mind.objectives)
			if(!(objective.check_completion()))
				return 0

		return 1

/////////////////////////////
//Checks for a head victory//
/////////////////////////////
/datum/game_mode/revolution/proc/check_heads_victory()
	for(var/datum/mind/rev_mind in head_revolutionaries)
		if(rev_mind.current?.stat != DEAD && isstationlevel(GET_TURF_Z(rev_mind.current)))
			if(ishuman(rev_mind.current))
				return 0
	return 1

//////////////////////////////////////////////////////////////////////
//Announces the end of the game with all relavent information stated//
//////////////////////////////////////////////////////////////////////
/datum/game_mode/revolution/declare_completion()
	if(!CONFIG_GET(/decl/configuration_entry/objectives_disabled))
		if(finished == 1)
			feedback_set_details("round_end_result", "win - heads killed")
			to_world(SPAN_DANGER("<FONT size = 3>The heads of staff were killed or abandoned the station! The revolutionaries win!</FONT>"))
		else if(finished == 2)
			feedback_set_details("round_end_result", "loss - rev heads killed")
			to_world(SPAN_DANGER("<FONT size = 3>The heads of staff managed to stop the revolution!</FONT>"))
		..()
	return 1

/datum/game_mode/proc/auto_declare_completion_revolution()
	if(!length(head_revolutionaries) && !length(revolutionaries) && !IS_GAME_MODE(/datum/game_mode/revolution))
		return

	var/list/targets = list()

	if(length(head_revolutionaries) || IS_GAME_MODE(/datum/game_mode/revolution))
		var/text = "<FONT size = 2><B>The head revolutionaries were:</B></FONT>"
		for(var/datum/mind/headrev in head_revolutionaries)
			text += "<br>[headrev.key] was [headrev.name] ("
			if(headrev.current)
				if(headrev.current.stat == DEAD)
					text += "died"
				else if(isnotstationlevel(headrev.current.z))
					text += "fled the station"
				else
					text += "survived the revolution"
				if(headrev.current.real_name != headrev.name)
					text += " as [headrev.current.real_name]"
			else
				text += "body destroyed"
			text += ")"

			for(var/datum/objective/mutiny/objective in headrev.objectives)
				targets |= objective.target
		to_world(text)

	if(length(revolutionaries) || IS_GAME_MODE(/datum/game_mode/revolution))
		var/text = "<FONT size = 2><B>The revolutionaries were:</B></FONT>"
		for(var/datum/mind/rev in revolutionaries)
			text += "<br>[rev.key] was [rev.name] ("
			if(rev.current)
				if(rev.current.stat == DEAD)
					text += "died"
				else if(isnotstationlevel(rev.current.z))
					text += "fled the station"
				else
					text += "survived the revolution"
				if(rev.current.real_name != rev.name)
					text += " as [rev.current.real_name]"
			else
				text += "body destroyed"
			text += ")"
		to_world(text)

	if(length(head_revolutionaries) || length(revolutionaries) || IS_GAME_MODE(/datum/game_mode/revolution))
		var/text = "<FONT size = 2><B>The heads of staff were:</B></FONT>"
		var/list/heads = get_all_heads()
		for(var/datum/mind/head in heads)
			var/target = (head in targets)
			if(target)
				text += "<font color='red'>"
			text += "<br>[head.key] was [head.name] ("
			if(head.current)
				if(head.current.stat == DEAD)
					text += "died"
				else if(isnotstationlevel(head.current.z))
					text += "fled the station"
				else
					text += "survived the revolution"
				if(head.current.real_name != head.name)
					text += " as [head.current.real_name]"
			else
				text += "body destroyed"
			text += ")"
			if(target)
				text += "</font>"
		to_world(text)

/proc/is_convertable_to_rev(datum/mind/mind)
	return istype(mind) && ishuman(mind.current) && !(mind.assigned_role in GLOBL.command_positions) \
	&& !(mind.assigned_role in list("Security Officer", "Detective", "Warden"))