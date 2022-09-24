/var/global/machinery_sort_required = FALSE

/var/global/list/machines = list()
/var/global/list/processing_power_items = list()
/var/global/list/powernets = list()

/datum/process/machinery
	name = "Machinery"
	schedule_interval = 2 SECONDS
	start_delay = 12

/datum/process/machinery/doWork()
	internal_sort()
	internal_process_machinery()
	internal_process_powernets()

/datum/process/machinery/proc/internal_sort()
	if(global.machinery_sort_required)
		global.machinery_sort_required = FALSE
		global.machines = dd_sortedObjectList(global.machines)

/datum/process/machinery/proc/internal_process_machinery()
	for(var/obj/machinery/M in global.machines)
		if(M && !M.gcDestroyed)
			if(M.process() == PROCESS_KILL)
				global.machines.Remove(M)
				continue

			if(M && M.use_power)
				M.auto_use_power()

		SCHECK

/datum/process/machinery/proc/internal_process_powernets()
	for(var/datum/powernet/powerNetwork in global.powernets)
		if(istype(powerNetwork) && isnull(powerNetwork.gcDestroyed))
			powerNetwork.reset()
			SCHECK
			continue

		global.powernets.Remove(powerNetwork)

	// This is necessary to ensure powersinks are always the first devices that drain power from powernet.
	// Otherwise APCs or other stuff go first, resulting in bad things happening.
	// Currently only used by powersinks. These items get priority processed before machinery
	for(var/obj/item/I in global.processing_power_items)
		if(!I.pwr_drain()) // 0 = Process Kill, remove from processing list.
			global.processing_power_items.Remove(I)
		SCHECK

/datum/process/machinery/statProcess()
	..()
	stat(null, "[global.machines.len] machines")
	stat(null, "[global.powernets.len] powernets")
	stat(null, "[global.processing_power_items.len] power item\s")