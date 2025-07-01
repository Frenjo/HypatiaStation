/*
 * Turf Process
 */
PROCESS_DEF(turf)
	name = "Turf"
	schedule_interval = 3 SECONDS

	var/static/list/turf/processing_list = list()

/datum/process/turf/do_work()
	for_no_type_check(var/turf/T, processing_list)
		if(!GC_DESTROYED(T))
			try
				if(T.process() == PROCESS_KILL)
					processing_list.Remove(T)
					continue
			catch(var/exception/e)
				catch_exception(e, T)
			SCHECK
		else
			catch_bad_type(T)
			processing_list.Remove(T)

/datum/process/turf/stat_entry()
	return list("[length(processing_list)] turf\s")