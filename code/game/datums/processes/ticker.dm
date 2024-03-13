/*
 * Game Ticker Process
 */
PROCESS_DEF(ticker)
	name = "Ticker"
	schedule_interval = 2 SECONDS

	var/lastTickerTimeDuration
	var/lastTickerTime

	var/const/restart_timeout = 1 MINUTE
	var/current_state = GAME_STATE_PREGAME

	// Whether or not the lobby timer is counting down.
	var/static/roundstart_progressing = TRUE
	// "extended"
	var/static/master_mode = "extended"
	// If this is anything but "secret", the secret rotation will forceably choose this mode.
	var/static/secret_force_mode = "secret"

	var/hide_mode = FALSE
	var/datum/game_mode/mode = null
	var/event_time = null
	var/event = 0

	// The music track played in the pregame lobby.
	var/decl/music_track/lobby_music = null

	// The people in the game. Used for objective tracking.
	var/list/datum/mind/minds = list()

	// If set to TRUE, ALL players who latejoin or declare-ready join will have random appearances/genders.
	var/random_players = FALSE

	var/pregame_timeleft = 0

	// If set to TRUE, the round will not restart on its own.
	var/delay_end = FALSE

	// Global holder for Triumvirate.
	var/triai = 0

	// station_explosion used to be a variable for every mob's hud, which was a waste!
	// Now we have a general cinematic centrally held within the gameticker, which is far more efficient!
	var/obj/screen/cinematic = null

/datum/process/ticker/setup()
	lastTickerTime = world.timeofday

/datum/process/ticker/do_work()
	var/currentTime = world.timeofday

	if(currentTime < lastTickerTime) // check for midnight rollover
		lastTickerTimeDuration = (currentTime - (lastTickerTime - TICKS_IN_DAY)) / TICKS_IN_SECOND
	else
		lastTickerTimeDuration = (currentTime - lastTickerTime) / TICKS_IN_SECOND

	lastTickerTime = currentTime

	process_internal()

/datum/process/ticker/proc/getLastTickerTimeDuration()
	return lastTickerTimeDuration

/datum/process/ticker/proc/pregame()
	var/list/possible_lobby_music = list(
		/decl/music_track/endless_space,
		/decl/music_track/absconditus,
		/decl/music_track/robocop,
		/decl/music_track/clouds_of_fire,
		/decl/music_track/space_oddity
	)
	if(CONFIG_GET(holiday_name) == "Halloween")
		possible_lobby_music.Add(list(
			/decl/music_track/spooky_scary_skeletons,
			/decl/music_track/this_is_halloween,
			/decl/music_track/ghostbusters
		))
	lobby_music = GET_DECL_INSTANCE(pick(possible_lobby_music))

	do
		pregame_timeleft = 180
		to_world("<B><FONT color='blue'>Welcome to the pre-game lobby!</FONT></B>")
		to_world("Please, setup your character and select ready. Game will start in [pregame_timeleft] seconds.")
		while(current_state == GAME_STATE_PREGAME)
			for(var/i = 0, i < 10, i++)
				sleep(1)
				global.PCvote.process()
			if(roundstart_progressing)
				pregame_timeleft--
/*			if(pregame_timeleft == config.vote_autogamemode_timeleft)
				if(!vote.time_remaining)
					vote.autogamemode()	//Quit calling this over and over and over and over.
					while(vote.time_remaining)
						for(var/i=0, i<10, i++)
							sleep(1)
							vote.process()*/
			if(pregame_timeleft <= 0)
				current_state = GAME_STATE_SETTING_UP
	while(!setup_internal())

/datum/process/ticker/proc/setup_internal()
	// Creates and announces mode.
	if(master_mode == "secret")
		hide_mode = TRUE
	var/list/datum/game_mode/runnable_modes
	if(master_mode == "random" || master_mode == "secret")
		runnable_modes = CONFIG_GET_OLD(get_runnable_modes())
		if(!length(runnable_modes))
			current_state = GAME_STATE_PREGAME
			to_world("<B>Unable to choose playable game mode.</B> Reverting to pre-game lobby.")
			return 0
		if(secret_force_mode != "secret")
			var/datum/game_mode/M = global.config.pick_mode(secret_force_mode)
			if(M.can_start())
				mode = global.config.pick_mode(secret_force_mode)
		global.CTjobs.reset_occupations()
		if(isnull(mode))
			mode = pickweight(runnable_modes)
		if(isnotnull(mode))
			mode = new mode.type()
	else
		mode = global.config.pick_mode(master_mode)
	if(!mode.can_start())
		to_world("<B>Unable to start [mode.name].</B> Not enough players, [mode.required_players] players needed. Reverting to pre-game lobby.")
		qdel(mode)
		current_state = GAME_STATE_PREGAME
		global.CTjobs.reset_occupations()
		return 0

	// Configures mode and assigns players to special mode stuff.
	global.CTjobs.divide_occupations() // Distributes jobs.
	var/can_continue = mode.pre_setup() // Sets up special modes.
	if(!can_continue)
		qdel(mode)
		current_state = GAME_STATE_PREGAME
		to_world("<B>Error setting up [master_mode].</B> Reverting to pre-game lobby.")
		global.CTjobs.reset_occupations()
		return 0

	if(hide_mode)
		var/list/modes = list()
		for(var/datum/game_mode/M in runnable_modes)
			modes.Add(M.name)
		modes = sortList(modes)
		to_world("<B>The current game mode is - Secret!</B>")
		to_world("<B>Possibilities:</B> [english_list(modes)]")
	else
		mode.announce()

	current_state = GAME_STATE_PLAYING
	create_characters() // Creates player characters and transfers them.
	collect_minds()
	equip_characters()
	GLOBL.data_core.manifest()

	callHook("roundstart")

	// Here to initialize the random events nicely at round start.
	setup_economy()
	global.PCshuttle.setup_shuttle_docks() // Updated to reflect 'shuttles' port. -Frenjo

	post_setup() // This forks off and doesn't need to be waited on.

	//start_events() //handles random events and space dust.
	//new random event system is handled from the MC.

	var/admins_number = 0
	for(var/client/C)
		if(C.holder)
			admins_number++
	if(admins_number == 0)
		send2adminirc("Round has started with no admins online.")

	// Starts the master controller's process scheduling.
	global.CTmaster.start()

	for(var/obj/multiz/ladder/L in GLOBL.movable_atom_list)
		L.connect() //Lazy hackfix for ladders. TODO: move this to an actual controller. ~ Z

	if(CONFIG_GET(sql_enabled))
		spawn(3000)
		statistic_cycle() // Polls population totals regularly and stores them in an SQL DB -- TLE

	return 1

/datum/process/ticker/proc/post_setup()
	set waitfor = FALSE // This forks off and doesn't need to be waited on.

	mode.post_setup()
	// Cleans up some stuff.
	for(var/obj/effect/landmark/start/S in GLOBL.landmark_list)
		// Deletes startpoints, but we need the ai point to AI-ize people later.
		if(S.name != "AI")
			qdel(S)
	to_world(SPAN_INFO_B("Enjoy the game!"))
	world << sound('sound/AI/welcome.ogg') // Skie
	// Holiday Round-start stuff	~Carn
	holiday_game_start()

//Plus it provides an easy way to make cinematics for other events. Just use this as a template :)
/datum/process/ticker/proc/station_explosion_cinematic(station_missed = 0, override = null)
	if(isnotnull(cinematic))
		return	//already a cinematic in progress!

	//initialise our cinematic screen object
	cinematic = new(src)
	cinematic.icon = 'icons/effects/station_explosion.dmi'
	cinematic.icon_state = "station_intact"
	cinematic.plane = HUD_PLANE
	cinematic.layer = HUD_ABOVE_ITEM_LAYER
	cinematic.mouse_opacity = FALSE
	cinematic.screen_loc = "1,0"

	var/obj/structure/stool/bed/temp_buckle = new(src)
	//Incredibly hackish. It creates a bed within the gameticker (lol) to stop mobs running around
	if(station_missed)
		for(var/mob/living/M in GLOBL.living_mob_list)
			M.buckled = temp_buckle				//buckles the mob so it can't do anything
			M.client?.screen.Add(cinematic)	//show every client the cinematic
	else	//nuke kills everyone on z-level 1 to prevent "hurr-durr I survived"
		for(var/mob/living/M in GLOBL.living_mob_list)
			M.buckled = temp_buckle
			M.client?.screen.Add(cinematic)

			switch(M.z)
				if(0)	//inside a crate or something
					var/turf/T = get_turf(M)
					if(T && isstationlevel(T.z))				//we don't use M.death(0) because it calls a for(/mob) loop and
						M.health = 0
						M.stat = DEAD
				if(1)	//on a z-level 1 turf.
					M.health = 0
					M.stat = DEAD

	//Now animate the cinematic
	switch(station_missed)
		if(1)	//nuke was nearby but (mostly) missed
			if(isnotnull(mode) && !override)
				override = mode.name
			switch(override)
				if("nuclear emergency") //Nuke wasn't on station when it blew up
					flick("intro_nuke", cinematic)
					sleep(35)
					world << sound('sound/effects/explosionfar.ogg')
					flick("station_intact_fade_red", cinematic)
					cinematic.icon_state = "summary_nukefail"
				else
					flick("intro_nuke", cinematic)
					sleep(35)
					world << sound('sound/effects/explosionfar.ogg')
					//flick("end",cinematic)

		if(2)	//nuke was nowhere nearby	//TODO: a really distant explosion animation
			sleep(50)
			world << sound('sound/effects/explosionfar.ogg')

		else	//station was destroyed
			if(isnotnull(mode) && !override)
				override = mode.name
			switch(override)
				if("nuclear emergency") //Nuke Ops successfully bombed the station
					flick("intro_nuke", cinematic)
					sleep(35)
					flick("station_explode_fade_red", cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_nukewin"
				if("AI malfunction") //Malf (screen,explosion,summary)
					flick("intro_malf", cinematic)
					sleep(76)
					flick("station_explode_fade_red", cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_malf"
				if("blob") //Station nuked (nuke,explosion,summary)
					flick("intro_nuke", cinematic)
					sleep(35)
					flick("station_explode_fade_red", cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_selfdes"
				else //Station nuked (nuke,explosion,summary)
					flick("intro_nuke", cinematic)
					sleep(35)
					flick("station_explode_fade_red", cinematic)
					world << sound('sound/effects/explosionfar.ogg')
					cinematic.icon_state = "summary_selfdes"
			for(var/mob/living/M in GLOBL.living_mob_list)
				if(isstationlevel(M.loc.z))
					M.death()//No mercy
	//If its actually the end of the round, wait for it to end.
	//Otherwise if its a verb it will continue on afterwards.
	sleep(300)

	if(isnotnull(cinematic))
		qdel(cinematic)		//end the cinematic
	if(isnotnull(temp_buckle))
		qdel(temp_buckle)	//release everybody
	return

/datum/process/ticker/proc/create_characters()
	for(var/mob/new_player/player in GLOBL.dead_mob_list)
		if(!player.ready || isnull(player.mind))
			continue
		if(player.mind.assigned_role == "AI")
			player.close_spawn_windows()
			player.AIize()
		else if(isnull(player.mind.assigned_role))
			continue
		else
			player.create_character()
			qdel(player)

/datum/process/ticker/proc/collect_minds()
	for(var/mob/living/player in GLOBL.player_list)
		if(isnotnull(player.mind))
			minds.Add(player.mind)

/datum/process/ticker/proc/equip_characters()
	var/captainless = TRUE
	for(var/mob/living/carbon/human/player in GLOBL.player_list)
		if(isnull(player) || isnull(player.mind))
			continue
		if(player.mind.assigned_role)
			if(player.mind.assigned_role == "Captain")
				captainless = FALSE
			if(player.mind.assigned_role != "MODE")
				global.CTjobs.equip_rank(player, player.mind.assigned_role, FALSE)
				EquipCustomItems(player)
	if(captainless)
		for_no_type_check(var/mob/M, GLOBL.player_list)
			if(!isnewplayer(M))
				to_chat(M, "Captainship not forced on anyone.")

/datum/process/ticker/proc/process_internal()
	if(current_state != GAME_STATE_PLAYING)
		return 0

	mode.process()

	var/mode_finished = mode.check_finished() || (global.PCemergency.returned() && global.PCemergency.evac)
	if(!mode.explosion_in_progress && mode_finished)
		current_state = GAME_STATE_FINISHED

		declare_completion()

		spawn(50)
			callHook("roundend")

			if(mode.station_was_nuked)
				feedback_set_details("end_proper", "nuke")
				if(!delay_end)
					to_world(SPAN_INFO_B("Rebooting due to destruction of station in [restart_timeout / 10] seconds."))
			else
				feedback_set_details("end_proper", "proper completion")
				if(!delay_end)
					to_world(SPAN_INFO_B("Restarting in [restart_timeout / 10] seconds."))

			blackbox?.save_all_data_to_sql()

			if(!delay_end)
				sleep(restart_timeout)
				if(!delay_end)
					world.Reboot()
				else
					to_world(SPAN_INFO_B("An admin has delayed the round end."))
			else
				to_world(SPAN_INFO_B("An admin has delayed the round end."))

	return 1

/datum/process/ticker/proc/get_faction_by_name(name)
	for_no_type_check(var/decl/faction/F, GLOBL.factions)
		if(F.name == name)
			return F

/datum/process/ticker/proc/declare_completion()
	set waitfor = FALSE
	for(var/mob/living/silicon/ai/aiPlayer in GLOBL.mob_list)
		if(aiPlayer.stat != DEAD)
			to_world("<b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws at the end of the game were:</b>")
		else
			to_world("<b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws when it was deactivated were:</b>")
		aiPlayer.show_laws(1)

		if(length(aiPlayer.connected_robots))
			var/robolist = "<b>The AI's loyal minions were:</b> "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat ?" (Deactivated) (Played by: [robo.key]), " : " (Played by: [robo.key]), "]"
			to_world(robolist)

	for(var/mob/living/silicon/robot/robo in GLOBL.mob_list)
		if(isnull(robo))
			continue
		if(isnotnull(robo.connected_ai))
			continue

		if(robo.stat != DEAD)
			to_world("<b>[robo.name] (Played by: [robo.key]) survived as an AI-less borg! Its laws were:</b>")
		else
			to_world("<b>[robo.name] (Played by: [robo.key]) was unable to survive the rigors of being a cyborg without an AI. Its laws were:</b>")

		robo.laws.show_laws(world) // How the hell do we lose robo between here and the world messages directly above this?

	mode.declare_completion()//To declare normal completion.

	//calls auto_declare_completion_* for all modes
	for(var/handler in typesof(/datum/game_mode/proc))
		if(findtext("[handler]", "auto_declare_completion_"))
			call(mode, handler)()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in minds)
		var/temprole = Mind.special_role
		if(isnotnull(temprole))					//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]([Mind.key])"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]([Mind.key])"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")

	return 1