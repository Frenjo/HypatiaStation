/proc/create_all_lighting_overlays()
	for(var/zlevel = 1 to world.maxz)
		create_lighting_overlays_zlevel(zlevel)
		CHECK_TICK

/proc/create_lighting_overlays_zlevel(zlevel)
	ASSERT(zlevel)

	for_no_type_check(var/turf/T, block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
		if(!T.dynamic_lighting)
			continue

		var/area/A = T.loc
		if(!A.dynamic_lighting)
			continue

		new /atom/movable/lighting_overlay(T, TRUE)
		CHECK_TICK