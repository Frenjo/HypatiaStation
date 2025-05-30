/turf/Enter(atom/movable/mover, atom/forget)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		FEEDBACK_MOVEMENT_ADMIN_DISABLED(usr) // This is to identify lag problems.
		return

	if(isnull(mover) || !isturf(mover.loc))
		return TRUE

	// First, check objects to block exit that are not on the border.
	for(var/obj/obstacle in mover.loc)
		if(!HAS_ATOM_FLAGS(obstacle, ATOM_FLAG_ON_BORDER) && mover != obstacle && forget != obstacle)
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return FALSE

	// Now, check objects to block exit that are on the border.
	for(var/obj/border_obstacle in mover.loc)
		if(HAS_ATOM_FLAGS(border_obstacle, ATOM_FLAG_ON_BORDER) && mover != border_obstacle && forget != border_obstacle)
			if(!border_obstacle.CheckExit(mover, src))
				mover.Bump(border_obstacle, 1)
				return FALSE

	// Next, check objects to block entry that are on the border.
	for(var/obj/border_obstacle in src)
		if(HAS_ATOM_FLAGS(border_obstacle, ATOM_FLAG_ON_BORDER))
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && forget != border_obstacle)
				mover.Bump(border_obstacle, 1)
				return FALSE

	// Then, check the turf itself.
	if(!CanPass(mover, src))
		mover.Bump(src, 1)
		return FALSE

	// Finally, check objects/mobs to block entry that are not on the border.
	for_no_type_check(var/atom/movable/obstacle, src)
		if(!HAS_ATOM_FLAGS(obstacle, ATOM_FLAG_ON_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && forget != obstacle)
				mover.Bump(obstacle, 1)
				return FALSE

	return TRUE // Nothing found to block so return success!

/turf/Entered(atom/movable/mover)
	if(movement_disabled)
		FEEDBACK_MOVEMENT_ADMIN_DISABLED(usr) // This is to identify lag problems.
		return
	. = ..()

//vvvvv Infared beam stuff vvvvv
	if(mover?.density && !istype(mover, /obj/effect/beam))
		for(var/obj/effect/beam/i_beam/I in src)
			spawn(0)
				if(isnotnull(I))
					I.hit()
				break
//^^^^^ Infared beam stuff ^^^^^

	if(HAS_ATOM_FLAGS(mover, ATOM_FLAG_UNSIMULATED))
		return

	var/loopsanity = 100
	if(ismob(mover))
		var/mob/mob = mover
		if(isnull(mob.lastarea))
			mob.lastarea = GET_AREA(mover)
		if(!mob.lastarea.has_gravity)
			inertial_drift(mover)

	/*
		if(mover.flags & NOGRAV)
			inertial_drift(mover)
	*/

		else if(!isspace(src))
			mob.inertia_dir = 0
	..()
	var/objects = 0
	for_no_type_check(var/atom/A, range(1))
		if(HAS_ATOM_FLAGS(A, ATOM_FLAG_UNSIMULATED))
			continue
		if(objects > loopsanity)
			break
		objects++
		spawn(0)
			if(isnotnull(A) && isnotnull(mover))
				A.HasProximity(mover, 1)
			return