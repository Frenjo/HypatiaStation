/*
 * Supply Process
 */
PROCESS_DEF(supply)
	name = "Supply"
	schedule_interval = 30 SECONDS

/datum/process/supply/setup()
	if(isnull(global.CTsupply))
		global.CTsupply = new /datum/controller/supply()
		global.CTsupply.shuttle = global.CTshuttle.shuttles["Supply"]

/datum/process/supply/do_work()
	global.CTsupply.process()