#define RECOMMENDED_VERSION 514

/*
 * World Creation
 *
 * Here is where a round itself is actually set up and started, lots of important things happen here:
 *	Sets the game window's title bar text to include the game version and current map's station name.
 *	Sets the world's tick_lag value from the configuration.
 *	Sets up some log files.
 *	Calculates the changelog hash.
 *	Checks if the recommended BYOND version is running.
 *	Post-loads the configuration files.
 *	Sets up the hub visibility variables.
 *	Loads admins and moderators.
 *	Activates the master_controller and process_scheduler, starting the game loop that causes everything else to begin setting up and processing.
 *
 * Nothing happens until something moves. ~ Albert Einstein
*/
/world/New()
	name = "Space Station 13 - [GLOBL.game_version]: [GLOBL.current_map.station_name]"
	tick_lag = CONFIG_GET(ticklag)

	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	GLOBL.href_logfile = file("data/logs/[date_string] hrefs.htm")
	GLOBL.diary = file("data/logs/[date_string].log")
	GLOBL.diaryofmeanpeople = file("data/logs/[date_string] Attack.log")
	GLOBL.diary << "[log_end]\n[log_end]\nStarting up. [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	GLOBL.diaryofmeanpeople << "[log_end]\n[log_end]\nStarting up. [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	GLOBL.changelog_hash = md5('html/changelog.html')			//used for telling if the changelog has changed recently

	if(byond_version < RECOMMENDED_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements for this server. Please update BYOND."

	global.config.post_load()

	if(CONFIG && CONFIG_GET(server_name) != null && CONFIG_GET(server_suffix) && world.port > 0)
		// dumb and hardcoded but I don't care~
		CONFIG_GET(server_name) += " #[(world.port % 1000) / 100]"

	if(CONFIG && CONFIG_GET(log_runtime))
		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

	callHook("startup")

	src.update_status()

	. = ..()

	// Load an away mission and set up the mining asteroid's secrets.
	createRandomZlevel()
	for(var/i = 0, i < GLOBL.max_secret_rooms, i++)
		make_mining_asteroid_secret()
	sleep(-1)

	sleep_offline = TRUE

	global.CTmaster = new /datum/controller/master()
	global.process_scheduler = new /datum/controller/process_scheduler()
	spawn(1)
		global.process_scheduler.deferSetupFor(/datum/process/ticker)
		global.process_scheduler.setup()
		global.CTmaster.setup()

	spawn(5 MINUTES) // Delay by 5 minutes (300 seconds/3000 deciseconds) so we aren't adding to the round-start lag.
		if(CONFIG_GET(ToRban))
			ToRban_autoupdate()
	return
#undef RECOMMENDED_VERSION

/world/Del()
	callHook("shutdown")
	global.debugger.shutdown_debugger()
	return ..()

/world/Reboot(reason)
	spawn(0)
		world << sound(pick('sound/AI/newroundsexy.ogg', 'sound/misc/apcdestroyed.ogg', 'sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy

	global.process_scheduler.stop()

	for(var/client/C in GLOBL.clients)
		if(CONFIG_GET(server))	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[CONFIG_GET(server)]")
		else
			C << link("byond://[world.address]:[world.port]")

	..(reason)

/world/Topic(T, addr, master, key)
	GLOBL.diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key][log_end]"

	if(T == "ping")
		var/x = 1
		for(var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in GLOBL.player_list)
			if(M.client)
				n++
		return n

	else if(T == "status")
		var/list/s = list()
		s["version"] = GLOBL.game_version
		s["mode"] = global.CTgame_ticker.master_mode
		s["respawn"] = CONFIG ? CONFIG_GET(respawn) : FALSE
		s["enter"] = GLOBL.enter_allowed
		s["vote"] = CONFIG_GET(allow_vote_mode)
		s["ai"] = CONFIG_GET(allow_ai)
		s["host"] = host ? host : null
		s["players"] = list()
		var/n = 0
		var/admins = 0

		for(var/client/C in GLOBL.clients)
			if(C.holder)
				if(C.holder.fakekey)
					continue	//so stealthmins aren't revealed by the hub
				admins++
			s["player[n]"] = C.key
			n++
		s["players"] = n

		if(global.revdata)
			s["revision"] = global.revdata.revision
		s["admins"] = admins

		return list2params(s)

// Gamemode saving/loading.
/hook/startup/proc/loadMode()
	world.load_mode()
	return 1

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			global.CTgame_ticker.master_mode = Lines[1]
			log_misc("Saved mode is '[global.CTgame_ticker.master_mode]'")

/world/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

// MOTD loading.
/hook/startup/proc/loadMOTD()
	world.load_motd()
	return 1

/world/proc/load_motd()
	GLOBL.join_motd = file2text("config/motd.txt")

// Moderator loading.
/hook/startup/proc/loadMods()
	world.load_mods()
	return 1

/world/proc/load_mods()
	if(CONFIG_GET(admin_legacy_system))
		var/text = file2text("config/moderators.txt")
		if(!text)
			error("Failed to load config/mods.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if(!line)
					continue

				if(copytext(line, 1, 2) == ";")
					continue

				var/rights = GLOBL.admin_ranks["Moderator"]
				var/ckey = copytext(line, 1, length(line) + 1)
				var/datum/admins/D = new /datum/admins("Moderator", rights, ckey)
				D.associate(GLOBL.directory[ckey])

// Hub status updates.
/world/proc/update_status()
	var/s = ""

	if(CONFIG && CONFIG_GET(server_name))
		s += "<b>[CONFIG_GET(server_name)]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"http://\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Default"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(global.CTgame_ticker)
		if(global.CTgame_ticker.master_mode)
			features += global.CTgame_ticker.master_mode
	else
		features += "<b>STARTING</b>"

	if(!GLOBL.enter_allowed)
		features += "closed"

	features += CONFIG_GET(respawn) ? "respawn" : "no respawn"

	if(CONFIG && CONFIG_GET(allow_vote_mode))
		features += "vote"

	if(CONFIG && CONFIG_GET(allow_ai))
		features += "AI allowed"

	var/n = 0
	for(var/mob/M in GLOBL.player_list)
		if(M.client)
			n++

	if(n > 1)
		features += "~[n] players"
	else if(n > 0)
		features += "~[n] player"

	/*
	is there a reason for this? the byond site shows 'hosted by X' when there is a proper host already.
	if(host)
		features += "hosted by <b>[host]</b>"
	*/

	if(!host && CONFIG && CONFIG_GET(hostedby))
		features += "hosted by <b>[CONFIG_GET(hostedby)]</b>"

	if(features)
		s += ": [jointext(features, ", ")]"

	/* does this help? I do not know */
	if(src.status != s)
		src.status = s

// Database connections.
/hook/startup/proc/connectDB()
	if(!setup_database_connection())
		world.log << "Your server failed to establish a connection with the feedback database."
	else
		world.log << "Feedback database connection established."
	return 1

/hook/startup/proc/connectOldDB()
	if(!setup_old_database_connection())
		world.log << "Your server failed to establish a connection with the SQL database."
	else
		world.log << "SQL database connection established."
	return 1