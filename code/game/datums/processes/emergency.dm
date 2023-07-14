/*
 * Emergency Process
 */
PROCESS_DEF(emergency)
	name = "Emergency"
	schedule_interval = 2 SECONDS

/datum/process/emergency/setup()
	if(isnull(global.CTemergency))
		global.CTemergency = new /datum/controller/emergency()

/datum/process/emergency/do_work()
	global.CTemergency.process()