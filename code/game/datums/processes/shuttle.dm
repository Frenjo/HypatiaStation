/*
 * Shuttle Process
 */
PROCESS_DEF(shuttle)
	name = "Shuttle"
	schedule_interval = 2 SECONDS

/datum/process/shuttle/setup()
	if(!global.CTshuttle)
		global.CTshuttle = new /datum/controller/shuttle()

/datum/process/shuttle/doWork()
	global.CTshuttle.process()