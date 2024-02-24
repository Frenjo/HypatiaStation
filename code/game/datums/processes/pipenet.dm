/*
 * Pipe Network Process
 */
GLOBAL_GLOBL_LIST_NEW(datum/pipe_network/pipe_networks)

PROCESS_DEF(pipenet)
	name = "PipeNet"
	schedule_interval = 2 SECONDS

	var/processing_killed = FALSE

/datum/process/pipenet/do_work()
	if(processing_killed)
		return

	for_no_type_check(var/datum/pipe_network/pipenet, GLOBL.pipe_networks)
		if(!GC_DESTROYED(pipenet))
			try
				pipenet.process()
			catch(var/exception/e)
				catch_exception(e, pipenet)
			SCHECK
		else
			catch_bad_type(pipenet)
			GLOBL.pipe_networks.Remove(pipenet)

/datum/process/pipenet/stat_entry()
	return list("[length(GLOBL.pipe_networks)] pipenets")