/var/global/list/processing_objects = list()

/datum/process/obj
	name = "Obj"
	schedule_interval = 2 SECONDS
	start_delay = 8

/datum/process/obj/started()
	..()
	if(!global.processing_objects)
		global.processing_objects = list()

/datum/process/obj/doWork()
	for(last_object in global.processing_objects)
		var/datum/O = last_object
		if(isnull(O.gcDestroyed))
			try
				O:process()
			catch(var/exception/e)
				catchException(e, O)
			SCHECK
		else
			catchBadType(O)
			global.processing_objects -= O

/datum/process/obj/statProcess()
	..()
	stat(null, "[global.processing_objects.len] object\s")