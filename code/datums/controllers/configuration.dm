/**
  * Configuration
  *
  * In a gentle way, you can shake the world. ~ Mahatma Gandhi
  *
  * The configuration object sets and globally stores configurable values after loading them from their associated files.
  *
  * Most of this is set up in configuration /New().
  */
/configuration
	var/static/server_name = null					// server name (for world name / status)
	var/static/server_suffix = 0					// generate numeric suffix based on server port

	var/static/nudge_script_path = "nudge.py"		// where the nudge.py script is located

	var/static/log_ooc = 0							// log OOC channel
	var/static/log_access = 0						// log login/logout
	var/static/log_say = 0							// log client say
	var/static/log_admin = 0						// log admin actions
	var/static/log_debug = 1						// log debug output
	var/static/log_game = 0							// log game events
	var/static/log_vote = 0							// log voting
	var/static/log_whisper = 0						// log client whisper
	var/static/log_emote = 0						// log emotes
	var/static/log_attack = 0						// log attack messages
	var/static/log_adminchat = 0					// log admin chat messages
	var/static/log_adminwarn = 0					// log warnings admins get about bomb construction and such
	var/static/log_pda = 0							// log pda messages
	var/static/log_hrefs = 0						// logs all links clicked in-game. Could be used for debugging and tracking down exploits
	var/static/log_runtime = 0						// logs world.log to a file
	var/static/log_world_output = 0					// log world.log << messages
	var/static/sql_enabled = 1						// for sql switching
	var/static/allow_admin_ooccolor = 0				// Allows admins with relevant permissions to have their own ooc colour
	var/static/allow_vote_restart = 0 				// allow votes to restart
	var/static/ert_admin_call_only = 0
	var/static/allow_vote_mode = 0					// allow votes to change mode
	var/static/allow_admin_jump = 1					// allows admin jumping
	var/static/allow_admin_spawning = 1				// allows admin item spawning
	var/static/allow_admin_rev = 1					// allows admin revives
	var/static/vote_delay = 6000					// minimum time between voting sessions (deciseconds, 10 minute default)
	var/static/vote_period = 600					// length of voting period (deciseconds, default 1 minute)
	var/static/vote_autotransfer_initial = 108000	// Length of time before the first autotransfer vote is called
	var/static/vote_autotransfer_interval = 36000	// length of time before next sequential autotransfer vote
	var/static/vote_autogamemode_timeleft = 100		//Length of time before round start when autogamemode vote is called (in seconds, default 100).
	var/static/vote_no_default = 0					// vote does not default to nochange/norestart (tbi)
	var/static/vote_no_dead = 0						// dead people can't vote (tbi)
//	var/static/enable_authentication = 0			// goon authentication
	var/static/del_new_on_log = 1					// del's new players if they log before they spawn in
	var/static/feature_object_spell_system = 0 		//spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard
	var/static/traitor_scaling = FALSE				//if amount of traitors scales based on amount of players
	var/static/objectives_disabled = 0 				//if objectives are disabled or not
	var/static/protect_roles_from_antagonist = 0	// If security and such can be traitor/cult/other
	var/static/continous_rounds = 1					// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
	var/static/allow_Metadata = 0					// Metadata is supported.
	var/static/popup_admin_pm = 0					//adminPMs to non-admins show in a pop-up 'reply' window when set to 1.
	var/static/Ticklag = 0.9
	var/static/Tickcomp = 0
	var/static/socket_talk	= 0						// use socket_talk to communicate with other processes
	var/static/list/resource_urls = null
	var/static/antag_hud_allowed = 0				// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
	var/static/antag_hud_restricted = 0				// Ghosts that turn on Antagovision cannot rejoin the round.
	var/static/list/mode_names = list()
	var/static/list/modes = list()					// allowed modes
	var/static/list/votable_modes = list()			// votable modes
	var/static/list/probabilities = list()			// relative probability of each mode
	var/static/humans_need_surnames = 0
	var/static/allow_random_events = 0				// enables random events mid-round when set to 1
	var/static/allow_ai = 1							// allow ai job
	var/static/hostedby = null
	var/static/respawn = 1
	var/static/guest_jobban = 1
	var/static/usewhitelist = 0
	var/static/kick_inactive = 0					//force disconnect for inactive players
	var/static/load_jobs_from_txt = 0
	var/static/ToRban = 0
	var/static/automute_on = 0						//enables automuting/spam prevention
	var/static/jobs_have_minimal_access = 0			//determines whether jobs use minimal access or expanded access.

	var/static/cult_ghostwriter = 1					//Allows ghosts to write in blood in cult rounds...
	var/static/cult_ghostwriter_req_cultists = 10	//...so long as this many cultists are active.

	var/static/max_maint_drones = 5			//This many drones can spawn,
	var/static/allow_drone_spawn = 1		//assuming the admin allow them to.
	var/static/drone_build_time = 1200		//A drone will become available every X ticks since last drone spawn. Default is 2 minutes.

	var/static/starlight = 0

	var/static/disable_player_mice = 0
	var/static/uneducated_mice = 0		//Set to 1 to prevent newly-spawned mice from understanding human speech

	var/static/usealienwhitelist = 0
	var/static/limitalienplayers = 0
	var/static/alien_to_human_ratio = 0.5

	var/static/server
	var/static/banappeals
	var/static/wikiurl
	var/static/forumurl
	var/static/donateurl	// Why is this even missing damnit Techy/Akai/Numbers! -- Marajin

	//Alert level description
	var/static/alert_desc_green = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."
	var/static/alert_desc_yellow_upto = "There is a security alert in progress. Security staff may have weapons visible, however privacy laws remain fully enforced."
	var/static/alert_desc_yellow_downto = "The possible threat has passed. Security staff may continue to have their weapons visible, however they may no longer conduct random searches."
	var/static/alert_desc_blue_upto = "The station has received reliable information about possible hostile activity on the station. Security staff may have weapons visible, random searches are permitted."
	var/static/alert_desc_blue_downto = "The immediate threat has passed. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still allowed."
	var/static/alert_desc_red_upto = "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised."
	var/static/alert_desc_red_downto = "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised."
	var/static/alert_desc_delta = "The station's self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill."

	var/static/forbid_singulo_possession = 0

	//game_options.txt configs

	var/static/health_threshold_softcrit = 0
	var/static/health_threshold_crit = 0
	var/static/health_threshold_dead = -100

	var/static/organ_health_multiplier = 1
	var/static/organ_regeneration_multiplier = 1

	var/static/bones_can_break = 0
	var/static/limbs_can_break = 0

	var/static/revival_pod_plants = 1
	var/static/revival_cloning = 1
	var/static/revival_brain_life = -1

	//Used for modifying movement speed for mobs.
	//Unversal modifiers
	var/static/run_speed = 0
	var/static/walk_speed = 0

	//Mob specific modifiers. NOTE: These will affect different mob types in different ways
	var/static/human_delay = 0
	var/static/robot_delay = 0
	var/static/monkey_delay = 0
	var/static/alien_delay = 0
	var/static/slime_delay = 0
	var/static/animal_delay = 0

	var/static/admin_legacy_system = 0			//Defines whether the server uses the legacy admin system with admins.txt or the SQL system. Config option in config.txt
	var/static/ban_legacy_system = 0			//Defines whether the server uses the legacy banning system with the files in /data or the SQL system. Config option in config.txt
	var/static/use_age_restriction_for_jobs = 0	//Do jobs use account age restrictions? --requires database

	var/static/simultaneous_pm_warning_timeout = 100

	var/static/use_recursive_explosions	//Defines whether the server uses recursive or circular explosions.

	var/static/assistant_maint = 0		//Do assistants get maint access?
	var/static/gateway_delay = 18000	//How long the gateway takes before it activates. Default is half an hour.
	var/static/ghost_interaction = 0

	var/static/comms_password = ""

	var/static/use_irc_bot = 0
	var/static/irc_bot_host = ""
	var/static/main_irc = ""
	var/static/admin_irc = ""
	var/static/python_path = ""		//Path to the python executable.  Defaults to "python" on windows and "/usr/bin/env python2" on unix
	var/static/use_lib_nudge = 0	//Use the C library nudge instead of the python nudge.

	var/static/list/station_levels = list(1)			// Defines which Z-levels the station exists on.
	var/static/list/admin_levels= list(2)				// Defines which Z-levels which are for admin functionality, for example including such areas as Central Command and the Syndicate Shuttle
	var/static/list/contact_levels = list(1, 5)			// Defines which Z-levels which, for example, a Code Red announcement may affect
	var/static/list/player_levels = list(1, 3, 4, 5, 6)	// Defines all Z-levels a character can typically reach

/configuration/New()
	load_gamemodes()
	load("config/config.txt")
	load("config/game_options.txt", "game_options")
	loadsql("config/dbconfig.txt")
	loadforumsql("config/forumdbconfig.txt")
	// apply some settings from config..
	global.abandon_allowed = respawn

/configuration/proc/load_gamemodes()
	var/list/L = SUBTYPESOF(/datum/game_mode)
	for(var/T in L)
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()

		if(M.config_tag)
			if(!(M.config_tag in modes))	// ensure each mode is added only once
				log_misc("Adding game mode [M.name] ([M.config_tag]) to configuration.")
				src.modes += M.config_tag
				src.mode_names[M.config_tag] = M.name
				src.probabilities[M.config_tag] = M.probability
				if(M.votable)
					src.votable_modes += M.config_tag
		qdel(M)
	src.votable_modes += "secret"

/configuration/proc/load(filename, type = "config") //the type can also be game_options, in which case it uses a different switch. not making it separate to not copypaste code - Urist
	var/list/Lines = file2list(filename)

	for(var/t in Lines)
		if(!t)
			continue

		t = trim(t)
		if(length(t) == 0)
			continue
		else if(copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if(pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if(!name)
			continue

		if(type == "config")
			switch(name)
				if("resource_urls")
					resource_urls = splittext(value, " ")

				if("admin_legacy_system")
					admin_legacy_system = 1

				if("ban_legacy_system")
					ban_legacy_system = 1

				if("use_age_restriction_for_jobs")
					use_age_restriction_for_jobs = 1

				if("jobs_have_minimal_access")
					jobs_have_minimal_access = 1

				if("use_recursive_explosions")
					use_recursive_explosions = 1

				if("log_ooc")
					log_ooc = 1

				if("log_access")
					log_access = 1

				if("sql_enabled")
					sql_enabled = text2num(value)

				if("log_say")
					log_say = 1

				if("log_admin")
					log_admin = 1

				if("log_debug")
					log_debug = text2num(value)

				if("log_game")
					log_game = 1

				if("log_vote")
					log_vote = 1

				if("log_whisper")
					log_whisper = 1

				if("log_attack")
					log_attack = 1

				if("log_emote")
					log_emote = 1

				if("log_adminchat")
					log_adminchat = 1

				if("log_adminwarn")
					log_adminwarn = 1

				if("log_pda")
					log_pda = 1
				
				if("log_world_output")
					log_world_output = 1

				if("log_hrefs")
					log_hrefs = 1

				if("log_runtime")
					log_runtime = 1

				if("allow_admin_ooccolor")
					allow_admin_ooccolor = 1

				if("allow_vote_restart")
					allow_vote_restart = 1

				if("allow_vote_mode")
					allow_vote_mode = 1

				if("allow_admin_jump")
					allow_admin_jump = 1

				if("allow_admin_rev")
					allow_admin_rev = 1

				if("allow_admin_spawning")
					allow_admin_spawning = 1

				if("no_dead_vote")
					vote_no_dead = 1

				if("default_no_vote")
					vote_no_default = 1

				if("vote_delay")
					vote_delay = text2num(value)

				if("vote_period")
					vote_period = text2num(value)

				if("vote_autotransfer_initial")
					vote_autotransfer_initial = text2num(value)

				if("vote_autotransfer_interval")
					vote_autotransfer_interval = text2num(value)

				if("vote_autogamemode_timeleft")
					vote_autogamemode_timeleft = text2num(value)

				if("ert_admin_only")
					ert_admin_call_only = 1

				if("allow_ai")
					allow_ai = 1

//				if("authentication")
//					enable_authentication = 1

				if("norespawn")
					respawn = 0

				if("servername")
					server_name = value

				if("serversuffix")
					server_suffix = 1

				if("nudge_script_path")
					nudge_script_path = value

				if("hostedby")
					hostedby = value

				if("server")
					server = value

				if("banappeals")
					banappeals = value

				if("wikiurl")
					wikiurl = value

				if("forumurl")
					forumurl = value

				if("donateurl") // Why is this even missing damnit Techy/Akai/Numbers! -- Marajin
					donateurl = value

				if("guest_jobban")
					guest_jobban = 1

				if("guest_ban")
					global.guests_allowed = FALSE

				if("usewhitelist")
					usewhitelist = 1

				if("feature_object_spell_system")
					feature_object_spell_system = 1

				if("allow_metadata")
					allow_Metadata = 1

				if("traitor_scaling")
					traitor_scaling = TRUE

				if("objectives_disabled")
					objectives_disabled = 1

				if("protect_roles_from_antagonist")
					protect_roles_from_antagonist = 1

				if("probability")
					var/prob_pos = findtext(value, " ")
					var/prob_name = null
					var/prob_value = null

					if(prob_pos)
						prob_name = lowertext(copytext(value, 1, prob_pos))
						prob_value = copytext(value, prob_pos + 1)
						if(prob_name in modes)
							probabilities[prob_name] = text2num(prob_value)
						else
							log_misc("Unknown game mode probability configuration definition: [prob_name].")
					else
						log_misc("Incorrect probability configuration definition: [prob_name]  [prob_value].")

				if("allow_random_events")
					allow_random_events = 1

				if("kick_inactive")
					kick_inactive = 1

				if("load_jobs_from_txt")
					load_jobs_from_txt = 1

				if("alert_red_upto")
					alert_desc_red_upto = value

				if("alert_red_downto")
					alert_desc_red_downto = value

				if("alert_blue_downto")
					alert_desc_blue_downto = value

				if("alert_blue_upto")
					alert_desc_blue_upto = value

				if("alert_green")
					alert_desc_green = value

				if("alert_delta")
					alert_desc_delta = value

				if("alert_yellow_upto")
					alert_desc_yellow_upto = value

				if("alert_yellow_downto")
					alert_desc_yellow_downto = value

				if("forbid_singulo_possession")
					forbid_singulo_possession = 1

				if("popup_admin_pm")
					popup_admin_pm = 1

				if("allow_holidays")
					global.Holiday = 1

				if("use_irc_bot")
					use_irc_bot = 1

				if("ticklag")
					Ticklag = text2num(value)

				if("allow_antag_hud")
					antag_hud_allowed = 1
				if("antag_hud_restricted")
					antag_hud_restricted = 1

				if("socket_talk")
					socket_talk = text2num(value)

				if("tickcomp")
					Tickcomp = 1

				if("humans_need_surnames")
					humans_need_surnames = 1

				if("tor_ban")
					ToRban = 1

				if("automute_on")
					automute_on = 1

				if("usealienwhitelist")
					usealienwhitelist = 1

				if("alien_player_ratio")
					limitalienplayers = 1
					alien_to_human_ratio = text2num(value)

				if("assistant_maint")
					assistant_maint = 1

				if("gateway_delay")
					gateway_delay = text2num(value)

				if("continuous_rounds")
					continous_rounds = 1

				if("ghost_interaction")
					ghost_interaction = 1

				if("disable_player_mice")
					disable_player_mice = 1

				if("uneducated_mice")
					uneducated_mice = 1

				if("comms_password")
					comms_password = value

				if("irc_bot_host")
					irc_bot_host = value

				if("main_irc")
					main_irc = value

				if("admin_irc")
					admin_irc = value

				if("python_path")
					if(value)
						python_path = value

				if("use_lib_nudge")
					use_lib_nudge = 1

				if("allow_cult_ghostwriter")
					cult_ghostwriter = 1

				if("req_cult_ghostwriter")
					cult_ghostwriter_req_cultists = text2num(value)

				if("allow_drone_spawn")
					allow_drone_spawn = text2num(value)

				if("drone_build_time")
					drone_build_time = text2num(value)

				if("max_maint_drones")
					max_maint_drones = text2num(value)

				if("starlight")
					value = text2num(value)
					starlight = value >= 0 ? value : 0
				
				if("station_levels")
					station_levels = text2numlist(value, ";")
				
				if("admin_levels")
					admin_levels = text2numlist(value, ";")

				if("contact_levels")
					contact_levels = text2numlist(value, ";")

				if("player_levels")
					player_levels = text2numlist(value, ";")

				else
					log_misc("Unknown setting in configuration: '[name]'")

		else if(type == "game_options")
			if(!value)
				log_misc("Unknown value for setting [name] in [filename].")
			value = text2num(value)

			switch(name)
				if("health_threshold_crit")
					health_threshold_crit = value
				if("health_threshold_softcrit")
					health_threshold_softcrit = value
				if("health_threshold_dead")
					health_threshold_dead = value

				if("revival_pod_plants")
					revival_pod_plants = value
				if("revival_cloning")
					revival_cloning = value
				if("revival_brain_life")
					revival_brain_life = value

				if("run_speed")
					run_speed = value
				if("walk_speed")
					walk_speed = value

				if("human_delay")
					human_delay = value
				if("robot_delay")
					robot_delay = value
				if("monkey_delay")
					monkey_delay = value
				if("alien_delay")
					alien_delay = value
				if("slime_delay")
					slime_delay = value
				if("animal_delay")
					animal_delay = value

				if("organ_health_multiplier")
					organ_health_multiplier = value / 100
				if("organ_regeneration_multiplier")
					organ_regeneration_multiplier = value / 100

				if("bones_can_break")
					bones_can_break = value
				if("limbs_can_break")
					limbs_can_break = value
				else
					log_misc("Unknown setting in configuration: '[name]'")

/configuration/proc/loadsql(filename)  // -- TLE
	var/list/Lines = file2list(filename)
	for(var/t in Lines)
		if(!t)
			continue

		t = trim(t)
		if(length(t) == 0)
			continue
		else if(copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if(pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if(!name)
			continue

		switch(name)
			if("address")
				global.sqladdress = value
			if("port")
				global.sqlport = value
			if("database")
				global.sqldb = value
			if("login")
				global.sqllogin = value
			if("password")
				global.sqlpass = value
			if("feedback_database")
				global.sqlfdbkdb = value
			if("feedback_login")
				global.sqlfdbklogin = value
			if("feedback_password")
				global.sqlfdbkpass = value
			if("enable_stat_tracking")
				global.sqllogging = TRUE
			else
				log_misc("Unknown setting in configuration: '[name]'")

/configuration/proc/loadforumsql(filename)  // -- TLE
	var/list/Lines = file2list(filename)
	for(var/t in Lines)
		if(!t)	continue

		t = trim(t)
		if(length(t) == 0)
			continue
		else if(copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
		var/value = null

		if(pos)
			name = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
		else
			name = lowertext(t)

		if(!name)
			continue

		switch(name)
			if("address")
				global.forumsqladdress = value
			if("port")
				global.forumsqlport = value
			if("database")
				global.forumsqldb = value
			if("login")
				global.forumsqllogin = value
			if("password")
				global.forumsqlpass = value
			if("activatedgroup")
				global.forum_activated_group = value
			if("authenticatedgroup")
				global.forum_authenticated_group = value
			else
				log_misc("Unknown setting in configuration: '[name]'")

/configuration/proc/pick_mode(mode_name)
	// I wish I didn't have to instance the game modes in order to look up
	// their information, but it is the only way (at least that I know of).
	for(var/T in SUBTYPESOF(/datum/game_mode))
		var/datum/game_mode/M = new T()
		if(M.config_tag && M.config_tag == mode_name)
			return M
		qdel(M)
	return new /datum/game_mode/extended()

/configuration/proc/get_runnable_modes()
	var/list/datum/game_mode/runnable_modes = new
	for(var/T in SUBTYPESOF(/datum/game_mode))
		var/datum/game_mode/M = new T()
		//world << "DEBUG: [T], tag=[M.config_tag], prob=[probabilities[M.config_tag]]"
		if(!(M.config_tag in modes))
			qdel(M)
			continue
		if(probabilities[M.config_tag] <= 0)
			qdel(M)
			continue
		if(M.can_start())
			runnable_modes[M] = probabilities[M.config_tag]
			//world << "DEBUG: runnable_mode\[[runnable_modes.len]\] = [M.config_tag]"
	return runnable_modes

/configuration/proc/post_load()
	//apply a default value to python_path, if needed
	if(!python_path)
		if(world.system_type == UNIX)
			python_path = "/usr/bin/env python2"
		else //probably windows, if not this should work anyway
			python_path = "python"