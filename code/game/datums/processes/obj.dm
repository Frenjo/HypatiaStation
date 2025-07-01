/*
 * Object Process
 */
PROCESS_DEF(obj)
	name = "Obj"
	schedule_interval = 2 SECONDS
	start_delay = 8

	var/list/obj/processing_list = list()

/datum/process/obj/do_work()
	for_no_type_check(var/obj/O, processing_list)
		if(!GC_DESTROYED(O))
			try
				if(O.process() == PROCESS_KILL)
					processing_list.Remove(O)
					continue
			catch(var/exception/e)
				catch_exception(e, O)
			SCHECK
		else
			catch_bad_type(O)
			processing_list.Remove(O)

/datum/process/obj/stat_entry()
	return list("[length(processing_list)] object\s")