/var/global/datum/global_init/global_init = new /datum/global_init()

/*
 * Global Initialisation
 * 
 * Pre-map initialisation stuff should go here:
 *	Enables the SpacemanDMM debugger.
 *	Loads the configuration files.
 *	Sets up the global variables controller.
 *	Sets up the declarations controller.
 *	Calls the global_init hook.
 *
 * The beginning is always today. ~ Mary Shelley
*/
/datum/global_init/New()
	global.debugger = new /debugger()
	global.config = new /configuration()
	global.GLOBL = new /datum/controller/global_variables()
	global.CTdecls = new /datum/controller/decls()

	callHook("global_init")
	del(src)