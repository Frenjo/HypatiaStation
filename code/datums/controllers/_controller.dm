/*
 * Base Controller Datum
 */
GLOBAL_GLOBL_LIST_NEW(controllers)

/datum/controller
	// The controller's name.
	var/name

/datum/controller/New()
	..()
	GLOBL.controllers += src

/datum/controller/Destroy()
	GLOBL.controllers -= src
	return ..()

/datum/controller/proc/setup()

/datum/controller/proc/process()

/datum/controller/proc/stat_controller()
	stat(name)