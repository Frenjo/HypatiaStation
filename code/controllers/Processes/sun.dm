/datum/controller/process/sun/setup()
	name = "sun"
	schedule_interval = 20 // every 2 seconds
	sun = new

/datum/controller/process/sun/doWork()
	sun.calc_position()