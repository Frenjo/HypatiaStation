/var/datum/sun/sun = null

/datum/controller/process/sun/setup()
	name = "sun"
	schedule_interval = 2 SECONDS
	global.sun = new

/datum/controller/process/sun/doWork()
	global.sun.calc_position()