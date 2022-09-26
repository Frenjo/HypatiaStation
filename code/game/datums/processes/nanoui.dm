// nanomanager, the manager for Nano UIs
GLOBAL_BYOND_TYPED(nanomanager, /datum/nanomanager)

/datum/process/nanoui
	name = "NanoUI"
	schedule_interval = 2 SECONDS

/datum/process/nanoui/setup()
	if(!global.nanomanager)
		global.nanomanager = new /datum/nanomanager()

/datum/process/nanoui/doWork()
	for(last_object in global.nanomanager.processing_uis)
		var/datum/nanoui/NUI = last_object
		if(istype(NUI) && isnull(NUI.gcDestroyed))
			try
				NUI.process()
			catch(var/exception/e)
				catchException(e, NUI)
		else
			catchBadType(NUI)
			global.nanomanager.processing_uis -= NUI

/datum/process/nanoui/statProcess()
	..()
	stat(null, "[global.nanomanager.processing_uis.len] UIs")