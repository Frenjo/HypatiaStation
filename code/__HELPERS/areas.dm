// Returns: all the areas in the world, sorted.
/proc/return_sorted_areas()
	return sortAtom(GLOBL.area_list.Copy())

// Takes: An area type as a typepath OR an instance of the area.
// Returns: A list of all turfs in areas of that type of that type in the world.
// This does NOT include subtypes of the provided area type.
/proc/get_area_turfs(area_type)
	RETURN_TYPE(/list/turf)

	if(!area_type)
		return null

	if(isarea(area_type))
		var/area/temp_area = area_type
		area_type = temp_area.type

	// This should be completely fine as there are currently no duplicated areas.
	// And there never should be!
	for_no_type_check(var/area/N, GLOBL.area_list)
		if(N.type == area_type)
			return N.turf_list

	return list()

// Takes: An area type as a typepath OR an instance of the area.
// Returns: A list of all atoms (objs, turfs, mobs) in areas of that type of that type in the world.
// This does NOT include subtypes of the provided area type.
/proc/get_area_all_atoms(area_type)
	RETURN_TYPE(/list/atom)

	if(!area_type)
		return null

	if(isarea(area_type))
		var/area/temp_area = area_type
		area_type = temp_area.type

	. = list()
	for_no_type_check(var/area/N, GLOBL.area_list)
		if(N.type != area_type)
			continue
		for_no_type_check(var/atom/A, N)
			. += A