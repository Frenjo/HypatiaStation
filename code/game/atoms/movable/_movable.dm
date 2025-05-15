/atom/movable
	layer = 3
	glide_size = 4

	appearance_flags = PIXEL_SCALE

	// Can this atom currently be moved?
	var/anchored = FALSE
	// The last direction the atom moved in.
	var/last_move = null
	// var/elevation = 2    - not used anywhere
	var/move_speed = 10
	var/l_move_time = 1
	var/m_flag = 1
	var/throwing = THROW_NONE
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = FALSE
	var/mob/pulledby = null

/atom/movable/New()
	SHOULD_CALL_PARENT(TRUE)

	. = ..()
	GLOBL.movable_atom_list.Add(src)

/atom/movable/Destroy()
	GLOBL.movable_atom_list.Remove(src)

	var/turf/un_opaque = null
	if(opacity && isturf(loc))
		un_opaque = loc

	forceMove(null)
	un_opaque?.recalc_atom_opacity()

	if(isnotnull(pulledby))
		if(pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null

	for_no_type_check(var/atom/movable/mover, src)
		qdel(mover)

	return ..()

/atom/movable/Move()
	var/atom/A = loc
	. = ..()
	move_speed = world.time - l_move_time
	l_move_time = world.time
	m_flag = 1
	if(A != loc && A?.z == z)
		last_move = get_dir(A, loc)

/atom/movable/Bump(atom/A, yes)
	if(throwing)
		throw_impact(A)
		throwing = THROW_NONE

	spawn(0)
		if(isnotnull(A) && yes)
			A.last_bumped = world.time
			A.Bumped(src)
		return
	. = ..()

/atom/movable/proc/forceMove(atom/destination)
	if(GC_DESTROYED(src) && isnotnull(destination))
		CRASH("Attempted to forceMove a GC_DESTROYED [src] out of nullspace!")
	if(destination == loc)
		return FALSE

	loc?.Exited(src)
	loc = destination
	loc?.Entered(src)
	return TRUE

/atom/movable/proc/hit_check(speed)
	if(throwing)
		for_no_type_check(var/atom/movable/mover, GET_TURF(src))
			if(mover == src)
				continue
			if(isliving(mover))
				var/mob/living/living = mover
				if(living.lying)
					continue
				throw_impact(living, speed)
				if(throwing)
					throwing = THROW_NONE
			if(isobj(mover))
				var/obj/object = mover
				if(object.density && !object.throwpass)	// **TODO: Better behaviour for windows which are dense, but shouldn't always stop movement
					throw_impact(object, speed)
					throwing = THROW_NONE

/atom/movable/proc/throw_at(atom/target, range, speed)
	if(isnull(target) || isnull(src))
		return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target

	throwing = THROW_WEAK

	if(isnotnull(usr))
		if(MUTATION_HULK in usr.mutations)
			throwing = THROW_STRONG // really strong throw!

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)

	var/dx
	if(target.x > src.x)
		dx = EAST
	else
		dx = WEST

	var/dy
	if(target.y > src.y)
		dy = NORTH
	else
		dy = SOUTH
	var/dist_travelled = 0
	var/dist_since_sleep = 0
	var/area/a = GET_AREA(src)
	if(dist_x > dist_y)
		var/error = dist_x / 2 - dist_y
		while(isnotnull(src) && isnotnull(target) &&((((x < target.x && dx == EAST) || (x > target.x && dx == WEST)) && dist_travelled < range) || (a && !a.has_gravity) || isspace(loc)) && throwing && isturf(loc))
			// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < 0)
				var/atom/step = get_step(src, dy)
				if(isnull(step)) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				Move(step)
				hit_check(speed)
				error += dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dx)
				if(isnull(step)) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				Move(step)
				hit_check(speed)
				error -= dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			a = GET_AREA(src)
	else
		var/error = dist_y / 2 - dist_x
		while(isnotnull(src) && isnotnull(target) &&((((y < target.y && dy == NORTH) || (y > target.y && dy == SOUTH)) && dist_travelled < range) || !a.has_gravity || isspace(loc)) && throwing && isturf(loc))
			// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < 0)
				var/atom/step = get_step(src, dx)
				if(isnull(step)) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				Move(step)
				hit_check(speed)
				error += dist_y
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dy)
				if(isnull(step)) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				Move(step)
				hit_check(speed)
				error -= dist_x
				dist_travelled++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)

			a = GET_AREA(src)

	//done throwing, either because it hit something or it finished moving
	throwing = THROW_NONE
	if(isobj(src))
		throw_impact(GET_TURF(src), speed)