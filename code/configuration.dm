/*
 * Configuration
 *
 * The configuration object sets and globally stores configurable values after loading them from their associated files.
 *
 * Most of this is set up in /configuration/New().
 *
 * In a gentle way, you can shake the world. ~ Mahatma Gandhi
*/
/var/global/configuration/config // Set in /datum/global_init/New()

#define CONFIG_GET(VAR) global.config.VAR
#define CONFIG_SET(VAR, VALUE) global.config.VAR = VALUE

/*
 * For the love of god use this macro when creating new configuration variables.
 * It exists to:
 *	Prevent manually typing out var/static everywhere.
 *	Force a default value to be assigned to each variable.
 */
#define CONVAR(VAR, VALUE) var/static/##VAR = VALUE
/configuration
	// ----- CONFIG.TXT STUFF -----
	// Server information.
	CONVAR(server_name, null)	// Server name (for world name / status).
	CONVAR(server_suffix, 0)	// Generate numeric suffix based on server port?
	CONVAR(hostedby, null)

	// Tick.
	CONVAR(ticklag, 0.9)
	CONVAR(tickcomp, FALSE)

	// URLs.
	CONVAR(server, null)
	CONVAR(wikiurl, null)
	CONVAR(forumurl, null)
	CONVAR(donateurl, null)	// Why is this even missing damnit Techy/Akai/Numbers! -- Marajin
	CONVAR(banappeals, null)
	CONVAR(list/resource_urls, null)

	// Python.
	CONVAR(python_path, null)				// Path to the python executable. Defaults to "python" on windows and "/usr/bin/env python2" on unix.
	CONVAR(use_lib_nudge, FALSE)			// Use the C library nudge instead of the python nudge?
	CONVAR(nudge_script_path, "nudge.py")	// Where the nudge.py script is located.

	// IRC.
	CONVAR(use_irc_bot, FALSE)
	CONVAR(irc_bot_host, null)
	CONVAR(main_irc, null)
	CONVAR(admin_irc, null)

	// Logging.
	CONVAR(log_ooc, FALSE)			// Log OOC channel?
	CONVAR(log_access, FALSE)		// Log login/logout?
	CONVAR(log_say, FALSE)			// Log client say?
	CONVAR(log_admin, FALSE)		// Log admin actions?
	CONVAR(log_debug, TRUE)			// Log debug output?
	CONVAR(log_game, FALSE)			// Log game events?
	CONVAR(log_vote, FALSE)			// Log voting?
	CONVAR(log_whisper, FALSE)		// Log client whisper?
	CONVAR(log_emote, FALSE)		// Log emotes?
	CONVAR(log_attack, FALSE)		// Log attack messages?
	CONVAR(log_adminchat, FALSE)	// Log admin chat messages?
	CONVAR(log_adminwarn, FALSE)	// Log warnings admins get about bomb construction and such?
	CONVAR(log_pda, FALSE)			// Log pda messages?
	CONVAR(log_hrefs, FALSE)		// Log all links clicked in-game? Could be used for debugging and tracking down exploits.
	CONVAR(log_runtime, FALSE)		// Log world.log to a file?
	CONVAR(log_world_output, FALSE)	// Log world.log << messages?

	// Chat.
	CONVAR(ooc_allowed, TRUE)		// Whether non-admins can use OOC chat.
	CONVAR(dead_ooc_allowed, TRUE)	// Whether dead, non-admin players can use OOC chat.
	CONVAR(dsay_allowed, TRUE)		// Whether non-admins can use deadchat.

	// Admin.
	CONVAR(admin_legacy_system, FALSE)				// Defines whether the server uses the legacy admin system with admins.txt or the SQL system.
	CONVAR(ban_legacy_system, FALSE)				// Defines whether the server uses the legacy banning system with the files in /data or the SQL system.
	CONVAR(allow_admin_ooccolor, FALSE)				// Allow admins with relevant permissions to have their own ooc colour?
	CONVAR(allow_admin_jump, TRUE)					// Allow admin jumping?
	CONVAR(allow_admin_spawning, TRUE)				// Allow admin item spawning?
	CONVAR(allow_admin_rev, TRUE)					// Allow admin revives?
	CONVAR(forbid_singulo_possession, FALSE)
	CONVAR(popup_admin_pm, FALSE)					// If TRUE, adminPMs to non-admins show in a pop-up 'reply' window.
	CONVAR(simultaneous_pm_warning_timeout, 100)
	CONVAR(ert_admin_call_only, FALSE)
	CONVAR(kick_inactive, FALSE)					// Force disconnect for inactive players?
	CONVAR(ToRban, FALSE)
	CONVAR(automute_on, FALSE)						// Enable automuting/spam prevention?

	// Gamemode.
	CONVAR(list/mode_names, list())
	CONVAR(list/modes, list())						// Allowed modes.
	CONVAR(list/votable_modes, list())				// Votable modes.
	CONVAR(list/probabilities, list())				// Relative probability of each mode
	CONVAR(cult_ghostwriter, TRUE)					// Allows ghosts to write in blood in cult rounds...
	CONVAR(cult_ghostwriter_req_cultists, 10)		// ... so long as this many cultists are active.
	CONVAR(continous_rounds, TRUE)					// Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.
	CONVAR(protect_roles_from_antagonist, FALSE)	// If security and such can be traitor/cult/other.
	CONVAR(traitor_scaling, FALSE)					// If amount of traitors scales based on amount of players.
	CONVAR(objectives_disabled, FALSE)				// If objectives are disabled or not.
	CONVAR(antag_hud_allowed, FALSE)				// Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.
	CONVAR(antag_hud_restricted, FALSE)				// Ghosts that turn on Antagovision cannot rejoin the round.
	CONVAR(allow_random_events, FALSE)				// Enables random events mid-round when set to TRUE
	CONVAR(allow_holidays, FALSE)					// Whether the holiday system is enabled.
	CONVAR(holiday_name, null)						// If the holiday system is active, the name of the current holiday.
	CONVAR(aliens_allowed, FALSE)					// Whether aliens are allowed.

	// Voting.
	CONVAR(allow_vote_restart, FALSE)			// Allow votes to restart?
	CONVAR(allow_vote_mode, FALSE)				// Allow votes to change mode?
	CONVAR(vote_no_default, FALSE)				// Vote does not default to nochange/norestart? (tbi)
	CONVAR(vote_no_dead, FALSE)					// Dead people can't vote? (tbi)
	CONVAR(vote_delay, 6000)					// Minimum time between voting sessions (deciseconds, 10 minute default).
	CONVAR(vote_period, 600)					// Length of voting period (deciseconds, default 1 minute).
	CONVAR(vote_autotransfer_initial, 108000)	// Length of time before the first autotransfer vote is called.
	CONVAR(vote_autotransfer_interval, 36000)	// Length of time before next sequential autotransfer vote.
	CONVAR(vote_autogamemode_timeleft, 100)		// Length of time before round start when autogamemode vote is called (in seconds, default 100).

	// Whitelists.
	CONVAR(guests_allowed, TRUE)
	CONVAR(guest_jobban, TRUE)
	CONVAR(usewhitelist, FALSE)
	CONVAR(usealienwhitelist, FALSE)
	CONVAR(limitalienplayers, FALSE)
	CONVAR(alien_to_human_ratio, 0.5)
	CONVAR(use_age_restriction_for_jobs, FALSE)	// Do jobs use account age restrictions? --requires database
	CONVAR(disable_player_mice, FALSE)
	CONVAR(uneducated_mice, FALSE)				// Set to TRUE to prevent newly-spawned mice from understanding human speech.

	// Alert level descriptions.
	CONVAR(alert_desc_green, "All threats to the station have passed. Security may not have weapons visible, privacy laws are once again fully enforced.")
	CONVAR(alert_desc_yellow_upto, "There is a security alert in progress. Security staff may have weapons visible, however privacy laws remain fully enforced.")
	CONVAR(alert_desc_yellow_downto, "The possible threat has passed. Security staff may continue to have their weapons visible, however they may no longer conduct random searches.")
	CONVAR(alert_desc_blue_upto, "The station has received reliable information about possible hostile activity on the station. Security staff may have weapons visible, random searches are permitted.")
	CONVAR(alert_desc_blue_downto, "The immediate threat has passed. Security may no longer have weapons drawn at all times, but may continue to have them visible. Random searches are still allowed.")
	CONVAR(alert_desc_red_upto, "There is an immediate serious threat to the station. Security may have weapons unholstered at all times. Random searches are allowed and advised.")
	CONVAR(alert_desc_red_downto, "The self-destruct mechanism has been deactivated, there is still however an immediate serious threat to the station. Security may have weapons unholstered at all times, random searches are allowed and advised.")
	CONVAR(alert_desc_delta, "The station's self-destruct mechanism has been engaged. All crew are instructed to obey all instructions given by heads of staff. Any violations of these orders can be punished by death. This is not a drill.")

	// Mobs.
	CONVAR(del_new_on_log, TRUE)			// del()'s new players if they log before they spawn in
	CONVAR(ghost_interaction, FALSE)
	CONVAR(respawn, TRUE)
	CONVAR(allow_ai, TRUE)					// Allow ai job?
	CONVAR(allow_drone_spawn, TRUE)			// Allows maintenance drones to spawn...
	CONVAR(max_maint_drones, 5)				// ... up to a maximum of this many.
	CONVAR(drone_build_time, 1200)			// A drone will become available every X ticks since last drone spawn. Default is 2 minutes.
	CONVAR(humans_need_surnames, FALSE)
	CONVAR(jobs_have_minimal_access, FALSE)	// Determines whether jobs use minimal or expanded access.
	CONVAR(assistant_maint, FALSE)			// Do assistants get maint access?

	// Miscellaneous.
	CONVAR(sql_enabled, TRUE)					// For sql switching.
	CONVAR(use_recursive_explosions, FALSE)		// Defines whether the server uses recursive or circular explosions.
	CONVAR(allow_Metadata, FALSE)				// Metadata is supported.
	CONVAR(feature_object_spell_system, FALSE)	// Spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard.
	CONVAR(load_jobs_from_txt, FALSE)
	CONVAR(socket_talk, FALSE)					// Use socket_talk to communicate with other processes?
	CONVAR(comms_password, "")
	CONVAR(gateway_delay, 18000)				// How long the gateway takes before it activates. Default is half an hour.
	CONVAR(starlight, 0)
	//CONVAR(enable_authentication, FALSE)		// goon authentication

	// ----- GAME_OPTIONS.TXT STUFF -----
	// Health thresholds.
	CONVAR(health_threshold_softcrit, 0)
	CONVAR(health_threshold_crit, 0)
	CONVAR(health_threshold_dead, -100)

	// Bone/limb breakage.
	CONVAR(bones_can_break, FALSE)
	CONVAR(limbs_can_break, FALSE)

	// Organ multipliers.
	CONVAR(organ_health_multiplier, 1)
	CONVAR(organ_regeneration_multiplier, 1)

	// Revival.
	CONVAR(revival_pod_plants, TRUE)
	CONVAR(revival_cloning, TRUE)
	CONVAR(revival_brain_life, -1)

	// Used for modifying movement speed for mobs.
	// Unversal modifiers.
	CONVAR(run_speed, 0)
	CONVAR(walk_speed, 0)

	// Mob specific modifiers.
	// NOTE: These will affect different mob types in different ways!
	CONVAR(human_delay, 0)
	CONVAR(robot_delay, 0)
	CONVAR(monkey_delay, 0)
	CONVAR(alien_delay, 0)
	CONVAR(slime_delay, 0)
	CONVAR(animal_delay, 0)

	// Miscellaneous.
	CONVAR(welding_protection_tint, TRUE)	// Whether headwear and eyewear that provides welding protection also reduces view range.

	// ----- MYSQL CONFIGURATION STUFF -----
	// Basic configuration.
	CONVAR(sqladdress, "localhost")
	CONVAR(sqlport, "3306")
	CONVAR(sqldb, "tgstation")
	CONVAR(sqllogin, "root")
	CONVAR(sqlpass, "")

	// Feedback configuration.
	CONVAR(sqlfdbkdb, "test")
	CONVAR(sqlfdbklogin, "root")
	CONVAR(sqlfdbkpass, "")
	CONVAR(sqllogging, FALSE) // Should we log deaths, population stats, etc?

	// ----- FORUM MYSQL CONFIGURATION -----
	// (for use with forum account/key authentication)
	// These are all default values that will load should the forumdbconfig.txt
	// file fail to read for whatever reason.
	CONVAR(forumsqladdress, "localhost")
	CONVAR(forumsqlport, "3306")
	CONVAR(forumsqldb, "tgstation")
	CONVAR(forumsqllogin, "root")
	CONVAR(forumsqlpass, "")
	CONVAR(forum_activated_group, "2")
	CONVAR(forum_authenticated_group, "10")
#undef CONVAR

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
		if(isnull(t))
			continue
		t = trim(t)
		if(length(t) == 0 || copytext(t, 1, 2) == "#")
			continue
		var/pos = findtext(t, " ")
		var/name = (pos ? lowertext(copytext(t, 1, pos)) : lowertext(t))
		if(isnull(name))
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

			// Chat.
			if("ooc_allowed")
				ooc_allowed = value
			if("dead_ooc_allowed")
				dead_ooc_allowed = value
			if("dsay_allowed")
				dsay_allowed = value

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
				if(isnotnull(prob_pos))
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
				allow_holidays = TRUE
			if("aliens_allowed")
				aliens_allowed = text2num(value)

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
				guests_allowed = FALSE
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

			// Used for modifying movement speed for mobs.
			// Unversal modifiers.
			if("run_speed")
				run_speed = value
			if("walk_speed")
				walk_speed = value

			// Mob specific modifiers.
			// NOTE: These will affect different mob types in different ways
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

			// Miscellaneous.
			if("welding_protection_tint")
				welding_protection_tint = value
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
	for(var/T in SUBTYPESOF(/datum/game_mode))
		// I wish I didn't have to instance the game modes in order to look up
		// their information, but it is the only way (at least that I know of).
		var/datum/game_mode/M = new T()

		if(isnotnull(M.config_tag))
			if(!(M.config_tag in modes))	// ensure each mode is added only once
				log_misc("Adding game mode [M.name] ([M.config_tag]) to configuration.")
				modes.Add(M.config_tag)
				mode_names[M.config_tag] = M.name
				probabilities[M.config_tag] = M.probability
				if(M.votable)
					votable_modes.Add(M.config_tag)
		qdel(M)
	votable_modes.Add("secret")

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
	var/list/datum/game_mode/runnable_modes = list()
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
			//world << "DEBUG: runnable_mode\[[length(runnable_modes)]\] = [M.config_tag]"
	return runnable_modes

/configuration/proc/post_load()
	//apply a default value to python_path, if needed
	if(isnull(python_path))
		if(world.system_type == UNIX)
			python_path = "/usr/bin/env python2"
		else //probably windows, if not this should work anyway
			python_path = "python"