//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/proc/dopage(src, target)
	var/href_list = params2list("src=\ref[src]&[target]=1")
	var/href = "src=\ref[src];[target]=1"
	src:temphtml = null
	src:Topic(href, href_list)
	return null

/proc/get_area_name(N) //get area by its name
	for_no_type_check(var/area/A, GLOBL.area_list)
		if(A.name == N)
			return A
	return 0

/proc/in_range(source, user)
	if(get_dist(source, user) <= 1)
		return 1

	return 0 //not in range and not telekinetic

// Like view but bypasses luminosity check
/proc/hear(range, atom/source)
	//var/lum = source.luminosity
	//source.luminosity = 6
	var/lum = source.light_range
	source.light_range = 6

	var/list/heard = view(range, source)
	//source.luminosity = lum
	source.light_range = lum

	return heard

//Magic constants obtained by using linear regression on right-angled triangles of sides 0<x<1, 0<y<1
//They should approximate pythagoras theorem well enough for our needs.
//#define k1 0.934
//#define k2 0.427
///proc/cheap_hypotenuse(Ax,Ay,Bx,By) // T is just the second atom to check distance to center with
//	var/dx = abs(Ax - Bx)	//sides of right-angled triangle
//	var/dy = abs(Ay - By)
//	if(dx>=dy)	return (k1*dx) + (k2*dy)	//No sqrt or powers :)
//	else		return (k1*dx) + (k2*dy)
//#undef k1
//#undef k2

/proc/circlerange(center = usr, radius = 3)
	. = list()
	var/turf/centerturf = GET_TURF(center)
	var/rsq = radius * (radius + 0.5)

	for_no_type_check(var/atom/T, range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx * dx + dy * dy <= rsq)
			. += T

/proc/circleview(center = usr, radius = 3)
	. = list()
	var/turf/centerturf = GET_TURF(center)
	var/rsq = radius * (radius + 0.5)

	for_no_type_check(var/atom/A, view(radius, centerturf))
		var/dx = A.x - centerturf.x
		var/dy = A.y - centerturf.y
		if(dx * dx + dy * dy <= rsq)
			. += A

/proc/get_dist_euclidian(atom/Loc1, atom/Loc2)
	var/dx = Loc1.x - Loc2.x
	var/dy = Loc1.y - Loc2.y

	var/dist = sqrt(dx ** 2 + dy ** 2)

	return dist

/proc/circlerangeturfs(center = usr, radius = 3)
	. = list()
	var/turf/centerturf = GET_TURF(center)
	var/rsq = radius * (radius + 0.5)

	for(var/turf/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx * dx + dy * dy <= rsq)
			. += T

/proc/circleviewturfs(center = usr, radius = 3)		//Is there even a diffrence between this proc and circlerangeturfs()?
	. = list()
	var/turf/centerturf = GET_TURF(center)
	var/rsq = radius * (radius + 0.5)

	for(var/turf/T in view(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx * dx + dy * dy <= rsq)
			. += T

//var/debug_mob = 0

// Will recursively loop through an atom's contents and check for mobs, then it will loop through every atom in that atom's contents.
// It will keep doing this until it checks every content possible. This will fix any problems with mobs, that are inside objects,
// being unable to hear people due to being in a box within a bag.

/proc/recursive_mob_check(atom/O, list/L = list(), recursion_limit = 3, client_check = 1, sight_check = 1, include_radio = 1)
	//debug_mob += length(O.contents)
	if(!recursion_limit)
		return L

	for_no_type_check(var/atom/movable/mover, O)
		if(ismob(mover))
			var/mob/M = mover
			if(client_check && isnull(M.client))
				L |= recursive_mob_check(mover, L, recursion_limit - 1, client_check, sight_check, include_radio)
				continue
			if(sight_check && !isInSight(mover, O))
				continue
			L |= M
			//world.log << "[recursion_limit] = [M] - [GET_TURF(M)] - ([M.x], [M.y], [M.z])"

		else if(include_radio && isradio(mover))
			if(sight_check && !isInSight(mover, O))
				continue
			L |= mover

		if(isobj(mover) || ismob(mover))
			L |= recursive_mob_check(mover, L, recursion_limit - 1, client_check, sight_check, include_radio)
	return L

// The old system would loop through lists for a total of 5000 per function call, in an empty server.
// This new system will loop at around 1000 in an empty server.
// SCREW THAT SHIT, we're not recursing.

// Returns a list of mobs in range of R from source. Used in radio and say code.
/proc/get_mobs_in_view(R, atom/source)
	. = list()
	var/turf/T = GET_TURF(source)

	if(isnull(T))
		return

	var/list/range = hear(R, T)

	for(var/mob/M in range)
		if(isnotnull(M.client))
			. += M

	var/list/objects = list()

	for(var/obj/O in range)				//Get a list of objects in hearing range.  We'll check to see if any clients have their "eye" set to the object
		objects.Add(O)

	for_no_type_check(var/client/C, GLOBL.clients)
		if(!istype(C) || !C.eye)
			continue		//I have no idea when this client check would be needed, but if this runtimes people won't hear anything
							//So kinda paranoid about runtime avoidance.
		if(C.mob in .)
			continue
		if(C.eye in (. | objects))
			if(!(C.mob in .))
				. += C.mob

		else if(!(C.mob in .))
			if(C.mob.loc && (C.mob.loc in (. | objects)))
				. += C.mob
			else if(C.mob.loc.loc && (C.mob.loc.loc in (. | objects)))
				. += C.mob
			else if(C.mob.loc.loc.loc && (C.mob.loc.loc.loc in (. | objects)))   //Going a little deeper
				. += C.mob

/proc/get_mobs_in_radio_ranges(list/obj/item/radio/radios)
	set background = BACKGROUND_ENABLED

	. = list()
	// Returns a list of mobs who can hear any of the radios given in @radios
	var/list/speaker_coverage = list()
	for(var/i = 1; i <= length(radios); i++)
		var/obj/item/radio/R = radios[i]
		if(isnotnull(R))
			var/turf/speaker = GET_TURF(R)
			if(isnotnull(speaker))
				for(var/turf/T in hear(R.canhear_range, speaker))
					speaker_coverage[T] = T

	// Try to find all the players who can hear the message
	for(var/i = 1; i <= length(GLOBL.player_list); i++)
		var/mob/M = GLOBL.player_list[i]
		if(isnotnull(M))
			var/turf/ear = GET_TURF(M)
			if(isnotnull(ear))
				// Ghostship is magic: Ghosts can hear radio chatter from anywhere
				if(speaker_coverage[ear] || (isghost(M) && (M.client?.prefs.toggles & CHAT_GHOSTRADIO)))
					. |= M		// Since we're already looping through mobs, why bother using |= ? This only slows things down.

/proc/inLineOfSight(X1, Y1, X2, Y2, Z = 1, PX1 = 16.5, PY1 = 16.5, PX2 = 16.5, PY2 = 16.5)
	var/turf/T
	if(X1 == X2)
		if(Y1 == Y2)
			return TRUE //Light cannot be blocked on same tile
		else
			var/s = sign(Y2 - Y1)
			Y1 += s
			while(Y1 != Y2)
				T = locate(X1, Y1, Z)
				if(T.opacity)
					return FALSE
				Y1 += s
	else
		var/m = (32 * (Y2 - Y1) + (PY2 - PY1)) / (32 * (X2 - X1) + (PX2 - PX1))
		var/b = (Y1 + PY1 / 32 - 0.015625) - m * (X1 + PX1 / 32 - 0.015625) //In tiles
		var/signX = sign(X2 - X1)
		var/signY = sign(Y2 - Y1)
		if(X1 < X2)
			b += m
		while(X1 != X2 || Y1 != Y2)
			if(round(m * X1 + b - Y1))
				Y1 += signY //Line exits tile vertically
			else
				X1 += signX //Line exits tile horizontally
			T = locate(X1, Y1, Z)
			if(T.opacity)
				return FALSE
	return TRUE

/proc/isInSight(atom/A, atom/B)
	var/turf/Aturf = GET_TURF(A)
	var/turf/Bturf = GET_TURF(B)

	if(isnull(Aturf) || isnull(Bturf))
		return FALSE

	if(inLineOfSight(Aturf.x, Aturf.y, Bturf.x, Bturf.y, Aturf.z))
		return TRUE
	else
		return FALSE

/proc/get_cardinal_step_away(atom/start, atom/finish) //returns the position of a step from start away from finish, in one of the cardinal directions
	//returns only NORTH, SOUTH, EAST, or WEST
	var/dx = finish.x - start.x
	var/dy = finish.y - start.y
	if(abs(dy) > abs (dx)) //slope is above 1:1 (move horizontally in a tie)
		if(dy > 0)
			return get_step(start, SOUTH)
		else
			return get_step(start, NORTH)
	else
		if(dx > 0)
			return get_step(start, WEST)
		else
			return get_step(start, EAST)

/proc/get_mob_by_key(key)
	for_no_type_check(var/mob/M, GLOBL.mob_list)
		if(M.ckey == lowertext(key))
			return M
	return null

// Will return a list of active candidates. It increases the buffer 5 times until it finds a candidate which is active within the buffer.
/proc/get_active_candidates(buffer = 1)
	. = list() //List of candidate KEYS to assume control of the new larva ~Carn
	var/i = 0
	while(!length(.) && i < 5)
		for(var/mob/dead/ghost/G in GLOBL.player_list)
			if(((G.client.inactivity / 10) / 60) <= buffer + i) // the most active players are more likely to become an alien
				if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
					. += G.key
		i++

// Same as above but for alien candidates.
/proc/get_alien_candidates()
	. = list() //List of candidate KEYS to assume control of the new larva ~Carn
	var/i = 0
	while(!length(.) && i < 5)
		for(var/mob/dead/ghost/G in GLOBL.player_list)
			if(G.client.prefs.be_special & BE_ALIEN)
				if(((G.client.inactivity / 10) / 60) <= ALIEN_SELECT_AFK_BUFFER + i) // the most active players are more likely to become an alien
					if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
						. += G.key
		i++

/proc/ScreenText(obj/O, maptext = "", screen_loc = "CENTER-7,CENTER-7", maptext_height = 480, maptext_width = 480)
	if(!isobj(O))
		O = new /atom/movable/screen/text()
	O.maptext = maptext
	O.maptext_height = maptext_height
	O.maptext_width = maptext_width
	O.screen_loc = screen_loc
	return O

/proc/Show2Group4Delay(obj/O, list/group, delay = 0)
	if(!isobj(O))
		return
	if(isnull(group))
		group = GLOBL.clients
	for(var/client/C in group)
		C.screen.Add(O)
	if(delay)
		spawn(delay)
			for(var/client/C in group)
				C.screen.Remove(O)

/datum/projectile_data
	var/src_x
	var/src_y
	var/time
	var/distance
	var/power_x
	var/power_y
	var/dest_x
	var/dest_y

/datum/projectile_data/New(src_x, src_y, time, distance, power_x, power_y, dest_x, dest_y)
	src.src_x = src_x
	src.src_y = src_y
	src.time = time
	src.distance = distance
	src.power_x = power_x
	src.power_y = power_y
	src.dest_x = dest_x
	src.dest_y = dest_y

/proc/projectile_trajectory(src_x, src_y, rotation, angle, power)
	// returns the destination (Vx,y) that a projectile shot at [src_x], [src_y], with an angle of [angle],
	// rotated at [rotation] and with the power of [power]
	// Thanks to VistaPOWA for this function

	var/power_x = power * cos(angle)
	var/power_y = power * sin(angle)
	var/time = 2* power_y / 10 //10 = g

	var/distance = time * power_x

	var/dest_x = src_x + distance*sin(rotation);
	var/dest_y = src_y + distance*cos(rotation);

	return new /datum/projectile_data(src_x, src_y, time, distance, power_x, power_y, dest_x, dest_y)