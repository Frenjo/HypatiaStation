/datum/controller/process/emergencyShuttle/setup()
	name = "emergency shuttle"
	schedule_interval = 2 SECONDS

	if(!global.emergency_shuttle)
		global.emergency_shuttle = new

/datum/controller/process/emergencyShuttle/doWork()
	global.emergency_shuttle.process()