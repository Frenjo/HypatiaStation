// nanomanager, the manager for Nano UIs
/var/datum/nanomanager/nanomanager = new()

/datum/controller/process/nanoui/setup()
	name = "nanoui"
	schedule_interval = 2 SECONDS

/datum/controller/process/nanoui/doWork()
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

/datum/controller/process/nanoui/statProcess()
	..()
	stat(null, "[global.nanomanager.processing_uis.len] UIs")