/*
 * Pipe Network Process
 */
PROCESS_DEF(pipenet)
	name = "PipeNet"
	schedule_interval = 2 SECONDS

	var/processing_killed = FALSE

	var/static/list/datum/pipe_network/processing_list = list()

/datum/process/pipenet/do_work()
	if(processing_killed)
		return

	for_no_type_check(var/datum/pipe_network/pipenet, processing_list)
		if(!GC_DESTROYED(pipenet))
			try
				pipenet.process()
			catch(var/exception/e)
				catch_exception(e, pipenet)
			SCHECK
		else
			catch_bad_type(pipenet)
			processing_list.Remove(pipenet)

/datum/process/pipenet/stat_entry()
	return list("[length(processing_list)] pipenets")