/datum/process/emergency_shuttle/setup()
	name = "emergency shuttle"
	schedule_interval = 2 SECONDS

	if(!global.emergency_shuttle)
		global.emergency_shuttle = new /datum/controller/emergency_shuttle()

/datum/process/emergency_shuttle/doWork()
	global.emergency_shuttle.process()