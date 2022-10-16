/var/global/datum/global_init/global_init = new /datum/global_init()

/*
 * Global Initialisation
 * 
 * Pre-map initialisation stuff should go here:
 *	Enables the SpacemanDMM debugger.
 *	Loads the configuration files.
 *	Sets up the global_variables controller.
 *	Calls the global_init hook.
 *
 * The beginning is always today. ~ Mary Shelley
*/
/datum/global_init/New()
	global.debugger = new /debugger()
	global.config = new /configuration()
	global.GLOBL = new /datum/controller/global_variables()

	callHook("global_init")
	del(src)