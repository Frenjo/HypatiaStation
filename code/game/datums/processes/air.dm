/*
 * Air Process
 */
PROCESS_DEF(air)
	name = "Air"
	schedule_interval = 2 SECONDS
	start_delay = 4

/datum/process/air/setup()
	if(!global.air_master)
		global.air_master = new /datum/controller/air_system()
		global.air_master.setup()

/datum/process/air/doWork()
	if(!global.air_processing_killed)
		if(!global.air_master.process()) //Runtimed.
			global.air_master.failed_ticks++

			if(global.air_master.failed_ticks > 5)
				to_world(SPAN_DANGER("RUNTIMES IN ATMOS TICKER. Killing air simulation!"))
				world.log << "### ZAS SHUTDOWN"

				message_admins("ZASALERT: Shutting down! status: [global.air_master.tick_progress]")
				log_admin("ZASALERT: Shutting down! status: [global.air_master.tick_progress]")

				global.air_processing_killed = TRUE
				global.air_master.failed_ticks = 0