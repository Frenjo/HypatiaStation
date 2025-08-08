/proc/createRandomZlevel()
	if(length(GLOBL.awaydestinations))	//crude, but it saves another var!
		return

	var/list/possible_z_levels = list()
	to_world(SPAN_DANGER("Searching for away missions..."))

	var/list/mission_list = file2list("maps/RandomZLevels/fileList.txt")
	if(!length(mission_list))
		return

	for(var/t in mission_list)
		if(!t)
			continue

		t = trim(t)
		if(length(t) == 0)
			continue
		else if(copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/name = null
	//	var/value = null

		if(pos)
			// No, don't do lowertext here, that breaks paths on linux
			name = copytext(t, 1, pos)
		//	value = copytext(t, pos + 1)
		else
			// No, don't do lowertext here, that breaks paths on linux
			name = t

		if(!name)
			continue
		possible_z_levels.Add(name)

	if(length(possible_z_levels))
		to_world(SPAN_DANGER("Loading away mission..."))

		var/map = pick(possible_z_levels)
		var/file = file(map)
		if(isfile(file))
			GLOBL.maploader.load_map(file)
			TO_WORLD_LOG("away mission loaded: [map]")

		for_no_type_check(var/obj/effect/landmark/L, GLOBL.landmark_list)
			if(L.name != "awaystart")
				continue
			GLOBL.awaydestinations.Add(L)

		to_world(SPAN_DANGER("Away mission loaded."))

	else
		to_world(SPAN_DANGER("No away missions found."))
		return