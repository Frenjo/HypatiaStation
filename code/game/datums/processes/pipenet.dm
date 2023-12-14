/*
 * Pipe Network Process
 */
GLOBAL_GLOBL_LIST_NEW(pipe_networks)

PROCESS_DEF(pipenet)
	name = "PipeNet"
	schedule_interval = 2 SECONDS

	var/processing_killed = FALSE

/datum/process/pipenet/do_work()
	if(processing_killed)
		return

	for(var/datum/pipe_network/pipeNetwork in GLOBL.pipe_networks)
		if(!GC_DESTROYED(pipeNetwork))
			pipeNetwork.process()
			SCHECK
			continue

		GLOBL.pipe_networks.Remove(pipeNetwork)

/datum/process/pipenet/stat_entry()
	return list("[length(GLOBL.pipe_networks)] pipenets")