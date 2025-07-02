/*
 * Machinery Process
 */
PROCESS_DEF(machinery)
	name = "Machinery"
	schedule_interval = 2 SECONDS
	start_delay = 12

	var/static/machinery_sort_required = FALSE

	var/static/list/obj/machinery/machines = list()
	var/static/list/machines_by_type = list()

	var/static/list/obj/item/processing_power_items = list()
	var/static/list/datum/powernet/powernets = list()

/datum/process/machinery/do_work()
	internal_sort()
	internal_process_machinery()
	internal_process_powernets()

/datum/process/machinery/proc/register_machine(obj/machinery/machine)
	LAZYADD(machines_by_type[machine.type], machine)
	if(machinery_sort_required)
		dd_insertObjectList(machines, machine)
	else
		machines.Add(machine)
		machinery_sort_required = TRUE

/datum/process/machinery/proc/unregister_machine(obj/machinery/machine)
	var/list/existing = machines_by_type[machine.type]
	existing.Remove(machine)
	if(!length(existing))
		machines_by_type.Remove(machine.type)
	machines.Remove(machine)

/datum/process/machinery/proc/get_machines_by_type(obj/machinery/machine_type)
	RETURN_TYPE(/list)

	if(!ispath(machine_type))
		machine_type = machine_type.type

	var/list/typed_machines = machines_by_type[machine_type]
	return typed_machines?.Copy() || list()

/datum/process/machinery/proc/get_machines_by_type_and_subtypes(obj/machinery/machine_type)
	RETURN_TYPE(/list)

	if(!ispath(machine_type))
		machine_type = machine_type.type

	. = list()
	for(var/next_type in typesof(machine_type))
		var/list/found_machines = machines_by_type[next_type]
		if(found_machines)
			. += found_machines

/datum/process/machinery/proc/internal_sort()
	if(machinery_sort_required)
		machines = dd_sortedObjectList(machines)
		machinery_sort_required = FALSE

/datum/process/machinery/proc/internal_process_machinery()
	for_no_type_check(var/obj/machinery/M, machines)
		if(!GC_DESTROYED(M))
			if(M.process() == PROCESS_KILL)
				machines.Remove(M)
				continue

			if(M?.power_state)
				M.auto_use_power()

		SCHECK

/datum/process/machinery/proc/internal_process_powernets()
	for_no_type_check(var/datum/powernet/powernet, powernets)
		if(!GC_DESTROYED(powernet))
			try
				powernet.reset()
			catch(var/exception/e)
				catch_exception(e, powernet)
			SCHECK
		else
			catch_bad_type(powernet)
			powernets.Remove(powernet)

	// This is necessary to ensure powersinks are always the first devices that drain power from powernet.
	// Otherwise APCs or other stuff go first, resulting in bad things happening.
	// Currently only used by powersinks. These items get priority processed before machinery
	for_no_type_check(var/obj/item/I, processing_power_items)
		if(!I.pwr_drain()) // 0 = Process Kill, remove from processing list.
			processing_power_items.Remove(I)
		SCHECK

/datum/process/machinery/stat_entry()
	return list(
		"[length(machines)] machines",
		"[length(powernets)] powernets",
		"[length(processing_power_items)] power item\s"
	)

// rebuild all power networks from scratch - only called at world creation or by the admin verb
/datum/process/machinery/proc/makepowernets()
	for_no_type_check(var/datum/powernet/power_network, powernets)
		qdel(power_network)
	powernets.Cut()

	for_no_type_check(var/obj/structure/cable/power_cable, GLOBL.cable_list)
		if(isnull(power_cable.powernet))
			var/datum/powernet/new_powernet = new /datum/powernet()
			new_powernet.add_cable(power_cable)
			propagate_network(power_cable, power_cable.powernet)
	return 1