/var/global/datum/debugger/debugger // Set in /datum/global_init/New()

// This datum is used to initialise the auxtools debugger during global_init.
/datum/debugger
	var/debug_server

/datum/debugger/New()
	debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	enable_debugger()

/datum/debugger/proc/enable_debugger()
	if(debug_server)
		call(debug_server, "auxtools_init")()
		enable_debugging()

/datum/debugger/proc/shutdown_debugger()
	if(debug_server)
		call(debug_server, "auxtools_shutdown")()