/*
 * Turf Process
 */
GLOBAL_GLOBL_LIST_NEW(turf/processing_turfs)

PROCESS_DEF(turf)
	name = "Turf"
	schedule_interval = 3 SECONDS

/datum/process/turf/do_work()
	for_no_type_check(var/turf/T, GLOBL.processing_turfs)
		if(!GC_DESTROYED(T))
			try
				if(T.process() == PROCESS_KILL)
					GLOBL.processing_turfs.Remove(T)
					continue
			catch(var/exception/e)
				catch_exception(e, T)
			SCHECK
		else
			catch_bad_type(T)
			GLOBL.processing_turfs.Remove(T)

/datum/process/turf/stat_entry()
	return list("[length(GLOBL.processing_turfs)] turf\s")