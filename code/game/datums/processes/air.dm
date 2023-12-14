/*
 * Air Process
 */
PROCESS_DEF(air)
	name = "Air"
	schedule_interval = 2 SECONDS
	start_delay = 4

	var/processing_killed = FALSE

/datum/process/air/setup()
	if(isnull(global.CTair))
		global.CTair = new /datum/controller/air()
		global.CTair.setup()
	. = ..()

/datum/process/air/do_work()
	if(processing_killed)
		return

	if(!global.CTair.process()) //Runtimed.
		global.CTair.failed_ticks++

		if(global.CTair.failed_ticks > 5)
			to_world(SPAN_DANGER("RUNTIMES IN ATMOS TICKER. Killing air simulation!"))
			world.log << "### ZAS SHUTDOWN"

			message_admins("ZASALERT: Shutting down! status: [global.CTair.tick_progress]")
			log_admin("ZASALERT: Shutting down! status: [global.CTair.tick_progress]")

			processing_killed = TRUE
			global.CTair.failed_ticks = 0