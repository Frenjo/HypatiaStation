/*
 * Air Process
 */
PROCESS_DEF(air)
	name = "Air"
	schedule_interval = 2 SECONDS
	start_delay = 4

/datum/process/air/setup()
	if(isnull(global.CTair_system))
		global.CTair_system = new /datum/controller/air_system()
		global.CTair_system.setup()

/datum/process/air/doWork()
	if(!global.air_processing_killed)
		if(!global.CTair_system.process()) //Runtimed.
			global.CTair_system.failed_ticks++

			if(global.CTair_system.failed_ticks > 5)
				to_world(SPAN_DANGER("RUNTIMES IN ATMOS TICKER. Killing air simulation!"))
				world.log << "### ZAS SHUTDOWN"

				message_admins("ZASALERT: Shutting down! status: [global.CTair_system.tick_progress]")
				log_admin("ZASALERT: Shutting down! status: [global.CTair_system.tick_progress]")

				global.air_processing_killed = TRUE
				global.CTair_system.failed_ticks = 0