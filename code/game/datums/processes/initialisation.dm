/*
 * Initialisation Process
 */
GLOBAL_GLOBL_LIST_NEW(queued_initialisations)

PROCESS_DEF(initialisation)
	name = "Initialisation"
	schedule_interval = 1 // Not 1 SECOND, 1 decisecond.

/datum/process/initialisation/do_work()
	for(var/last_object in GLOBL.queued_initialisations)
		var/atom/A = last_object
		dequeue_for_initialisation(A)
		A.initialise()
		SCHECK

	if(!length(GLOBL.queued_initialisations))
		disable()	// If we've initialized all pending objects, disable ourselves

/proc/queue_for_initialisation(atom/A)
	if(!istype(A))
		CRASH("Invalid type. Was [A.type].")
	GLOBL.queued_initialisations.Add(A)
	if(global.PCinitialisation?.disabled)
		global.PCinitialisation.enable() // If a new object has been queued and the initializer is disabled, awaken it

/proc/dequeue_for_initialisation(atom/A)
	GLOBL.queued_initialisations.Remove(A)

/datum/process/initialisation/stat_entry()
	return list("[length(GLOBL.queued_initialisations)] pending object\s")