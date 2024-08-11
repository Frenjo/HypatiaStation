/*
 * Master Controller
 *
 * This is an unholy abomination of GoonPS, CarnMC and StonedMC.
 *
 * Takes over after global initialisation happens and the world has been created:
 *	Generates syndicate code phrases and responses.
 *	Initialises job and radio controllers.
 *	Sets up processes.
 *	Calls initialise() on all areas, simulated turfs and movable atoms.
 *	Calls atmos_initialise() and post_status() on all pipe networks and atmospherics machinery.
 *	Populates latejoin spawn points.
 *	Creates the space parallax background.
 *	Calls setup_genetics() to initialise DNA2.
 *	Sets up factions.
 *	Sets up xenoarchaeological finds and artifacts.
 *
 * A leader is best when people barely know he exists, when his work is done, his aim fulfilled, they will say: we did it ourselves. ~ Lao Tzu
 */
CONTROLLER_DEF(master)
	name = "Master"

	// Whether the master controller is fully initialised.
	var/tmp/initialised = FALSE
	// Whether the master controller is running.
	var/tmp/is_running = FALSE

	/*
	 * Tick Data
	 */
	// How long to sleep between runs.
	// By default this is set to world.tick_lag in /New().
	var/tmp/scheduler_sleep_interval

	var/tmp/current_tick = 0

	var/tmp/time_allowance = 0

	var/tmp/cpu_average = 0

	var/tmp/time_allowance_max = 0

	/*
	 * Process Lists
	 */
	// List of known processes.
	var/tmp/list/datum/process/processes = list()

	// List of processes that are currently running.
	var/tmp/list/datum/process/running = list()

	// List of processes that are idle.
	var/tmp/list/datum/process/idle = list()

	// List of processes that are queued to run.
	var/tmp/list/datum/process/queued = list()

	// Process typepath -> process instance map.
	var/tmp/list/processes_by_type = list()

	// List of processes whose setup will be deferred until all the other processes are set up.
	var/tmp/list/deferred_setup_list = list()

	/*
	 * Process Timekeeping
	 */
	// List of process last queued times in world time.
	var/tmp/list/last_queued = list()

	// List of process last start times in real time.
	var/tmp/list/last_start = list()

	// List of process last run durations.
	var/tmp/list/last_run_time = list()

	// Per process list of the last 20 durations
	var/tmp/list/last_twenty_run_times = list()

	// List of process highest run times.
	var/tmp/list/highest_run_time = list()

/datum/controller/master/New()
	. = ..()
	// world.tick_lag is set by this point, so there's no need to reset these later.
	scheduler_sleep_interval = world.tick_lag
	time_allowance = world.tick_lag * 0.5
	time_allowance_max = world.tick_lag

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
	// Stores the time we started setting up the master controller.
	var/start_time = world.timeofday
	to_world(SPAN_DANGER("Initialising Master controller."))

	if(isnull(global.CTjobs))
		global.CTjobs = new /datum/controller/jobs()
		global.CTjobs.setup_occupations()
		global.CTjobs.load_jobs("config/jobs.txt")
		to_world(SPAN_DANGER("↪ Job setup complete."))

	// This must be initialised before processes to avoid runtimes.
	if(isnull(global.CTradio))
		global.CTradio = new /datum/controller/radio()
		to_world(SPAN_DANGER("↪ Radio setup complete."))

	// Here to initialize the random events nicely at round start.
	if(isnull(global.CTeconomy))
		global.CTeconomy = new /datum/controller/economy()
		to_world(SPAN_DANGER("↪ Economy setup complete."))

	setup_processes()
	setup_objects()
	setup_genetics()
	setup_factions()
	setup_xenoarch()

	// Reports how long master controller initialisation took.
	to_world(SPAN_DANGER("Initialisation completed in [(world.timeofday - start_time) / 10] second\s."))
	initialised = TRUE

/datum/controller/master/process()
	update_current_tick_data()

	for(var/i = world.tick_lag, i < world.tick_lag * 50, i += world.tick_lag)
		spawn(i)
			update_current_tick_data()
	while(is_running)
		// Hopefully spawning this for 50 ticks in the future will make it the first thing in the queue.
		spawn(world.tick_lag * 50)
			update_current_tick_data()
		check_running_processes()
		queue_processes()
		run_queued_processes()
		sleep(scheduler_sleep_interval)

/*
 * Scheduler State
 */
/datum/controller/master/proc/start()
	if(!initialised)
		CRASH("Attempted to start un-initialised master controller!")

	is_running = TRUE
	update_start_delays()
	spawn(0)
		process()

/datum/controller/master/proc/stop()
	is_running = FALSE

/*
 * Tick Data
 */
/datum/controller/master/proc/get_current_tick_elapsed_time()
	if(world.time > current_tick)
		update_current_tick_data()
		return 0
	else
		return TimeOfTick

/datum/controller/master/proc/update_current_tick_data()
	if(world.time > current_tick)
		// New tick!
		current_tick = world.time
		update_time_allowance()
		cpu_average = (world.cpu + cpu_average + cpu_average) / 3

/datum/controller/master/proc/update_time_allowance()
	// Time allowance goes down linearly with world.cpu.
	var/error = cpu_average - 100
	var/time_allowance_delta = SIMPLE_SIGN(error) * -0.5 * world.tick_lag * max(0, 0.001 * abs(error))

	//timeAllowance = world.tick_lag * min(1, 0.5 * ((200/max(1,cpuAverage)) - 1))
	time_allowance = min(time_allowance_max, max(0, time_allowance + time_allowance_delta))

/datum/controller/master/proc/update_start_delays()
	for_no_type_check(var/datum/process/p, processes)
		if(p.start_delay)
			last_queued[p] = world.time - p.start_delay

/*
 * Status Panel Information
 */
/datum/controller/master/proc/stat_controllers()
	stat("Controllers:", length(GLOBL.controllers))
	for_no_type_check(var/datum/controller/controller, GLOBL.controllers)
		controller.stat_controller()

/datum/controller/master/proc/stat_processes()
	if(!is_running)
		stat("Processes:", "Scheduler not running!")
		return
	stat("Processes:", "[length(processes)] (R [length(running)] / Q [length(queued)] / I [length(idle)])")
	stat(null, "[round(cpu_average, 0.1)] CPU, [round(time_allowance, 0.1) / 10] TA")
	for_no_type_check(var/datum/process/p, processes)
		p.stat_process()

/datum/controller/master/proc/get_status_data()
	var/list/data = list()
	for_no_type_check(var/datum/process/p, processes)
		data.len++
		data[length(data)] = p.get_context_data()
	return data

/*
 * Setup_* Procs
 */
/datum/controller/master/proc/setup_processes()
	// Stores the time we started setting up processes.
	var/start_time = world.timeofday
	to_world(SPAN_DANGER("Initialising processes."))

	var/process
	// Adds all the processes we can find, except those deferred until later.
	for(process in SUBTYPESOF(/datum/process))
		if(!(process in deferred_setup_list))
			add_process(new process(src))

	// Adds all deferred processes to the end of the list.
	for(process in deferred_setup_list)
		add_process(new process(src))

	// Reports how long full process initialisation took.
	to_world(SPAN_DANGER("Initialised all processes in [(world.timeofday - start_time) / 10] second\s."))
	WAIT_FOR_BACKLOG

/datum/controller/master/proc/setup_objects()
	to_world(SPAN_DANGER("↪ Initialising areas."))
	for_no_type_check(var/area/area, GLOBL.area_list)
		if(!GC_DESTROYED(area))
			area.initialise()
	WAIT_FOR_BACKLOG

	to_world(SPAN_DANGER("↪ Initialising turfs."))
	for_no_type_check(var/turf/open/turf, GLOBL.open_turf_list)
		if(!GC_DESTROYED(turf))
			turf.initialise()
	for_no_type_check(var/turf/closed/rock/turf, GLOBL.all_rock_turfs)
		if(!GC_DESTROYED(turf))
			turf.initialise()
	WAIT_FOR_BACKLOG

	to_world(SPAN_DANGER("↪ Initialising objects."))
	for_no_type_check(var/atom/movable/object, GLOBL.movable_atom_list)
		if(!GC_DESTROYED(object))
			object.initialise()
	WAIT_FOR_BACKLOG

	to_world(SPAN_DANGER("↪ Initialising pipe networks."))
	for(var/obj/machinery/atmospherics/machine in GLOBL.machines)
		machine.atmos_initialise()
	for(var/obj/machinery/atmospherics/machine in GLOBL.machines)
		machine.build_network()
	WAIT_FOR_BACKLOG

	to_world(SPAN_DANGER("↪ Initialising atmos machinery."))
	for(var/obj/machinery/atmospherics/unary/U in GLOBL.machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()
	WAIT_FOR_BACKLOG

	// Sets up spawn points.
	to_world(SPAN_DANGER("↪ Populating spawn points."))
	populate_spawn_points()
	WAIT_FOR_BACKLOG

	// Creates the space parallax background.
	to_world(SPAN_DANGER("↪ Creating space parallax."))
	create_parallax()
	WAIT_FOR_BACKLOG

/datum/controller/master/proc/setup_factions()
	to_world(SPAN_DANGER("↪ Setting up factions."))

	// Populates the factions list.
	for(var/path in SUBTYPESOF(/decl/faction))
		var/decl/faction/F = GET_DECL_INSTANCE(path)
		GLOBL.factions.Add(F)
		GLOBL.available_factions.Add(F)

	// Populates the syndicate coalition.
	for(var/decl/faction/syndicate/S in GLOBL.factions)
		GLOBL.syndicate_coalition.Add(S)

	WAIT_FOR_BACKLOG

#define XENOARCH_SPAWN_CHANCE 0.5
#define XENOARCH_SPREAD_CHANCE 15
#define ARTIFACT_SPAWN_CHANCE 20
/datum/controller/master/proc/setup_xenoarch()
	to_world(SPAN_DANGER("↪ Setting up xenoarchaeology."))

	for_no_type_check(var/turf/closed/rock/turf, GLOBL.all_rock_turfs)
		if(isnull(turf.geologic_data))
			turf.geologic_data = new /datum/geosample(turf)

		if(!prob(XENOARCH_SPAWN_CHANCE))
			continue

		var/digsite = get_random_digsite_type()
		var/list/processed_turfs = list()
		var/list/turf/closed/rock/turfs_to_process = list(turf)
		for_no_type_check(var/turf/closed/rock/archeo_turf, turfs_to_process)
			for(var/turf/closed/rock/T in orange(1, archeo_turf))
				if(isnotnull(T.finds))
					continue
				if(T in processed_turfs)
					continue
				if(prob(XENOARCH_SPREAD_CHANCE))
					turfs_to_process.Add(T)

			processed_turfs.Add(archeo_turf)
			if(isnull(archeo_turf.finds))
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
					archeo_turf.overlays.Add(archeo_turf.archaeo_overlay)

		//dont create artifact machinery in animal or plant digsites, or if we already have one
		if(isnull(turf.artifact_find) && digsite != 1 && digsite != 2 && prob(ARTIFACT_SPAWN_CHANCE))
			turf.artifact_find = new /datum/artifact_find()

	WAIT_FOR_BACKLOG
#undef XENOARCH_SPAWN_CHANCE
#undef XENOARCH_SPREAD_CHANCE
#undef ARTIFACT_SPAWN_CHANCE

/*
 * Process Queue
 */
/*
 * defer_setup_for()
 * @param path process_path
 * If a process needs to be initialized after everything else, add it to
 * the deferred setup list. On goonstation, only the ticker needs to have
 * this treatment.
 */
/datum/controller/master/proc/defer_setup_for(process_path)
	if(!(process_path in deferred_setup_list))
		deferred_setup_list.Add(process_path)

/datum/controller/master/proc/add_process(datum/process/process)
	var/start_time = world.timeofday
	// Reports that we're initialising a process.
	to_world(SPAN_DANGER("Initialising [process.name] process."))

	processes.Add(process)
	process.idle()
	idle.Add(process)

	// Inits recordkeeping vars.
	last_start.Add(process)
	last_start[process] = 0
	last_run_time.Add(process)
	last_run_time[process] = 0
	last_twenty_run_times.Add(process)
	last_twenty_run_times[process] = list()
	highest_run_time.Add(process)
	highest_run_time[process] = 0

	// Inits starts and stops record starts.
	record_start(process, 0)
	record_end(process, 0)

	// Sets up the process.
	process.setup()

	// Saves the process in the type -> instance map.
	processes_by_type[process.type] = process

	// Waits until setup is done.
	WAIT_FOR_BACKLOG

	// Reports successful initialisation.
	to_world(SPAN_DANGER("↪ Processing every [process.schedule_interval / 10] second\s."))
	to_world(SPAN_DANGER("↪ Initialised in [(world.timeofday - start_time) / 10] second\s."))

/datum/controller/master/proc/replace_process(datum/process/oldProcess, datum/process/newProcess)
	processes.Remove(oldProcess)
	processes.Add(newProcess)

	newProcess.idle()
	idle.Remove(oldProcess)
	running.Remove(oldProcess)
	queued.Remove(oldProcess)
	idle.Add(newProcess)

	last_start.Remove(oldProcess)
	last_start.Add(newProcess)
	last_start[newProcess] = 0

	last_run_time.Add(newProcess)
	last_run_time[newProcess] = last_run_time[oldProcess]
	last_run_time.Remove(oldProcess)

	last_twenty_run_times.Add(newProcess)
	last_twenty_run_times[newProcess] = last_twenty_run_times[oldProcess]
	last_twenty_run_times.Remove(oldProcess)

	highest_run_time.Add(newProcess)
	highest_run_time[newProcess] = highest_run_time[oldProcess]
	highest_run_time.Remove(oldProcess)

	record_start(newProcess, 0)
	record_end(newProcess, 0)

	processes_by_type[newProcess.type] = newProcess

/datum/controller/master/proc/queue_processes()
	for_no_type_check(var/datum/process/p, processes)
		// Doesn't double-queue or queue running processes
		if(p.disabled || p.running || p.queued || !p.idle)
			continue

		// If the process should be running by now, goes ahead and queues it
		if(world.time >= last_queued[p] + p.schedule_interval)
			set_queued_process_state(p)

/datum/controller/master/proc/run_queued_processes()
	for_no_type_check(var/datum/process/p, queued)
		spawn(0)
			p.process()

/datum/controller/master/proc/enable_process(process_type)
	if(isnotnull(processes_by_type[process_type]))
		var/datum/process/process = processes_by_type[process_type]
		process.enable()

/datum/controller/master/proc/disable_process(process_type)
	if(isnotnull(processes_by_type[process_type]))
		var/datum/process/process = processes_by_type[process_type]
		process.disable()

/datum/controller/master/proc/restart_process(process_type)
	if(isnotnull(processes_by_type[process_type]))
		var/datum/process/oldInstance = processes_by_type[process_type]
		var/datum/process/newInstance = new process_type(src)
		newInstance._copy_state_from(oldInstance)
		replace_process(oldInstance, newInstance)
		oldInstance.kill()

/datum/controller/master/proc/check_running_processes()
	for_no_type_check(var/datum/process/p, running)
		p.update()

		if(isnull(p)) // Process was killed
			continue

		var/status = p.get_status()
		var/previousStatus = p.get_previous_status()

		// Check status changes
		if(status != previousStatus)
			//Status changed.
			switch(status)
				if(PROCESS_STATUS_PROBABLY_HUNG)
					message_admins("Process '[p.name]' may be hung.")
				if(PROCESS_STATUS_HUNG)
					message_admins("Process '[p.name]' is hung and will be restarted.")

/*
 * Process State
 */
/datum/controller/master/proc/process_started(datum/process/process)
	set_running_process_state(process)
	record_start(process)

/datum/controller/master/proc/process_finished(datum/process/process)
	set_idle_process_state(process)
	record_end(process)

/datum/controller/master/proc/set_idle_process_state(datum/process/process)
	if(process in running)
		running.Remove(process)
	if(process in queued)
		queued.Remove(process)
	if(!(process in idle))
		idle.Add(process)

/datum/controller/master/proc/set_queued_process_state(datum/process/process)
	if(process in running)
		running.Remove(process)
	if(process in idle)
		idle.Remove(process)
	if(!(process in queued))
		queued.Add(process)

	// The other state transitions are handled internally by the process.
	process.queued()

/datum/controller/master/proc/set_running_process_state(datum/process/process)
	if(process in queued)
		queued.Remove(process)
	if(process in idle)
		idle.Remove(process)
	if(!(process in running))
		running.Add(process)

/*
 * Process Profiling
 */
/datum/controller/master/proc/record_start(datum/process/process, time = null)
	if(isnull(time))
		time = TimeOfGame
		last_queued[process] = world.time
		last_start[process] = time
	else
		last_queued[process] = (time == 0 ? 0 : world.time)
		last_start[process] = time

/datum/controller/master/proc/record_end(datum/process/process, time = null)
	if(isnull(time))
		time = TimeOfGame

	var/lastRunTime = time - last_start[process]

	if(lastRunTime < 0)
		lastRunTime = 0

	record_run_time(process, lastRunTime)

/*
 * record_run_time()
 * Records a run time for a process.
 */
/datum/controller/master/proc/record_run_time(datum/process/process, time)
	last_run_time[process] = time
	if(time > highest_run_time[process])
		highest_run_time[process] = time

	var/list/lastTwenty = last_twenty_run_times[process]
	if(length(lastTwenty) == 20)
		lastTwenty.Cut(1, 2)
	lastTwenty.len++
	lastTwenty[length(lastTwenty)] = time

/*
 * average_run_time()
 * Returns the average run time (over the last 20) of the process.
 */
/datum/controller/master/proc/average_run_time(datum/process/process)
	var/lastTwenty = last_twenty_run_times[process]

	var/t = 0
	var/c = 0
	for(var/time in lastTwenty)
		t += time
		c++

	if(c > 0)
		return t / c
	return c