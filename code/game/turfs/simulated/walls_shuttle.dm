/turf/simulated/shuttle/wall/corner
	var/corner_overlay_state = "diagonalWall"
	var/image/corner_overlay

/turf/simulated/shuttle/wall/corner/New()
	..()
	reset_base_appearance()
	reset_overlay()

//Grabs the base turf type from our area and copies its appearance
/turf/simulated/shuttle/wall/corner/proc/reset_base_appearance()
	var/turf/base_type = get_base_turf_by_area(src)
	if(!base_type)
		return

	icon = initial(base_type.icon)
	icon_state = initial(base_type.icon_state)
	plane = initial(base_type.plane)
	layer = initial(base_type.layer)

/turf/simulated/shuttle/wall/corner/proc/reset_overlay()
	if(corner_overlay)
		overlays -= corner_overlay
	else
		corner_overlay = image(icon = 'icons/turf/shuttle.dmi', icon_state = corner_overlay_state, layer = src.layer, dir = src.dir)
		corner_overlay.plane = 0
	overlays += corner_overlay

//Predefined Shuttle Corners
/turf/simulated/shuttle/wall/corner/smoothwhite
	icon_state = "swall_c" //for mapping preview
	corner_overlay_state = "swall_c"
/turf/simulated/shuttle/wall/corner/smoothwhite/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/smoothwhite/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/smoothwhite/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/smoothwhite/sw
	dir = SOUTH|WEST

/turf/simulated/shuttle/wall/corner/smoothinverted
	icon_state = "swall_cinv" //for mapping preview
	corner_overlay_state = "swall_cinv"
/turf/simulated/shuttle/wall/corner/smoothinverted/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/smoothinverted/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/smoothinverted/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/smoothinverted/sw
	dir = SOUTH|WEST

/turf/simulated/shuttle/wall/corner/blockwhite
	icon_state = "diagonalWall"
	corner_overlay_state = "diagonalWall"
/turf/simulated/shuttle/wall/corner/blockwhite/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/blockwhite/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/blockwhite/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/blockwhite/sw
	dir = SOUTH|WEST

/turf/simulated/shuttle/wall/corner/blockorange
	icon_state = "diagonalWall2"
	corner_overlay_state = "diagonalWall2"
/turf/simulated/shuttle/wall/corner/blockorange/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/blockorange/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/blockorange/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/blockorange/sw
	dir = SOUTH|WEST

/turf/simulated/shuttle/wall/corner/dark
	icon_state = "diagonalWall3"
	corner_overlay_state = "diagonalWall3"
/turf/simulated/shuttle/wall/corner/dark/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/dark/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/dark/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/dark/sw
	dir = SOUTH|WEST