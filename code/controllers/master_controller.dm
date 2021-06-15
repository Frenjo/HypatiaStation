//simplified MC that is designed to fail when procs 'break'. When it fails it's just replaced with a new one.
//It ensures master_controller.process() is never doubled up by killing the MC (hence terminating any of its sleeping procs)
//WIP, needs lots of work still

var/global/datum/controller/game_controller/master_controller //Set in world.New()

var/global/controller_iteration = 0
var/global/last_tick_timeofday = world.timeofday
var/global/last_tick_duration = 0

var/global/air_processing_killed = 0
var/global/pipe_processing_killed = 0

/datum/controller/game_controller
	var/rebuild_active_areas = 0

/datum/controller/game_controller/New()
	//There can be only one master_controller. Out with the old and in with the new.
	if(master_controller != src)
		log_debug("Rebuilding Master Controller")
		if(istype(master_controller))
			qdel(master_controller)
		master_controller = src

	if(!job_master)
		job_master = new /datum/controller/occupations()
		job_master.setup_occupations()
		job_master.load_jobs("config/jobs.txt")
		to_chat(world, SPAN_DANGER("Job setup complete."))

	if(!syndicate_code_phrase)
		syndicate_code_phrase = generate_code_phrase()
	if(!syndicate_code_response)
		syndicate_code_response	= generate_code_phrase()

/datum/controller/game_controller/proc/setup()
	world.tick_lag = config.Ticklag

	spawn(20)
		createRandomZlevel()

	setup_objects()
	setup_genetics()
	setup_factions()
	setup_xenoarch()

	transfer_controller = new

	for(var/i = 0, i < max_secret_rooms, i++)
		make_mining_asteroid_secret()

/datum/controller/game_controller/proc/setup_objects()
	to_chat(world, SPAN_DANGER("Initializing objects."))
	sleep(-1)
	for(var/atom/movable/object in world)
		object.initialize()

	to_chat(world, SPAN_DANGER("Initializing pipe networks."))
	sleep(-1)
	for(var/obj/machinery/atmospherics/machine in machines)
		machine.build_network()

	to_chat(world, SPAN_DANGER("Initializing atmos machinery."))
	sleep(-1)
	for(var/obj/machinery/atmospherics/unary/U in machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()

	//Set up spawn points.
	to_chat(world, SPAN_DANGER("Populating spawn points."))
	populate_spawn_points()

	to_chat(world, SPAN_DANGER("Initializations complete."))
	sleep(-1)