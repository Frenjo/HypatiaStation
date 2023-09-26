/*
 * Base Controller Datum
 */
GLOBAL_GLOBL_LIST_NEW(controllers)

/datum/controller
	// The controller's name.
	var/name
	// The clickable stat() panel button object.
	var/atom/movable/clickable_stat/stat_click = null

/datum/controller/New()
	. = ..()
	GLOBL.controllers.Add(src)
	stat_click = new /atom/movable/clickable_stat(null, src, name)

/datum/controller/Destroy()
	GLOBL.controllers.Remove(src)
	qdel(stat_click)
	return ..()

/datum/controller/proc/setup()

/datum/controller/proc/process()

/datum/controller/proc/stat_controller()
	stat(stat_click)