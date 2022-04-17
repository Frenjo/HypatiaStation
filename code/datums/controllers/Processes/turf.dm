/var/global/list/processing_turfs = list()

/datum/controller/process/turf/setup()
	name = "turf"
	schedule_interval = 3 SECONDS

/datum/controller/process/turf/doWork()
	for(var/turf/T in global.processing_turfs)
		if(T && !T.gcDestroyed)
			if(T.process() == PROCESS_KILL)
				global.processing_turfs.Remove(T)
				continue

		SCHECK

/datum/controller/process/turf/statProcess()
	..()
	stat(null, "[global.processing_turfs.len] turf\s")