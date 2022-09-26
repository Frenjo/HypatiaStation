GLOBAL_GLOBL_LIST_NEW(active_diseases)

/datum/process/disease
	name = "Disease"
	schedule_interval = 2 SECONDS

/datum/process/disease/doWork()
	for(var/disease in GLOBL.active_diseases)
		var/datum/disease/D = disease
		D.process()
		SCHECK

/datum/process/disease/statProcess()
	..()
	stat(null, "[GLOBL.active_diseases.len] disease\s")