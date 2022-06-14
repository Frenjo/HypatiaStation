/datum/controller/process/supply/setup()
	name = "supply"
	schedule_interval = 30 SECONDS

	if(!global.supply_controller)
		global.supply_controller = new /datum/controller/supply()
		global.supply_controller.shuttle = global.shuttles["Supply"]

/datum/controller/process/supply/doWork()
	global.supply_controller.process()