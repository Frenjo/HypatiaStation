/datum/controller/process/emergencyShuttle/setup()
	name = "emergency shuttle"
	schedule_interval = 2 SECONDS

	if(!emergency_shuttle)
		emergency_shuttle = new

/datum/controller/process/emergencyShuttle/doWork()
	emergency_shuttle.process()