/datum/controller/process/supply/setup()
	name = "supply"
	schedule_interval = 30 SECONDS

/datum/controller/process/supply/doWork()
	global.supply_controller.process()