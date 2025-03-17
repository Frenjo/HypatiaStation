/*Adding a wizard area teleport list because motherfucking lag -- Urist*/
/*I am far too lazy to make it a proper list of areas so I'll just make it run the usual teleport routine at the start of the game.*/
GLOBAL_GLOBL_LIST_NEW(teleportlocs)
GLOBAL_GLOBL_LIST_NEW(ghostteleportlocs)

/hook/startup/proc/setup_teleport_locs()
	. = TRUE
	for_no_type_check(var/area/a, GLOBL.area_list)
		if(istype(a, /area/shuttle) || istype(a, /area/enemy/wizard_station))
			continue
		if(GLOBL.teleportlocs.Find(a.name))
			continue
		var/turf/picked = pick(get_area_turfs(a.type))
		if(isstationlevel(picked.z))
			GLOBL.teleportlocs.Add(a.name)
			GLOBL.teleportlocs[a.name] = a
	GLOBL.teleportlocs = sortAssoc(GLOBL.teleportlocs)

/hook/startup/proc/setup_ghost_teleport_locs()
	. = TRUE
	for_no_type_check(var/area/a, GLOBL.area_list)
		if(GLOBL.ghostteleportlocs.Find(a.name))
			continue
		if(/*istype(a, /area/turret_protected/aisat) ||*/ istype(a, /area/external/abandoned/derelict) || istype(a, /area/centcom/tdome))
			GLOBL.ghostteleportlocs.Add(a.name)
			GLOBL.ghostteleportlocs[a.name] = a
		var/turf/picked = pick(get_area_turfs(a.type))
		if(isplayerlevel(picked.z))
			GLOBL.ghostteleportlocs.Add(a.name)
			GLOBL.ghostteleportlocs[a.name] = a
	GLOBL.ghostteleportlocs = sortAssoc(GLOBL.ghostteleportlocs)

//Returns location. Returns null if no location was found.
/proc/get_teleport_loc(turf/location, mob/target, distance = 1, density = FALSE, errorx = 0, errory = 0, eoffsetx = 0, eoffsety = 0)
/*
Location where the teleport begins, target that will teleport, distance to go, density checking 0/1(yes/no).
Random error in tile placement x, error in tile placement y, and block offset.
Block offset tells the proc how to place the box. Behind teleport location, relative to starting location, forward, etc.
Negative values for offset are accepted, think of it in relation to North, -x is west, -y is south. Error defaults to positive.
Turf and target are seperate in case you want to teleport some distance from a turf the target is not standing on or something.
*/
	var/dirx = 0//Generic location finding variable.
	var/diry = 0

	var/xoffset = 0//Generic counter for offset location.
	var/yoffset = 0

	var/b1xerror = 0//Generic placing for point A in box. The lower left.
	var/b1yerror = 0
	var/b2xerror = 0//Generic placing for point B in box. The upper right.
	var/b2yerror = 0

	errorx = abs(errorx)//Error should never be negative.
	errory = abs(errory)
	//var/errorxy = round((errorx+errory)/2)//Used for diagonal boxes.

	switch(target.dir)//This can be done through equations but switch is the simpler method. And works fast to boot.
	//Directs on what values need modifying.
		if(1)//North
			diry += distance
			yoffset += eoffsety
			xoffset += eoffsetx
			b1xerror -= errorx
			b1yerror -= errory
			b2xerror += errorx
			b2yerror += errory
		if(2)//South
			diry -= distance
			yoffset -= eoffsety
			xoffset += eoffsetx
			b1xerror -= errorx
			b1yerror -= errory
			b2xerror += errorx
			b2yerror += errory
		if(4)//East
			dirx += distance
			yoffset += eoffsetx//Flipped.
			xoffset += eoffsety
			b1xerror -= errory//Flipped.
			b1yerror -= errorx
			b2xerror += errory
			b2yerror += errorx
		if(8)//West
			dirx -= distance
			yoffset -= eoffsetx//Flipped.
			xoffset += eoffsety
			b1xerror -= errory//Flipped.
			b1yerror -= errorx
			b2xerror += errory
			b2yerror += errorx

	var/turf/destination = locate(location.x + dirx, location.y + diry, location.z)

	if(isnotnull(destination)) // If there is a destination.
		if(errorx || errory)//If errorx or y were specified.
			var/list/destination_list = list() // To add turfs to list.
			/*This will draw a block around the target turf, given what the error is.
			Specifying the values above will basically draw a different sort of block.
			If the values are the same, it will be a square. If they are different, it will be a rectengle.
			In either case, it will center based on offset. Offset is position from center.
			Offset always calculates in relation to direction faced. In other words, depending on the direction of the teleport,
			the offset should remain positioned in relation to destination.*/

			var/turf/center = locate((destination.x + xoffset), (destination.y + yoffset), location.z)//So now, find the new center.

			//Now to find a box from center location and make that our destination.
			for_no_type_check(var/turf/T, block(center.x + b1xerror, center.y + b1yerror, location.z, center.x + b2xerror, center.y + b2yerror, location.z))
				if(density && T.density)
					continue//If density was specified.
				if(T.x > world.maxx || T.x < 1)
					continue//Don't want them to teleport off the map.
				if(T.y > world.maxy || T.y < 1)
					continue
				destination_list.Add(T)
			if(length(destination_list))
				destination = pick(destination_list)
			else
				return

		else//Same deal here.
			if(density && destination.density)
				return
			if(destination.x > world.maxx || destination.x < 1)
				return
			if(destination.y > world.maxy || destination.y < 1)
				return
	else
		return

	return destination