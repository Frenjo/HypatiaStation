/datum/controller/process/nanoui/setup()
	name = "nanoui"
	schedule_interval = 2 SECONDS

/datum/controller/process/nanoui/doWork()
	for(last_object in nanomanager.processing_uis)
		var/datum/nanoui/NUI = last_object
		if(istype(NUI) && isnull(NUI.gcDestroyed))
			try
				NUI.process()
			catch(var/exception/e)
				catchException(e, NUI)
		else
			catchBadType(NUI)
			nanomanager.processing_uis -= NUI

/datum/controller/process/nanoui/statProcess()
	..()
	stat(null, "[nanomanager.processing_uis.len] UIs")