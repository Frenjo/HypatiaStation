/*
 * Object Process
 */
GLOBAL_GLOBL_LIST_NEW(processing_objects)

PROCESS_DEF(obj)
	name = "Obj"
	schedule_interval = 2 SECONDS
	start_delay = 8

/datum/process/obj/started()
	..()
	if(!GLOBL.processing_objects)
		GLOBL.processing_objects = list()

/datum/process/obj/doWork()
	for(var/last_object in GLOBL.processing_objects)
		var/obj/O = last_object
		if(!GC_DESTROYED(O))
			try
				if(O.process() == PROCESS_KILL)
					GLOBL.processing_objects.Remove(O)
					continue
			catch(var/exception/e)
				catchException(e, O)
			SCHECK
		else
			catchBadType(O)
			GLOBL.processing_objects -= O

/datum/process/obj/statProcess()
	. = ..()
	stat(null, "[length(GLOBL.processing_objects)] object\s")