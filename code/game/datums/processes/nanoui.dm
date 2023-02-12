/*
 * NanoUI Process
 */
// nanomanager, the manager for Nano UIs
GLOBAL_BYOND_TYPED(nanomanager, /datum/nanomanager)

/hook/startup/proc/create_nanomanager()
	global.nanomanager = new /datum/nanomanager()
	return 1

PROCESS_DEF(nanoui)
	name = "NanoUI"
	schedule_interval = 2 SECONDS

/datum/process/nanoui/doWork()
	for(last_object in global.nanomanager.processing_uis)
		var/datum/nanoui/NUI = last_object
		if(istype(NUI) && !GC_DESTROYED(NUI))
			try
				NUI.process()
			catch(var/exception/e)
				catchException(e, NUI)
		else
			catchBadType(NUI)
			global.nanomanager.processing_uis -= NUI

/datum/process/nanoui/statProcess()
	. = ..()
	stat(null, "[length(global.nanomanager.processing_uis)] UIs")