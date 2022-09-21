/datum/process/pipenet
	name = "PipeNet"
	schedule_interval = 2 SECONDS

/datum/process/pipenet/doWork()
	for(var/datum/pipe_network/pipeNetwork in global.pipe_networks)
		if(istype(pipeNetwork) && isnull(pipeNetwork.gcDestroyed))
			pipeNetwork.process()
			SCHECK
			continue

		global.pipe_networks.Remove(pipeNetwork)

/datum/process/pipenet/statProcess()
	..()
	stat(null, "[global.pipe_networks.len] pipenets")