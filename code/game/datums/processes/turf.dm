/var/global/list/processing_turfs = list()

/datum/process/turf
	name = "Turf"
	schedule_interval = 3 SECONDS

/datum/process/turf/doWork()
	for(var/turf/T in global.processing_turfs)
		if(T && !T.gcDestroyed)
			if(T.process() == PROCESS_KILL)
				global.processing_turfs.Remove(T)
				continue

		SCHECK

/datum/process/turf/statProcess()
	..()
	stat(null, "[global.processing_turfs.len] turf\s")