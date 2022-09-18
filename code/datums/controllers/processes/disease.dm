/var/global/list/active_diseases = list()

/datum/process/disease/setup()
	name = "disease"
	schedule_interval = 2 SECONDS

/datum/process/disease/doWork()
	for(var/disease in global.active_diseases)
		var/datum/disease/D = disease
		D.process()
		SCHECK

/datum/process/disease/statProcess()
	..()
	stat(null, "[global.active_diseases.len] disease\s")