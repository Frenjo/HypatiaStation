//put this here because i needed specific functionality, and i wanted to avoid the hassle of getting it onto svn


/area/proc/copy_turfs_to(area/A, platingRequired = 0 )
	//Takes: Area. Optional: If it should copy to areas that don't have plating
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//       Movement based on lower left corner. Tiles that do not fit
	//		 into the new area will not be moved.

	if(!A || !src)
		return 0

	var/list/turfs_src = get_area_turfs(src.type)
	var/list/turfs_trg = get_area_turfs(A.type)

	var/src_min_x = 0
	var/src_min_y = 0
	for_no_type_check(var/turf/T, turfs_src)
		if(T.x < src_min_x || !src_min_x) src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y) src_min_y	= T.y

	var/trg_min_x = 0
	var/trg_min_y = 0
	for_no_type_check(var/turf/T, turfs_trg)
		if(T.x < trg_min_x || !trg_min_x) trg_min_x	= T.x
		if(T.y < trg_min_y || !trg_min_y) trg_min_y	= T.y

	var/alist/refined_src = alist()
	for_no_type_check(var/turf/T, turfs_src)
		refined_src[T] = vector(T.x - src_min_x, T.y - src_min_y)

	var/alist/refined_trg = alist()
	for_no_type_check(var/turf/T, turfs_trg)
		refined_trg[T] = vector(T.x - trg_min_x, T.y - trg_min_y)

	var/list/toupdate = list()

	var/copiedobjs = list()


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


					var/list/mobs = list()
					var/list/newmobs = list()

					for(var/mob/M in T)
						if(!ismob(M) || istype(M, /mob/aiEye))
							continue // If we need to check for more mobs, I'll add a variable
						mobs += M

					for(var/mob/M in mobs)
						newmobs += DuplicateObject(M , 1)

					for(var/mob/M in newmobs)
						M.forceMove(X)



					for(var/V in T.vars)
						if(!(V in list("type", "loc", "locs", "vars", "parent", "parent_type", "verbs", "ckey", "key", "x", "y", "z", "contents", "luminosity")))
							X.vars[V] = T.vars[V]

//					var/area/AR = X.loc

//					if(AR.lighting_use_dynamic)
//						X.opacity = !X.opacity
//						X.sd_SetOpacity(!X.opacity)			//TODO: rewrite this code so it's not messed by lighting ~Carn

					toupdate += X

					refined_src -= T
					refined_trg -= B
					continue moving




	/*var/list/doors = list()

	if(toupdate.len)
		for_no_type_check(var/turf/open/T1, toupdate)
			for(var/obj/machinery/door/D2 in T1)
				doors += D2
			if(T1.parent)
				air_master.groups_to_rebuild += T1.parent
			else
				air_master.tiles_to_update += T1

	for(var/obj/O in doors)
		O:update_nearby_tiles(1)*/




	return copiedobjs
