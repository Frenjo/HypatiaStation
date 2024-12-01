/*
 * World Creation
 *
 * Here is where a round itself is actually set up and started, lots of important things happen here:
 *	Sets the game window's title bar text to include the game version and current map's station name.
 *	Sets the world's tick_lag value from the configuration.
 *	Checks if the recommended BYOND version is running.
 *	Post-loads the configuration files.
 *	Sets up the hub visibility variables.
 *	Calls the startup hook.
 *	Loads an away mission and generates the mining asteroid's secrets.
 *	Activates the master_controller and process_scheduler, starting the game loop that causes everything else to begin setting up and processing.
 *
 * Nothing happens until something moves. ~ Albert Einstein
*/
#define RECOMMENDED_VERSION 515
/world/New()
	name = "Space Station 13 - [GLOBL.game_version]: [GLOBL.current_map.station_name]"
	tick_lag = CONFIG_GET(ticklag)

	if(byond_version < RECOMMENDED_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements for this server. Please update BYOND."

	global.CTconfiguration.post_load()

	if(isnotnull(CONFIG_GET(server_name)) && CONFIG_GET(server_suffix) && world.port > 0)
		// dumb and hardcoded but I don't care~
		var/list/new_name = list(CONFIG_GET(server_name), " #[(world.port % 1000) / 100]")
		CONFIG_SET(server_name, jointext(new_name, ""))

	if(CONFIG_GET(log_runtime))
		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

	update_status()

	. = ..()

	// Load an away mission and set up the mining asteroid's secrets.
	createRandomZlevel()
	for(var/i = 0, i < GLOBL.max_secret_rooms, i++)
		make_mining_asteroid_secret()
	WAIT_FOR_BACKLOG

	call_hook(/hook/startup)

	global.CTmaster = new /datum/controller/master()
	//global.CTmaster.defer_setup_for(/datum/process/ticker) // This should no longer be needed, but I'm leaving it commented just in case.
	global.CTmaster.setup()
	global.PCticker.pregame() // This was moved here to avoid unnecessary while() and sleep().

	spawn(5 MINUTES) // Delay by 5 minutes (300 seconds/3000 deciseconds) so we aren't adding to the round-start lag.
		if(CONFIG_GET(ToRban))
			ToRban_autoupdate()
#undef RECOMMENDED_VERSION

/world/Del()
	call_hook(/hook/shutdown)
	global.debugger.shutdown_debugger()
	return ..()

/world/Reboot(reason)
	spawn(0)
		world << sound(pick('sound/AI/newroundsexy.ogg', 'sound/misc/apcdestroyed.ogg', 'sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy

	// Stops the master controller's process scheduling.
	global.CTmaster.stop()

	for_no_type_check(var/client/C, GLOBL.clients)
		if(isnotnull(CONFIG_GET(server)))	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
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
		for_no_type_check(var/mob/M, GLOBL.player_list)
			if(M.client)
				n++
		return n

	else if(T == "status")
		var/list/s = list(
			"version" = GLOBL.game_version,
			"mode" = global.PCticker.master_mode,
			"respawn" = CONFIG_GET(respawn),
			"enter" = GLOBL.enter_allowed,
			"vote" = CONFIG_GET(allow_vote_mode),
			"ai" = CONFIG_GET(allow_ai),
			"host" = host ? host : null,
			"players" = list()
		)
		var/n = 0
		var/admins = 0

		for_no_type_check(var/client/C, GLOBL.clients)
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
/hook/startup/proc/load_mode()
	. = TRUE
	var/list/lines = file2list("data/mode.txt")
	if(length(lines))
		if(lines[1])
			global.PCticker.master_mode = lines[1]
			log_misc("Saved mode is '[global.PCticker.master_mode]'")

/world/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

// MOTD loading.
/hook/startup/proc/load_motd()
	. = TRUE
	GLOBL.join_motd = file2text("config/motd.txt")

// Moderator loading.
/hook/startup/proc/load_mods()
	. = TRUE
	if(CONFIG_GET(admin_legacy_system))
		var/text = file2text("config/moderators.txt")
		if(isnull(text))
			error("Failed to load config/mods.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if(isnull(line))
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

	if(isnotnull(CONFIG_GET(server_name)))
		s += "<b>[CONFIG_GET(server_name)]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"http://\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Default"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(isnotnull(global.PCticker?.master_mode))
		features.Add(global.PCticker.master_mode)
	else
		features.Add("<b>STARTING</b>")

	if(!GLOBL.enter_allowed)
		features.Add("closed")

	features.Add(CONFIG_GET(respawn) ? "respawn" : "no respawn")

	if(CONFIG_GET(allow_vote_mode))
		features.Add("vote")

	if(CONFIG_GET(allow_ai))
		features.Add("AI allowed")

	var/n = 0
	for_no_type_check(var/mob/M, GLOBL.player_list)
		if(isnotnull(M.client))
			n++

	if(n > 1)
		features.Add("~[n] players")
	else if(n > 0)
		features.Add("~[n] player")

	/*
	is there a reason for this? the byond site shows 'hosted by X' when there is a proper host already.
	if(host)
		features.Add("hosted by <b>[host]</b>")
	*/

	if(!host && isnotnull(CONFIG_GET(hostedby)))
		features.Add("hosted by <b>[CONFIG_GET(hostedby)]</b>")

	if(isnotnull(features))
		s += ": [jointext(features, ", ")]"

	/* does this help? I do not know */
	if(status != s)
		status = s

// Database connections.
/hook/startup/proc/connect_database()
	. = TRUE
	if(!setup_database_connection())
		world.log << "Your server failed to establish a connection with the feedback database."
	else
		world.log << "Feedback database connection established."

/hook/startup/proc/connect_old_database()
	. = TRUE
	if(!setup_old_database_connection())
		world.log << "Your server failed to establish a connection with the SQL database."
	else
		world.log << "SQL database connection established."