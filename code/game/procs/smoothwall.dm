//Separate dm because it relates to two types of atoms + ease of removal in case it's needed.
//Also assemblies.dm for falsewall checking for this when used.
//I should really make the shuttle wall check run every time it's moved, but centcom uses unsimulated floors so !effort

/atom/proc/relativewall() //atom because it should be useable both for walls and false walls
	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	var/list/range_list = orange(src, 1)
	for(var/turf/closed/wall/W in range_list)
		if(abs(x - W.x) - abs(y - W.y)) //doesn't count diagonal walls
			junction |= get_dir(src, W)
	for(var/obj/structure/falsewall/W in range_list)
		if(abs(x - W.x) - abs(y - W.y)) //doesn't count diagonal walls
			junction |= get_dir(src, W)

/*
 * Commenting this out for now until we figure out what to do with shuttle smooth walls, if anything.
 * As they are now, they sort of work screwy and may need further coding. Or just be scrapped.
 */
/*
	if(istype(src, /turf/closed/wall/shuttle))
		for(var/turf/closed/wall/shuttle/W in range_list)
			if(abs(src.x-W.x)-abs(src.y-W.y)) //doesn't count diagonal walls
				junction |= get_dir(src,W)
		for(var/obj/machinery/shuttle/W in range_list) //stuff like engine and propulsion should merge with walls
			if(abs(src.x-W.x)-abs(src.y-W.y))
				junction |= get_dir(src,W)
		for(var/obj/machinery/door/W in range_list) //doors should not result in diagonal walls, it just looks ugly. checking if area is shuttle so it won't merge with the station
			if((abs(src.x-W.x)-abs(src.y-W.y)) && (istype(W.loc.loc,/area/shuttle) || istype(W.loc.loc,/area/supply)))
				junction |= get_dir(src,W)
		for(var/obj/structure/grille/W in range_list) //same for grilles. checking if area is shuttle so it won't merge with the station
			if((abs(src.x-W.x)-abs(src.y-W.y)) && (istype(W.loc.loc,/area/shuttle) || istype(W.loc.loc,/area/supply)))
				junction |= get_dir(src,W)
*/

	if(istype(src, /turf/closed/wall))
		var/turf/closed/wall/wall = src
		wall.icon_state = "[wall.material.icon_prefix][junction]"
	else if(istype(src, /obj/structure/falsewall))
		var/obj/structure/falsewall/fwall = src
		fwall.icon_state = "[fwall.material.icon_prefix][junction]"
/*	else if(istype(src,/turf/closed/wall/shuttle))
		var/newicon = icon;
		var/newiconstate = icon_state;
		if(junction!=5 && junction!=6 && junction!=9 && junction!=10) //if it's not diagonal, all is well, no additional calculations needed
			src.icon_state = "swall[junction]"
		else //if it's diagonal, we need to figure out if we're using the floor diagonal or the space diagonal sprite
			var/is_floor = 0
			for(var/turf/open/floor/F in range_list)
				if(abs(src.x-F.x)-abs(src.y-F.y))
					if((15-junction) & get_dir(src,F)) //if there's a floor in at least one of the empty space directions, return 1
						is_floor = 1
						newicon = F.icon
						newiconstate = F.icon_state //we'll save these for later
			for(var/turf/open/floor/F in range_list)
				if(abs(src.x-F.x)-abs(src.y-F.y))
					if((15-junction) & get_dir(src,F)) //if there's a floor in at least one of the empty space directions, return 1
						is_floor = 1
						newicon = F.icon
						newiconstate = F.icon_state //we'll save these for later
			for(var/turf/open/floor/shuttle/F in range_list)
				if(abs(src.x-F.x)-abs(src.y-F.y))
					if((15-junction) & get_dir(src,F)) //if there's a floor in at least one of the empty space directions, return 1
						is_floor = 1
						newicon = F.icon
						newiconstate = F.icon_state //we'll save these for later
			if(is_floor) //if is_floor = 1, we use the floor diagonal sprite
				src.icon = newicon; //we'll set the floor's icon to the floor next to it and overlay the wall segment. shuttle floor sprites have priority
				src.icon_state = newiconstate; //
				add_overlay(icon('icons/turf/shuttle.dmi', "swall_f[junction]"))
			else //otherwise, the space one
				src.icon_state = "swall_s[junction]"*/

/atom/proc/relativewall_neighbours()
	for(var/turf/closed/wall/W in RANGE_TURFS(src, 1))
		W.relativewall()
	for(var/obj/structure/falsewall/W in range(src, 1))
		W.relativewall()
		W.update_icon()//Refreshes the wall to make sure the icons don't desync

/turf/closed/wall/initialise()
	. = ..()
	relativewall_neighbours()

/*/turf/closed/wall/shuttle/New()

	spawn(20) //testing if this will make /obj/machinery/shuttle and /door count - It does, it stays.
		if(src.icon_state in list("wall1", "wall", "diagonalWall", "wall_floor", "wall_space")) //so wizard den, syndie shuttle etc will remain black
			for(var/turf/closed/wall/shuttle/W in RANGE_TURFS(src, 1))
				W.relativewall()

	..()*/

/turf/closed/wall/Destroy()
	var/turf/temploc = src.loc

	spawn(10)
		for(var/turf/closed/wall/W in RANGE_TURFS(temploc, 1))
			W.relativewall()

		for(var/obj/structure/falsewall/W in range(temploc, 1))
			W.relativewall()

	for(var/direction in GLOBL.cardinal)
		for(var/obj/effect/glowshroom/shroom in get_step(src, direction))
			if(!shroom.floor) //shrooms drop to the floor
				shroom.floor = 1
				shroom.icon_state = "glowshroomf"
				shroom.pixel_x = 0
				shroom.pixel_y = 0

	return ..()

/*/turf/closed/wall/shuttle/Del()

	var/temploc = src.loc

	spawn(10)
		for(var/turf/closed/wall/shuttle/W in RANGE_TURFS(temploc, 1))
			W.relativewall()

	..()*/

/turf/closed/wall/relativewall()
	var/junction = 0 //will be used to determine from which side the wall is connected to other walls

	var/list/range_list = orange(src, 1)
	for(var/turf/closed/wall/W in range_list)
		if(abs(x - W.x) - abs(y - W.y)) //doesn't count diagonal walls
			if(isnull(W.material)) // Skip walls that don't have a material set.
				continue
			if(W.material.type in material.wall_links_to) // Only 'like' walls connect -Sieve
				junction |= get_dir(src, W)
	for(var/obj/structure/falsewall/W in range_list)
		if(abs(x - W.x) - abs(y - W.y)) //doesn't count diagonal walls
			if(isnull(W.material)) // Skip walls that don't have a material set.
				continue
			if(W.material.type in material.wall_links_to)
				junction |= get_dir(src, W)
	icon_state = "[material.icon_prefix][junction]"