//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
 * A large number of misc global procs.
 */

//Inverts the colour of an HTML string
/proc/invertHTML(HTMLstring)
	if(!istext(HTMLstring))
		CRASH("Given non-text argument!")
	else
		if(length(HTMLstring) != 7)
			CRASH("Given non-HTML argument!")
	var/textr = copytext(HTMLstring, 2, 4)
	var/textg = copytext(HTMLstring, 4, 6)
	var/textb = copytext(HTMLstring, 6, 8)
	var/r = hex2num(textr)
	var/g = hex2num(textg)
	var/b = hex2num(textb)
	textr = num2hex(255 - r)
	textg = num2hex(255 - g)
	textb = num2hex(255 - b)
	if(length(textr) < 2)
		textr = "0[textr]"
	if(length(textg) < 2)
		textr = "0[textg]"
	if(length(textb) < 2)
		textr = "0[textb]"
	return "#[textr][textg][textb]"

//Returns the middle-most value
/proc/dd_range(low, high, num)
	return max(low, min(high, num))

//Returns whether or not A is the middle most value
/proc/InRange(A, lower, upper)
	if(A < lower)
		return 0
	if(A > upper)
		return 0
	return 1

/proc/Get_Angle(atom/movable/start, atom/movable/end) // For beams.
	if(isnull(start) || isnull(end))
		return 0

	var/dy
	var/dx
	dy = (32 * end.y + end.pixel_y) - (32 * start.y + start.pixel_y)
	dx = (32 * end.x + end.pixel_x) - (32 * start.x + start.pixel_x)
	if(!dy)
		return (dx >= 0) ? 90 : 270
	. = arctan(dx / dy)
	if(dy < 0)
		. += 180
	else if(dx < 0)
		. += 360

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

/proc/LinkBlocked(turf/A, turf/B)
	if(isnull(A) || isnull(B))
		return 1
	var/adir = get_dir(A, B)
	var/rdir = get_dir(B, A)
	if((adir & (NORTH | SOUTH)) && (adir & (EAST | WEST)))	//	diagonal
		var/iStep = get_step(A, adir & (NORTH | SOUTH))
		if(!LinkBlocked(A, iStep) && !LinkBlocked(iStep, B))
			return 0

		var/pStep = get_step(A, adir & (EAST | WEST))
		if(!LinkBlocked(A, pStep) && !LinkBlocked(pStep, B))
			return 0
		return 1

	if(DirBlocked(A, adir))
		return 1
	if(DirBlocked(B, rdir))
		return 1
	return 0

/proc/DirBlocked(turf/loc, dir)
	for(var/obj/structure/window/D in loc)
		if(!D.density)
			continue
		if(D.dir == SOUTHWEST)
			return 1
		if(D.dir == dir)
			return 1

	for(var/obj/machinery/door/D in loc)
		if(!D.density)
			continue
		if(istype(D, /obj/machinery/door/window))
			if((dir & SOUTH) && (D.dir & (EAST | WEST)))
				return 1
			if((dir & EAST) && (D.dir & (NORTH | SOUTH)))
				return 1
		else
			return 1	// it's a real, air blocking door
	return 0

/proc/TurfBlockedNonWindow(turf/loc)
	for(var/obj/O in loc)
		if(O.density && !istype(O, /obj/structure/window))
			return 1
	return 0

/proc/getline(atom/M, atom/N)//Ultra-Fast Bresenham Line-Drawing Algorithm
	var/px = M.x		//starting x
	var/py = M.y
	var/list/line = list(locate(px, py, M.z))
	var/dx = N.x - px	//x distance
	var/dy = N.y - py
	var/dxabs = abs(dx)//Absolute value of x distance
	var/dyabs = abs(dy)
	var/sdx = sign(dx)	//Sign of x distance (+ or -)
	var/sdy = sign(dy)
	var/x = dxabs >> 1	//Counters for steps taken, setting to distance/2
	var/y = dyabs >> 1	//Bit-shifting makes me l33t. It also makes getline() unnessecarrily fast.
	var/j			//Generic integer for counting
	if(dxabs >= dyabs)	//x distance is greater than y
		for(j = 0; j < dxabs; j++)//It'll take dxabs steps to get there
			y += dyabs
			if(y >= dxabs)	//Every dyabs steps, step once in y direction
				y -= dxabs
				py += sdy
			px += sdx		//Step on in x direction
			line += locate(px, py, M.z)//Add the turf to the list
	else
		for(j = 0; j < dyabs; j++)
			x += dxabs
			if(x >= dyabs)
				x -= dyabs
				px += sdx
			py += sdy
			line += locate(px, py, M.z)
	return line

//Returns whether or not a player is a guest using their ckey as an input
/proc/IsGuestKey(key)
	if(findtext(key, "Guest-", 1, 7) != 1) //was findtextEx
		return 0

	var/i, ch, len = length(key)

	for(i = 7, i <= len, ++i)
		ch = text2ascii(key, i)
		if(ch < 48 || ch > 57)
			return 0
	return 1

//This will update a mob's name, real_name, mind.name, data_core records, pda and id
//Calling this proc without an oldname will only update the mob and skip updating the pda, id and records ~Carn
/mob/proc/fully_replace_character_name(oldname, newname)
	if(!newname)
		return 0
	real_name = newname
	name = newname
	mind?.name = newname
	dna?.real_name = real_name

	if(oldname)
		//update the datacore records! This is goig to be a bit costly.
		for_no_type_check(var/list/L, list(GLOBL.data_core.general, GLOBL.data_core.medical, GLOBL.data_core.security, GLOBL.data_core.locked))
			for_no_type_check(var/datum/data/record/R, L)
				if(R.fields["name"] == oldname)
					R.fields["name"] = newname
					break

		//update our pda and id if we have them on our person
		var/list/searching = GetAllContents(searchDepth = 3)
		var/search_id = TRUE
		var/search_pda = TRUE

		for(var/A in searching)
			if(search_id && istype(A, /obj/item/card/id))
				var/obj/item/card/id/ID = A
				if(ID.registered_name == oldname)
					ID.registered_name = newname
					ID.name = "[newname]'s ID Card ([ID.assignment])"
					if(!search_pda)
						break
					search_id = FALSE

			else if(search_pda && istype(A, /obj/item/pda))
				var/obj/item/pda/PDA = A
				if(PDA.owner == oldname)
					PDA.owner = newname
					PDA.name = "PDA - [newname] ([PDA.ownjob])" // Edited this to space out the dash. -Frenjo
					if(!search_id)
						break
					search_pda = FALSE
	return 1

//Generalised helper proc for letting mobs rename themselves. Used to be clname() and ainame()
//Last modified by Carn
/mob/proc/rename_self(role, allow_numbers = 0)
	set waitfor = FALSE

	var/oldname = real_name

	var/time_passed = world.time
	var/newname

	for(var/i = 1, i <= 3, i++)	//we get 3 attempts to pick a suitable name.
		newname = input(src, "You are a [role]. Would you like to change your name to something else?", "Name change", oldname) as text
		if((world.time - time_passed) > 300)
			return	//took too long
		newname = reject_bad_name(newname, allow_numbers)	//returns null if the name doesn't meet some basic requirements. Tidies up a few other things like bad-characters.

		for(var/mob/living/M in GLOBL.player_list)
			if(M == src)
				continue
			if(!newname || M.real_name == newname)
				newname = null
				break
		if(newname)
			break	//That's a suitable name!
		to_chat(src, "Sorry, that [role]-name wasn't appropriate, please try another. It's possibly too long/short, has bad characters or is already taken.")

	if(!newname)	//we'll stick with the oldname then
		return

	if(cmptext("ai", role))
		if(isAI(src))
			var/mob/living/silicon/ai/A = src
			oldname = null//don't bother with the records update crap
			//to_world("<b>[newname] is the AI!</b>")
			//world << sound('sound/AI/newAI.ogg')
			// Set eyeobj name
			A.eyeobj?.name = "[newname] (AI Eye)"

			// Set ai pda name
			if(isnotnull(A.aiPDA))
				A.aiPDA.owner = newname
				A.aiPDA.name = newname + " (" + A.aiPDA.ownjob + ")"

	fully_replace_character_name(oldname, newname)

//Picks a string of symbols to display as the law number for hacked or ion laws
/proc/ionnum()
	return "[pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")][pick("!","@","#","$","%","^","&","*")]"

//When an AI is activated, it can choose from a list of non-slaved borgs to have as a slave.
/proc/freeborg()
	var/select = null
	var/list/borgs = list()
	for(var/mob/living/silicon/robot/A in GLOBL.player_list)
		if(A.stat == DEAD || isnotnull(A.connected_ai) || A.scrambledcodes || isdrone(A))
			continue
		var/name = "[A.real_name] ([A.model.display_name] [A.braintype])"
		borgs[name] = A

	if(length(borgs))
		select = input("Unshackled borg signals detected:", "Borg selection", null, null) as null | anything in borgs
		return borgs[select]

//When a borg is activated, it can choose which AI it wants to be slaved to
/proc/active_ais()
	. = list()
	for_no_type_check(var/mob/living/silicon/ai/A, GLOBL.ai_list)
		if(A.stat == DEAD)
			continue
		if(A.control_disabled)
			continue
		. += A

// Find an active ai with the least borgs. VERBOSE PROCNAME HUH!
/proc/select_active_ai_with_fewest_borgs()
	var/mob/living/silicon/ai/selected = null
	var/list/active = active_ais()
	for(var/mob/living/silicon/ai/A in active)
		if(isnull(selected) || (selected.connected_robots > A.connected_robots))
			selected = A

	return selected

/proc/select_active_ai(mob/user)
	var/list/ais = active_ais()
	if(length(ais))
		if(user)
			. = input(usr, "AI signals detected:", "AI selection") in ais
		else
			. = pick(ais)

/proc/get_sorted_mobs()
	var/list/old_list = getmobs()
	var/list/ai_list = list()
	var/list/dead_list = list()
	var/list/keyclient_list = list()
	var/list/key_list = list()
	var/list/logged_list = list()
	for(var/named in old_list)
		var/mob/M = old_list[named]
		if(issilicon(M))
			ai_list |= M
		else if(isghost(M) || M.stat == DEAD)
			dead_list |= M
		else if(isnotnull(M.key) && isnotnull(M.client))
			keyclient_list |= M
		else if(isnotnull(M.key))
			key_list |= M
		else
			logged_list |= M
		old_list.Remove(named)
	. = list()
	. += ai_list
	. += keyclient_list
	. += key_list
	. += logged_list
	. += dead_list

//Returns a list of all mobs with their name
/proc/getmobs()
	. = list()
	var/list/mobs = sortmobs()
	var/list/names = list()
	var/list/namecounts = list()
	for(var/mob/M in mobs)
		var/name = M.name
		if(name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		if(isnotnull(M.real_name) && M.real_name != M.name)
			name += " \[[M.real_name]\]"
		if(M.stat == DEAD)
			if(isghost(M))
				name += " \[ghost\]"
			else
				name += " \[dead\]"
		.[name] = M

//Orders mobs by type then by name
/proc/sortmobs()
	. = list()
	var/list/sorted_mob_list = sortAtom(GLOBL.mob_list)
	for(var/mob/living/silicon/ai/M in sorted_mob_list)
		. += M
	for(var/mob/living/silicon/pai/M in sorted_mob_list)
		. += M
	for(var/mob/living/silicon/robot/M in sorted_mob_list)
		. += M
	for(var/mob/living/carbon/human/M in sorted_mob_list)
		. += M
	for(var/mob/living/brain/M in sorted_mob_list)
		. += M
	for(var/mob/living/carbon/alien/M in sorted_mob_list)
		. += M
	for(var/mob/dead/ghost/M in sorted_mob_list)
		. += M
	for(var/mob/dead/new_player/M in sorted_mob_list)
		. += M
	for(var/mob/living/carbon/monkey/M in sorted_mob_list)
		. += M
	for(var/mob/living/carbon/slime/M in sorted_mob_list)
		. += M
	for(var/mob/living/simple/M in sorted_mob_list)
		. += M
//	for(var/mob/living/silicon/hivebot/M in sorted_mob_list)
//		. += M
//	for(var/mob/living/silicon/hive_mainframe/M in sorted_mob_list)
//		. += M

//E = MC^2
/proc/convert2energy(M)
	var/E = M * (SPEED_OF_LIGHT_SQ)
	return E

//M = E/C^2
/proc/convert2mass(E)
	var/M = E / (SPEED_OF_LIGHT_SQ)
	return M

//Forces a variable to be posative
/proc/modulus(M)
	if(M >= 0)
		return M
	if(M < 0)
		return -M

/proc/key_name(whom, include_link = null, include_name = 1)
	var/mob/M
	var/client/C
	var/key

	if(!whom)
		return "*null*"
	if(isclient(whom))
		C = whom
		M = C.mob
		key = C.key
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
	else if(isdatum(whom))
		var/datum/D = whom
		return "*invalid:[D.type]*"
	else
		return "*invalid*"

	. = ""

	if(key)
		if(include_link && isnotnull(C))
			. += "<a href='byond://?priv_msg=\ref[C]'>"

		if(C?.holder?.fakekey && !include_name)
			. += "Administrator"
		else
			. += key

		if(include_link)
			if(isnotnull(C))
				. += "</a>"
			else
				. += " (DC)"
	else
		. += "*no key*"

	if(include_name && isnotnull(M))
		if(isnotnull(M.real_name))
			. += "/([M.real_name])"
		else if(M.name)
			. += "/([M.name])"

/proc/key_name_admin(whom, include_name = 1)
	return key_name(whom, 1, include_name)

// returns the turf located at the map edge in the specified direction relative to A
// used for mass driver
/proc/get_edge_target_turf(atom/A, direction)
	var/turf/target = locate(A.x, A.y, A.z)
	if(isnull(A) || isnull(target))
		return 0
		//since NORTHEAST == NORTH & EAST, etc, doing it this way allows for diagonal mass drivers in the future
		//and isn't really any more complicated

		// Note diagonal directions won't usually be accurate
	if(direction & NORTH)
		target = locate(target.x, world.maxy, target.z)
	if(direction & SOUTH)
		target = locate(target.x, 1, target.z)
	if(direction & EAST)
		target = locate(world.maxx, target.y, target.z)
	if(direction & WEST)
		target = locate(1, target.y, target.z)

	return target

// returns turf relative to A in given direction at set range
// result is bounded to map size
// note range is non-pythagorean
// used for disposal system
/proc/get_ranged_target_turf(atom/A, direction, range)
	var/x = A.x
	var/y = A.y
	if(direction & NORTH)
		y = min(world.maxy, y + range)
	if(direction & SOUTH)
		y = max(1, y - range)
	if(direction & EAST)
		x = min(world.maxx, x + range)
	if(direction & WEST)
		x = max(1, x - range)

	return locate(x, y, A.z)

// returns turf relative to A offset in dx and dy tiles
// bound to map limits
/proc/get_offset_target_turf(atom/A, dx, dy)
	var/x = min(world.maxx, max(1, A.x + dx))
	var/y = min(world.maxy, max(1, A.y + dy))
	return locate(x, y, A.z)

//returns random gauss number
/proc/GaussRand(sigma)
	var/x, y, rsq
	do
		x = 2 * rand() - 1
		y = 2 * rand() - 1
		rsq = x * x + y * y
	while(rsq > 1 || !rsq)
	return sigma * y * sqrt(-2 * log(rsq) / rsq)

//returns random gauss number, rounded to 'roundto'
/proc/GaussRandRound(sigma, roundto)
	return round(GaussRand(sigma), roundto)

/proc/anim(turf/location as turf, target as mob|obj, a_icon, a_icon_state as text, flick_anim as text, sleeptime = 0, direction as num)
//This proc throws up either an icon or an animation for a specified amount of time.
//The variables should be apparent enough.
	var/atom/movable/overlay/animation = new /atom/movable/overlay(location)
	if(direction)
		animation.set_dir(direction)
	animation.icon = a_icon
	animation.layer = target:layer + 1
	if(a_icon_state)
		animation.icon_state = a_icon_state
	else
		animation.icon_state = "blank"
		animation.master = target
		flick(flick_anim, animation)
	sleep(max(sleeptime, 15))
	qdel(animation)

//Will return the contents of an atom recursivly to a depth of 'searchDepth'
/atom/proc/GetAllContents(searchDepth = 5)
	. = list()

	for_no_type_check(var/atom/movable/part, src)
		. += part
		if(length(part.contents) && searchDepth)
			. += part.GetAllContents(searchDepth - 1)

//Step-towards method of determining whether one atom can see another. Similar to viewers()
/proc/can_see(atom/source, atom/target, length = 5) // I couldnt be arsed to do actual raycasting :I This is horribly inaccurate.
	var/turf/current = GET_TURF(source)
	var/turf/target_turf = GET_TURF(target)
	var/steps = 0

	while(current != target_turf)
		if(steps > length)
			return FALSE
		if(current.opacity)
			return FALSE
		for_no_type_check(var/atom/movable/mover, current)
			if(mover.opacity)
				return FALSE
		current = get_step_towards(current, target_turf)
		steps++

	return TRUE

/proc/is_blocked_turf(turf/T)
	. = FALSE
	if(T.density)
		. = TRUE
	for_no_type_check(var/atom/movable/mover, T)
		if(mover.density)// && mover.anchored
			. = TRUE

/proc/get_step_towards2(atom/ref, atom/trg)
	var/base_dir = get_dir(ref, get_step_towards(ref, trg))
	var/turf/temp = get_step_towards(ref, trg)

	if(is_blocked_turf(temp))
		var/dir_alt1 = turn(base_dir, 90)
		var/dir_alt2 = turn(base_dir, -90)
		var/turf/turf_last1 = temp
		var/turf/turf_last2 = temp
		var/free_tile = null
		var/breakpoint = 0

		while(!free_tile && breakpoint < 10)
			if(!is_blocked_turf(turf_last1))
				free_tile = turf_last1
				break
			if(!is_blocked_turf(turf_last2))
				free_tile = turf_last2
				break
			turf_last1 = get_step(turf_last1, dir_alt1)
			turf_last2 = get_step(turf_last2, dir_alt2)
			breakpoint++

		if(!free_tile)
			return get_step(ref, base_dir)
		else
			return get_step_towards(ref, free_tile)

	else
		return get_step(ref, base_dir)

//Takes: Anything that could possibly have variables and a varname to check.
//Returns: 1 if found, 0 if not.
/proc/hasvar(datum/A, varname)
	if(A.vars.Find(lowertext(varname)))
		return 1
	else return 0

//Returns: all the areas in the world, sorted.
/proc/return_sorted_areas()
	return sortAtom(GLOBL.area_list.Copy())

//Takes: Area type as text string or as typepath OR an instance of the area.
//Returns: A list of all areas of that type in the world.
/proc/get_areas(area_type)
	RETURN_TYPE(/list)

	if(!area_type)
		return null
	else if(istext(area_type))
		area_type = text2path(area_type)
	else if(isarea(area_type))
		var/area/areatemp = area_type
		area_type = areatemp.type

	. = list()
	for_no_type_check(var/area/A, GLOBL.area_list)
		if(istype(A, area_type))
			. += A

//Takes: Area type as text string or as typepath OR an instance of the area.
//Returns: A list of all turfs in areas of that type of that type in the world.
/proc/get_area_turfs(area_type)
	RETURN_TYPE(/list)

	if(!area_type)
		return null
	else if(istext(area_type))
		area_type = text2path(area_type)
	else if(isarea(area_type))
		var/area/temp_area = area_type
		area_type = temp_area.type

	// This should be completely fine as there are currently no duplicated areas.
	// And there never should be!
	for_no_type_check(var/area/N, GLOBL.area_list)
		if(istype(N, area_type))
			return N.turf_list

	return list()

//Takes: Area type as text string or as typepath OR an instance of the area.
//Returns: A list of all atoms	(objs, turfs, mobs) in areas of that type of that type in the world.
/proc/get_area_all_atoms(areatype)
	if(!areatype)
		return null
	if(istext(areatype))
		areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	. = list()
	for_no_type_check(var/area/N, GLOBL.area_list)
		if(istype(N, areatype))
			for(var/atom/A in N)
				. += A

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
		//var/datum/coords/C = new/datum/coords
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

//Transports a turf from a source turf to a target turf, moving all of the turf's contents and making the target a copy of the source.
/proc/transport_turf_contents(turf/source, turf/target, direction)
	var/turf/new_turf = target.ChangeTurf(source.type, 1, 1)
	new_turf.transport_properties_from(source)

	for(var/obj/O in source)
		if(O.simulated)
			O.forceMove(new_turf)

	for(var/mob/M in source)
		//if(isEye(M))
		//	continue // If we need to check for more mobs, I'll add a variable
		M.forceMove(new_turf)

	return new_turf

/proc/DuplicateObject(obj/original, perfectcopy = 0 , sameloc = 0)
	if(isnull(original))
		return null

	var/obj/O = null

	if(sameloc)
		O = new original.type(original.loc)
	else
		O = new original.type(locate(0, 0, 0))

	if(perfectcopy)
		if(isnotnull(O) && isnotnull(original))
			for(var/V in original.vars)
				if(!(V in list("type", "loc", "locs", "vars", "parent", "parent_type", "verbs", "ckey", "key")))
					O.vars[V] = original.vars[V]
	return O

/datum/coords //Simple datum for storing coordinates.
	var/x_pos = null
	var/y_pos = null
	var/z_pos = null

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

	var/list/refined_src = list()
	for_no_type_check(var/turf/T, turfs_src)
		refined_src.Add(T)
		refined_src[T] = new /datum/coords()
		var/datum/coords/C = refined_src[T]
		C.x_pos = (T.x - src_min_x)
		C.y_pos = (T.y - src_min_y)

	var/list/refined_trg = list()
	for_no_type_check(var/turf/T, turfs_trg)
		refined_trg.Add(T)
		refined_trg[T] = new /datum/coords()
		var/datum/coords/C = refined_trg[T]
		C.x_pos = (T.x - trg_min_x)
		C.y_pos = (T.y - trg_min_y)

	var/list/toupdate = list()

	var/list/copiedobjs = list()

	moving:
		for_no_type_check(var/turf/T, refined_src)
			var/datum/coords/C_src = refined_src[T]
			for_no_type_check(var/turf/B, refined_trg)
				var/datum/coords/C_trg = refined_trg[B]
				if(C_src.x_pos == C_trg.x_pos && C_src.y_pos == C_trg.y_pos)
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

/proc/get_cardinal_dir(atom/A, atom/B)
	var/dx = abs(B.x - A.x)
	var/dy = abs(B.y - A.y)
	return get_dir(A, B) & (rand() * (dx + dy) < dy ? 3 : 12)

//chances are 1:value. anyprob(1) will always return true
/proc/anyprob(value)
	return (rand(1, value) == value)

/proc/view_or_range(distance = world.view, center = usr, type)
	switch(type)
		if("view")
			. = view(distance, center)
		if("range")
			. = range(distance, center)
	return

/proc/oview_or_orange(distance = world.view, center = usr, type)
	switch(type)
		if("view")
			. = oview(distance, center)
		if("range")
			. = orange(distance, center)
	return

/proc/get_mob_with_client_list()
	. = list()
	for(var/mob/M in GLOBL.mob_list)
		if(isnotnull(M.client))
			. += M

/proc/parse_zone(zone)
	if(zone == "r_hand")
		return "right hand"
	else if(zone == "l_hand")
		return "left hand"
	else if(zone == "l_arm")
		return "left arm"
	else if(zone == "r_arm")
		return "right arm"
	else if(zone == "l_leg")
		return "left leg"
	else if(zone == "r_leg")
		return "right leg"
	else if(zone == "l_foot")
		return "left foot"
	else if(zone == "r_foot")
		return "right foot"
	else if(zone == "l_hand")
		return "left hand"
	else if(zone == "r_hand")
		return "right hand"
	else if(zone == "l_foot")
		return "left foot"
	else if(zone == "r_foot")
		return "right foot"
	else
		return zone

/proc/get(atom/loc, type)
	while(loc)
		if(istype(loc, type))
			return loc
		loc = loc.loc
	return null

/proc/get_turf_or_move(turf/location)
	return GET_TURF(location)

/proc/is_hot(obj/item/W)
	switch(W.type)
		if(/obj/item/weldingtool)
			var/obj/item/weldingtool/WT = W
			if(WT.isOn())
				return 3800
			else
				return 0
		if(/obj/item/lighter)
			var/obj/item/lighter/L = W
			if(L.lit)
				return 1500
			else
				return 0
		if(/obj/item/match)
			var/obj/item/match/M = W
			if(M.lit)
				return 1000
			else
				return 0
		if(/obj/item/clothing/mask/cigarette)
			var/obj/item/clothing/mask/cigarette/C = W
			if(C.lit)
				return 1000
			else
				return 0
		if(/obj/item/pickaxe/plasmacutter)
			return 3800
		if(/obj/item/melee/energy)
			return 3500
		else
			return 0

//Whether or not the given item counts as sharp in terms of dealing damage
/proc/is_sharp(obj/O)
	if(isnull(O))
		return FALSE
	if(O.sharp)
		return TRUE
	if(O.edge)
		return TRUE
	return FALSE

//Whether or not the given item counts as cutting with an edge in terms of removing limbs
/proc/has_edge(obj/O)
	if(isnull(O))
		return FALSE
	if(O.edge)
		return TRUE
	return FALSE

//Returns 1 if the given item is capable of popping things like balloons, inflatable barriers, or cutting police tape.
/proc/can_puncture(obj/item/W)		// For the record, WHAT THE HELL IS THIS METHOD OF DOING IT?
	if(isnull(W))
		return FALSE
	if(W.sharp)
		return TRUE
	return( \
		W.sharp											|| \
		istype(W, /obj/item/screwdriver)			|| \
		istype(W, /obj/item/pen)					|| \
		istype(W, /obj/item/weldingtool)			|| \
		istype(W, /obj/item/lighter/zippo)		|| \
		istype(W, /obj/item/match)				|| \
		istype(W, /obj/item/clothing/mask/cigarette)
	)

/proc/is_surgery_tool(obj/item/W)
	return(	\
		istype(W, /obj/item/scalpel)		||	\
		istype(W, /obj/item/hemostat)	||	\
		istype(W, /obj/item/retractor)	||	\
		istype(W, /obj/item/cautery)		||	\
		istype(W, /obj/item/bonegel)		||	\
		istype(W, /obj/item/bonesetter)
	)

//check if mob is lying down on something we can operate him on.
/proc/can_operate(mob/living/carbon/M)
	return (locate(/obj/machinery/optable, M.loc) && M.resting) || \
		(locate(/obj/structure/stool/bed/roller, M.loc) && \
		(M.buckled || M.lying || M.weakened || M.stunned || M.paralysis || M.sleeping || M.stat)) && prob(75) || \
		(locate(/obj/structure/table/, M.loc) && \
		(M.lying || M.weakened || M.stunned || M.paralysis || M.sleeping || M.stat) && prob(66))

/proc/reverse_direction(dir)
	switch(dir)
		if(NORTH)
			return SOUTH
		if(NORTHEAST)
			return SOUTHWEST
		if(EAST)
			return WEST
		if(SOUTHEAST)
			return NORTHWEST
		if(SOUTH)
			return NORTH
		if(SOUTHWEST)
			return NORTHEAST
		if(WEST)
			return EAST
		if(NORTHWEST)
			return SOUTHEAST

/*
Checks if that loc and dir has a item on the wall
*/
GLOBAL_GLOBL_LIST_INIT(wall_items, list(
	/obj/machinery/power/apc, /obj/machinery/air_alarm, /obj/item/radio/intercom,
	/obj/structure/extinguisher_cabinet, /obj/structure/reagent_dispensers/peppertank,
	/obj/machinery/status_display, /obj/machinery/requests_console, /obj/machinery/light_switch, /obj/effect/sign,
	/obj/machinery/newscaster, /obj/machinery/fire_alarm, /obj/structure/noticeboard, /obj/machinery/door_control,
	/obj/machinery/computer/security/telescreen, /*/obj/machinery/embedded_controller/radio/simple_vent_controller,*/
	/obj/item/storage/secure/safe, /obj/machinery/door_timer, /obj/machinery/flasher, /obj/machinery/keycard_auth,
	/obj/structure/mirror, /obj/structure/closet/fireaxecabinet, /obj/machinery/computer/security/telescreen/entertainment
))

/proc/has_wall_item(loc, dir)
	for(var/obj/O in loc)
		for(var/item in GLOBL.wall_items)
			if(istype(O, item))
				// Direction works sometimes.
				if(O.dir == dir)
					return TRUE

				// Some stuff doesn't use dir properly, so we need to check pixel instead.
				switch(dir)
					if(SOUTH)
						if(O.pixel_y > 10)
							return TRUE
					if(NORTH)
						if(O.pixel_y < -10)
							return TRUE
					if(WEST)
						if(O.pixel_x > 10)
							return TRUE
					if(EAST)
						if(O.pixel_x < -10)
							return TRUE

	// Some stuff is placed directly on the wallturf, IE signs.
	for(var/obj/O in get_step(loc, dir))
		for(var/item in GLOBL.wall_items)
			if(istype(O, item))
				if(!O.pixel_x && !O.pixel_y)
					return TRUE
	return FALSE

/proc/format_text(text)
	return replacetext(replacetext(text, "\proper ", ""), "\improper ", "")

// Ported from Baystation12 on 27/11/2019. -Frenjo
//Returns the amount of heat gained while in space due to thermal radiation (usually a negative value)
//surface - the surface area in m^2
//exposed_surface_ratio - the proportion of the surface that is exposed to sunlight
//thermal_conductivity - a multipler on the heat transfer rate. See OPEN_HEAT_TRANSFER_COEFFICIENT and friends
/proc/get_thermal_radiation(surface_temperature, surface, exposed_surface_ratio, thermal_conductivity)
	//*** Gain heat from sunlight, then lose heat from radiation.

	// We only get heat from the star on the exposed surface area.
	// If the HE pipes gain more energy from AVERAGE_SOLAR_RADIATION than they can radiate, then they have a net heat increase.
	. = AVERAGE_SOLAR_RADIATION * (exposed_surface_ratio * surface) * thermal_conductivity

	// Previously, the temperature would enter equilibrium at 26C or 294K.
	// Only would happen if both sides (all 2 square meters of surface area) were exposed to sunlight.  We now assume it aligned edge on.
	// It currently should stabilise at 129.6K or -143.6C
	. -= surface * STEFAN_BOLTZMANN_CONSTANT * thermal_conductivity * (surface_temperature - COSMIC_RADIATION_TEMPERATURE) ** 4