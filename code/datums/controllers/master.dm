/*
 * Master Controller
 */
GLOBAL_BYOND_TYPED(master_controller, /datum/controller/master) // Set in world/New()

/var/global/controller_iteration = 0
/var/global/last_tick_timeofday = world.timeofday
/var/global/last_tick_duration = 0

GLOBAL_BYOND_INIT(air_processing_killed, FALSE)
GLOBAL_BYOND_INIT(pipe_processing_killed, FALSE)

/datum/controller/master
	name = "Master"

/datum/controller/master/New()
	..()
	// There can be only one master_controller. Out with the old and in with the new.
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
	
	if(!global.radio_controller)
		global.radio_controller = new /datum/controller/radio()
		to_world(SPAN_DANGER("Radio setup complete."))

	if(!global.syndicate_code_phrase)
		global.syndicate_code_phrase = generate_code_phrase()
	if(!global.syndicate_code_response)
		global.syndicate_code_response	= generate_code_phrase()

/datum/controller/master/setup()
	world.tick_lag = global.config.ticklag

	spawn(2 SECONDS)
		createRandomZlevel()

	setup_objects()
	setup_genetics()
	setup_factions()
	setup_xenoarch()

	for(var/i = 0, i < global.max_secret_rooms, i++)
		make_mining_asteroid_secret()

/datum/controller/master/proc/stat_controllers()
	stat("Controllers:", GLOBL.controllers.len)
	for(var/datum/controller/controller in GLOBL.controllers)
		controller.stat_controller()

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

	// Set up spawn points.
	to_world(SPAN_DANGER("Populating spawn points."))
	populate_spawn_points()

	// Create the space parallax background.
	to_world(SPAN_DANGER("Creating space parallax."))
	create_parallax()

	to_world(SPAN_DANGER("Initializations complete."))
	sleep(-1)