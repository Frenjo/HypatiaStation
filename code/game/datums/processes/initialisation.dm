/*
 * Initialisation Process
 */
GLOBAL_GLOBL_LIST_NEW(queued_initialisations)

PROCESS_DEF(initialisation)
	name = "Initialisation"
	schedule_interval = 1 // Not 1 SECOND, 1 decisecond.

	var/list/atom/late_loaders
	var/list/atom/late_qdels

/datum/process/initialisation/setup()
	LAZYINITLIST(late_loaders)
	LAZYINITLIST(late_qdels)

	to_world(SPAN_DANGER("↪ Initialising atoms."))
	for(var/atom/A in world)
		initialise_atom(A, TRUE)

	for_no_type_check(var/atom/A, late_loaders)
		A.late_initialise()
	late_loaders.Cut()

	for_no_type_check(var/atom/A, late_qdels)
		qdel(A)
	late_qdels.Cut()

/datum/process/initialisation/do_work()
	for(var/last_object in GLOBL.queued_initialisations)
		var/atom/A = last_object
		dequeue_for_initialisation(A)
		initialise_atom(A, FALSE)
		SCHECK

	if(!length(GLOBL.queued_initialisations))
		disable() // If we've initialized all pending objects, disable ourselves.

/datum/process/initialisation/proc/initialise_atom(atom/A, mapload)
	var/result = A.initialise()
	if(result != INITIALISE_NORMAL)
		switch(result)
			if(INITIALISE_LATE)
				if(mapload)
					late_loaders.Add(A)
				else
					A.late_initialise()
			if(INITIALISE_QDEL)
				qdel(A)
			if(INITIALISE_LATE_QDEL)
				if(mapload)
					late_qdels.Add(A)
				else
					qdel(A)

/proc/queue_for_initialisation(atom/A)
	if(!istype(A))
		CRASH("Invalid type. Was [A.type].")
	GLOBL.queued_initialisations.Add(A)
	if(global.PCinitialisation?.disabled)
		global.PCinitialisation.enable() // If a new object has been queued and the initialiser is disabled, awaken it.

/proc/dequeue_for_initialisation(atom/A)
	GLOBL.queued_initialisations.Remove(A)

/datum/process/initialisation/stat_entry()
	return list("[length(GLOBL.queued_initialisations)] pending object\s")