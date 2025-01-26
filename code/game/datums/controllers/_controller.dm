/*
 * Base Controller Datum
 */
// If this list is explicitly typed as /datum/controller/controllers then the whole game breaks.
GLOBAL_GLOBL_LIST_NEW(controllers)

/datum/controller
	// The controller's name.
	var/name = "controller"
	// The clickable stat() panel button object.
	var/atom/movable/clickable_stat/stat_click = null

/datum/controller/New()
	SHOULD_CALL_PARENT(TRUE)

	. = ..()
	GLOBL.controllers.Add(src)
	stat_click = new /atom/movable/clickable_stat(null, src, name)

/datum/controller/Destroy()
	GLOBL.controllers.Remove(src)
	QDEL_NULL(stat_click)
	return ..()

/datum/controller/proc/setup()

/datum/controller/proc/process()

/datum/controller/proc/stat_controller()
	SHOULD_NOT_OVERRIDE(TRUE)

	stat(stat_click)