/var/global/list/active_diseases = list()

/datum/controller/process/disease/setup()
	name = "disease"
	schedule_interval = 2 SECONDS

/datum/controller/process/disease/doWork()
	for(var/disease in global.active_diseases)
		var/datum/disease/D = disease
		D.process()
		SCHECK

/datum/controller/process/disease/statProcess()
	..()
	stat(null, "[global.active_diseases.len] disease\s")