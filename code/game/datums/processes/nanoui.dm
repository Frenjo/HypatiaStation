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

/datum/process/nanoui/do_work()
	for_no_type_check(var/datum/nanoui/ui, global.nanomanager.processing_uis)
		if(!GC_DESTROYED(ui))
			try
				ui.process()
			catch(var/exception/e)
				catch_exception(e, ui)
		else
			catch_bad_type(ui)
			global.nanomanager.processing_uis.Remove(ui)

/datum/process/nanoui/stat_entry()
	return list("[length(global.nanomanager.processing_uis)] UIs")