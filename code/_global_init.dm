/var/global/datum/global_init/init = new()

/*
 * Pre-map initialization stuff should go here.
*/
/datum/global_init/New()
	global.debugger = new /debugger()
	global.config = new /configuration()

	callHook("global_init")
	del(src)