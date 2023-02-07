/*
 * Mob Process
 */
PROCESS_DEF(mob)
	name = "Mob"
	schedule_interval = 2 SECONDS
	start_delay = 16

/datum/process/mob/started()
	..()
	if(!GLOBL.mob_list)
		GLOBL.mob_list = list()

/datum/process/mob/doWork()
	for(last_object in GLOBL.mob_list)
		var/mob/M = last_object
		if(isnull(M.gcDestroyed))
			try
				M.Life()
			catch(var/exception/e)
				catchException(e, M)
			SCHECK
		else
			catchBadType(M)
			GLOBL.mob_list -= M

/datum/process/mob/statProcess()
	. = ..()
	stat(null, "[GLOBL.mob_list.len] mobs")