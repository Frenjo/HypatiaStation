/datum/controller/process/sun/setup()
	name = "sun"
	schedule_interval = 2 SECONDS
	sun = new

/datum/controller/process/sun/doWork()
	sun.calc_position()