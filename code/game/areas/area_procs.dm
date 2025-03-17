/area/proc/move_contents_to(area/A, turftoleave = null, direction = null, ignore_turf = null)
	//Takes: Area. Optional: turf type to leave behind.
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//		Movement based on lower left corner. Tiles that do not fit
	//		into the new area will not be moved.
	if(isnull(A) || isnull(src))
		return 0

	var/list/turf/turfs_src = get_area_turfs(src.type)
	var/list/turf/turfs_trg = get_area_turfs(A.type)

	if(!length(turfs_src) || !length(turfs_trg))
		return 0

	//figure out a suitable origin - this assumes the shuttle areas are the exact same size and shape
	//might be worth doing this with a shuttle core object instead of areas, in the future
	var/src_min_x = 0
	var/src_min_y = 0
	for_no_type_check(var/turf/T, turfs_src)
		if(T.x < src_min_x || !src_min_x)
			src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y)
			src_min_y	= T.y

	var/trg_z = 0 //multilevel shuttles are not supported, unfortunately
	var/trg_min_x = 0
	var/trg_min_y = 0
	for_no_type_check(var/turf/T, turfs_trg)
		if(!trg_z)
			trg_z = T.z
		if(T.x < trg_min_x || !trg_min_x)
			trg_min_x	= T.x
		if(T.y < trg_min_y || !trg_min_y)
			trg_min_y	= T.y

	//obtain all the source turfs and their relative coords,
	//then use that to find corresponding targets
	for_no_type_check(var/turf/source, turfs_src)
		var/x_pos = (source.x - src_min_x)
		var/y_pos = (source.y - src_min_y)

		var/turf/target = locate(trg_min_x + x_pos, trg_min_y + y_pos, trg_z)
		if(isnull(target) || target.loc != A)
			continue

		transport_turf_contents(source, target, direction)

	//change the old turfs
	for_no_type_check(var/turf/source, turfs_src)
		if(turftoleave)
			source.ChangeTurf(turftoleave, 1, 1)
		else
			source.ChangeTurf(get_base_turf_by_area(source), 1, 1)

	//fixes lighting issue caused by turf

/area/proc/copy_contents_to(area/A , platingRequired = 0)
	//Takes: Area. Optional: If it should copy to areas that don't have plating
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//		Movement based on lower left corner. Tiles that do not fit
	//		into the new area will not be moved.
	if(isnull(A) || isnull(src))
		return 0

	var/list/turf/turfs_src = get_area_turfs(src.type)
	var/list/turf/turfs_trg = get_area_turfs(A.type)

	var/src_min_x = 0
	var/src_min_y = 0
	for_no_type_check(var/turf/T, turfs_src)
		if(T.x < src_min_x || !src_min_x)
			src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y)
			src_min_y	= T.y

	var/trg_min_x = 0
	var/trg_min_y = 0
	for_no_type_check(var/turf/T, turfs_trg)
		if(T.x < trg_min_x || !trg_min_x)
			trg_min_x	= T.x
		if(T.y < trg_min_y || !trg_min_y)
			trg_min_y	= T.y

	var/alist/refined_src = alist()
	for_no_type_check(var/turf/T, turfs_src)
		refined_src[T] = vector(T.x - src_min_x, T.y - src_min_y)

	var/alist/refined_trg = alist()
	for_no_type_check(var/turf/T, turfs_trg)
		refined_trg[T] = vector(T.x - trg_min_x, T.y - trg_min_y)

	var/list/toupdate = list()

	var/list/copiedobjs = list()

	moving:
		for_no_type_check(var/turf/T, refined_src)
			var/vector/C_src = refined_src[T]
			for_no_type_check(var/turf/B, refined_trg)
				var/vector/C_trg = refined_trg[B]
				if(C_src.x == C_trg.x && C_src.y == C_trg.y)
					var/old_dir1 = T.dir
					var/old_icon_state1 = T.icon_state
					var/old_icon1 = T.icon

					if(platingRequired)
						if(isspace(B))
							continue moving

					var/turf/X = new T.type(B)
					X.set_dir(old_dir1)
					X.icon_state = old_icon_state1
					X.icon = old_icon1 //Shuttle floors are in shuttle.dmi while the defaults are floors.dmi

					var/list/objs = list()
					var/list/newobjs = list()
					var/list/mobs = list()
					var/list/newmobs = list()

					for(var/obj/O in T)
						if(!isobj(O))
							continue
						objs.Add(O)

					for(var/obj/O in objs)
						newobjs.Add(DuplicateObject(O, TRUE))

					for(var/obj/O in newobjs)
						O.forceMove(X)

					for(var/mob/M in T)
						if(!ismob(M) || isaieye(M))
							continue // If we need to check for more mobs, I'll add a variable
						mobs.Add(M)

					for(var/mob/M in mobs)
						newmobs.Add(DuplicateObject(M, TRUE))

					for(var/mob/M in newmobs)
						M.forceMove(X)

					copiedobjs.Add(newobjs)
					copiedobjs.Add(newmobs)

					for(var/V in T.vars)
						if(!(V in list("type", "loc", "locs", "vars", "parent", "parent_type", "verbs", "ckey", "key", "x", "y", "z", "contents", "luminosity")))
							X.vars[V] = T.vars[V]

					toupdate.Add(X)

					refined_src.Remove(T)
					refined_trg.Remove(B)
					continue moving

	if(length(toupdate))
		for(var/turf/open/T1 in toupdate)
			for(var/obj/machinery/door/door in T1)
				door.update_nearby_tiles(TRUE)

	return copiedobjs