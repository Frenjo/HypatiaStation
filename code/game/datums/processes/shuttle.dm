/*
 * Shuttle Process
 */
PROCESS_DEF(shuttle)
	name = "Shuttle"
	schedule_interval = 2 SECONDS

/datum/process/shuttle/setup()
	if(isnull(global.CTshuttle))
		global.CTshuttle = new /datum/controller/shuttle()

/datum/process/shuttle/do_work()
	global.CTshuttle.process()