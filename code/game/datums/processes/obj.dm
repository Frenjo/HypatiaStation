GLOBAL_GLOBL_LIST_NEW(processing_objects)

/datum/process/obj
	name = "Obj"
	schedule_interval = 2 SECONDS
	start_delay = 8

/datum/process/obj/started()
	..()
	if(!GLOBL.processing_objects)
		GLOBL.processing_objects = list()

/datum/process/obj/doWork()
	for(last_object in GLOBL.processing_objects)
		var/datum/O = last_object
		if(isnull(O.gcDestroyed))
			try
				O:process()
			catch(var/exception/e)
				catchException(e, O)
			SCHECK
		else
			catchBadType(O)
			GLOBL.processing_objects -= O

/datum/process/obj/statProcess()
	..()
	stat(null, "[GLOBL.processing_objects.len] object\s")