#define RECOMMENDED_VERSION 514

/**
  * World Creation
  *
  * Here is where a round itself is actually begun and setup, lots of important config changes happen here:
  * * Sets up some log files.
  * * Calculates the changelog hash.
  * * Checks if the recommended BYOND version is running.
  * * Post-loads the configuration files.
  * * Sets up the hub visibility variables.
  * * Loads admins and moderators.
  * * Activates the processScheduler and master_controller, starting the game loop that causes everything else to begin setting up and processing.
  * 
  * Nothing happens until something moves. ~ Albert Einstein
  * 
  */
/world/New()
	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	global.href_logfile = file("data/logs/[date_string] hrefs.htm")
	global.diary = file("data/logs/[date_string].log")
	global.diaryofmeanpeople = file("data/logs/[date_string] Attack.log")
	global.diary << "[log_end]\n[log_end]\nStarting up. [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	global.diaryofmeanpeople << "[log_end]\n[log_end]\nStarting up. [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	global.changelog_hash = md5('html/changelog.html')			//used for telling if the changelog has changed recently

	if(byond_version < RECOMMENDED_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements for this server. Please update BYOND."

	global.config.post_load()

	if(global.config && global.config.server_name != null && global.config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		global.config.server_name += " #[(world.port % 1000) / 100]"

	if(global.config && global.config.log_runtime)
		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

	callHook("startup")
	//Emergency Fix
	load_mods()
	//end-emergency fix

	src.update_status()

	. = ..()

	sleep_offline = TRUE

	global.processScheduler = new /datum/controller/processScheduler()
	global.master_controller = new /datum/controller/master()
	spawn(1)
		global.processScheduler.deferSetupFor(/datum/controller/process/ticker)
		global.processScheduler.setup()
		global.master_controller.setup()

	spawn(3000)	// Delay by 5 minutes (300 seconds/3000 deciseconds) so we aren't adding to the round-start lag.
		if(global.config.ToRban)
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

	global.processScheduler.stop()

	for(var/client/C in global.clients)
		if(global.config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[global.config.server]")
		else
			C << link("byond://[world.address]:[world.port]")

	..(reason)

/world/Topic(T, addr, master, key)
	global.diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key][log_end]"

	if(T == "ping")
		var/x = 1
		for(var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in global.player_list)
			if(M.client)
				n++
		return n

	else if(T == "status")
		var/list/s = list()
		s["version"] = global.game_version
		s["mode"] = global.master_mode
		s["respawn"] = global.config ? global.config.respawn : FALSE
		s["enter"] = global.enter_allowed
		s["vote"] = global.config.allow_vote_mode
		s["ai"] = global.config.allow_ai
		s["host"] = host ? host : null
		s["players"] = list()
		var/n = 0
		var/admins = 0

		for(var/client/C in global.clients)
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
			global.master_mode = Lines[1]
			log_misc("Saved mode is '[global.master_mode]'")

/world/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

// MOTD loading.
/hook/startup/proc/loadMOTD()
	world.load_motd()
	return 1

/world/proc/load_motd()
	global.join_motd = file2text("config/motd.txt")

// Moderator loading.
/hook/startup/proc/loadMods()
	world.load_mods()
	return 1

/world/proc/load_mods()
	if(global.config.admin_legacy_system)
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

				var/rights = admin_ranks["Moderator"]
				var/ckey = copytext(line, 1, length(line) + 1)
				var/datum/admins/D = new /datum/admins("Moderator", rights, ckey)
				D.associate(directory[ckey])

// Hub status updates.
/world/proc/update_status()
	var/s = ""

	if(global.config && global.config.server_name)
		s += "<b>[global.config.server_name]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"http://\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Default"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(global.ticker)
		if(global.master_mode)
			features += global.master_mode
	else
		features += "<b>STARTING</b>"

	if(!global.enter_allowed)
		features += "closed"

	features += global.config.respawn ? "respawn" : "no respawn"

	if(global.config && global.config.allow_vote_mode)
		features += "vote"

	if(global.config && global.config.allow_ai)
		features += "AI allowed"

	var/n = 0
	for(var/mob/M in global.player_list)
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

	if(!host && global.config && global.config.hostedby)
		features += "hosted by <b>[global.config.hostedby]</b>"

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