GLOBAL_GLOBL_LIST_NEW(pipe_networks)

/datum/process/pipenet
	name = "PipeNet"
	schedule_interval = 2 SECONDS

/datum/process/pipenet/doWork()
	for(var/datum/pipe_network/pipeNetwork in GLOBL.pipe_networks)
		if(istype(pipeNetwork) && isnull(pipeNetwork.gcDestroyed))
			pipeNetwork.process()
			SCHECK
			continue

		GLOBL.pipe_networks.Remove(pipeNetwork)

/datum/process/pipenet/statProcess()
	..()
	stat(null, "[GLOBL.pipe_networks.len] pipenets")