/var/global/datum/global_init/init = new()
/var/global/datum/configuration/config = null

/var/diary = null
/var/diaryofmeanpeople = null
/var/href_logfile = null

/*
	Pre-map initialization stuff should go here.
*/
/datum/global_init/New()
	load_configuration()
	callHook("global_init")

	del(src)


/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session

#define RECOMMENDED_VERSION 514
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

	global.processScheduler = new
	global.master_controller = new /datum/controller/game_controller()
	spawn(1)
		global.processScheduler.deferSetupFor(/datum/controller/process/ticker)
		global.processScheduler.setup()
		global.master_controller.setup()

	spawn(3000)	// Delay by 5 minutes (300 seconds/3000 deciseconds) so we aren't adding to the round-start lag.
		if(global.config.ToRban)
			ToRban_autoupdate()
	return
#undef RECOMMENDED_VERSION

//world/Topic(href, href_list[])
//		world << "Received a Topic() call!"
//		world << "[href]"
//		for(var/a in href_list)
//			world << "[a]"
//		if(href_list["hello"])
//			world << "Hello world!"
//			return "Hello world!"
//		world << "End of Topic() call."
//		..()

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
		s["respawn"] = global.config ? global.abandon_allowed : FALSE
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


/world/Del()
	callHook("shutdown")
	return ..()

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


/hook/startup/proc/loadMOTD()
	world.load_motd()
	return 1

/world/proc/load_motd()
	global.join_motd = file2text("config/motd.txt")


/proc/load_configuration()
	global.config = new /datum/configuration()
	global.config.load("config/config.txt")
	global.config.load("config/game_options.txt", "game_options")
	global.config.loadsql("config/dbconfig.txt")
	global.config.loadforumsql("config/forumdbconfig.txt")
	// apply some settings from config..
	global.abandon_allowed = global.config.respawn


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

	features += global.abandon_allowed ? "respawn" : "no respawn"

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


#define FAILED_DB_CONNECTION_CUTOFF 5
/var/global/failed_db_connections = 0
/var/global/failed_old_db_connections = 0

/hook/startup/proc/connectDB()
	if(!setup_database_connection())
		world.log << "Your server failed to establish a connection with the feedback database."
	else
		world.log << "Feedback database connection established."
	return 1

/proc/setup_database_connection()
	if(global.failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!global.dbcon)
		global.dbcon = new()

	var/user = sqlfdbklogin
	var/pass = sqlfdbkpass
	var/db = sqlfdbkdb
	var/address = sqladdress
	var/port = sqlport

	global.dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = global.dbcon.IsConnected()
	if(.)
		global.failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		global.failed_db_connections++		//If it failed, increase the failed connections counter.
		world.log << dbcon.ErrorMsg()

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection()
	if(global.failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1


/hook/startup/proc/connectOldDB()
	if(!setup_old_database_connection())
		world.log << "Your server failed to establish a connection with the SQL database."
	else
		world.log << "SQL database connection established."
	return 1

//These two procs are for the old database, while it's being phased out. See the tgstation.sql file in the SQL folder for more information.
/proc/setup_old_database_connection()
	if(global.failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!global.dbcon_old)
		global.dbcon_old = new()

	var/user = sqllogin
	var/pass = sqlpass
	var/db = sqldb
	var/address = sqladdress
	var/port = sqlport

	global.dbcon_old.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = global.dbcon_old.IsConnected()
	if(.)
		global.failed_old_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		global.failed_old_db_connections++		//If it failed, increase the failed connections counter.
		world.log << dbcon.ErrorMsg()

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_old_db_connection()
	if(global.failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!global.dbcon_old || !global.dbcon_old.IsConnected())
		return setup_old_database_connection()
	else
		return 1

#undef FAILED_DB_CONNECTION_CUTOFF