/datum/controller/process/shuttle/setup()
	name = "shuttle"
	schedule_interval = 2 SECONDS

	if(!shuttle_controller)
		shuttle_controller = new

/datum/controller/process/shuttle/doWork()
	shuttle_controller.process()