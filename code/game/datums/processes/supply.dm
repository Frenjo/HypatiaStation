/*
 * Supply Process
 */
/datum/process/supply
	name = "Supply"
	schedule_interval = 30 SECONDS

/datum/process/supply/setup()
	if(!global.supply_controller)
		global.supply_controller = new /datum/controller/supply()
		global.supply_controller.shuttle = global.shuttle_controller.shuttles["Supply"]

/datum/process/supply/doWork()
	global.supply_controller.process()