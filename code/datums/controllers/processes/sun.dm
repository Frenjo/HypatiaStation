/var/global/datum/sun/sun

/datum/controller/process/sun/setup()
	name = "sun"
	schedule_interval = 2 SECONDS

	if(!global.sun)
		global.sun = new /datum/sun()

/datum/controller/process/sun/doWork()
	global.sun.calc_position()