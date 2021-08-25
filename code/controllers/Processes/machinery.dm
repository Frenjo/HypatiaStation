/var/global/machinery_sort_required = 0

/datum/controller/process/machinery/setup()
	name = "machinery"
	schedule_interval = 2 SECONDS
	start_delay = 12

/datum/controller/process/machinery/doWork()
	internal_sort()
	internal_process_pipenets()
	internal_process_machinery()
	internal_process_powernets()

/datum/controller/process/machinery/proc/internal_sort()
	if(machinery_sort_required)
		machinery_sort_required = 0
		machines = dd_sortedObjectList(machines)

/datum/controller/process/machinery/proc/internal_process_pipenets()
	for(var/datum/pipe_network/pipeNetwork in pipe_networks)
		if(istype(pipeNetwork) && !isnull(pipeNetwork.gcDestroyed))
			pipeNetwork.process()
			SCHECK
			continue

		pipe_networks.Remove(pipeNetwork)

/datum/controller/process/machinery/proc/internal_process_machinery()
	for(var/obj/machinery/M in machines)
		if(M && !M.gcDestroyed)
			if(M.process() == PROCESS_KILL)
				machines.Remove(M)
				continue

			if(M && M.use_power)
				M.auto_use_power()

		SCHECK

/datum/controller/process/machinery/proc/internal_process_powernets()
	for(var/datum/powernet/powerNetwork in powernets)
		if(istype(powerNetwork) && isnull(powerNetwork.gcDestroyed))
			powerNetwork.reset()
			SCHECK
			continue

		powernets.Remove(powerNetwork)

	// This is necessary to ensure powersinks are always the first devices that drain power from powernet.
	// Otherwise APCs or other stuff go first, resulting in bad things happening.
	// Currently only used by powersinks. These items get priority processed before machinery
	for(var/obj/item/I in processing_power_items)
		if(!I.pwr_drain()) // 0 = Process Kill, remove from processing list.
			processing_power_items.Remove(I)
		SCHECK

/datum/controller/process/machinery/statProcess()
	..()
	stat(null, "[machines.len] machines")
	stat(null, "[powernets.len] powernets")
	stat(null, "[pipe_networks.len] pipenets")
	stat(null, "[processing_power_items.len] power item\s")