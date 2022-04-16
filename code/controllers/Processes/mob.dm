/datum/controller/process/mob/setup()
	name = "mob"
	schedule_interval = 2 SECONDS
	start_delay = 16

/datum/controller/process/mob/started()
	..()
	if(!global.mob_list)
		global.mob_list = list()

/datum/controller/process/mob/doWork()
	for(last_object in global.mob_list)
		var/mob/M = last_object
		if(isnull(M.gcDestroyed))
			try
				M.Life()
			catch(var/exception/e)
				catchException(e, M)
			SCHECK
		else
			catchBadType(M)
			global.mob_list -= M

/datum/controller/process/mob/statProcess()
	..()
	stat(null, "[global.mob_list.len] mobs")