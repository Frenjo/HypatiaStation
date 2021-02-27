/datum/controller/process/shuttle/setup()
	name = "shuttle controller"
	schedule_interval = 40 // every 4 seconds

	if(!shuttle_controller)
		shuttle_controller = new

/datum/controller/process/shuttle/doWork()
	shuttle_controller.process()