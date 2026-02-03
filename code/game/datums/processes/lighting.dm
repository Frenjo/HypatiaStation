/*
 * Lighting Process
 */
PROCESS_DEF(lighting)
	name = "Lighting"

	var/static/lighting_overlays_initialised = FALSE

	var/static/list/datum/light_source/lighting_update_lights = list() // List of lighting sources queued for update.
	var/static/list/datum/lighting_corner/lighting_update_corners = list() // List of lighting corners queued for update.
	var/static/list/atom/movable/lighting_overlay/lighting_update_overlays = list() // List of lighting overlays queued for update.

	var/static/list/datum/light_source/lighting_update_lights_old = list() // List of lighting sources currently being updated.
	var/static/list/datum/lighting_corner/lighting_update_corners_old = list() // List of lighting corners currently being updated.
	var/static/list/atom/movable/lighting_overlay/lighting_update_overlays_old = list() // List of lighting overlays currently being updated.

/datum/process/lighting/setup()
	schedule_interval = world.tick_lag // Run as fast as we possibly can.

	create_all_lighting_overlays()
	lighting_overlays_initialised = TRUE
	// TODO: Give this more debug output like the air_system has, total areas, total turfs, total overlays, total corners, etc.

	do_work(TRUE)

// Solves problems with lighting updates lagging shit
// Max constraints on number of updates per doWork():
#define MAX_LIGHT_UPDATES_PER_WORK 100
#define MAX_CORNER_UPDATES_PER_WORK 1000
#define MAX_OVERLAY_UPDATES_PER_WORK 2000

/datum/process/lighting/do_work(roundstart = FALSE)
	if(roundstart)
		set waitfor = FALSE

	// Counters
	var/light_updates	= 0
	var/corner_updates	= 0
	var/overlay_updates	= 0

	lighting_update_lights_old = lighting_update_lights // We use a different list so any additions to the update lists during a delay from scheck() don't cause things to be cut from the list without being updated.
	lighting_update_lights = list()
	for_no_type_check(var/datum/light_source/L, lighting_update_lights_old)
		if(light_updates >= MAX_LIGHT_UPDATES_PER_WORK && !roundstart)
			lighting_update_lights.Add(L)
			continue // DON'T break, we're adding stuff back into the update queue.

		if(L.check() || L.destroyed || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	// We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update	= FALSE
		L.force_update	= FALSE
		L.needs_update	= FALSE

		light_updates++

		SCHECK

	lighting_update_corners_old = lighting_update_corners // Same as above.
	lighting_update_corners = list()
	for_no_type_check(var/datum/lighting_corner/C, lighting_update_corners_old)
		if(corner_updates >= MAX_CORNER_UPDATES_PER_WORK && !roundstart)
			lighting_update_corners.Add(C)
			continue // DON'T break, we're adding stuff back into the update queue.

		C.update_overlays()

		C.needs_update = FALSE

		corner_updates++

		SCHECK

	lighting_update_overlays_old = lighting_update_overlays //Same as above.
	lighting_update_overlays = list()
	for_no_type_check(var/atom/movable/lighting_overlay/O, lighting_update_overlays_old)
		if(overlay_updates >= MAX_OVERLAY_UPDATES_PER_WORK && !roundstart)
			lighting_update_overlays.Add(O)
			continue // DON'T break, we're adding stuff back into the update queue.

		O.update_overlay()
		O.needs_update = FALSE
		overlay_updates++
		SCHECK

#undef MAX_LIGHT_UPDATES_PER_WORK
#undef MAX_CORNER_UPDATES_PER_WORK
#undef MAX_OVERLAY_UPDATES_PER_WORK

/datum/process/lighting/proc/create_all_lighting_overlays()
	for(var/zlevel in 1 to world.maxz)
		create_lighting_overlays_zlevel(zlevel)
		CHECK_TICK

/datum/process/lighting/proc/create_lighting_overlays_zlevel(zlevel)
	ASSERT(zlevel)

	for_no_type_check(var/turf/T, block(1, 1, zlevel, world.maxx, world.maxy, zlevel))
		if(!T.dynamic_lighting)
			continue
		var/area/A = T.loc
		if(!A.dynamic_lighting)
			continue

		new /atom/movable/lighting_overlay(T, TRUE)
		CHECK_TICK