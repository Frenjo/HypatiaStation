/*
 * Mob Process
 */
PROCESS_DEF(mob)
	name = "Mob"
	schedule_interval = 2 SECONDS
	start_delay = 16

/datum/process/mob/doWork()
	for(var/last_object in GLOBL.mob_list)
		var/mob/M = last_object
		if(!GC_DESTROYED(M))
			try
				M.Life()
			catch(var/exception/e)
				catchException(e, M)
			SCHECK
		else
			catchBadType(M)
			GLOBL.mob_list.Remove(M)

/datum/process/mob/stat_entry()
	return list("[length(GLOBL.mob_list)] mobs")