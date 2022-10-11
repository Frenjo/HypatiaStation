/*
 * Emergency Process
 */
/datum/process/emergency
	name = "Emergency"
	schedule_interval = 2 SECONDS

/datum/process/emergency/setup()
	if(!global.emergency_controller)
		global.emergency_controller = new /datum/controller/emergency()

/datum/process/emergency/doWork()
	global.emergency_controller.process()