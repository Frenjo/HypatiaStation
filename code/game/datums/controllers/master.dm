/*
 * Master Controller
 */
GLOBAL_BYOND_INIT(air_processing_killed, FALSE)
GLOBAL_BYOND_INIT(pipe_processing_killed, FALSE)

CONTROLLER_DEF(master)
	name = "Master"

	var/initialised = FALSE

/datum/controller/master/New()
	. = ..()
	// There can be only one master_controller. Out with the old and in with the new.
	if(global.CTmaster != src)
		log_debug("Rebuilding Master Controller")
		if(istype(global.CTmaster))
			qdel(global.CTmaster)
		global.CTmaster = src

	if(!global.CToccupations)
		global.CToccupations = new /datum/controller/occupations()
		global.CToccupations.setup_occupations()
		global.CToccupations.load_jobs("config/jobs.txt")
		to_world(SPAN_DANGER("Job setup complete."))
	
	if(!global.CTradio)
		global.CTradio = new /datum/controller/radio()
		to_world(SPAN_DANGER("Radio setup complete."))

	if(!GLOBL.syndicate_code_phrase)
		GLOBL.syndicate_code_phrase = generate_code_phrase()
	if(!GLOBL.syndicate_code_response)
		GLOBL.syndicate_code_response = generate_code_phrase()

/datum/controller/master/setup()
	setup_objects()
	setup_genetics()
	setup_factions()
	setup_xenoarch()
	sleep(-1)

	to_world(SPAN_DANGER("Initialisations complete."))
	initialised = TRUE

/datum/controller/master/proc/stat_controllers()
	stat("Controllers:", length(GLOBL.controllers))
	for(var/datum/controller/controller in GLOBL.controllers)
		controller.stat_controller()

/datum/controller/master/proc/setup_objects()
	to_world(SPAN_DANGER("Initialising areas."))
	for(var/area/area in world)
		if(!GC_DESTROYED(area))
			area.initialize()
	sleep(-1)

	to_world(SPAN_DANGER("Initialising objects."))
	for(var/atom/movable/object in world)
		if(!GC_DESTROYED(object))
			object.initialize()
	sleep(-1)

	to_world(SPAN_DANGER("Initialising pipe networks."))
	for(var/obj/machinery/atmospherics/machine in GLOBL.machines)
		machine.atmos_initialise()
	for(var/obj/machinery/atmospherics/machine in GLOBL.machines)
		machine.build_network()
	sleep(-1)

	to_world(SPAN_DANGER("Initialising atmos machinery."))
	for(var/obj/machinery/atmospherics/unary/U in GLOBL.machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()
	sleep(-1)

	// Set up spawn points.
	to_world(SPAN_DANGER("Populating spawn points."))
	populate_spawn_points()
	sleep(-1)

	// Create the space parallax background.
	to_world(SPAN_DANGER("Creating space parallax."))
	create_parallax()
	sleep(-1)