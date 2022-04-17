/datum/controller/process/air/setup()
	name = "air"
	schedule_interval = 2 SECONDS
	start_delay = 4

	if(!global.air_master)
		global.air_master = new
		global.air_master.Setup()

/datum/controller/process/air/doWork()
	if(!global.air_processing_killed)
		if(!global.air_master.Tick()) //Runtimed.
			global.air_master.failed_ticks++

			if(global.air_master.failed_ticks > 5)
				to_world(SPAN_DANGER("RUNTIMES IN ATMOS TICKER. Killing air simulation!"))
				world.log << "### ZAS SHUTDOWN"

				message_admins("ZASALERT: Shutting down! status: [global.air_master.tick_progress]")
				log_admin("ZASALERT: Shutting down! status: [global.air_master.tick_progress]")

				global.air_processing_killed = TRUE
				global.air_master.failed_ticks = 0