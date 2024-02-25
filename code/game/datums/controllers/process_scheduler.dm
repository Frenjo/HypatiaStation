/*
 * Process Scheduler
 */
GLOBAL_BYOND_TYPED(process_scheduler, /datum/controller/process_scheduler) // Set in world/New()

// This should NOT use CONTROLLER_DEF.
/datum/controller/process_scheduler
	name = "Process Scheduler"

	// Processes known by the scheduler
	var/tmp/list/datum/process/processes = list()

	// Processes that are currently running
	var/tmp/list/datum/process/running = list()

	// Processes that are idle
	var/tmp/list/datum/process/idle = list()

	// Processes that are queued to run
	var/tmp/list/datum/process/queued = list()

	// Process name -> process object map
	// TODO: Probably update this to index by typepath instead of name.
	var/tmp/list/processes_by_name = list()

	// Process last queued times (world time)
	var/tmp/list/last_queued = list()

	// Process last start times (real time)
	var/tmp/list/last_start = list()

	// Process last run durations
	var/tmp/list/last_run_time = list()

	// Per process list of the last 20 durations
	var/tmp/list/last_twenty_run_times = list()

	// Process highest run time
	var/tmp/list/highest_run_time = list()

	// How long to sleep between runs (set to tick_lag in New)
	var/tmp/scheduler_sleep_interval

	// Controls whether the scheduler is running or not
	var/tmp/is_running = FALSE

	// Setup for these processes will be deferred until all the other processes are set up.
	var/tmp/list/deferred_setup_list = list()

	var/tmp/current_tick = 0

	var/tmp/time_allowance = 0

	var/tmp/cpu_average = 0

	var/tmp/time_allowance_max = 0

/datum/controller/process_scheduler/New()
	. = ..()
	// world.tick_lag is set by this point, so there's no need to reset these later.
	scheduler_sleep_interval = world.tick_lag
	time_allowance = world.tick_lag * 0.5
	time_allowance_max = world.tick_lag

/**
 * deferSetupFor
 * @param path processPath
 * If a process needs to be initialized after everything else, add it to
 * the deferred setup list. On goonstation, only the ticker needs to have
 * this treatment.
 */
/datum/controller/process_scheduler/proc/defer_setup_for(processPath)
	if(!(processPath in deferred_setup_list))
		deferred_setup_list.Add(processPath)

/datum/controller/process_scheduler/setup()
	// There can be only one
	if(isnotnull(global.process_scheduler) && (global.process_scheduler != src))
		del(src)
		return 0

	// Stores the time we started setting up processes.
	var/start_time = world.timeofday
	to_world(SPAN_DANGER("Initialising processes."))

	var/process
	// Add all the processes we can find, except those deferred until later.
	for(process in SUBTYPESOF(/datum/process))
		if(!(process in deferred_setup_list))
			add_process(new process(src))

	for(process in deferred_setup_list)
		add_process(new process(src))

	// Report how long full process initialisation took.
	to_world(SPAN_DANGER("Initialised all processes in [(world.timeofday - start_time) / 10] second\s."))

/datum/controller/process_scheduler/proc/start()
	is_running = TRUE
	update_start_delays()
	spawn(0)
		process()

/datum/controller/process_scheduler/process()
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

/datum/controller/process_scheduler/proc/stop()
	is_running = FALSE

/datum/controller/process_scheduler/proc/check_running_processes()
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

/datum/controller/process_scheduler/proc/queue_processes()
	for(var/datum/process/p in processes)
		// Don't double-queue, don't queue running processes
		if(p.disabled || p.running || p.queued || !p.idle)
			continue

		// If the process should be running by now, go ahead and queue it
		if(world.time >= last_queued[p] + p.schedule_interval)
			set_queued_process_state(p)

/datum/controller/process_scheduler/proc/run_queued_processes()
	for_no_type_check(var/datum/process/p, queued)
		run_process(p)

/datum/controller/process_scheduler/proc/add_process(datum/process/process)
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

	// Saves process in the name -> process map.
	processes_by_name[process.name] = process

	// Waits until setup is done.
	WAIT_FOR_BACKLOG

	// Reports successful initialisation.
	to_world(SPAN_DANGER("↪ Processing every [process.schedule_interval / 10] second\s."))
	to_world(SPAN_DANGER("↪ Initialised in [(world.timeofday - start_time) / 10] second\s."))

/datum/controller/process_scheduler/proc/replace_process(datum/process/oldProcess, datum/process/newProcess)
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

	processes_by_name[newProcess.name] = newProcess

/datum/controller/process_scheduler/proc/update_start_delays()
	for_no_type_check(var/datum/process/p, processes)
		if(p.start_delay)
			last_queued[p] = world.time - p.start_delay

/datum/controller/process_scheduler/proc/run_process(datum/process/process)
	spawn(0)
		process.process()

/datum/controller/process_scheduler/proc/process_started(datum/process/process)
	set_running_process_state(process)
	record_start(process)

/datum/controller/process_scheduler/proc/process_finished(datum/process/process)
	set_idle_process_state(process)
	record_end(process)

/datum/controller/process_scheduler/proc/set_idle_process_state(datum/process/process)
	if(process in running)
		running.Remove(process)
	if(process in queued)
		queued.Remove(process)
	if(!(process in idle))
		idle.Add(process)

/datum/controller/process_scheduler/proc/set_queued_process_state(datum/process/process)
	if(process in running)
		running.Remove(process)
	if(process in idle)
		idle.Remove(process)
	if(!(process in queued))
		queued.Add(process)

	// The other state transitions are handled internally by the process.
	process.queued()

/datum/controller/process_scheduler/proc/set_running_process_state(datum/process/process)
	if(process in queued)
		queued.Remove(process)
	if(process in idle)
		idle.Remove(process)
	if(!(process in running))
		running.Add(process)

/datum/controller/process_scheduler/proc/record_start(datum/process/process, time = null)
	if(isnull(time))
		time = TimeOfGame
		last_queued[process] = world.time
		last_start[process] = time
	else
		last_queued[process] = (time == 0 ? 0 : world.time)
		last_start[process] = time

/datum/controller/process_scheduler/proc/record_end(datum/process/process, time = null)
	if(isnull(time))
		time = TimeOfGame

	var/lastRunTime = time - last_start[process]

	if(lastRunTime < 0)
		lastRunTime = 0

	record_run_time(process, lastRunTime)

/**
 * recordRunTime
 * Records a run time for a process
 */
/datum/controller/process_scheduler/proc/record_run_time(datum/process/process, time)
	last_run_time[process] = time
	if(time > highest_run_time[process])
		highest_run_time[process] = time

	var/list/lastTwenty = last_twenty_run_times[process]
	if(length(lastTwenty) == 20)
		lastTwenty.Cut(1, 2)
	lastTwenty.len++
	lastTwenty[length(lastTwenty)] = time

/**
 * averageRunTime
 * returns the average run time (over the last 20) of the process
 */
/datum/controller/process_scheduler/proc/average_run_time(datum/process/process)
	var/lastTwenty = last_twenty_run_times[process]

	var/t = 0
	var/c = 0
	for(var/time in lastTwenty)
		t += time
		c++

	if(c > 0)
		return t / c
	return c

/datum/controller/process_scheduler/proc/get_process_last_run_time(datum/process/process)
	return last_run_time[process]

/datum/controller/process_scheduler/proc/get_process_highest_run_time(datum/process/process)
	return highest_run_time[process]

/datum/controller/process_scheduler/proc/get_status_data()
	var/list/data = list()

	for_no_type_check(var/datum/process/p, processes)
		data.len++
		data[length(data)] = p.get_context_data()

	return data

/datum/controller/process_scheduler/proc/get_process_count()
	return length(processes)

/datum/controller/process_scheduler/proc/has_process(processName as text)
	if(processes_by_name[processName])
		return 1

/datum/controller/process_scheduler/proc/kill_process(processName as text)
	restart_process(processName)

/datum/controller/process_scheduler/proc/restart_process(processName as text)
	if(has_process(processName))
		var/datum/process/oldInstance = processes_by_name[processName]
		var/datum/process/newInstance = new oldInstance.type(src)
		newInstance._copy_state_from(oldInstance)
		replace_process(oldInstance, newInstance)
		oldInstance.kill()

/datum/controller/process_scheduler/proc/enable_process(processName as text)
	if(has_process(processName))
		var/datum/process/process = processes_by_name[processName]
		process.enable()

/datum/controller/process_scheduler/proc/disable_process(processName as text)
	if(has_process(processName))
		var/datum/process/process = processes_by_name[processName]
		process.disable()

/datum/controller/process_scheduler/proc/get_current_tick_elapsed_time()
	if(world.time > current_tick)
		update_current_tick_data()
		return 0
	else
		return TimeOfTick

/datum/controller/process_scheduler/proc/update_current_tick_data()
	if(world.time > current_tick)
		// New tick!
		current_tick = world.time
		update_time_allowance()
		cpu_average = (world.cpu + cpu_average + cpu_average) / 3

/datum/controller/process_scheduler/proc/update_time_allowance()
	// Time allowance goes down linearly with world.cpu.
	var/error = cpu_average - 100
	var/time_allowance_delta = SIMPLE_SIGN(error) * -0.5 * world.tick_lag * max(0, 0.001 * abs(error))

	//timeAllowance = world.tick_lag * min(1, 0.5 * ((200/max(1,cpuAverage)) - 1))
	time_allowance = min(time_allowance_max, max(0, time_allowance + time_allowance_delta))

/datum/controller/process_scheduler/proc/stat_processes()
	if(!is_running)
		stat("Processes:", "Scheduler not running!")
		return
	stat("Processes:", "[length(processes)] (R [length(running)] / Q [length(queued)] / I [length(idle)])")
	stat(null, "[round(cpu_average, 0.1)] CPU, [round(time_allowance, 0.1) / 10] TA")
	for_no_type_check(var/datum/process/p, processes)
		p.stat_process()