/*
 * Disease Process
 */
GLOBAL_GLOBL_LIST_NEW(active_diseases)

PROCESS_DEF(disease)
	name = "Disease"
	schedule_interval = 2 SECONDS

/datum/process/disease/do_work()
	for(var/disease in GLOBL.active_diseases)
		var/datum/disease/D = disease
		D.process()
		SCHECK

/datum/process/disease/stat_entry()
	return list("[length(GLOBL.active_diseases)] disease\s")