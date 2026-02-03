/turf/space
	name = "\proper space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	plane = SPACE_PLANE

	temperature = TCMB
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT
//	heat_capacity = 700000 No.

	dynamic_lighting = FALSE
	luminosity = 1

	explosion_resistance = 10

	var/static/list/dust_cache
	var/static/list/speedspace_cache
	var/static/list/phase_shift_by_x
	var/static/list/phase_shift_by_y

/turf/space/New()
	SHOULD_CALL_PARENT(FALSE)

	var/area/turf_area = loc
	turf_area.turf_list.Add(src)

	if(isnull(dust_cache))
		build_dust_cache()
	toggle_transit() //add static dust

	update_starlight()

/turf/space/proc/update_starlight()
	if(!CONFIG_GET(/decl/configuration_entry/starlight))
		return

	if(locate(/turf/open) in RANGE_TURFS(src, 1))
		set_light(CONFIG_GET(/decl/configuration_entry/starlight))
	else
		set_light(0)

/turf/space/proc/build_dust_cache()
	// Static.
	dust_cache = list()
	for(var/i in 0 to 25)
		var/image/im = image('icons/turf/space_dust.dmi', "[i]")
		im.plane = SPACE_DUST_PLANE
		im.alpha = 128 //80
		im.blend_mode = BLEND_ADD
		dust_cache["[i]"] = im

	// Moving.
	speedspace_cache = list()
	for(var/i in 0 to 14)
		// NORTH/SOUTH
		var/image/im = image('icons/turf/space_transit.dmi', "speedspace_ns_[i]")
		im.plane = SPACE_PARALLAX_PLANE
		im.blend_mode = BLEND_ADD
		speedspace_cache["NS_[i]"] = im
		// EAST/WEST
		im = image('icons/turf/space_transit.dmi', "speedspace_ew_[i]")
		im.plane = SPACE_PARALLAX_PLANE
		im.blend_mode = BLEND_ADD
		speedspace_cache["EW_[i]"] = im

/turf/space/proc/toggle_transit(direction)
	cut_overlays()

	if(!direction)
		overlays |= dust_cache["[((x + y) ^ ~(x * y) + z) % 25]"]
		return

	if(direction & (NORTH|SOUTH))
		if(isnull(phase_shift_by_x))
			phase_shift_by_x = get_cross_shift_list(15)
		var/x_shift = phase_shift_by_x[x % (length(phase_shift_by_x) - 1) + 1]
		var/transit_state = ((direction & SOUTH ? world.maxy - y : y) + x_shift) % 15
		overlays |= speedspace_cache["NS_[transit_state]"]
	else if(direction & (EAST|WEST))
		if(isnull(phase_shift_by_y))
			phase_shift_by_y = get_cross_shift_list(15)
		var/y_shift = phase_shift_by_y[y % (length(phase_shift_by_y) - 1) + 1]
		var/transit_state = ((direction & WEST ? world.maxx - x : x) + y_shift) % 15
		overlays |= speedspace_cache["EW_[transit_state]"]

	for_no_type_check(var/atom/movable/mover, src)
		if(!mover.is_unsimulated() && !mover.anchored)
			mover.throw_at(get_step(src, reverse_direction(direction)), 5, 1)

//generates a list used to randomize transit animations so they aren't in lockstep
/turf/space/proc/get_cross_shift_list(size)
	var/list/result = list()
	result.Add(rand(0, 14))

	for(var/i in 2 to size)
		var/list/shifts = list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
		shifts.Remove(result[i - 1]) //consecutive shifts should not be equal
		if(i == size)
			shifts.Remove(result[1]) //because shift list is a ring buffer
		result.Add(pick(shifts))

	return result

/turf/space/proc/Sandbox_Spacemove(atom/movable/A)
	var/cur_x
	var/cur_y
	var/next_x
	var/next_y
	var/target_z
	var/list/y_arr

	if(x <= 1)
		if(istype(A, /obj/effect/meteor) || istype(A, /obj/effect/space_dust))
			qdel(A)
			return

		var/list/cur_pos = get_global_map_pos()
		if(isnull(cur_pos))
			return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (--cur_x || length(GLOBL.global_map))
		y_arr = GLOBL.global_map[next_x]
		target_z = y_arr[cur_y]

		if(target_z)
			A.z = target_z
			A.x = world.maxx - 2
			spawn(0)
				A?.loc?.Entered(A)

	else if(x >= world.maxx)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return

		var/list/cur_pos = get_global_map_pos()
		if(isnull(cur_pos))
			return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		next_x = (++cur_x > length(GLOBL.global_map) ? 1 : cur_x)
		y_arr = GLOBL.global_map[next_x]
		target_z = y_arr[cur_y]

		if(target_z)
			A.z = target_z
			A.x = 3
			spawn(0)
				A?.loc?.Entered(A)

	else if(y <= 1)
		if(istype(A, /obj/effect/meteor))
			qdel(A)
			return
		var/list/cur_pos = get_global_map_pos()
		if(isnull(cur_pos))
			return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = GLOBL.global_map[cur_x]
		next_y = (--cur_y || length(y_arr))
		target_z = y_arr[next_y]

		if(target_z)
			A.z = target_z
			A.y = world.maxy - 2
			spawn(0)
				A?.loc?.Entered(A)

	else if(y >= world.maxy)
		if(istype(A, /obj/effect/meteor) || istype(A, /obj/effect/space_dust))
			qdel(A)
			return
		var/list/cur_pos = get_global_map_pos()
		if(isnull(cur_pos))
			return
		cur_x = cur_pos["x"]
		cur_y = cur_pos["y"]
		y_arr = GLOBL.global_map[cur_x]
		next_y = (++cur_y > length(y_arr) ? 1 : cur_y)
		target_z = y_arr[next_y]

		if(target_z)
			A.z = target_z
			A.y = 3
			spawn(0)
				A?.loc?.Entered(A)