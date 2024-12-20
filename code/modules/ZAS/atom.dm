/atom
	var/pressure_resistance = ONE_ATMOSPHERE

/atom/proc/CanPass(atom/movable/mover, turf/target, height = 1.5, air_group = 0)
	//Purpose: Determines if the object (or airflow) can pass this atom.
	//Called by: Movement, airflow.
	//Inputs: The moving atom (optional), target turf, "height" and air group
	//Outputs: Boolean if can pass.

	return (!density || !height || air_group)

/turf/CanPass(atom/movable/mover, turf/target, height = 1.5, air_group = 0)
	if(!target)
		return FALSE

	if(istype(mover)) // turf/Enter(...) will perform more advanced checks
		return !density

	else // Now, doing more detailed checks for air movement and air group formation
		if(HAS_TURF_FLAGS(target, TURF_FLAG_BLOCKS_AIR) || HAS_TURF_FLAGS(src, TURF_FLAG_BLOCKS_AIR))
			return FALSE

		for(var/obj/obstacle in src)
			if(!obstacle.CanPass(mover, target, height, air_group))
				return FALSE
		if(target != src)
			for(var/obj/obstacle in target)
				if(!obstacle.CanPass(mover, src, height, air_group))
					return FALSE

		return TRUE

//Basically another way of calling CanPass(null, other, 0, 0) and CanPass(null, other, 1.5, 1).
//Returns:
// 0 - Not blocked
// AIR_BLOCKED - Blocked
// ZONE_BLOCKED - Not blocked, but zone boundaries will not cross.
// BLOCKED - Blocked, zone boundaries will not cross even if opened.
/atom/proc/c_airblock(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	return !CanPass(null, other, 0, 0) + 2 * !CanPass(null, other, 1.5, 1)

/turf/c_airblock(turf/other)
	#ifdef ZASDBG
	ASSERT(isturf(other))
	#endif
	if(HAS_TURF_FLAGS(src, TURF_FLAG_BLOCKS_AIR))
		return BLOCKED

	//Z-level handling code. Always block if there isn't an open space.
	#ifdef ZLEVELS
	if(other.z != src.z)
		if(other.z < src.z)
			if(!isopenspace(src))
				return BLOCKED
		else
			if(!isopenspace(other))
				return BLOCKED
	#endif

	var/result = 0
	for_no_type_check(var/atom/movable/mover, src)
		result |= mover.c_airblock(other)
		if(result == BLOCKED)
			return BLOCKED
	return result