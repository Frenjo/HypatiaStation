/*

Overview:
	Each zone is a self-contained area where gas values would be the same if tile-based equalization were run indefinitely.
	If you're unfamiliar with ZAS, FEA's air groups would have similar functionality if they didn't break in a stiff breeze.

Class Vars:
	name - A name of the format "Zone [#]", used for debugging.
	invalid - True if the zone has been erased and is no longer eligible for processing.
	needs_update - True if the zone has been added to the update list.
	edges - A list of edges that connect to this zone.
	air - The gas mixture that any turfs in this zone will return. Values are per-tile with a group multiplier.

Class Procs:
	add(turf/open/T)
		Adds a turf to the contents, sets its zone and merges its air.

	remove(turf/open/T)
		Removes a turf, sets its zone to null and erases any gas graphics.
		Invalidates the zone if it has no more tiles.

	c_merge(zone/into)
		Invalidates this zone and adds all its former contents to into.

	c_invalidate()
		Marks this zone as invalid and removes it from processing.

	rebuild()
		Invalidates the zone and marks all its former tiles for updates.

	add_tile_air(turf/open/T)
		Adds the air contained in T.air to the zone's air supply. Called when adding a turf.

	tick()
		Called only when the gas content is changed. Archives values and changes gas graphics.

	dbg_data(mob/M)
		Sends M a printout of important figures for the zone.

*/
/zone
	var/name
	var/invalid = FALSE
	var/list/turf/open/contents
	var/list/turf/open/fire_tiles

	var/needs_update = FALSE

	var/list/connection_edge/edges

	var/datum/gas_mixture/air

/zone/New()
	contents = list()
	fire_tiles = list()
	edges = list()
	air = new /datum/gas_mixture()

	global.PCair.add_zone(src)
	air.temperature = TCMB
	air.group_multiplier = 1
	air.volume = CELL_VOLUME

/zone/proc/add(turf/open/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(!air_master.has_valid_zone(T))
#endif

	var/datum/gas_mixture/turf_air = T.return_air()
	add_tile_air(turf_air)
	T.zone = src
	contents.Add(T)
	if(T.fire)
		fire_tiles.Add(T)
		global.PCair.active_fire_zones.Add(src)
	T.set_graphic(air.graphic)

/zone/proc/remove(turf/open/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(T.zone == src)
	soft_assert(T in contents, "Lists are weird broseph")
#endif
	contents.Remove(T)
	fire_tiles.Remove(T)
	T.zone = null
	T.set_graphic(0)
	if(length(contents))
		air.group_multiplier = length(contents)
	else
		c_invalidate()

/zone/proc/c_merge(zone/into)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(into))
	ASSERT(into != src)
	ASSERT(!into.invalid)
#endif
	c_invalidate()
	for_no_type_check(var/turf/open/T, contents)
		into.add(T)
		#ifdef ZASDBG
		T.dbg(merged)
		#endif

/zone/proc/c_invalidate()
	invalid = TRUE
	global.PCair.remove_zone(src)
	#ifdef ZASDBG
	for_no_type_check(var/turf/open/T, src)
		T.dbg(invalid_zone)
	#endif

/zone/proc/rebuild()
	if(invalid)
		return //Short circuit for explosions where rebuild is called many times over.
	c_invalidate()
	for_no_type_check(var/turf/open/T, contents)
		//T.dbg(invalid_zone)
		T.needs_air_update = FALSE //Reset the marker so that it will be added to the list.
		global.PCair.mark_for_update(T)
		CHECK_TICK

/zone/proc/add_tile_air(datum/gas_mixture/tile_air)
	//air.volume += CELL_VOLUME
	air.group_multiplier = 1
	air.multiply(length(contents))
	air.merge(tile_air)
	air.divide(length(contents) + 1)
	air.group_multiplier = length(contents) + 1

/zone/proc/tick()
	if(air.check_tile_graphic())
		for_no_type_check(var/turf/open/T, contents)
			T.set_graphic(air.graphic)
			CHECK_TICK

	for_no_type_check(var/connection_edge/E, edges)
		if(E.sleeping)
			E.recheck()
			CHECK_TICK

/zone/proc/dbg_data(mob/M)
	to_chat(M, name)
	var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
	for(var/g in air.gas)
		to_chat(M, "[gas_data.name[g]]: [air.gas[g]]")
	to_chat(M, "P: [air.return_pressure()] kPa V: [air.volume]L T: [air.temperature]�K ([air.temperature - T0C]�C)")
	to_chat(M, "O2 per N2: [(air.gas[/decl/xgm_gas/nitrogen] ? air.gas[/decl/xgm_gas/oxygen] / air.gas[/decl/xgm_gas/nitrogen] : "N/A")] Moles: [air.total_moles]")
	to_chat(M, "Simulated: [length(contents)] ([air.group_multiplier])")
	//to_chat(M, "Unsimulated: [length(unsimulated_contents)]")
	//to_chat(M, "Edges: [length(edges)]")
	if(invalid)
		to_chat(M, "Invalid!")
	var/zone_edges = 0
	var/space_edges = 0
	var/space_coefficient = 0
	for_no_type_check(var/connection_edge/E, edges)
		if(E.type == /connection_edge/zone)
			zone_edges++
		else
			space_edges++
			space_coefficient += E.coefficient
			to_chat(M, "[E:air:return_pressure()]kPa")

	to_chat(M, "Zone Edges: [zone_edges]")
	to_chat(M, "Space Edges: [space_edges] ([space_coefficient] connections)")

	//for(var/turf/T in unsimulated_contents)
	//	to_chat(M, "[T] at ([T.x],[T.y])")