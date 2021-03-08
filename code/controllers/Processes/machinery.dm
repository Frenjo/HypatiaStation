/datum/controller/process/machinery/setup()
	name = "machinery"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/machinery/doWork()
	//internal_process_pipenets()
	internal_process_machinery()
	internal_process_powernets()

/datum/controller/process/machinery/proc/internal_process_pipenets()
	for(var/datum/pipe_network/pipeNetwork in pipe_networks)
		if(istype(pipeNetwork) && !pipeNetwork.disposed)
			pipeNetwork.process()
			scheck()
			continue

		pipe_networks.Remove(pipeNetwork)

/datum/controller/process/machinery/proc/internal_process_machinery()
	for(var/obj/machinery/M in machines)
		if(M && !M.gcDestroyed)
			#ifdef PROFILE_MACHINES
			var/time_start = world.timeofday
			#endif

			if(M.process() == PROCESS_KILL)
				//M.inMachineList = 0 We don't use this debugging function
				machines.Remove(M)
				continue

			if(M && M.use_power)
				M.auto_use_power()

			#ifdef PROFILE_MACHINES
			var/time_end = world.timeofday

			if(!(M.type in machine_profiling))
				machine_profiling[M.type] = 0

			machine_profiling[M.type] += (time_end - time_start)
			#endif

		scheck()

/datum/controller/process/machinery/proc/internal_process_powernets()
	for(var/datum/powernet/powerNetwork in powernets)
		if(istype(powerNetwork) && !powerNetwork.disposed)
			powerNetwork.reset()
			scheck()
			continue

		powernets.Remove(powerNetwork)