/*
README:

The global_iterator datum is supposed to provide a simple and robust way to
create some constantly "looping" processes with ability to stop and restart them at will.
Generally, the only thing you want to play with (meaning, redefine) is the process() proc.
It must contain all the things you want done.

Control functions:
	new - used to create datum. First argument (optional) - var list(to use in process() proc) as list,
	second (optional) - autostart control.
	If autostart == TRUE, the loop will be started immediately after datum creation.

	start(list/arguments) - starts the loop. Takes arguments(optional) as a list, which is then used
	by process() proc. Returns null if datum already active, 1 if loop started succesfully and 0 if there's
	an error in supplied arguments (not list or empty list).

	stop() - stops the loop. Returns null if datum is already inactive and 1 on success.

	set_delay(new_delay) - sets the delay between iterations. Pretty selfexplanatory.
	Returns 0 on error(new_delay is not numerical), 1 otherwise.

	set_process_args(list/arguments) - passes the supplied arguments to the process() proc.

	active() - Returns 1 if datum is active, 0 otherwise.

	toggle() - toggles datum state. Returns new datum state (see active()).

Misc functions:

	get_last_exec_time() - Returns the time of last iteration.

	get_last_exec_time_as_text() - Returns the time of last iteration as text


Control vars:

	delay - 	delay between iterations

	check_for_null - if equals TRUE, on each iteration the supplied arguments will be checked for nulls.
	If some varible equals null (and null only), the loop is stopped.
	Usefull, if some var unexpectedly becomes null - due to object deletion, for example.
	Of course, you can also check the variables inside process() proc to prevent runtime errors.

Data storage vars:

	result - stores the value returned by process() proc
*/
/datum/global_iterator
	var/control_switch = 0
	var/delay = 1 SECOND
	var/list/arg_list = null
	var/last_exec = null
	var/check_for_null = TRUE
	var/result
	var/state = 0

/datum/global_iterator/New(list/arguments = null, autostart = TRUE)
	. = ..()
	arg_list = list()
	delay = delay > 0 ? delay : 1
	set_process_args(arguments)
	if(autostart)
		start()

/datum/global_iterator/Destroy()
	LAZYCLEARLIST(arg_list)
	stop()
	return ..()

/datum/global_iterator/proc/main()
	state = 1
	while(src && control_switch)
		last_exec = world.timeofday
		if(check_for_null && has_null_args())
			stop()
			return 0
		result = process(arglist(arg_list))
		for(var/sleep_time = delay; sleep_time > 0; sleep_time--) //uhh, this is ugly. But I see no other way to terminate sleeping proc. Such disgrace.
			if(!control_switch)
				return 0
			sleep(1)
	return 0

/datum/global_iterator/proc/start(list/arguments = null)
	if(active())
		return
	if(arguments)
		if(!set_process_args(arguments))
			return 0
	if(!state_check()) //the main loop is sleeping, wait for it to terminate.
		return
	control_switch = 1
	spawn()
		state = main()
	return 1

/datum/global_iterator/proc/stop()
	if(!active())
		return
	control_switch = 0
	spawn(-1) //report termination error but don't wait for state_check().
		state_check()
	return 1

/datum/global_iterator/proc/state_check()
	var/lag = 0
	while(state)
		sleep(1)
		if(++lag > 10)
			CRASH("The global_iterator loop \ref[src] failed to terminate in designated timeframe. This may be caused by server lagging.")
	return 1

/datum/global_iterator/proc/process()
	return

/datum/global_iterator/proc/active()
	return control_switch

/datum/global_iterator/proc/has_null_args()
	if(null in arg_list)
		return 1
	return 0

/datum/global_iterator/proc/set_delay(new_delay)
	if(isnum(new_delay))
		delay = max(1, round(new_delay))
		return 1
	else
		return 0

/datum/global_iterator/proc/get_last_exec_time()
	return (last_exec||0)

/datum/global_iterator/proc/get_last_exec_time_as_text()
	return (time2text(last_exec)||"Wasn't executed yet")

/datum/global_iterator/proc/set_process_args(list/arguments)
	if(islist(arguments) && length(arguments))
		arg_list = arguments
		return 1
	else
		//to_world("\red Invalid arguments supplied for [src.type], ref = \ref[src]")
		return 0

/datum/global_iterator/proc/toggle_null_checks()
	check_for_null = !check_for_null
	return check_for_null

/datum/global_iterator/proc/toggle()
	if(!stop())
		start()
	return active()