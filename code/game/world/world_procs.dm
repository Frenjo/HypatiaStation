/world/Reboot(reason)
	spawn(0)
		world << sound(pick('sound/AI/newroundsexy.ogg', 'sound/misc/apcdestroyed.ogg', 'sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy

	// Stops the master controller's process scheduling.
	global.CTmaster.stop()

	// If you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
	var/server_location = CONFIG_GET(/decl/configuration_entry/server)
	for_no_type_check(var/client/C, GLOBL.clients)
		if(isnotnull(server_location))
			C << link("byond://[server_location]")
		else
			C << link("byond://[world.address]:[world.port]")

	. = ..(reason)

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
	if(CONFIG_GET(/decl/configuration_entry/admin_legacy_system))
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

// Database connections.
/hook/startup/proc/connect_database()
	. = TRUE
	if(!setup_database_connection())
		TO_WORLD_LOG("Your server failed to establish a connection with the feedback database.")
	else
		TO_WORLD_LOG("Feedback database connection established.")

/hook/startup/proc/connect_old_database()
	. = TRUE
	if(!setup_old_database_connection())
		TO_WORLD_LOG("Your server failed to establish a connection with the SQL database.")
	else
		TO_WORLD_LOG("SQL database connection established.")