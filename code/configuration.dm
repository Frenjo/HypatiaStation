/**
  * Configuration
  *
  * The configuration object sets and globally stores configurable values after loading them from their associated files.
  *
  * Most of this is set up in /configuration/New().
  * 
  * In a gentle way, you can shake the world. ~ Mahatma Gandhi
  * 
  */
/configuration
	// ----- CONFIG.TXT STUFF -----
	// Server information.
	var/static/server_name = null	// server name (for world name / status)
	var/static/server_suffix = 0	// generate numeric suffix based on server port
	var/static/hostedby = null

	// Tick.
	var/static/ticklag = 0.9
	var/static/tickcomp = FALSE

	// URLs.
	var/static/server
	var/static/wikiurl
	var/static/forumurl
	var/static/donateurl	// Why is this even missing damnit Techy/Akai/Numbers! -- Marajin
	var/static/banappeals
	var/static/list/resource_urls = null

	// Python.
	var/static/python_path = ""					//Path to the python executable.  Defaults to "python" on windows and "/usr/bin/env python2" on unix
	var/static/use_lib_nudge = FALSE			//Use the C library nudge instead of the python nudge.
	var/static/nudge_script_path = "nudge.py"	// where the nudge.py script is located

	// IRC.
	var/static/use_irc_bot = FALSE
	var/static/irc_bot_host = ""
	var/static/main_irc = ""
	var/static/admin_irc = ""

	// Logging.
	var/static/log_ooc = FALSE			// log OOC channel
	var/static/log_access = FALSE		// log login/logout
	var/static/log_say = FALSE			// log client say
	var/static/log_admin = FALSE		// log admin actions
	var/static/log_debug = TRUE			// log debug output
	var/static/log_game = FALSE			// log game events
	var/static/log_vote = FALSE			// log voting
	var/static/log_whisper = FALSE		// log client whisper
	var/static/log_emote = FALSE		// log emotes
	var/static/log_attack = FALSE		// log attack messages
	var/static/log_adminchat = FALSE	// log admin chat messages
	var/static/log_adminwarn = FALSE	// log warnings admins get about bomb construction and such
	var/static/log_pda = FALSE			// log pda messages
	var/static/log_hrefs = FALSE		// logs all links clicked in-game. Could be used for debugging and tracking down exploits
	var/static/log_runtime = FALSE		// logs world.log to a file
	var/static/log_world_output = FALSE	// log world.log << messages

	// Admin.
	var/static/admin_legacy_system = FALSE	//Defines whether the server uses the legacy admin system with admins.txt or the SQL system.
	var/static/ban_legacy_system = FALSE	//Defines whether the server uses the legacy banning system with the files in /data or the SQL system.
	var/static/allow_admin_ooccolor = FALSE	// Allows admins with relevant permissions to have their own ooc colour
	var/static/allow_admin_jump = TRUE		// allows admin jumping
	var/static/allow_admin_spawning = TRUE	// allows admin item spawning
	var/static/allow_admin_rev = TRUE		// allows admin revives
	var/static/forbid_singulo_possession = FALSE
	var/static/popup_admin_pm = FALSE		//adminPMs to non-admins show in a pop-up 'reply' window when set to 1.
	var/static/simultaneous_pm_warning_timeout = 100
	var/static/ert_admin_call_only = FALSE
	var/static/kick_inactive = FALSE		//force disconnect for inactive players
	var/static/ToRban = FALSE
	var/static/automute_on = FALSE			//enables automuting/spam prevention

	// Gamemode.
	var/static/list/mode_names = list()
	var/static/list/modes = list()						// allowed modes
	var/static/list/votable_modes = list()				// votable modes
	var/static/list/probabilities = list()				// relative probability of each mode
	var/static/cult_ghostwriter = TRUE					//Allows ghosts to write in blood in cult rounds...
	var/static/cult_ghostwriter_req_cultists = 10		//...so long as this many cultists are active.
	var/static/continous_rounds = TRUE					// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
	var/static/protect_roles_from_antagonist = FALSE	// If security and such can be traitor/cult/other
	var/static/traitor_scaling = FALSE					//if amount of traitors scales based on amount of players
	var/static/objectives_disabled = FALSE				//if objectives are disabled or not
	var/static/antag_hud_allowed = FALSE				// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
	var/static/antag_hud_restricted = FALSE				// Ghosts that turn on Antagovision cannot rejoin the round.
	var/static/allow_random_events = FALSE				// enables random events mid-round when set to 1

	// Voting.
	var/static/allow_vote_restart = FALSE			// allow votes to restart
	var/static/allow_vote_mode = FALSE				// allow votes to change mode
	var/static/vote_no_default = FALSE				// vote does not default to nochange/norestart (tbi)
	var/static/vote_no_dead = FALSE					// dead people can't vote (tbi)
	var/static/vote_delay = 6000					// minimum time between voting sessions (deciseconds, 10 minute default)
	var/static/vote_period = 600					// length of voting period (deciseconds, default 1 minute)
	var/static/vote_autotransfer_initial = 108000	// Length of time before the first autotransfer vote is called
	var/static/vote_autotransfer_interval = 36000	// length of time before next sequential autotransfer vote
	var/static/vote_autogamemode_timeleft = 100		//Length of time before round start when autogamemode vote is called (in seconds, default 100).

	// Whitelists.
	var/static/guest_jobban = TRUE
	var/static/usewhitelist = FALSE
	var/static/usealienwhitelist = FALSE
	var/static/limitalienplayers = FALSE
	var/static/alien_to_human_ratio = 0.5
	var/static/use_age_restriction_for_jobs = FALSE	//Do jobs use account age restrictions? --requires database
	var/static/disable_player_mice = FALSE
	var/static/uneducated_mice = FALSE				//Set to 1 to prevent newly-spawned mice from understanding human speech

	// Levels.
	var/static/list/station_levels = list(1)			// Defines which Z-levels the station exists on.
	var/static/list/admin_levels = list(2)				// Defines which Z-levels which are for admin functionality, for example including such areas as Central Command and the Syndicate Shuttle
	var/static/list/contact_levels = list(1, 5)			// Defines which Z-levels which, for example, a Code Red announcement may affect
	var/static/list/player_levels = list(1, 3, 4, 5, 6)	// Defines all Z-levels a character can typically reach

	// Alert level descriptions.
	var/static/alert_desc_green = "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced."
	var/static/alert_desc_yellow_upto = "There is a security alert in progress. Security staff may have weapons visible, however privacy laws remain fully enforced."
	var/static/alert_desc_yellow_downto = "The possible threat has passed. Security staff may continue to have their weapons visible, however they may no longer conduct random searches."
	var/static/alert_desc_blue_upto = "The station has received reliable information about possible hostile activity on the station. Security staff may have weapons visible, random searches are permitted."
	var/static/alert_desc_blue_downto = "The immediate threat has passed. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still allowed."
	var/static/alert_desc_red_upto = "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised."
	var/static/alert_desc_red_downto = "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised."
	var/static/alert_desc_delta = "The station's self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill."

	// Mobs.
	var/static/del_new_on_log = TRUE			// del's new players if they log before they spawn in
	var/static/ghost_interaction = FALSE
	var/static/respawn = TRUE
	var/static/allow_ai = TRUE					// allow ai job
	var/static/allow_drone_spawn = TRUE			//Assuming the admin allow them to,
	var/static/max_maint_drones = 5				//this many drones can spawn.
	var/static/drone_build_time = 1200			//A drone will become available every X ticks since last drone spawn. Default is 2 minutes.
	var/static/humans_need_surnames = FALSE
	var/static/jobs_have_minimal_access = FALSE	//determines whether jobs use minimal access or expanded access.
	var/static/assistant_maint = FALSE			//Do assistants get maint access?

	// Miscellaneous.
	var/static/sql_enabled = TRUE					// for sql switching
	var/static/use_recursive_explosions = FALSE		//Defines whether the server uses recursive or circular explosions.
	var/static/allow_Metadata = FALSE				// Metadata is supported.
	var/static/feature_object_spell_system = FALSE	//spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard
	var/static/load_jobs_from_txt = FALSE
	var/static/socket_talk = FALSE					// use socket_talk to communicate with other processes
	var/static/comms_password = ""
	var/static/gateway_delay = 18000				//How long the gateway takes before it activates. Default is half an hour.
	var/static/starlight = 0
	//var/static/enable_authentication = FALSE		// goon authentication

	// ----- GAME_OPTIONS.TXT STUFF -----
	// Health thresholds.
	var/static/health_threshold_softcrit = 0
	var/static/health_threshold_crit = 0
	var/static/health_threshold_dead = -100

	// Bone/limb breakage.
	var/static/bones_can_break = FALSE
	var/static/limbs_can_break = FALSE

	// Organ multipliers.
	var/static/organ_health_multiplier = 1
	var/static/organ_regeneration_multiplier = 1

	// Revival.
	var/static/revival_pod_plants = TRUE
	var/static/revival_cloning = TRUE
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

	// ----- MYSQL CONFIGURATION STUFF -----
	// Basic configuration.
	var/static/sqladdress = "localhost"
	var/static/sqlport = "3306"
	var/static/sqldb = "tgstation"
	var/static/sqllogin = "root"
	var/static/sqlpass = ""

	// Feedback configuration.
	var/static/sqlfdbkdb = "test"
	var/static/sqlfdbklogin = "root"
	var/static/sqlfdbkpass = ""
	var/static/sqllogging = FALSE // Should we log deaths, population stats, etc?

	// ----- FORUM MYSQL CONFIGURATION -----
	// (for use with forum account/key authentication)
	// These are all default values that will load should the forumdbconfig.txt
	// file fail to read for whatever reason.
	var/static/forumsqladdress = "localhost"
	var/static/forumsqlport = "3306"
	var/static/forumsqldb = "tgstation"
	var/static/forumsqllogin = "root"
	var/static/forumsqlpass = ""
	var/static/forum_activated_group = "2"
	var/static/forum_authenticated_group = "10"

/configuration/New()
	load_gamemodes()
	load_config()
	load_game_options()
	load_sql()
	load_forum_sql()

// This does what /proc/load(filename, type) used to do, except it returns the result as a list...
// So it can be used in other functions for the different config files. -Frenjo
/configuration/proc/read(filename)
	var/list/result = list()
	var/list/lines = file2list(filename)
	for(var/t in lines)
		if(!t)
			continue
		t = trim(t)
		if(length(t) == 0 || copytext(t, 1, 2) == "#")
			continue
		var/pos = findtext(t, " ")
		var/name = (pos ? lowertext(copytext(t, 1, pos)) : lowertext(t))
		if(!name)
			continue
		var/value = (pos ? copytext(t, pos + 1) : TRUE)
		result[name] = value
	return result

/configuration/proc/load_config()
	var/list/config_file = read("config/config.txt")

	for(var/option in config_file)
		var/value = config_file[option]
		switch(option)
			// Server information.
			if("servername")
				server_name = value
			if("serversuffix")
				server_suffix = TRUE
			if("hostedby")
				hostedby = value
			
			// Tick.
			if("ticklag")
				ticklag = text2num(value)
			if("tickcomp")
				tickcomp = TRUE

			// URLs
			if("server")
				server = value
			if("wikiurl")
				wikiurl = value
			if("forumurl")
				forumurl = value
			if("donateurl") // Why is this even missing damnit Techy/Akai/Numbers! -- Marajin
				donateurl = value
			if("banappeals")
				banappeals = value
			if("resource_urls")
				resource_urls = splittext(value, " ")
			
			// Python.
			if("python_path")
				if(value)
					python_path = value
			if("use_lib_nudge")
				use_lib_nudge = TRUE
			if("nudge_script_path")
				nudge_script_path = value

			// IRC.
			if("use_irc_bot")
				use_irc_bot = TRUE
			if("irc_bot_host")
				irc_bot_host = value
			if("main_irc")
				main_irc = value
			if("admin_irc")
				admin_irc = value

			// Logging.
			if("log_ooc")
				log_ooc = TRUE
			if("log_access")
				log_access = TRUE
			if("log_say")
				log_say = TRUE
			if("log_admin")
				log_admin = TRUE
			if("log_debug")
				log_debug = text2num(value)
			if("log_game")
				log_game = TRUE
			if("log_vote")
				log_vote = TRUE
			if("log_whisper")
				log_whisper = TRUE
			if("log_emote")
				log_emote = TRUE
			if("log_attack")
				log_attack = TRUE
			if("log_adminchat")
				log_adminchat = TRUE
			if("log_adminwarn")
				log_adminwarn = TRUE
			if("log_pda")
				log_pda = TRUE
			if("log_hrefs")
				log_hrefs = TRUE
			if("log_runtime")
				log_runtime = TRUE
			if("log_world_output")
				log_world_output = TRUE

			// Admin.
			if("admin_legacy_system")
				admin_legacy_system = TRUE
			if("ban_legacy_system")
				ban_legacy_system = TRUE
			if("allow_admin_ooccolor")
				allow_admin_ooccolor = TRUE
			if("allow_admin_jump")
				allow_admin_jump = TRUE
			if("allow_admin_spawning")
				allow_admin_spawning = TRUE
			if("allow_admin_rev")
				allow_admin_rev = TRUE
			if("forbid_singulo_possession")
				forbid_singulo_possession = TRUE
			if("popup_admin_pm")
				popup_admin_pm = TRUE
			if("ert_admin_only")
				ert_admin_call_only = TRUE
			if("kick_inactive")
				kick_inactive = TRUE
			if("tor_ban")
				ToRban = TRUE
			if("automute_on")
				automute_on = TRUE
			
			// Gamemode.
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
			if("allow_cult_ghostwriter")
				cult_ghostwriter = TRUE
			if("req_cult_ghostwriter")
				cult_ghostwriter_req_cultists = text2num(value)
			if("continuous_rounds")
				continous_rounds = TRUE
			if("protect_roles_from_antagonist")
				protect_roles_from_antagonist = TRUE
			if("traitor_scaling")
				traitor_scaling = TRUE
			if("objectives_disabled")
				objectives_disabled = TRUE
			if("allow_antag_hud")
				antag_hud_allowed = TRUE
			if("antag_hud_restricted")
				antag_hud_restricted = TRUE
			if("allow_random_events")
				allow_random_events = TRUE
			if("allow_holidays")
				global.Holiday = TRUE
			
			// Voting.
			if("allow_vote_restart")
				allow_vote_restart = TRUE
			if("allow_vote_mode")
				allow_vote_mode = TRUE
			if("no_dead_vote")
				vote_no_dead = TRUE
			if("default_no_vote")
				vote_no_default = TRUE
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

			// Whitelists.
			if("guest_ban")
				global.guests_allowed = FALSE
			if("guest_jobban")
				guest_jobban = TRUE
			if("usewhitelist")
				usewhitelist = TRUE
			if("usealienwhitelist")
				usealienwhitelist = TRUE
			if("alien_player_ratio")
				limitalienplayers = TRUE
				alien_to_human_ratio = text2num(value)
			if("use_age_restriction_for_jobs")
				use_age_restriction_for_jobs = TRUE
			if("disable_player_mice")
				disable_player_mice = TRUE
			if("uneducated_mice")
				uneducated_mice = TRUE

			// Levels.
			if("station_levels")
				station_levels = text2numlist(value, ";")
			if("admin_levels")
				admin_levels = text2numlist(value, ";")
			if("contact_levels")
				contact_levels = text2numlist(value, ";")
			if("player_levels")
				player_levels = text2numlist(value, ";")
			
			// Alert level descriptions.
			if("alert_green")
				alert_desc_green = value
			if("alert_yellow_upto")
				alert_desc_yellow_upto = value
			if("alert_yellow_downto")
				alert_desc_yellow_downto = value
			if("alert_blue_upto")
				alert_desc_blue_upto = value
			if("alert_blue_downto")
				alert_desc_blue_downto = value
			if("alert_red_upto")
				alert_desc_red_upto = value
			if("alert_red_downto")
				alert_desc_red_downto = value
			if("alert_delta")
				alert_desc_delta = value
			
			// Mobs.
			if("dont_del_newmob")
				del_new_on_log = FALSE
			if("ghost_interaction")
				ghost_interaction = TRUE
			if("norespawn")
				respawn = FALSE
			if("allow_ai")
				allow_ai = TRUE
			if("allow_drone_spawn")
				allow_drone_spawn = text2num(value)
			if("max_maint_drones")
				max_maint_drones = text2num(value)
			if("drone_build_time")
				drone_build_time = text2num(value)
			if("humans_need_surnames")
				humans_need_surnames = TRUE
			if("jobs_have_minimal_access")
				jobs_have_minimal_access = TRUE
			if("assistant_maint")
				assistant_maint = TRUE

			// Miscellaneous.
			if("sql_enabled")
				sql_enabled = text2num(value)
			if("use_recursive_explosions")
				use_recursive_explosions = TRUE
			if("allow_metadata")
				allow_Metadata = TRUE
			if("feature_object_spell_system")
				feature_object_spell_system = TRUE
			if("load_jobs_from_txt")
				load_jobs_from_txt = TRUE
			if("socket_talk")
				socket_talk = text2num(value)
			if("comms_password")
				comms_password = value
			if("gateway_delay")
				gateway_delay = text2num(value)
			if("starlight")
				value = text2num(value)
				starlight = value >= 0 ? value : 0
			/*
			if("authentication")
				enable_authentication = TRUE
			*/
			else
				log_misc("Unknown setting in config/config.txt: '[option]'")

/configuration/proc/load_game_options()
	var/list/config_file = read("config/game_options.txt")

	for(var/option in config_file)
		var/value = config_file[option]
		value = text2num(value)
		switch(option)
			// Health thresholds.
			if("health_threshold_softcrit")
				health_threshold_softcrit = value
			if("health_threshold_crit")
				health_threshold_crit = value
			if("health_threshold_dead")
				health_threshold_dead = value

			// Bone/limb breakage.
			if("bones_can_break")
				bones_can_break = value
			if("limbs_can_break")
				limbs_can_break = value

			// Organ multipliers.
			if("organ_health_multiplier")
				organ_health_multiplier = value / 100
			if("organ_regeneration_multiplier")
				organ_regeneration_multiplier = value / 100

			// Revival.
			if("revival_pod_plants")
				revival_pod_plants = value
			if("revival_cloning")
				revival_cloning = value
			if("revival_brain_life")
				revival_brain_life = value

			//Used for modifying movement speed for mobs.
			//Unversal modifiers
			if("run_speed")
				run_speed = value
			if("walk_speed")
				walk_speed = value

			//Mob specific modifiers. NOTE: These will affect different mob types in different ways
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
			else
				log_misc("Unknown setting in config/game_options.txt: '[option]'")

/configuration/proc/load_sql()	// -- TLE
	var/list/config_file = read("config/dbconfig.txt")

	for(var/option in config_file)
		var/value = config_file[option]
		switch(option)
			// Basic configuration.
			if("address")
				sqladdress = value
			if("port")
				sqlport = value
			if("database")
				sqldb = value
			if("login")
				sqllogin = value
			if("password")
				sqlpass = value
			
			// Feedback configuration.
			if("feedback_database")
				sqlfdbkdb = value
			if("feedback_login")
				sqlfdbklogin = value
			if("feedback_password")
				sqlfdbkpass = value
			if("enable_stat_tracking")
				sqllogging = TRUE
			else
				log_misc("Unknown setting in config/dbconfig.txt: '[option]'")

/configuration/proc/load_forum_sql()	// -- TLE
	var/list/config_file = read("config/forumdbconfig.txt")

	for(var/option in config_file)
		var/value = config_file[option]
		switch(option)
			if("address")
				forumsqladdress = value
			if("port")
				forumsqlport = value
			if("database")
				forumsqldb = value
			if("login")
				forumsqllogin = value
			if("password")
				forumsqlpass = value
			if("activatedgroup")
				forum_activated_group = value
			if("authenticatedgroup")
				forum_authenticated_group = value
			else
				log_misc("Unknown setting in config/forumdbconfig.txt: '[option]'")

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