/*
 * Machinery Process
 */
GLOBAL_GLOBL_INIT(machinery_sort_required, FALSE)

GLOBAL_GLOBL_LIST_NEW(machines)
GLOBAL_GLOBL_LIST_NEW(processing_power_items)
GLOBAL_GLOBL_LIST_NEW(powernets)

PROCESS_DEF(machinery)
	name = "Machinery"
	schedule_interval = 2 SECONDS
	start_delay = 12

/datum/process/machinery/doWork()
	internal_sort()
	internal_process_machinery()
	internal_process_powernets()

/datum/process/machinery/proc/internal_sort()
	if(GLOBL.machinery_sort_required)
		GLOBL.machinery_sort_required = FALSE
		GLOBL.machines = dd_sortedObjectList(GLOBL.machines)

/datum/process/machinery/proc/internal_process_machinery()
	for(var/obj/machinery/M in GLOBL.machines)
		if(M && !GC_DESTROYED(M))
			if(M.process() == PROCESS_KILL)
				GLOBL.machines.Remove(M)
				continue

			if(M && M.use_power)
				M.auto_use_power()

		SCHECK

/datum/process/machinery/proc/internal_process_powernets()
	for(var/datum/powernet/powerNetwork in GLOBL.powernets)
		if(istype(powerNetwork) && !GC_DESTROYED(powerNetwork))
			powerNetwork.reset()
			SCHECK
			continue

		GLOBL.powernets.Remove(powerNetwork)

	// This is necessary to ensure powersinks are always the first devices that drain power from powernet.
	// Otherwise APCs or other stuff go first, resulting in bad things happening.
	// Currently only used by powersinks. These items get priority processed before machinery
	for(var/obj/item/I in GLOBL.processing_power_items)
		if(!I.pwr_drain()) // 0 = Process Kill, remove from processing list.
			GLOBL.processing_power_items.Remove(I)
		SCHECK

/datum/process/machinery/statProcess()
	. = ..()
	stat(null, "[length(GLOBL.machines)] machines")
	stat(null, "[length(GLOBL.powernets)] powernets")
	stat(null, "[length(GLOBL.processing_power_items)] power item\s")