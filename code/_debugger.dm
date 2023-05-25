/var/global/debugger/debugger // Set in /datum/global_init/New()

// This datum is used to initialise the auxtools debugger during global_init.
/debugger
	var/debug_server = null

/debugger/New()
	debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	enable_debugger()

/debugger/proc/enable_debugger()
	if(!isnull(debug_server))
		LIBCALL(debug_server, "auxtools_init")()
		enable_debugging()

/debugger/proc/shutdown_debugger()
	if(!isnull(debug_server))
		LIBCALL(debug_server, "auxtools_shutdown")()