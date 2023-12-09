//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/new_player
	universal_speak = TRUE

	invisibility = INVISIBILITY_MAXIMUM

	density = FALSE
	stat = DEAD
	canmove = FALSE

	anchored = TRUE	// don't get pushed around

	var/ready = FALSE
	var/spawning = FALSE		//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		//Player counts for the Lobby tab
	var/totalPlayersReady = 0

/mob/new_player/New()
	GLOBL.mob_list += src

/mob/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()

/mob/new_player/proc/new_player_panel_proc()
	var/output = "<div align='center'><B>New Player Options</B>"
	output +="<hr>"
	output += "<p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A></p>"

	if(!global.CTticker || global.CTticker.current_state <= GAME_STATE_PREGAME)
		if(!ready)
			output += "<p><a href='byond://?src=\ref[src];ready=1'>Declare Ready</A></p>"
		else
			output += "<p><b>You are ready</b> (<a href='byond://?src=\ref[src];ready=2'>Cancel</A>)</p>"

	else
		output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

	if(!IsGuestKey(src.key))
		establish_db_connection()

		if(GLOBL.dbcon.IsConnected())
			var/isadmin = 0
			if(src.client && src.client.holder)
				isadmin = 1
			var/DBQuery/query = GLOBL.dbcon.NewQuery("SELECT id FROM erro_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM erro_poll_vote WHERE ckey = \"[ckey]\") AND id NOT IN (SELECT pollid FROM erro_poll_textreply WHERE ckey = \"[ckey]\")")
			query.Execute()
			var/newpoll = 0
			while(query.NextRow())
				newpoll = 1
				break

			if(newpoll)
				output += "<p><b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
			else
				output += "<p><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A></p>"

	output += "</div>"

	src << browse(output,"window=playersetup;size=210x240;can_close=0")
	return

/mob/new_player/Stat()
	..()

	statpanel(PANEL_STATUS)
	if(client.statpanel == PANEL_STATUS && global.CTticker)
		if(global.CTticker.current_state != GAME_STATE_PREGAME)
			stat("Station Time:", "[worldtime2text()]")
	statpanel(PANEL_LOBBY)
	if(client.statpanel == PANEL_LOBBY && global.CTticker)
		if(global.CTticker.hide_mode)
			stat("Game Mode:", "Secret")
		else
			if(!global.CTticker.hide_mode)
				stat("Game Mode:", "[global.CTticker.master_mode]") // Old setting for showing the game mode

		if(global.CTticker.current_state == GAME_STATE_PREGAME)
			stat("Time To Start:", "[global.CTticker.pregame_timeleft][global.CTticker.roundstart_progressing ? "" : " (DELAYED)"]")
			stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")
			totalPlayers = 0
			totalPlayersReady = 0
			for(var/mob/new_player/player in GLOBL.player_list)
				stat("[player.key]", player.ready ? "(Playing)" : null)
				totalPlayers++
				if(player.ready)
					totalPlayersReady++

/mob/new_player/Topic(href, list/href_list)
	if(!client)
		return 0

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return 1

	if(href_list["ready"])
		if(!global.CTticker || global.CTticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			ready = !ready
		else
			ready = FALSE

	if(href_list["refresh"])
		src << browse(null, "window=playersetup") //closes the player setup window
		new_player_panel_proc()

	if(href_list["observe"])
		if(alert(src, "Are you sure you wish to observe? You will have to wait 30 minutes before being able to respawn!", "Player Setup", "Yes", "No") == "Yes")
			if(!client)
				return 1
			var/mob/dead/observer/observer = new()

			spawning = TRUE
			src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

			observer.started_as_observer = 1
			close_spawn_windows()
			var/obj/O = locate("landmark*Observer-Start")
			to_chat(src, SPAN_INFO("Now teleporting."))
			observer.loc = O.loc
			observer.timeofdeath = world.time // Set the time of death so that the respawn timer works correctly.

			client.prefs.update_preview_icon()
			observer.icon = client.prefs.preview_icon
			observer.alpha = 127

			if(client.prefs.be_random_name)
				client.prefs.real_name = random_name(client.prefs.gender)
			observer.real_name = client.prefs.real_name
			observer.name = observer.real_name
			if(!client.holder && !CONFIG_GET(antag_hud_allowed))			// For new ghosts we remove the verb from even showing up if it's not allowed.
				observer.verbs -= /mob/dead/observer/verb/toggle_antagHUD	// Poor guys, don't know what they are missing!
			observer.key = key
			qdel(src)

			return 1

	if(href_list["late_join"])
		if(!global.CTticker || global.CTticker.current_state != GAME_STATE_PLAYING)
			to_chat(usr, SPAN_WARNING("The round is either not ready, or has already finished..."))
			return

		if(client.prefs.species != SPECIES_HUMAN)
			if(!is_alien_whitelisted(src, client.prefs.species) && CONFIG_GET(usealienwhitelist))
				src << alert("You are currently not whitelisted to play [client.prefs.species].")
				return 0

		LateChoices()

	if(href_list["manifest"])
		ViewManifest()

	if(href_list["SelectedJob"])
		if(!GLOBL.enter_allowed)
			to_chat(usr, SPAN_INFO("There is an administrative lock on entering the game!"))
			return

		if(!is_alien_whitelisted(src, client.prefs.species) && CONFIG_GET(usealienwhitelist))
			src << alert("You are currently not whitelisted to play [client.prefs.species].")
			return 0

		AttemptLateSpawn(href_list["SelectedJob"], client.prefs.spawnpoint)
		return

	if(href_list["privacy_poll"])
		establish_db_connection()
		if(!GLOBL.dbcon.IsConnected())
			return
		var/voted = FALSE

		//First check if the person has not voted yet.
		var/DBQuery/query = GLOBL.dbcon.NewQuery("SELECT * FROM erro_privacy WHERE ckey='[src.ckey]'")
		query.Execute()
		while(query.NextRow())
			voted = TRUE
			break

		//This is a safety switch, so only valid options pass through
		var/option = "UNKNOWN"
		switch(href_list["privacy_poll"])
			if("signed")
				option = "SIGNED"
			if("anonymous")
				option = "ANONYMOUS"
			if("nostats")
				option = "NOSTATS"
			if("later")
				usr << browse(null,"window=privacypoll")
				return
			if("abstain")
				option = "ABSTAIN"

		if(option == "UNKNOWN")
			return

		if(!voted)
			var/sql = "INSERT INTO erro_privacy VALUES (null, Now(), '[src.ckey]', '[option]')"
			var/DBQuery/query_insert = GLOBL.dbcon.NewQuery(sql)
			query_insert.Execute()
			usr << "<b>Thank you for your vote!</b>"
			usr << browse(null,"window=privacypoll")

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list["late_join"])
		new_player_panel()

	if(href_list["showpoll"])
		handle_player_polling()
		return

	if(href_list["pollid"])
		var/pollid = href_list["pollid"]
		if(istext(pollid))
			pollid = text2num(pollid)
		if(isnum(pollid))
			src.poll_player(pollid)
		return

	if(href_list["votepollid"] && href_list["votetype"])
		var/pollid = text2num(href_list["votepollid"])
		var/votetype = href_list["votetype"]
		switch(votetype)
			if("OPTION")
				var/optionid = text2num(href_list["voteoptionid"])
				vote_on_poll(pollid, optionid)
			if("TEXT")
				var/replytext = href_list["replytext"]
				log_text_poll_reply(pollid, replytext)
			if("NUMVAL")
				var/id_min = text2num(href_list["minid"])
				var/id_max = text2num(href_list["maxid"])

				if((id_max - id_min) > 100)	//Basic exploit prevention
					usr << "The option ID difference is too big. Please contact administration or the database admin."
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(isnotnull(href_list["o[optionid]"]))	//Test if this optionid was replied to
						var/rating
						if(href_list["o[optionid]"] == "abstain")
							rating = null
						else
							rating = text2num(href_list["o[optionid]"])
							if(!isnum(rating))
								return

						vote_on_numval_poll(pollid, optionid, rating)
			if("MULTICHOICE")
				var/id_min = text2num(href_list["minoptionid"])
				var/id_max = text2num(href_list["maxoptionid"])

				if((id_max - id_min) > 100)	//Basic exploit prevention
					usr << "The option ID difference is too big. Please contact administration or the database admin."
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(isnotnull(href_list["option_[optionid]"]))	//Test if this optionid was selected
						vote_on_poll(pollid, optionid, 1)

/mob/new_player/proc/IsJobAvailable(rank)
	var/datum/job/job = global.CTjobs.get_job(rank)
	if(!job)
		return 0
	if((job.current_positions >= job.total_positions) && job.total_positions != -1)
		return 0
	if(jobban_isbanned(src, rank))
		return 0
	if(!job.player_old_enough(src.client))
		return 0

	return 1

/mob/new_player/proc/AttemptLateSpawn(rank, spawning_at)
	if(src != usr)
		return 0
	if(!global.CTticker || global.CTticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, SPAN_WARNING("The round is either not ready, or has already finished..."))
		return 0
	if(!GLOBL.enter_allowed)
		to_chat(usr, SPAN_INFO("There is an administrative lock on entering the game!"))
		return 0
	if(!IsJobAvailable(rank))
		src << alert("[rank] is not available. Please try another.")
		return 0

	spawning = TRUE
	close_spawn_windows()

	global.CTjobs.assign_role(src, rank, 1)

	var/mob/living/carbon/human/character = create_character()	//creates the human and transfers vars and mind
	global.CTjobs.equip_rank(character, rank, TRUE)				//equips the human
	EquipCustomItems(character)

	//Find our spawning point.
	var/join_message
	var/datum/spawnpoint/S

	if(spawning_at)
		S = GLOBL.spawntypes[spawning_at]

	if(S && istype(S))
		character.loc = pick(S.turfs)
		join_message = S.msg
	else
		character.loc = pick(GLOBL.latejoin)
		join_message = "has arrived on the station"

	character.lastarea = get_area(loc)

	global.CTticker.mode.latespawn(character)

	//ticker.mode.latespawn(character)

	if(character.mind.assigned_role != "Cyborg")
		GLOBL.data_core.manifest_inject(character)
		global.CTticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
		AnnounceArrival(character, rank, join_message)

	else
		character.Robotize()
	qdel(src)

/mob/new_player/proc/AnnounceArrival(mob/living/carbon/human/character, rank, join_message)
	if(global.CTticker.current_state == GAME_STATE_PLAYING)
		var/obj/item/radio/intercom/a = new /obj/item/radio/intercom(null)// BS12 EDIT Arrivals Announcement Computer, rather than the AI.
		if(isnotnull(character.mind.role_alt_title))
			rank = character.mind.role_alt_title
		a.autosay("[character.real_name], [rank ? "[rank]," : "visitor," ] [join_message ? join_message : "has arrived on the station"].", "Arrivals Announcement Computer")
		qdel(a)

/mob/new_player/proc/LateChoices()
	var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000

	var/dat = "<html><body><center>"
	dat += "Round Duration: [round(hours)]h [round(mins)]m<br>"

	if(global.CTemergency) //In case Nanotrasen decides reposess CentCom's shuttles.
		//Shuttle is going to centcom, not recalled
		if(global.CTemergency.going_to_centcom())
			dat += "<font color='red'><b>The station has been evacuated.</b></font><br>"
		// Emergency shuttle is past the point of no recall
		if(global.CTemergency.online())
			if(global.CTemergency.evac)
				dat += "<font color='red'>The station is currently undergoing evacuation procedures.</font><br>"
			else
				// Crew transfer initiated
				dat += "<font color='red'>The station is currently undergoing crew transfer procedures.</font><br>"

	dat += "Choose from the following open positions:<br>"
	for(var/datum/job/job in global.CTjobs.occupations)
		if(job && IsJobAvailable(job.title))
			var/active = 0
			// Only players with the job assigned and AFK for less than 10 minutes count as active
			for(var/mob/M in GLOBL.player_list)
				if(M.mind && M.client && M.mind.assigned_role == job.title && M.client.inactivity <= 10 * 60 * 10)
					active++
			dat += "<a href='byond://?src=\ref[src];SelectedJob=[job.title]'>[job.title] ([job.current_positions]) (Active: [active])</a><br>"

	dat += "</center>"
	src << browse(dat, "window=latechoices;size=300x640;can_close=1")

/mob/new_player/proc/create_character()
	spawning = TRUE
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = GLOBL.all_species[client.prefs.species]
	if(chosen_species)
		if(is_alien_whitelisted(src, client.prefs.species) || !CONFIG_GET(usealienwhitelist) || !(chosen_species.flags & IS_WHITELISTED) || (client.holder.rights & R_ADMIN))// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
			new_character = new(loc, client.prefs.species)

		if(!new_character)
			new_character = new(loc)

		new_character.lastarea = get_area(loc)

	var/datum/language/chosen_language
	if(client.prefs.secondary_language)
		chosen_language = GLOBL.all_languages["[client.prefs.secondary_language]"]
	if(chosen_language)
		if(is_alien_whitelisted(src, client.prefs.secondary_language) || !CONFIG_GET(usealienwhitelist) || !(chosen_language.flags & WHITELISTED) || (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
			new_character.add_language("[client.prefs.secondary_language]")

	if(global.CTticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_for(new_character)
	else
		client.prefs.copy_to(new_character)

	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // MAD JAMS cant last forever yo

	if(mind)
		mind.active = FALSE				//we wish to transfer the key manually
		if(mind.assigned_role == "Clown")				//give them a clownname if they are a clown
			new_character.real_name = pick(GLOBL.clown_names)	//I hate this being here of all places but unfortunately dna is based on real_name!
			new_character.rename_self("clown")
		mind.original = new_character
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

	new_character.name = real_name
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type

	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLASSESBLOCK, 1, 0)
		new_character.disabilities |= NEARSIGHTED

	// And uncomment this, too.
	//new_character.dna.UpdateSE()

	new_character.key = key		//Manually transfer the key to log them in

	return new_character

/mob/new_player/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4>Crew Manifest</h4>"
	dat += GLOBL.data_core.get_manifest(OOC = 1)

	src << browse(dat, "window=manifest;size=370x420;can_close=1")

/mob/new_player/Move()
	return 0

/mob/new_player/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window

/mob/new_player/hear_say(message, verbage = "says", datum/language/language = null, alt_name = "", italics = 0, mob/speaker = null)
	return

/mob/new_player/hear_radio(message, verbage = "says", datum/language/language = null, part_a, part_b, mob/speaker = null, hard_to_hear = 0)
	return