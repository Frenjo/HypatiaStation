//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
 * GAMEMODES (by Rastaf0)
 *
 * In the new mode system all special roles are fully supported.
 * You can have proper wizards/traitors/changelings/cultists during any mode.
 * Only two things really depends on gamemode:
 * 1. Starting roles, equipment and preparations
 * 2. Conditions of finishing the round.
 *
 */
/datum/game_mode
	var/name = "invalid"
	var/config_tag = null
	var/intercept_hacked = 0
	var/list/intercept_time = list(1 MINUTE, 3 MINUTES) // The time range between which the intercept will be sent.
	var/votable = TRUE
	var/probability = 0
	var/station_was_nuked = 0 //see nuclearbomb.dm and malfunction.dm
	var/explosion_in_progress = 0 //sit back and relax
	var/list/datum/mind/modePlayer = new
	var/list/restricted_jobs = list()	// Jobs it doesn't make sense to be.  I.E chaplain or AI cultist
	var/list/protected_jobs = list()	// Jobs that can't be traitors because
	var/required_players = 0
	var/required_players_secret = 0 //Minimum number of players for that game mode to be chose in Secret
	var/required_enemies = 0
	var/recommended_enemies = 0
	var/newscaster_announcements = null
	var/uplink_welcome = "Syndicate Uplink Console:"
	var/uplink_uses = 10
	var/uplink_items = {"Highly Visible and Dangerous Weapons;
/obj/item/gun/projectile:6:Revolver;
/obj/item/ammo_magazine/a357:2:Ammo-357;
/obj/item/gun/energy/crossbow:5:Energy Crossbow;
/obj/item/melee/energy/sword:4:Energy Sword;
/obj/item/storage/box/syndicate:10:Syndicate Bundle;
/obj/item/storage/box/emps:3:5 EMP Grenades;
Whitespace:Seperator;
Stealthy and Inconspicuous Weapons;
/obj/item/pen/paralysis:3:Paralysis Pen;
/obj/item/soap/syndie:1:Syndicate Soap;
/obj/item/cartridge/syndicate:3:Detomatix PDA Cartridge;
Whitespace:Seperator;
Stealth and Camouflage Items;
/obj/item/clothing/under/chameleon:3:Chameleon Jumpsuit;
/obj/item/clothing/shoes/syndigaloshes:2:No-Slip Syndicate Shoes;
/obj/item/card/id/syndicate:2:Agent ID card;
/obj/item/clothing/mask/gas/voice:4:Voice Changer;
/obj/item/chameleon:4:Chameleon-Projector;
Whitespace:Seperator;
Devices and Tools;
/obj/item/card/emag:3:Cryptographic Sequencer;
/obj/item/storage/toolbox/syndicate:1:Fully Loaded Toolbox;
/obj/item/storage/box/syndie_kit/space:3:Space Suit;
/obj/item/clothing/glasses/thermal/syndi:3:Thermal Imaging Glasses;
/obj/item/encryptionkey/binary:3:Binary Translator Key;
/obj/item/ai_module/syndicate:7:Hacked AI Upload Module;
/obj/item/plastique:2:C-4 (Destroys walls);
/obj/item/powersink:5:Powersink (DANGER!);
/obj/item/radio/beacon/syndicate:7:Singularity Beacon (DANGER!);
/obj/item/circuitboard/teleporter:20:Teleporter Circuit Board;
Whitespace:Seperator;
Implants;
/obj/item/storage/box/syndie_kit/imp_freedom:3:Freedom Implant;
/obj/item/storage/box/syndie_kit/imp_uplink:10:Uplink Implant (Contains 5 Telecrystals);
/obj/item/storage/box/syndie_kit/imp_explosive:6:Explosive Implant (DANGER!);
/obj/item/storage/box/syndie_kit/imp_compress:4:Compressed Matter Implant;Whitespace:Seperator;
(Pointless) Badassery;
/obj/item/toy/syndicateballoon:10:For showing that You Are The BOSS (Useless Balloon);"}

// Items removed from above:
/*
/obj/item/cloaking_device:4:Cloaking Device;	//Replacing cloakers with thermals.	-Pete
*/

/datum/game_mode/New()
	. = ..()
	newscaster_announcements = pick(GLOBL.newscaster_standard_feeds)

/datum/game_mode/proc/announce() // To be called when a round starts.
	SHOULD_NOT_OVERRIDE(TRUE)

	var/list/messages = get_announce_content()
	if(isnotnull(messages))
		to_world(jointext(messages, "\n"))
	else
		to_world("<B>Notice</B>: [src] did not define get_announce_content()")

// Returns a list of strings to be displayed by announce() when a round starts.
/datum/game_mode/proc/get_announce_content()
	RETURN_TYPE(/list)
	return null

///can_start()
///Checks to see if the game can be setup and ran with the current number of players or whatnot.
/datum/game_mode/proc/can_start()
	var/playerC = 0
	for(var/mob/dead/new_player/player in GLOBL.dead_mob_list)
		if(isnotnull(player.client) && player.ready)
			playerC++

	if(global.PCticker.master_mode == "secret")
		if(playerC >= required_players_secret)
			return 1
	else
		if(playerC >= required_players)
			return 1
	return 0

///pre_setup()
///Attempts to select players for special roles the mode might have.
/datum/game_mode/proc/pre_setup()
	return 1

///post_setup()
///Everyone should now be on the station and have their normal gear.  This is the place to give the special roles extra things
/datum/game_mode/proc/post_setup()
	SHOULD_CALL_PARENT(TRUE)

	spawn(ROUNDSTART_LOGOUT_REPORT_TIME)
		display_roundstart_logout_report()

	feedback_set_details("round_start", "[time2text(world.realtime)]")
	if(isnotnull(global.PCticker?.mode))
		feedback_set_details("game_mode", "[global.PCticker.mode]")
	if(global.revdata)
		feedback_set_details("revision", "[global.revdata.revision]")
	feedback_set_details("server_ip", "[world.internet_address]:[world.port]")

	spawn(rand(intercept_time[1], intercept_time[2]))
		send_intercept()
	return 1

///process()
///Called by the gameticker
/datum/game_mode/proc/process()
	return 0

/datum/game_mode/proc/check_finished() //to be called by ticker
	SHOULD_CALL_PARENT(TRUE)

	if(global.PCemergency.returned() || station_was_nuked)
		return 1
	return 0

/datum/game_mode/proc/declare_completion()
	SHOULD_CALL_PARENT(TRUE)

	var/clients = 0
	var/surviving_humans = 0
	var/surviving_total = 0
	var/ghosts = 0
	var/escaped_humans = 0
	var/escaped_total = 0
	var/escaped_on_pod_1 = 0
	var/escaped_on_pod_2 = 0
	var/escaped_on_pod_3 = 0
	var/escaped_on_pod_4 = 0
	var/escaped_on_pod_5 = 0
	var/escaped_on_shuttle = 0

	for_no_type_check(var/mob/M, GLOBL.player_list)
		if(isnotnull(M.client))
			clients++
			if(ishuman(M))
				if(!M.stat)
					surviving_humans++
					var/area/mob_area = GET_AREA(M)
					if(isnotnull(mob_area) && HAS_AREA_FLAGS(mob_area, AREA_FLAG_IS_CENTCOM))
						escaped_humans++
			if(!M.stat)
				surviving_total++
				var/area/mob_area = GET_AREA(M)
				if(isnotnull(mob_area) && HAS_AREA_FLAGS(mob_area, AREA_FLAG_IS_CENTCOM))
					escaped_total++

				if(isnotnull(M.loc?.loc) && M.loc.loc.type == /area/shuttle/escape/centcom)
					escaped_on_shuttle++

				if(isnotnull(M.loc?.loc) && M.loc.loc.type == /area/shuttle/escape_pod/one/centcom)
					escaped_on_pod_1++
				if(isnotnull(M.loc?.loc) && M.loc.loc.type == /area/shuttle/escape_pod/two/centcom)
					escaped_on_pod_2++
				if(isnotnull(M.loc?.loc) && M.loc.loc.type == /area/shuttle/escape_pod/three/centcom)
					escaped_on_pod_3++
				if(isnotnull(M.loc?.loc) && M.loc.loc.type == /area/shuttle/escape_pod/four/centcom)
					escaped_on_pod_4++
				if(isnotnull(M.loc?.loc) && M.loc.loc.type == /area/shuttle/escape_pod/five/centcom)
					escaped_on_pod_5++

			if(isghost(M))
				ghosts++

	if(clients > 0)
		feedback_set("round_end_clients", clients)
	if(ghosts > 0)
		feedback_set("round_end_ghosts", ghosts)
	if(surviving_humans > 0)
		feedback_set("survived_human", surviving_humans)
	if(surviving_total > 0)
		feedback_set("survived_total", surviving_total)
	if(escaped_humans > 0)
		feedback_set("escaped_human", escaped_humans)
	if(escaped_total > 0)
		feedback_set("escaped_total", escaped_total)
	if(escaped_on_shuttle > 0)
		feedback_set("escaped_on_shuttle", escaped_on_shuttle)
	if(escaped_on_pod_1 > 0)
		feedback_set("escaped_on_pod_1", escaped_on_pod_1)
	if(escaped_on_pod_2 > 0)
		feedback_set("escaped_on_pod_2", escaped_on_pod_2)
	if(escaped_on_pod_3 > 0)
		feedback_set("escaped_on_pod_3", escaped_on_pod_3)
	if(escaped_on_pod_4 > 0)
		feedback_set("escaped_on_pod_4", escaped_on_pod_4)
	if(escaped_on_pod_5 > 0)
		feedback_set("escaped_on_pod_5", escaped_on_pod_5)

	send2mainirc("A round of [name] has ended - [surviving_total] survivors, [ghosts] ghosts.")

	return 0

/datum/game_mode/proc/check_win() //universal trigger to be called at mob death, nuke explosion, etc. To be called from everywhere.
	return 0

/datum/game_mode/proc/send_intercept()
	var/text = "<font size = 3><B>CentCom Update</B></font>"
	text += "<br>"
	text += "<font size = 3>Requested status information:</font>"
	text += "<hr>"
	text += "<B>In case you have misplaced your copy, attached is a list of personnel whom reliable sources&trade; suspect may be affiliated with the Syndicate:</B>"
	text += "<br>"

	var/list/mob/suspects = list()
	for(var/mob/living/carbon/human/H in GLOBL.player_list)
		if(isnotnull(H.client) && isnotnull(H.mind))
			// NT relation option
			var/special_role = H.mind.special_role
			if(special_role == "Wizard" || special_role == "Ninja" || special_role == "Syndicate" || special_role == "Vox Raider")
				continue	//NT intelligence ruled out possiblity that those are too classy to pretend to be a crew.
			if(H.client.prefs.nanotrasen_relation == "Opposed" && prob(50) || H.client.prefs.nanotrasen_relation == "Skeptical" && prob(20))
				suspects.Add(H)
			// Antags
			else if(special_role == "traitor" && prob(40) || special_role == "Changeling" && prob(50) \
			|| special_role == "Cultist" && prob(30) || special_role == "Head Revolutionary" && prob(30))
				suspects.Add(H)

				// If they're a traitor or likewise, give them extra TC in exchange.
				var/obj/item/uplink/hidden/suplink = H.mind.find_syndicate_uplink()
				if(isnotnull(suplink))
					var/extra = 4
					suplink.uses += extra
					to_chat(H, SPAN_WARNING("We have received notice that enemy intelligence suspects you to be linked with us. We have thus invested significant resources to increase your uplink's capacity."))
				else
					// Give them a warning!
					to_chat(H, SPAN_WARNING("They are on to you!"))

			// Some poor people who were just in the wrong place at the wrong time..
			else if(prob(10))
				suspects.Add(H)
	for_no_type_check(var/mob/M, suspects)
		switch(rand(1, 100))
			if(1 to 50)
				text += "Someone with the job of <b>[M.mind.assigned_role]</b>."
				text += "<br>"
			else
				text += "<b>[M.name]</b>, the <b>[M.mind.assigned_role]</b>."
				text += "<br>"

	print_command_report(text)

/*
	priority_announce(
		"Summary downloaded and printed out at all communications consoles.", "Enemy communication intercept. Security Level Elevated.",
		'sound/AI/intercept.ogg'
	)
	if(GLOBL.security_level.severity < SEC_LEVEL_BLUE)
		set_security_level(/decl/security_level/blue)
*/

// Returns: The number of people who had the antagonist role set to yes, regardless of recomended_enemies, if that number is greater than recommended_enemies
//			recommended_enemies if the number of people with that role set to yes is less than recomended_enemies,
//			Less if there are not enough valid players in the game entirely to make recommended_enemies.
/datum/game_mode/proc/get_players_for_role(role, override_jobbans = 0)
	. = list()
	var/list/players = list()
	//var/list/drafted = list()
	//var/datum/mind/applicant = null

	var/roletext
	switch(role)
		if(BE_CHANGELING)
			roletext = "changeling"
		if(BE_TRAITOR)
			roletext = "traitor"
		if(BE_OPERATIVE)
			roletext = "operative"
		if(BE_WIZARD)
			roletext = "wizard"
		if(BE_REV)
			roletext = "revolutionary"
		if(BE_CULTIST)
			roletext = "cultist"
		if(BE_NINJA)
			roletext = "ninja"
		if(BE_RAIDER)
			roletext = "raider"

	// Assemble a list of active players without jobbans.
	for(var/mob/dead/new_player/player in GLOBL.dead_mob_list)
		if(player.client && player.ready)
			if(!jobban_isbanned(player, "Syndicate") && !jobban_isbanned(player, roletext))
				players.Add(player)

	// Shuffle the players list so that it becomes ping-independent.
	players = shuffle(players)

	// Get a list of all the people who want to be the antagonist for this round
	for(var/mob/dead/new_player/player in players)
		if(player.client.prefs.be_special & role)
			log_debug("[player.key] had [roletext] enabled, so we are drafting them.")
			. += player.mind
			players.Remove(player)

	// If we don't have enough antags, draft people who voted for the round.
	if(length(.) < recommended_enemies)
		for(var/key in global.PCvote.round_voters)
			for(var/mob/dead/new_player/player in players)
				if(player.ckey == key)
					log_debug("[player.key] voted for this round, so we are drafting them.")
					. += player.mind
					players.Remove(player)
					break

	// Remove candidates who want to be antagonist but have a job that precludes it
	if(restricted_jobs)
		for_no_type_check(var/datum/mind/player, .)
			for(var/job in restricted_jobs)
				if(player.assigned_role == job)
					. -= player

	/*if(length(.) < recommended_enemies)
		for(var/mob/dead/new_player/player in players)
			if(player.client && player.ready)
				if(!(player.client.prefs.be_special & role)) // We don't have enough people who want to be antagonist, make a seperate list of people who don't want to be one
					if(!jobban_isbanned(player, "Syndicate") && !jobban_isbanned(player, roletext)) //Nodrak/Carn: Antag Job-bans
						drafted += player.mind

	if(restricted_jobs)
		for(var/datum/mind/player in drafted)				// Remove people who can't be an antagonist
			for(var/job in restricted_jobs)
				if(player.assigned_role == job)
					drafted -= player

	drafted = shuffle(drafted) // Will hopefully increase randomness, Donkie

	while(length(.) < recommended_enemies)				// Pick randomlly just the number of people we need and add them to our list of candidates
		if(length(drafted) > 0)
			applicant = pick(drafted)
			if(applicant)
				. += applicant
				log_debug("[applicant.key] was force-drafted as [roletext], because there aren't enough candidates.")
				drafted.Remove(applicant)

		else												// Not enough scrubs, ABORT ABORT ABORT
			break

	if(length(.) < recommended_enemies && override_jobbans) //If we still don't have enough people, we're going to start drafting banned people.
		for(var/mob/dead/new_player/player in players)
			if (player.client && player.ready)
				if(jobban_isbanned(player, "Syndicate") || jobban_isbanned(player, roletext)) //Nodrak/Carn: Antag Job-bans
					drafted += player.mind

	if(restricted_jobs)
		for(var/datum/mind/player in drafted)				// Remove people who can't be an antagonist
			for(var/job in restricted_jobs)
				if(player.assigned_role == job)
					drafted -= player

	drafted = shuffle(drafted) // Will hopefully increase randomness, Donkie

	while(length(.) < recommended_enemies)				// Pick randomlly just the number of people we need and add them to our list of candidates
		if(length(drafted) > 0)
			applicant = pick(drafted)
			if(applicant)
				. += applicant
				drafted.Remove(applicant)
				log_debug("[applicant.key] was force-drafted as [roletext], because there aren't enough candidates.")

		else												// Not enough scrubs, ABORT ABORT ABORT
			break
	*/


/datum/game_mode/proc/latespawn(mob)
	return

/*
/datum/game_mode/proc/check_player_role_pref(var/role, var/mob/dead/new_player/player)
	if(player.preferences.be_special & role)
		return 1
	return 0
*/

/datum/game_mode/proc/num_players()
	. = 0
	for(var/mob/dead/new_player/P in GLOBL.dead_mob_list)
		if(isnotnull(P.client) && P.ready)
			. ++

///////////////////////////////////
//Keeps track of all living heads//
///////////////////////////////////
/datum/game_mode/proc/get_living_heads()
	. = list()
	for(var/mob/living/carbon/human/player in GLOBL.mob_list)
		if(player.stat != DEAD && (player.mind?.assigned_role in GLOBL.command_positions))
			. += player.mind

////////////////////////////
//Keeps track of all heads//
////////////////////////////
/datum/game_mode/proc/get_all_heads()
	. = list()
	for_no_type_check(var/mob/player, GLOBL.mob_list)
		if((player.mind?.assigned_role in GLOBL.command_positions))
			. += player.mind

//////////////////////////
//Reports player logouts//
//////////////////////////
/proc/display_roundstart_logout_report()
	var/msg = "\blue <b>Roundstart logout report\n\n"
	for(var/mob/living/L in GLOBL.mob_list)
		if(isnotnull(L.ckey))
			var/found = 0
			for_no_type_check(var/client/C, GLOBL.clients)
				if(C.ckey == L.ckey)
					found = 1
					break
			if(!found)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Disconnected</b></font>)\n"


		if(isnotnull(L.ckey) && isnotnull(L.client))
			if(L.client.inactivity >= (ROUNDSTART_LOGOUT_REPORT_TIME / 2))	//Connected, but inactive (alt+tabbed or something)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Connected, Inactive</b></font>)\n"
				continue //AFK client
			if(L.stat)
				if(L.suiciding)	//Suicider
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='red'><b>Suicide</b></font>)\n"
					continue //Disconnected client
				if(L.stat == UNCONSCIOUS)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dying)\n"
					continue //Unconscious
				if(L.stat == DEAD)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dead)\n"
					continue //Dead

			continue //Happy connected client
		for(var/mob/dead/ghost/D in GLOBL.mob_list)
			if(isnotnull(D.mind) && (D.mind.original == L || D.mind.current == L))
				if(L.stat == DEAD)
					if(L.suiciding)	//Suicider
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Suicide</b></font>)\n"
						continue //Disconnected client
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (Dead)\n"
						continue //Dead mob, ghost abandoned
				else
					if(D.can_reenter_corpse)
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>This shouldn't appear.</b></font>)\n"
						continue //Lolwhat
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Ghosted</b></font>)\n"
						continue //Ghosted while alive

	for_no_type_check(var/mob/M, GLOBL.mob_list)
		if(isnotnull(M.client?.holder))
			to_chat(M, msg)

/proc/get_nt_opposed()
	var/list/dudes = list()
	for(var/mob/living/carbon/human/man in GLOBL.player_list)
		if(isnotnull(man.client))
			if(man.client.prefs.nanotrasen_relation == "Opposed")
				dudes.Add(man)
			else if(man.client.prefs.nanotrasen_relation == "Skeptical" && prob(50))
				dudes.Add(man)
	if(!length(dudes))
		return null
	return pick(dudes)