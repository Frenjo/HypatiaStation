/*
 * Carpet
 */
/turf/open/floor/carpet
	name = "carpet"
	icon_state = "carpet"
	tile_path = /obj/item/stack/tile/carpet

/turf/open/floor/carpet/New()
	if(!icon_state)
		icon_state = "carpet"
	. = ..()

/turf/open/floor/carpet/update_special()
	for(var/direction in GLOBL.alldirs)
		var/turf/T = get_step(src, direction)
		if(isfloorturf(T))
			var/turf/open/floor/F = T
			F.update_icon() //so siding get updated properly

/turf/open/floor/carpet/update_icon()
	. = ..()
	if(!.)
		return FALSE
	if(broken || burnt)
		return FALSE
	if(icon_state == "carpetsymbol" || icon_state == "carpetnoconnect")
		return FALSE

	var/connectdir = 0
	for(var/direction in GLOBL.cardinal)
		if(istype(get_step(src, direction), /turf/open/floor/carpet))
			connectdir |= direction

	//Check the diagonal connections for corners, where you have, for example, connections both north and east. In this case it checks for a north-east connection to determine whether to add a corner marker or not.
	var/diagonalconnect = 0 //1 = NE; 2 = SE; 4 = NW; 8 = SW

	//Northeast
	if(connectdir & NORTH && connectdir & EAST)
		if(istype(get_step(src, NORTHEAST), /turf/open/floor/carpet))
			diagonalconnect |= 1

	//Southeast
	if(connectdir & SOUTH && connectdir & EAST)
		if(istype(get_step(src, SOUTHEAST), /turf/open/floor/carpet))
			diagonalconnect |= 2

	//Northwest
	if(connectdir & NORTH && connectdir & WEST)
		if(istype(get_step(src, NORTHWEST), /turf/open/floor/carpet))
			diagonalconnect |= 4

	//Southwest
	if(connectdir & SOUTH && connectdir & WEST)
		if(istype(get_step(src, SOUTHWEST), /turf/open/floor/carpet))
			diagonalconnect |= 8

	icon_state = "carpet[connectdir]-[diagonalconnect]"

/turf/open/floor/carpet/break_tile()
	. = ..()
	if(.)
		icon_state = "carpet-broken"

/turf/open/floor/carpet/burn_tile()
	. = ..()
	if(.)
		icon_state = "carpet-broken"