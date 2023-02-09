/*
 * Initialisation Process
 */
GLOBAL_GLOBL_LIST_NEW(queued_initialisations)

PROCESS_DEF(initialisation)
	name = "Initialisation"
	schedule_interval = 1 // Not 1 SECOND, 1 decisecond.

/datum/process/initialisation/doWork()
	for(last_object in GLOBL.queued_initialisations)
		var/atom/movable/AM = last_object
		dequeue_for_initialisation(AM)
		AM.initialize()
		SCHECK

	if(!length(GLOBL.queued_initialisations))
		disable()	// If we've initialized all pending objects, disable ourselves

/proc/queue_for_initialisation(atom/movable/AM)
	if(!istype(AM))
		CRASH("Invalid type. Was [AM.type].")
	GLOBL.queued_initialisations += AM
	if(global.PCinitialisation && global.PCinitialisation.disabled)
		global.PCinitialisation.enable() // If a new object has been queued and the initializer is disabled, awaken it

/proc/dequeue_for_initialisation(atom/movable/AM)
	GLOBL.queued_initialisations.Remove(AM)

/datum/process/initialisation/statProcess()
	. = ..()
	stat(null, "[length(GLOBL.queued_initialisations)] pending object\s")