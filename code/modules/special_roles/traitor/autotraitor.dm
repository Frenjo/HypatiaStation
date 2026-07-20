//This is a beta game mode to test ways to implement an "infinite" traitor round in which more traitors are automatically added in as needed.
//Automatic traitor adding is complete pending the inevitable bug fixes.  Need to add a respawn system to let dead people respawn after 30 minutes or so.

/datum/game_mode/traitor/auto
	name = "AutoTraitor"
	config_tag = "extend-a-traitormongous"

	var/list/datum/mind/possible_traitors = list()
	var/num_players = 0

/datum/game_mode/traitor/auto/get_announce_content()
	. = ..()
	. += "<B>Game mode is AutoTraitor. Traitors will be added to the round automagically as needed.</B>"

/datum/game_mode/traitor/auto/pre_setup()
	. = ..()
	possible_traitors = get_players_for_role(/decl/special_role/traitor)
	// Stop setup if no possible traitors
	if(!length(possible_traitors))
		return 0

	for(var/mob/dead/new_player/P in GLOBL.dead_mob_list)
		if(isnotnull(P.client) && P.ready)
			num_players++

	//var/r = rand(5)
	var/num_traitors = 1
	var/max_traitors = 1
	var/traitor_prob = 0
	max_traitors = round(num_players / 10) + 1
	traitor_prob = (num_players - (max_traitors - 1) * 10) * 10

	if(CONFIG_GET(/decl/configuration_entry/traitor_scaling))
		num_traitors = max_traitors - 1 + prob(traitor_prob)
		log_game("Number of traitors: [num_traitors]")
		message_admins("Players counted: [num_players]  Number of traitors chosen: [num_traitors]")
	else
		num_traitors = max(1, min(num_players(), traitors_possible))

	for(var/i = 0, i < num_traitors, i++)
		var/datum/mind/traitor = pick(possible_traitors)
		selected_traitors += traitor
		possible_traitors.Remove(traitor)

/datum/game_mode/traitor/auto/post_setup()
	. = ..()
	CONFIG_SET(/decl/configuration_entry/respawn, TRUE)
	var/decl/special_role/traitor/traitor_role = GET_DECL_INSTANCE(__IMPLIED_TYPE__)
	for_no_type_check(var/datum/mind/traitor, selected_traitors)
		traitor_role.setup(traitor.current)
	traitorcheckloop()

/datum/game_mode/traitor/auto/proc/traitorcheckloop()
	spawn(9000)
		if(global.PCemergency.departed)
			return
		//message_admins("Performing AutoTraitor Check")
		var/playercount = 0
		var/traitorcount = 0
		for(var/mob/living/player in GLOBL.mob_list)
			if(isnull(player.client))
				continue
			if(player.stat != DEAD)
				playercount += 1
			if(isnull(player.mind) || player.stat == DEAD)
				continue
			if(player.mind.has_special_role(SPECIAL_ROLE_TRAITOR))
				traitorcount += 1
				continue
		possible_traitors = get_players_for_role(/decl/special_role/traitor)

		//message_admins("Live Players: [playercount]")
		//message_admins("Live Traitors: [traitorcount]")
//		message_admins("Potential Traitors:")
//		for(var/mob/living/traitorlist in possible_traitors)
//			message_admins("[traitorlist.real_name]")

//		var/r = rand(5)
//		var/target_traitors = 1
		var/max_traitors = 1
		var/traitor_prob = 0
		max_traitors = round(playercount / 10) + 1
		traitor_prob = (playercount - (max_traitors - 1) * 10) * 5
		if(traitorcount < max_traitors - 1)
			traitor_prob += 50

		if(traitorcount < max_traitors)
			//message_admins("Number of Traitors is below maximum.  Rolling for new Traitor.")
			//message_admins("The probability of a new traitor is [traitor_prob]%")
			if(prob(traitor_prob))
				message_admins("Making a new Traitor.")
				if(!length(possible_traitors))
					message_admins("No potential traitors.  Cancelling new traitor.")
					traitorcheckloop()
					return
				var/mob/living/newtraitor = pick(possible_traitors)
				var/decl/special_role/traitor/traitor_role = GET_DECL_INSTANCE(__IMPLIED_TYPE__)
				//message_admins("[newtraitor.real_name] is the new Traitor.")
				to_chat(newtraitor, "\red <B>ATTENTION:</B> \black It is time to pay your debt to the Syndicate...")
				traitor_role.setup(newtraitor)
			//else
				//message_admins("No new traitor being added.")
		//else
			//message_admins("Number of Traitors is at maximum.  Not making a new Traitor.")

		traitorcheckloop()

/datum/game_mode/traitor/auto/latespawn(mob/living/carbon/human/character)
	. = ..()
	if(global.PCemergency.departed)
		return
	//message_admins("Late Join Check")
	if((character.client && character.client.prefs.be_special & BE_TRAITOR) && !jobban_isbanned(character, "Syndicate"))
		//message_admins("Late Joiner has Be Syndicate")
		//message_admins("Checking number of players")
		var/playercount = 0
		var/traitorcount = 0
		for(var/mob/living/player in GLOBL.mob_list)
			if(isnull(player.client))
				continue
			if(player.stat != DEAD)
				playercount += 1
			if(player.mind?.has_special_role(SPECIAL_ROLE_TRAITOR) && player.stat != DEAD)
				traitorcount += 1
		//message_admins("Live Players: [playercount]")
		//message_admins("Live Traitors: [traitorcount]")

		//var/r = rand(5)
		//var/target_traitors = 1
		var/max_traitors = 2
		var/traitor_prob = 0
		max_traitors = round(playercount / 10) + 1
		traitor_prob = (playercount - (max_traitors - 1) * 10) * 5
		if(traitorcount < max_traitors - 1)
			traitor_prob += 50

		//target_traitors = max(1, min(round((playercount + r) / 10, 1), traitors_possible))
		//message_admins("Target Traitor Count is: [target_traitors]")
		if(traitorcount < max_traitors)
			//message_admins("Number of Traitors is below maximum.  Rolling for New Arrival Traitor.")
			//message_admins("The probability of a new traitor is [traitor_prob]%")
			if(prob(traitor_prob))
				message_admins("New traitor roll passed.  Making a new Traitor.")
				var/decl/special_role/traitor/traitor_role = GET_DECL_INSTANCE(__IMPLIED_TYPE__)
				traitor_role.setup(character)
			//else
				//message_admins("New traitor roll failed.  No new traitor.")
	//else
		//message_admins("Late Joiner does not have Be Syndicate")