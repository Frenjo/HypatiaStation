/*
 * Disease Process
 */
GLOBAL_GLOBL_LIST_NEW(datum/disease/active_diseases)

PROCESS_DEF(disease)
	name = "Disease"
	schedule_interval = 2 SECONDS

/datum/process/disease/do_work()
	for_no_type_check(var/datum/disease/D, GLOBL.active_diseases)
		if(!GC_DESTROYED(D))
			try
				D.process()
			catch(var/exception/e)
				catch_exception(e, D)
			SCHECK
		else
			catch_bad_type(D)
			GLOBL.active_diseases.Remove(D)

/datum/process/disease/stat_entry()
	return list("[length(GLOBL.active_diseases)] disease\s")