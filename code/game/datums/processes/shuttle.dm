/*
 * Shuttle Process
 */
/datum/process/shuttle
	name = "Shuttle"
	schedule_interval = 2 SECONDS

/datum/process/shuttle/setup()
	if(!global.shuttle_controller)
		global.shuttle_controller = new /datum/controller/shuttle()

/datum/process/shuttle/doWork()
	global.shuttle_controller.process()