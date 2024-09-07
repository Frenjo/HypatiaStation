/proc/create_all_lighting_overlays()
	for(var/zlevel = 1 to world.maxz)
		create_lighting_overlays_zlevel(zlevel)
		CHECK_TICK

/proc/create_lighting_overlays_zlevel(zlevel)
	ASSERT(zlevel)

	for_no_type_check(var/turf/T, block(locate(1, 1, zlevel), locate(world.maxx, world.maxy, zlevel)))
		if(!T.dynamic_lighting)
			continue
		T.lighting_build_overlay()
		CHECK_TICK