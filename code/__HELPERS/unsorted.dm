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