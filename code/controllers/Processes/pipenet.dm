/datum/controller/process/pipenet/setup()
	name = "pipenet"
	schedule_interval = 2 SECONDS

/datum/controller/process/pipenet/doWork()
	for(var/datum/pipe_network/pipeNetwork in pipe_networks)
		if(istype(pipeNetwork) && isnull(pipeNetwork.gcDestroyed))
			pipeNetwork.process()
			SCHECK
			continue

		pipe_networks.Remove(pipeNetwork)

/datum/controller/process/pipenet/statProcess()
	..()
	stat(null, "[pipe_networks.len] pipenets")