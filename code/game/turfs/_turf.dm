/turf
	icon = 'icons/turf/floors.dmi'
	plane = TURF_PLANE
	layer = TURF_BASE_LAYER

	level = 1.0

	// Stores turf-specific bitflag values.
	// Overridden on subtypes or manipulated with *_TURF_FLAGS(TURF, FLAGS) macros.
	var/turf_flags

	// For floors, use is_plating(), is_plasteel_floor() and is_light_floor().
	var/intact = 1

	// Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	// Properties for both
	var/temperature = T20C

	var/icon_old = null
	var/pathweight = 1

/turf/New()
	SHOULD_CALL_PARENT(TRUE)

	. = ..()
	var/area/turf_area = loc
	turf_area.turf_list.Add(src)
	GLOBL.processing_turfs.Add(src)
	levelupdate()

/turf/Destroy()
	SHOULD_CALL_PARENT(TRUE)

	var/area/turf_area = loc
	turf_area.turf_list.Remove(src)
	GLOBL.processing_turfs.Remove(src)
	return ..()

/turf/proc/process()
	return PROCESS_KILL

/turf/proc/return_siding_icon_state()		//used for grass floors, which have siding.
	return 0

/turf/proc/inertial_drift(atom/movable/A)
	if(isnull(A.last_move))
		return

	if(ismob(A) && x > 2 && x < (world.maxx - 1) && y > 2 && y < (world.maxy - 1))
		var/mob/M = A
		if(M.Process_Spacemove(1))
			M.inertia_dir = 0
			return
		spawn(5)
			if(isnotnull(M) && !M.anchored && !M.pulledby && M.loc == src)
				if(M.inertia_dir)
					step(M, M.inertia_dir)
					return
				M.inertia_dir = M.last_move
				step(M, M.inertia_dir)

/turf/proc/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(src.intact)

// override for space turfs, since they should never hide anything
/turf/space/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(0)

/turf/proc/kill_creatures(mob/U = null)	//Will kill people/creatures and damage mechs./N
//Useful to batch-add creatures to the list.
	for(var/mob/living/M in src)
		if(M == U)
			continue	//Will not harm U. Since null != M, can be excluded to kill everyone.
		spawn(0)
			M.gib()
	for(var/obj/mecha/M in src)//Mecha are not gibbed but are damaged.
		spawn(0)
			M.take_damage(100, "brute")

/turf/proc/Bless()
	if(HAS_TURF_FLAGS(src, TURF_FLAG_NO_JAUNT))
		return
	SET_TURF_FLAGS(src, TURF_FLAG_NO_JAUNT)

/turf/proc/AdjacentTurfs()
	var/list/list = list()
	for(var/turf/open/t in oview(src, 1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				list.Add(t)
	return list

/turf/proc/Distance(turf/t)
	if(get_dist(src, t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight + t.pathweight) / 2
		return cost
	else
		return get_dist(src, t)

/turf/proc/AdjacentTurfsSpace()
	var/list/list = list()
	for(var/turf/t in oview(src, 1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				list.Add(t)
	return list