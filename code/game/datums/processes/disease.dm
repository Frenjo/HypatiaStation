/*
 * Disease Process
 */

PROCESS_DEF(disease)
	name = "Disease"
	schedule_interval = 2 SECONDS

	var/static/list/datum/disease/processing_list = list()

/datum/process/disease/do_work()
	for_no_type_check(var/datum/disease/D, processing_list)
		if(!GC_DESTROYED(D))
			try
				D.process()
			catch(var/exception/e)
				catch_exception(e, D)
			SCHECK
		else
			catch_bad_type(D)
			processing_list.Remove(D)

/datum/process/disease/stat_entry()
	return list("[length(processing_list)] disease\s")