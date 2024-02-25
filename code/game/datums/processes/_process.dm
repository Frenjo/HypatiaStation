/*
 * Base Process Datum
 */
/datum/process
	// Reference to the master controller.
	var/tmp/datum/controller/master/master
	// The clickable stat() panel button object.
	var/atom/movable/clickable_stat/stat_click = null

	/*
	 * Configuration
	 */
	// The name of the process.
	var/name = "process"

	// Process schedule interval.
	// This controls how often the process would run under ideal conditions.
	// If the master controller sees that the process has finished, it will wait until...
	// ... this amount of time has elapsed from the start of the previous run to start the...
	// ... process running again.
	var/tmp/schedule_interval = PROCESS_DEFAULT_SCHEDULE_INTERVAL

	// Process sleep interval.
	// This controls how often the process will yield (call sleep(0)) while it is running.
	// Every concurrent process should sleep periodically while running in order to allow other...
	// ... processes to execute concurrently.
	var/tmp/sleep_interval

	// After this much time, in deciseconds, the server will begin to show "maybe hung" in the context window.
	var/tmp/hang_warning_time = PROCESS_DEFAULT_HANG_WARNING_TIME

	// After this much time, in deciseconds, the server will send an admin debug message saying the process may be hung.
	var/tmp/hang_alert_time = PROCESS_DEFAULT_HANG_ALERT_TIME

	// After this much time, in deciseconds, the server will automatically kill and restart the process.
	var/tmp/hang_restart_time = PROCESS_DEFAULT_HANG_RESTART_TIME

	// How many times in the current run has the process deferred work till the next tick?
	var/tmp/cpu_defer_count = 0

	// How many SCHECKs have been skipped to limit btime calls.
	var/tmp/calls_since_last_scheck = 0

	/*
	 * State
	 */
	// TRUE if the process is not running or queued.
	var/tmp/idle = TRUE

	// Whether the process is queued.
	var/tmp/queued = FALSE

	// Whether the process is running.
	var/tmp/running = FALSE

	// Whether the process is blocked up.
	var/tmp/hung = FALSE

	// Whether the process has been killed.
	var/tmp/killed = FALSE

	// Whether the process is disabled.
	var/tmp/disabled = FALSE

	// Status text.
	var/tmp/status
	// Previous status text.
	var/tmp/previous_status

	/*
	 * Tick Data
	 */
	// Tick count.
	var/tmp/ticks = 0

	var/tmp/last_task = ""

	var/tmp/last_object

	// Counts the number of times an exception has occurred.
	// Gets reset after 10.
	var/tmp/list/exceptions = list()

	// Number of deciseconds to delay before starting the process.
	var/start_delay = 0

	/*
	 * Recordkeeping
	 */
	// Records the time (1/10s timeoftick) at which the process last finished sleeping.
	var/tmp/last_slept = 0

	// Records the time (1/10s timeofgame) at which the process last began running.
	var/tmp/run_start = 0

	// Records the number of times this process has been killed and restarted.
	var/tmp/times_killed

/datum/process/New(datum/controller/master/master)
	. = ..()
	src.master = master
	previous_status = "idle"
	idle()
	sleep_interval = world.tick_lag / PROCESS_DEFAULT_SLEEP_INTERVAL
	last_slept = 0
	run_start = 0
	ticks = 0
	last_task = 0
	last_object = null

	stat_click = new /atom/movable/clickable_stat(null, src)

/datum/process/Destroy()
	master = null
	qdel(stat_click)
	return ..()

/datum/process/proc/started()
	// Initialize run_start so we can detect hung processes.
	run_start = TimeOfGame

	// Initialize defer count
	cpu_defer_count = 0

	running()
	master.process_started(src)

	on_start()

/datum/process/proc/finished()
	ticks++
	idle()
	master.process_finished(src)

	on_finish()

/datum/process/proc/setup()
	return

/datum/process/proc/do_work()
	return

/datum/process/proc/process()
	started()
	do_work()
	finished()

/datum/process/proc/running()
	idle = FALSE
	queued = FALSE
	running = TRUE
	hung = FALSE
	set_status(PROCESS_STATUS_RUNNING)

/datum/process/proc/idle()
	queued = FALSE
	running = FALSE
	idle = TRUE
	hung = FALSE
	set_status(PROCESS_STATUS_IDLE)

/datum/process/proc/queued()
	idle = FALSE
	running = FALSE
	queued = TRUE
	hung = FALSE
	set_status(PROCESS_STATUS_QUEUED)

/datum/process/proc/hung()
	hung = TRUE
	set_status(PROCESS_STATUS_HUNG)

/datum/process/proc/handle_hung()
	var/datum/lastObj = last_object
	var/lastObjType = "null"
	if(istype(lastObj))
		lastObjType = lastObj.type

	var/msg = "[name] process hung at tick #[ticks]. Process was unresponsive for [(TimeOfGame - run_start) / 10] seconds and was restarted. Last task: [last_task]. Last Object Type: [lastObjType]"
	log_debug(msg)
	message_admins(msg)

	master.restart_process(name)

/datum/process/proc/kill()
	if(!killed)
		var/msg = "[name] process was killed at tick #[ticks]."
		log_debug(msg)
		message_admins(msg)
		//finished()

		// Allow inheritors to clean up if needed
		on_kill()

		// This should del
		del(src)

// Do not call this directly - use SHECK or SCHECK_EVERY
/datum/process/proc/sleep_check(tickId = 0)
	calls_since_last_scheck = 0
	if(killed)
		// The kill proc is the only place where killed is set.
		// The kill proc should have deleted this datum, and all sleeping procs that are
		// owned by it.
		CRASH("A killed process is still running somehow...")

	if(hung)
		// This will only really help if the doWork proc ends up in an infinite loop.
		handle_hung()
		CRASH("Process [name] hung and was restarted.")

	if(master.get_current_tick_elapsed_time() > master.time_allowance)
		sleep(world.tick_lag)
		cpu_defer_count++
		last_slept = 0
	else
		if(TimeOfTick > last_slept + sleep_interval)
			// If we haven't slept in sleep_interval deciseconds, sleep to allow other work to proceed.
			sleep(0)
			last_slept = TimeOfTick

/datum/process/proc/update()
	// Clear delta
	if(previous_status != status)
		set_status(status)

	var/elapsedTime = get_elapsed_time()

	if(hung)
		handle_hung()
		return
	else if(elapsedTime > hang_restart_time)
		hung()
	else if(elapsedTime > hang_alert_time)
		set_status(PROCESS_STATUS_PROBABLY_HUNG)
	else if(elapsedTime > hang_warning_time)
		set_status(PROCESS_STATUS_MAYBE_HUNG)

/datum/process/proc/get_elapsed_time()
	return TimeOfGame - run_start

/datum/process/proc/get_context()
	return "<tr><td>[name]</td><td>[master.average_run_time(src)]</td><td>[master.last_run_time[src]]</td><td>[master.highest_run_time[src]]</td><td>[ticks]</td></tr>\n"

/datum/process/proc/get_context_data()
	return list(
		"name" = name,
		"averageRunTime" = master.average_run_time(src),
		"lastRunTime" = master.last_run_time[src],
		"highestRunTime" = master.highest_run_time[src],
		"ticks" = ticks,
		"schedule" = schedule_interval,
		"status" = get_status_text(),
		"disabled" = disabled
	)

/datum/process/proc/get_status()
	return status

/datum/process/proc/get_status_text(s = null)
	if(isnull(s))
		s = status
	switch(s)
		if(PROCESS_STATUS_IDLE)
			return "idle"
		if(PROCESS_STATUS_QUEUED)
			return "queued"
		if(PROCESS_STATUS_RUNNING)
			return "running"
		if(PROCESS_STATUS_MAYBE_HUNG)
			return "maybe hung"
		if(PROCESS_STATUS_PROBABLY_HUNG)
			return "probably hung"
		if(PROCESS_STATUS_HUNG)
			return "HUNG"
		else
			return "UNKNOWN"

/datum/process/proc/get_previous_status()
	return previous_status

/datum/process/proc/get_previous_status_text()
	return get_status_text(previous_status)

/datum/process/proc/set_status(newStatus)
	previous_status = status
	status = newStatus

/datum/process/proc/set_last_task(task, object)
	last_task = task
	last_object = object

/datum/process/proc/_copy_state_from(datum/process/target)
	master = target.master
	name = target.name
	schedule_interval = target.schedule_interval
	sleep_interval = target.sleep_interval
	last_slept = 0
	run_start = 0
	times_killed = target.times_killed
	ticks = target.ticks
	last_task = target.last_task
	last_object = target.last_object
	copy_state_from(target)

/datum/process/proc/copy_state_from(datum/process/target)
	return

/datum/process/proc/on_kill()
	return

/datum/process/proc/on_start()
	return

/datum/process/proc/on_finish()
	return

/datum/process/proc/disable()
	disabled = TRUE

/datum/process/proc/enable()
	disabled = FALSE

/datum/process/proc/stat_process()
	SHOULD_NOT_OVERRIDE(TRUE)

	var/average_run_time = round(master.average_run_time(src), 0.1) / 10
	var/last_run_time = round(master.last_run_time[src], 0.1) / 10
	var/highest_run_time = round(master.highest_run_time[src], 0.1) / 10
	var/list/stats = list("T#[ticks] | AR [average_run_time] | LR [last_run_time] | HR [highest_run_time] | D [cpu_defer_count]")
	stats.Add(stat_entry())
	stat_click.name = jointext(stats, "\n")
	stat(name, stat_click)

/datum/process/proc/stat_entry()
	RETURN_TYPE(/list)

/datum/process/proc/catch_exception(exception/e, thrower)
	if(istype(e)) // Real runtimes go to the real error handler
		// There are two newlines here, because handling desc sucks
		e.desc = "  Caught by process: [name]\n\n" + e.desc
		world.Error(e, thrower)
		return

	var/etext = "[e]"
	var/eid = "[e]" // Exception ID, for tracking repeated exceptions
	var/ptext = "" // "processing..." text, for what was being processed (if known)
	if(istype(e))
		etext += " in [e.file], line [e.line]"
		eid = "[e.file]:[e.line]"
	if(eid in exceptions)
		if(exceptions[eid]++ >= 10)
			return
	else
		exceptions[eid] = 1
	if(isdatum(thrower))
		var/datum/D = thrower
		ptext = " processing [D.type]"
		if(isatom(thrower))
			var/atom/A = thrower
			ptext += " ([A]) ([A.x],[A.y],[A.z])"
	log_to_dd("\[[time_stamp()]\] Process [name] caught exception[ptext]: [etext]")
	if(exceptions[eid] >= 10)
		log_to_dd("This exception will now be ignored for ten minutes.")
		spawn(6000)
			exceptions[eid] = 0

/datum/process/proc/catch_bad_type(datum/caught)
	if(isnull(caught) || !istype(caught) || GC_DESTROYED(caught))
		return // Only bother with types we can identify and that don't belong
	catch_exception("Type [caught.type] does not belong in process' queue")