/*
 * Sun Process
 */
GLOBAL_BYOND_TYPED(sun, /datum/sun)

PROCESS_DEF(sun)
	name = "Sun"
	schedule_interval = 2 SECONDS

/datum/process/sun/setup()
	if(isnull(global.sun))
		global.sun = new /datum/sun()

/datum/process/sun/doWork()
	global.sun.calc_position()