/datum/process/shuttle/setup()
	name = "shuttle"
	schedule_interval = 2 SECONDS

	if(!global.shuttle_controller)
		global.shuttle_controller = new /datum/controller/shuttle()

/datum/process/shuttle/doWork()
	global.shuttle_controller.process()