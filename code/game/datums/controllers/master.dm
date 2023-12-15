/*
 * Master Controller
 */
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

	// TODO: Move this somewhere more relevant. Maybe into a startup hook?
	if(isnull(GLOBL.syndicate_code_phrase))
		GLOBL.syndicate_code_phrase = generate_code_phrase()
	if(isnull(GLOBL.syndicate_code_response))
		GLOBL.syndicate_code_response = generate_code_phrase()

/datum/controller/master/setup()
	var/start_time = world.timeofday
	to_world(SPAN_DANGER("Initialising Master controller."))

	if(isnull(global.CTjobs))
		global.CTjobs = new /datum/controller/jobs()
		global.CTjobs.setup_occupations()
		global.CTjobs.load_jobs("config/jobs.txt")
		to_world(SPAN_DANGER("↪ Job setup complete."))

	if(isnull(global.CTradio))
		global.CTradio = new /datum/controller/radio()
		to_world(SPAN_DANGER("↪ Radio setup complete."))

	setup_objects()
	setup_genetics()
	setup_factions()
	setup_xenoarch()
	sleep(-1)

	to_world(SPAN_DANGER("Initialisation completed in [(world.timeofday - start_time) / 10] second\s."))
	initialised = TRUE

/datum/controller/master/proc/stat_controllers()
	stat("Controllers:", length(GLOBL.controllers))
	for(var/datum/controller/controller in GLOBL.controllers)
		controller.stat_controller()

/datum/controller/master/proc/setup_objects()
	to_world(SPAN_DANGER("↪ Initialising areas."))
	for(var/area/area in world)
		if(!GC_DESTROYED(area))
			area.initialize()
	sleep(-1)

	to_world(SPAN_DANGER("↪ Initialising turfs."))
	for(var/turf/simulated/turf in world)
		if(!GC_DESTROYED(turf))
			turf.initialize()
	sleep(-1)

	to_world(SPAN_DANGER("↪ Initialising objects."))
	for(var/atom/movable/object in world)
		if(!GC_DESTROYED(object))
			object.initialize()
	sleep(-1)

	to_world(SPAN_DANGER("↪ Initialising pipe networks."))
	for(var/obj/machinery/atmospherics/machine in GLOBL.machines)
		machine.atmos_initialise()
	for(var/obj/machinery/atmospherics/machine in GLOBL.machines)
		machine.build_network()
	sleep(-1)

	to_world(SPAN_DANGER("↪ Initialising atmos machinery."))
	for(var/obj/machinery/atmospherics/unary/U in GLOBL.machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()
	sleep(-1)

	// Sets up spawn points.
	to_world(SPAN_DANGER("↪ Populating spawn points."))
	populate_spawn_points()
	sleep(-1)

	// Creates the space parallax background.
	to_world(SPAN_DANGER("↪ Creating space parallax."))
	create_parallax()
	sleep(-1)

/datum/controller/master/proc/setup_factions()
	to_world(SPAN_DANGER("↪ Setting up factions."))

	// Populates the factions list.
	for(var/path in typesof(/datum/faction))
		var/datum/faction/F = new path
		if(!F.name)
			qdel(F)
			continue
		else
			GLOBL.factions.Add(F)
			GLOBL.available_factions.Add(F)

	// Populates the syndicate coalition.
	for(var/datum/faction/syndicate/S in GLOBL.factions)
		GLOBL.syndicate_coalition.Add(S)

	sleep(-1)

#define XENOARCH_SPAWN_CHANCE 0.5
#define XENOARCH_SPREAD_CHANCE 15
#define ARTIFACT_SPAWN_CHANCE 20
/datum/controller/master/proc/setup_xenoarch()
	to_world(SPAN_DANGER("↪ Setting up xenoarchaeology."))

	for(var/turf/simulated/mineral/M in block(locate(1, 1, 1), locate(world.maxx, world.maxy, world.maxz)))
		if(!M.geologic_data)
			M.geologic_data = new /datum/geosample(M)

		if(!prob(XENOARCH_SPAWN_CHANCE))
			continue

		var/digsite = get_random_digsite_type()
		var/list/processed_turfs = list()
		var/list/turfs_to_process = list(M)
		for(var/turf/simulated/mineral/archeo_turf in turfs_to_process)
			for(var/turf/simulated/mineral/T in orange(1, archeo_turf))
				if(T.finds)
					continue
				if(T in processed_turfs)
					continue
				if(prob(XENOARCH_SPREAD_CHANCE))
					turfs_to_process.Add(T)

			processed_turfs.Add(archeo_turf)
			if(!archeo_turf.finds)
				archeo_turf.finds = list()
				if(prob(50))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(5, 95)))
				else if(prob(75))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(5, 45)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(55, 95)))
				else
					archeo_turf.finds.Add(new /datum/find(digsite, rand(5, 30)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(35, 75)))
					archeo_turf.finds.Add(new /datum/find(digsite, rand(75, 95)))

				//sometimes a find will be close enough to the surface to show
				var/datum/find/F = archeo_turf.finds[1]
				if(F.excavation_required <= F.view_range)
					archeo_turf.archaeo_overlay = "overlay_archaeo[rand(1, 3)]"
					archeo_turf.overlays += archeo_turf.archaeo_overlay

		//dont create artifact machinery in animal or plant digsites, or if we already have one
		if(!M.artifact_find && digsite != 1 && digsite != 2 && prob(ARTIFACT_SPAWN_CHANCE))
			M.artifact_find = new /datum/artifact_find()
#undef XENOARCH_SPAWN_CHANCE
#undef XENOARCH_SPREAD_CHANCE
#undef ARTIFACT_SPAWN_CHANCE