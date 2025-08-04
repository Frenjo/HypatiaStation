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
#define RECOMMENDED_VERSION 516
/world/New()
	name = "Space Station 13 - [GLOBL.game_version]: [GLOBL.current_map.station_name]"
	tick_lag = CONFIG_GET(/decl/configuration_entry/ticklag)

	if(byond_version < RECOMMENDED_VERSION)
		TO_WORLD_LOG("Your server's byond version does not meet the recommended requirements for this server. Please update BYOND.")

	global.CTconfiguration.post_load()

	var/server_name = CONFIG_GET(/decl/configuration_entry/server_name)
	if(isnotnull(server_name) && CONFIG_GET(/decl/configuration_entry/server_suffix) && world.port > 0)
		// dumb and hardcoded but I don't care~
		var/list/new_name = list(server_name, " #[(world.port % 1000) / 100]")
		CONFIG_SET(/decl/configuration_entry/server_name, jointext(new_name, ""))

	if(CONFIG_GET(/decl/configuration_entry/log_runtime))
		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

	update_status()

	. = ..()

	// Loads an away mission.
	createRandomZlevel()
	// Sets up the mining asteroid's caves and secret rooms.
	for(var/i = 0, i < GLOBL.max_asteroid_caves, i++)
		make_mining_asteroid_cave()
	for(var/i = 0, i < GLOBL.max_asteroid_secret_rooms, i++)
		make_mining_asteroid_secret()
	WAIT_FOR_BACKLOG

	call_hook(/hook/startup)

	global.CTmaster = new /datum/controller/master()
	global.CTmaster.setup()
	global.PCticker.pregame() // This was moved here to avoid unnecessary while() and sleep().

	spawn(5 MINUTES) // Delay by 5 minutes (300 seconds / 3000 deciseconds) so we aren't adding to the round-start lag.
		if(CONFIG_GET(/decl/configuration_entry/ToRban))
			ToRban_autoupdate()
#undef RECOMMENDED_VERSION

/world/Del()
	call_hook(/hook/shutdown)
	global.debugger.shutdown_debugger()
	return ..()