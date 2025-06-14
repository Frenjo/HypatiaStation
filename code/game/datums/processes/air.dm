/*
 * Air Process
 *
 * Overview:
 *	The air controller does everything. There are tons of procs in here.
 *
 * Class Vars:
 *	zones - All zones currently holding one or more turfs.
 *	edges - All processing edges.
 *
 *	tiles_to_update - Tiles scheduled to update next tick.
 *	zones_to_update - Zones which have had their air changed and need air archival.
 *	active_hotspots - All processing fire objects.
 *
 *	active_zones - The number of zones which were archived last tick. Used in debug verbs.
 *	next_id - The next UID to be applied to a zone. Mostly useful for debugging purposes as zones do not need UIDs to function.
 *
 * Class Procs:
 *	mark_for_update(turf/T)
 *		Adds the turf to the update list. When updated, update_air_properties() will be called.
 *		When stuff changes that might affect airflow, call this. It's basically the only thing you need.
 *
 *	add_zone(zone/Z) and remove_zone(zone/Z)
 *		Adds zones to the zones list. Does not mark them for update.
 *
 *	air_blocked(turf/A, turf/B)
 *		Returns a bitflag consisting of:
 *		AIR_BLOCKED - The connection between turfs is physically blocked. No air can pass.
 *		ZONE_BLOCKED - There is a door between the turfs, so zones cannot cross. Air may or may not be permeable.
 *
 *	has_valid_zone(turf/T)
 *		Checks the presence and validity of T's zone.
 *		May be called on unsimulated turfs, returning 0.
 *
 *	merge(zone/A, zone/B)
 *		Called when zones have a direct connection and equivalent pressure and temperature.
 *		Merges the zones to create a single zone.
 *
 *	connect(turf/open/A, turf/B)
 *		Called by turf/update_air_properties(). The first argument must be simulated.
 *		Creates a connection between A and B.
 *
 *	mark_zone_update(zone/Z)
 *		Adds zone to the update list. Unlike mark_for_update(), this one is called automatically whenever
 *		air is returned from a simulated turf.
 *
 *	equivalent_pressure(zone/A, zone/B)
 *		Currently identical to A.air.compare(B.air). Returns 1 when directly connected zones are ready to be merged.
 *
 *	get_edge(zone/A, zone/B)
 *	get_edge(zone/A, turf/B)
 *		Gets a valid connection_edge between A and B, creating a new one if necessary.
 *
 *	has_same_air(turf/A, turf/B)
 *		Used to determine if an unsimulated edge represents a specific turf.
 *		Simulated edges use connection_edge/contains_zone() for the same purpose.
 *		Returns 1 if A has identical gases and temperature to B.
 *
 *	remove_edge(connection_edge/edge)
 *	Called when an edge is erased. Removes it from processing.
 */
PROCESS_DEF(air)
	name = "Air"
	schedule_interval = 2 SECONDS
	start_delay = 4

	var/static/tick_multiplier = 2

	var/processing_killed = FALSE

	// Geometry lists
	var/list/zone/zones = list()
	var/list/connection_edge/edges = list()

	// Geometry updates lists
	var/list/turf/tiles_to_update = list()
	var/list/zone/zones_to_update = list()
	var/list/zone/active_fire_zones = list()
	var/list/obj/fire/active_hotspots = list()
	var/list/connection_edge/active_edges = list()

	var/active_zones = 0

	var/current_cycle = 0
	var/update_delay = 0.5 SECONDS	// How long between check should it try to process atmos again.
	var/failed_ticks = 0			// How many ticks have runtimed?

	var/tick_progress = 0

	var/next_id = 1	// Used to keep track of zone UIDs.

/*
 * Purpose: Call this at the start to setup air groups geometry
 *	(Warning: Very processor intensive but only must be done once per round)
 * Called by: process scheduler.
 * Inputs: None.
 * Outputs: None.
 */
/datum/process/air/setup()
	#ifndef ZASDBG
	set background = BACKGROUND_ENABLED
	#endif

	to_world(SPAN_DANGER("↪ Processing geometry..."))

	var/simulated_turf_count = length(GLOBL.open_turf_list)
	for_no_type_check(var/turf/open/S, GLOBL.open_turf_list)
		if(!S.needs_air_update) // Skips anything that's already queued.
			continue
		S.update_air_properties()
		CHECK_TICK

	world << {"<span class='info'>
↪ Total Simulated Turfs: [simulated_turf_count]
↪ Total Zones: [length(zones)]
↪ Total Edges: [length(edges)]
↪ Total Active Edges: [length(active_edges) ? SPAN_DANGER(length(active_edges)) : "None"]
↪ Total Unsimulated Turfs: [world.maxx * world.maxy * world.maxz - simulated_turf_count]</font>
</span>"}

/datum/process/air/do_work()
	if(processing_killed)
		return

	if(!process_internal()) //Runtimed.
		failed_ticks++

		if(failed_ticks > 5)
			to_world(SPAN_DANGER("RUNTIMES IN ATMOS TICKER. Killing air simulation!"))
			world.log << "### ZAS SHUTDOWN"

			message_admins("ZASALERT: Shutting down! status: [tick_progress]")
			log_admin("ZASALERT: Shutting down! status: [tick_progress]")

			processing_killed = TRUE
			failed_ticks = 0

/datum/process/air/proc/process_internal()
	. = 1 // Set the default return value, for runtime detection.

	current_cycle++

	// If there are tiles to update, do so.
	tick_progress = "updating turf properties"

	var/list/updating

	if(length(tiles_to_update))
		updating = tiles_to_update
		tiles_to_update = list()

		#ifdef ZASDBG
		var/updated = 0
		#endif
		for_no_type_check(var/turf/T, updating)
			T.update_air_properties()
			T.post_update_air_properties()
			T.needs_air_update = FALSE
			#ifdef ZASDBG
			T.overlays.Remove(mark)
			updated++
			#endif
			CHECK_TICK

		#ifdef ZASDBG
		if(updated != length(updating))
			tick_progress = "[length(updating) - updated] tiles left unupdated."
			to_world(SPAN_WARNING("[tick_progress]"))
			. = 0
		#endif

	// Where gas exchange happens.
	if(.)
		tick_progress = "processing edges"

	for_no_type_check(var/connection_edge/edge, active_edges)
		edge.tick()
		CHECK_TICK

	// Process fire zones.
	if(.)
		tick_progress = "processing fire zones"

	for_no_type_check(var/zone/Z, active_fire_zones)
		Z.process_fire()
		CHECK_TICK

	// Process hotspots.
	if(.)
		tick_progress = "processing hotspots"

	for_no_type_check(var/obj/fire/fire, active_hotspots)
		fire.process()
		CHECK_TICK

	// Process zones.
	if(.)
		tick_progress = "updating zones"

	active_zones = length(zones_to_update)
	if(length(zones_to_update))
		updating = zones_to_update
		zones_to_update = list()
		for_no_type_check(var/zone/zone, updating)
			zone.tick()
			zone.needs_update = FALSE
			CHECK_TICK

	if(.)
		tick_progress = "success"

/datum/process/air/proc/add_zone(zone/z)
	zones.Add(z)
	z.name = "Zone [next_id++]"
	mark_zone_update(z)

/datum/process/air/proc/remove_zone(zone/z)
	zones.Remove(z)

/datum/process/air/proc/air_blocked(turf/A, turf/B)
	#ifdef ZASDBG
	ASSERT(isturf(A))
	ASSERT(isturf(B))
	#endif
	var/ablock = A.c_airblock(B)
	if(ablock == BLOCKED)
		return BLOCKED
	return ablock | B.c_airblock(A)

/datum/process/air/proc/has_valid_zone(turf/open/T)
	#ifdef ZASDBG
	ASSERT(istype(T))
	#endif
	return istype(T) && T.zone && !T.zone.invalid

/datum/process/air/proc/merge(zone/A, zone/B)
	#ifdef ZASDBG
	ASSERT(istype(A))
	ASSERT(istype(B))
	ASSERT(!A.invalid)
	ASSERT(!B.invalid)
	ASSERT(A != B)
	#endif
	if(length(A.contents) < length(B.contents))
		A.c_merge(B)
		mark_zone_update(B)
	else
		B.c_merge(A)
		mark_zone_update(A)

/datum/process/air/proc/connect(turf/open/A, turf/open/B)
	#ifdef ZASDBG
	ASSERT(istype(A))
	ASSERT(isturf(B))
	ASSERT(A.zone)
	ASSERT(!A.zone.invalid)
	//ASSERT(B.zone)
	ASSERT(A != B)
	#endif

	var/block = air_blocked(A, B)
	if(block & AIR_BLOCKED)
		return

	var/direct = !(block & ZONE_BLOCKED)
	var/space = !istype(B)

	if(direct && !space)
		if(equivalent_pressure(A.zone, B.zone) || current_cycle == 0)
			merge(A.zone, B.zone)
			return

	var/a_to_b = get_dir(A, B)
	var/b_to_a = get_dir(B, A)

	if(isnull(A.connections))
		A.connections = new /connection_manager()
	if(isnull(B.connections))
		B.connections = new /connection_manager()

	if(A.connections.get(a_to_b))
		return
	if(B.connections.get(b_to_a))
		return
	if(!space)
		if(A.zone == B.zone)
			return

	var/connection/c = new /connection(A, B)

	A.connections.place(c, a_to_b)
	B.connections.place(c, b_to_a)

	if(direct)
		c.mark_direct()

/datum/process/air/proc/mark_for_update(turf/T)
	#ifdef ZASDBG
	ASSERT(isturf(T))
	#endif
	if(T.needs_air_update)
		return
	tiles_to_update |= T
	#ifdef ZASDBG
	T.add_overlay(mark)
	#endif
	T.needs_air_update = TRUE

/datum/process/air/proc/mark_zone_update(zone/Z)
	#ifdef ZASDBG
	ASSERT(istype(Z))
	#endif
	if(Z.needs_update)
		return
	zones_to_update.Add(Z)
	Z.needs_update = TRUE

/datum/process/air/proc/mark_edge_sleeping(connection_edge/E)
	#ifdef ZASDBG
	ASSERT(istype(E))
	#endif
	if(E.sleeping)
		return
	active_edges.Remove(E)
	E.sleeping = TRUE

/datum/process/air/proc/mark_edge_active(connection_edge/E)
	#ifdef ZASDBG
	ASSERT(istype(E))
	#endif
	if(!E.sleeping)
		return
	active_edges.Add(E)
	E.sleeping = FALSE

/datum/process/air/proc/equivalent_pressure(zone/A, zone/B)
	return A.air.compare(B.air)

/datum/process/air/proc/get_edge(zone/A, zone/B)
	RETURN_TYPE(/connection_edge)

	if(istype(B))
		for(var/connection_edge/zone/edge in A.edges)
			if(edge.contains_zone(B))
				return edge
		var/connection_edge/edge = new /connection_edge/zone(A, B)
		edges.Add(edge)
		edge.recheck()
		return edge
	else
		for(var/connection_edge/unsimulated/edge in A.edges)
			if(has_same_air(edge.B, B))
				return edge
		var/connection_edge/edge = new /connection_edge/unsimulated(A, B)
		edges.Add(edge)
		edge.recheck()
		return edge

/datum/process/air/proc/has_same_air(turf/open/A, turf/open/B)
	if(!istype(A) || !istype(B)) // This was added to replicate identical behaviour to what came before.
		return TRUE // Still not sure if this should return TRUE or FALSE.
	if(isnotnull(A.initial_gases) && isnull(B.initial_gases))
		return FALSE
	if(isnull(A.initial_gases) && isnotnull(B.initial_gases))
		return FALSE
	for(var/gas in A.initial_gases)
		if(!(gas in B.initial_gases))
			return FALSE
		if(A.initial_gases[gas] != B.initial_gases[gas])
			return FALSE
	if(A.temperature != B.temperature)
		return FALSE
	return TRUE

/datum/process/air/proc/remove_edge(connection_edge/E)
	edges.Remove(E)
	if(!E.sleeping)
		active_edges.Remove(E)