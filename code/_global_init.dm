/var/global/datum/global_init/global_init = new /datum/global_init()

/*
 * Pre-map initialization stuff should go here.
*/
/datum/global_init/New()
	global.debugger = new /debugger()
	global.config = new /configuration()
	global.GLOBL = new /datum/controller/global_variables()

	callHook("global_init")
	del(src)