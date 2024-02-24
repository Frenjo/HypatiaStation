/*
 * Machinery Process
 */
GLOBAL_GLOBL_INIT(machinery_sort_required, FALSE)

GLOBAL_GLOBL_LIST_NEW(obj/machinery/machines)
GLOBAL_GLOBL_LIST_NEW(obj/item/processing_power_items)
GLOBAL_GLOBL_LIST_NEW(datum/powernet/powernets)

PROCESS_DEF(machinery)
	name = "Machinery"
	schedule_interval = 2 SECONDS
	start_delay = 12

/datum/process/machinery/do_work()
	internal_sort()
	internal_process_machinery()
	internal_process_powernets()

/datum/process/machinery/proc/internal_sort()
	if(GLOBL.machinery_sort_required)
		GLOBL.machinery_sort_required = FALSE
		GLOBL.machines = dd_sortedObjectList(GLOBL.machines)

/datum/process/machinery/proc/internal_process_machinery()
	for_no_type_check(var/obj/machinery/M, GLOBL.machines)
		if(!GC_DESTROYED(M))
			if(M.process() == PROCESS_KILL)
				GLOBL.machines.Remove(M)
				continue

			if(M?.power_state)
				M.auto_use_power()

		SCHECK

/datum/process/machinery/proc/internal_process_powernets()
	for_no_type_check(var/datum/powernet/powernet, GLOBL.powernets)
		if(!GC_DESTROYED(powernet))
			try
				powernet.reset()
			catch(var/exception/e)
				catch_exception(e, powernet)
			SCHECK
		else
			catch_bad_type(powernet)
			GLOBL.powernets.Remove(powernet)

	// This is necessary to ensure powersinks are always the first devices that drain power from powernet.
	// Otherwise APCs or other stuff go first, resulting in bad things happening.
	// Currently only used by powersinks. These items get priority processed before machinery
	for_no_type_check(var/obj/item/I, GLOBL.processing_power_items)
		if(!I.pwr_drain()) // 0 = Process Kill, remove from processing list.
			GLOBL.processing_power_items.Remove(I)
		SCHECK

/datum/process/machinery/stat_entry()
	return list(
		"[length(GLOBL.machines)] machines",
		"[length(GLOBL.powernets)] powernets",
		"[length(GLOBL.processing_power_items)] power item\s"
	)