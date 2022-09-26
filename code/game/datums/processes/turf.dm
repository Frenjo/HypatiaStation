GLOBAL_GLOBL_LIST_NEW(processing_turfs)

/datum/process/turf
	name = "Turf"
	schedule_interval = 3 SECONDS

/datum/process/turf/doWork()
	for(var/turf/T in GLOBL.processing_turfs)
		if(T && !T.gcDestroyed)
			if(T.process() == PROCESS_KILL)
				GLOBL.processing_turfs.Remove(T)
				continue

		SCHECK

/datum/process/turf/statProcess()
	..()
	stat(null, "[GLOBL.processing_turfs.len] turf\s")