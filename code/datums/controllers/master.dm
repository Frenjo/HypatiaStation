//simplified MC that is designed to fail when procs 'break'. When it fails it's just replaced with a new one.
//It ensures master_controller.process() is never doubled up by killing the MC (hence terminating any of its sleeping procs)
//WIP, needs lots of work still

/var/global/datum/controller/master/master_controller //Set in world.New()

/var/global/controller_iteration = 0
/var/global/last_tick_timeofday = world.timeofday
/var/global/last_tick_duration = 0

/var/global/air_processing_killed = FALSE
/var/global/pipe_processing_killed = FALSE

/datum/controller/master/New()
	//There can be only one master_controller. Out with the old and in with the new.
	if(global.master_controller != src)
		log_debug("Rebuilding Master Controller")
		if(istype(global.master_controller))
			qdel(global.master_controller)
		global.master_controller = src

	if(!global.job_master)
		global.job_master = new /datum/controller/occupations()
		global.job_master.setup_occupations()
		global.job_master.load_jobs("config/jobs.txt")
		to_world(SPAN_DANGER("Job setup complete."))

	if(!global.syndicate_code_phrase)
		global.syndicate_code_phrase = generate_code_phrase()
	if(!global.syndicate_code_response)
		global.syndicate_code_response	= generate_code_phrase()

/datum/controller/master/proc/setup()
	world.tick_lag = global.config.ticklag

	spawn(20)
		createRandomZlevel()

	setup_objects()
	setup_genetics()
	setup_factions()
	setup_xenoarch()

	global.transfer_controller = new /datum/controller/transfer()

	for(var/i = 0, i < max_secret_rooms, i++)
		make_mining_asteroid_secret()

/datum/controller/master/proc/setup_objects()
	to_world(SPAN_DANGER("Initializing objects."))
	sleep(-1)
	for(var/atom/movable/object in world)
		if(isnull(object.gcDestroyed))
			object.initialize()

	to_world(SPAN_DANGER("Initializing pipe networks."))
	sleep(-1)
	for(var/obj/machinery/atmospherics/machine in global.machines)
		machine.build_network()

	to_world(SPAN_DANGER("Initializing atmos machinery."))
	sleep(-1)
	for(var/obj/machinery/atmospherics/unary/U in global.machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()

	//Set up spawn points.
	to_world(SPAN_DANGER("Populating spawn points."))
	populate_spawn_points()

	// Create the space parallax background.
	to_world(SPAN_DANGER("Creating space parallax."))
	create_parallax()

	to_world(SPAN_DANGER("Initializations complete."))
	sleep(-1)