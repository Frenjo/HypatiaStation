//Returns: all the areas in the world, sorted.
/proc/return_sorted_areas()
	return sortAtom(GLOBL.area_list.Copy())

//Takes: Area type as a typepath OR an instance of the area.
//Returns: A list of all areas of that type in the world.
/proc/get_areas(area_type)
	RETURN_TYPE(/list)

	if(!area_type)
		return null

	if(isarea(area_type))
		var/area/areatemp = area_type
		area_type = areatemp.type

	. = list()
	for_no_type_check(var/area/A, GLOBL.area_list)
		if(istype(A, area_type))
			. += A

//Takes: Area type as a typepath OR an instance of the area.
//Returns: A list of all turfs in areas of that type of that type in the world.
/proc/get_area_turfs(area_type)
	RETURN_TYPE(/list)

	if(!area_type)
		return null

	if(isarea(area_type))
		var/area/temp_area = area_type
		area_type = temp_area.type

	// This should be completely fine as there are currently no duplicated areas.
	// And there never should be!
	for_no_type_check(var/area/N, GLOBL.area_list)
		if(istype(N, area_type))
			return N.turf_list

	return list()

//Takes: Area type as a typepath OR an instance of the area.
//Returns: A list of all atoms (objs, turfs, mobs) in areas of that type of that type in the world.
/proc/get_area_all_atoms(areatype)
	if(!areatype)
		return null
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	. = list()
	for_no_type_check(var/area/N, GLOBL.area_list)
		if(istype(N, areatype))
			for_no_type_check(var/atom/A, N)
				. += A