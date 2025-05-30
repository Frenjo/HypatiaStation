/*
 * Garbage Collector Process
 */
#define GC_COLLECTIONS_PER_RUN 150
#define GC_COLLECTION_TIMEOUT (30 SECONDS)
#define GC_FORCE_DEL_PER_RUN 30

GLOBAL_BYOND_LIST_NEW(delayed_garbage)

PROCESS_DEF(garbage)
	name = "Garbage"
	schedule_interval = 2 SECONDS
	start_delay = 3

	var/garbage_collect = TRUE	// Whether or not to actually do work
	var/total_dels	= 0			// number of total del()'s
	var/tick_dels	= 0			// number of del()'s we've done this tick
	var/soft_dels	= 0
	var/hard_dels	= 0			// number of hard dels in total
	var/list/destroyed = list() // list of refID's of things that should be garbage collected
								// refID's are associated with the time at which they time out and need to be manually del()
								// we do this so we aren't constantly locating them and preventing them from being gc'd

	var/list/logging = list()	// list of all types that have failed to GC associated with the number of times that's happened.
								// the types are stored as strings

/datum/process/garbage/setup()
	for(var/garbage in global.delayed_garbage)
		qdel(garbage)
	LAZYCLEARLIST(global.delayed_garbage)

/datum/process/garbage/do_work()
	if(!garbage_collect)
		return

	tick_dels = 0
	var/time_to_kill = world.time - GC_COLLECTION_TIMEOUT
	var/checkRemain = GC_COLLECTIONS_PER_RUN
	var/remaining_force_dels = GC_FORCE_DEL_PER_RUN

	while(length(destroyed) && --checkRemain >= 0)
		if(remaining_force_dels <= 0)
			#ifdef GC_DEBUG
			testing("GC: Reached max force dels per tick [dels] vs [maxDels]")
			#endif
			break // Server's already pretty pounded, everything else can wait 2 seconds
		var/refID = destroyed[1]
		var/GCd_at_time = destroyed[refID]
		if(GCd_at_time > time_to_kill)
			#ifdef GC_DEBUG
			testing("GC: [refID] not old enough, breaking at [world.time] for [GCd_at_time - time_to_kill] deciseconds until [GCd_at_time + collection_timeout]")
			#endif
			break // Everything else is newer, skip them
		var/atom/A = locate(refID)
		#ifdef GC_DEBUG
		testing("GC: [refID] old enough to test: GCd_at_time: [GCd_at_time] time_to_kill: [time_to_kill] current: [world.time]")
		#endif
		if(A?.gc_destroyed == GCd_at_time) // So if something else coincidently gets the same ref, it's not deleted by mistake
			// Something's still referring to the qdel'd object. Kill it.
			testing("GC: -- \ref[A] | [A.type] was unable to be GC'd and was deleted --")
			logging["[A.type]"]++
			del(A)

			hard_dels++
			remaining_force_dels--
		else
			#ifdef GC_DEBUG
			testing("GC: [refID] properly GC'd at [world.time] with timeout [GCd_at_time]")
			#endif
			soft_dels++
		tick_dels++
		total_dels++
		destroyed.Cut(1, 2)
		SCHECK

//#undef GC_FORCE_DEL_PER_TICK
#undef GC_COLLECTION_TIMEOUT
//#undef GC_COLLECTIONS_PER_TICK

/datum/process/garbage/proc/AddTrash(datum/A)
	if(!istype(A) || GC_DESTROYED(A))
		return
	#ifdef GC_DEBUG
	testing("GC: AddTrash(\ref[A] - [A.type])")
	#endif
	A.gc_destroyed = world.time
	destroyed.Remove("\ref[A]") // Removing any previous references that were GC'd so that the current object will be at the end of the list.
	destroyed["\ref[A]"] = world.time

/datum/process/garbage/stat_entry()
	return list(
		"[garbage_collect ? "On" : "Off"], [length(destroyed)] queued",
		"Dels: [total_dels], [soft_dels] soft, [hard_dels] hard, [tick_dels] last run"
	)

// Should be treated as a replacement for the 'del' keyword.
// Datums passed to this will be given a chance to clean up references to allow the GC to collect them.
/proc/qdel(datum/A)
	if(isnull(A))
		return
	if(islist(A))
		var/list/L = A
		for(var/E in L)
			qdel(E)
		return

	if(!istype(A))
		warning("qdel() passed object of type [A.type]. qdel() can only handle /datum types.")
		del(A)
		global.PCgarbage.total_dels++
		global.PCgarbage.hard_dels++
	else if(!GC_DESTROYED(A))
		// Let our friend know they're about to get collected
		. = !A.Destroy()
		if(. && A)
			A.finalize_qdel()

/datum/proc/finalize_qdel()
	del(src)

/atom/finalize_qdel()
	if(isnotnull(global.PCgarbage))
		global.PCgarbage.AddTrash(src)
	else
		global.delayed_garbage |= src

/icon/finalize_qdel()
	del(src)

/image/finalize_qdel()
	del(src)

/mob/finalize_qdel()
	del(src)

/turf/finalize_qdel()
	del(src)

#ifdef TESTING
/client/var/running_find_references

/mob/verb/create_thing()
	set category = PANEL_DEBUG
	set name = "Create Thing"

	var/path = input("Enter path")
	var/atom/thing = new path(loc)
	thing.find_references()

/atom/verb/find_references()
	set category = PANEL_DEBUG
	set name = "Find References"
	set background = BACKGROUND_ENABLED
	set src in world

	if(isnull(usr) || isnull(usr.client))
		return

	if(isnotnull(usr.client.running_find_references))
		testing("CANCELLED search for references to a [usr.client.running_find_references].")
		usr.client.running_find_references = null
		return

	if(alert("Running this will create a lot of lag until it finishes. You can cancel it by running it again. Would you like to begin the search?", "Find References", "Yes", "No") == "No")
		return

	// Remove this object from the list of things to be auto-deleted.
	global.garbage_collector?.destroyed.Remove("\ref[src]")

	usr.client.running_find_references = type
	testing("Beginning search for references to a [type].")
	var/list/things = list()
	for(var/client/thing)
		things.Add(thing)
	for(var/datum/thing)
		things.Add(thing)
	for(var/atom/thing)
		things.Add(thing)
	testing("Collected list of things in search for references to a [type]. ([length(things)] Thing\s)")
	for(var/datum/thing in things)
		if(isnull(usr.client.running_find_references))
			return
		for(var/varname in thing.vars)
			var/variable = thing.vars[varname]
			if(variable == src)
				testing("Found [src.type] \ref[src] in [thing.type]'s [varname] var.")
			else if(islist(variable))
				if(src in variable)
					testing("Found [src.type] \ref[src] in [thing.type]'s [varname] list var.")
	testing("Completed search for references to a [type].")
	usr.client.running_find_references = null

/client/verb/purge_all_destroyed_objects()
	set category = PANEL_DEBUG

	if(global.garbage_collector)
		while(length(global.garbage_collector.destroyed))
			var/datum/o = locate(global.garbage_collector.destroyed[1])
			if(istype(o) && o.gcDestroyed)
				del(o)
				global.garbage_collector.dels++
			global.garbage_collector.destroyed.Cut(1, 2)
#endif

#ifdef GC_DEBUG
#undef GC_DEBUG
#endif