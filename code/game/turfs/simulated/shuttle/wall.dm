/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = TRUE
	density = TRUE
	turf_flags = TURF_FLAG_BLOCKS_AIR

/*
 * Interior Corners
 */
// Smooth white.
/turf/simulated/shuttle/wall/corner/interior/smoothwhite
	icon_state = "swall_floor" //for mapping preview
/turf/simulated/shuttle/wall/corner/interior/smoothwhite/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/interior/smoothwhite/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/interior/smoothwhite/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/interior/smoothwhite/sw
	dir = SOUTH|WEST

// Smooth inverted.
/turf/simulated/shuttle/wall/corner/interior/smoothinverted
	icon_state = "swall_inv_floor" //for mapping preview
/turf/simulated/shuttle/wall/corner/interior/smoothinverted/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/interior/smoothinverted/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/interior/smoothinverted/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/interior/smoothinverted/sw
	dir = SOUTH|WEST

// Blocky white.
/turf/simulated/shuttle/wall/corner/interior/blockwhite
	icon_state = "wall_floor"
/turf/simulated/shuttle/wall/corner/interior/blockwhite/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/interior/blockwhite/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/interior/blockwhite/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/interior/blockwhite/sw
	dir = SOUTH|WEST

// Blocky orange.
/turf/simulated/shuttle/wall/corner/interior/blockorange
	icon_state = "wall2_floor"
/turf/simulated/shuttle/wall/corner/interior/blockorange/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/interior/blockorange/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/interior/blockorange/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/interior/blockorange/sw
	dir = SOUTH|WEST

// Dark.
/turf/simulated/shuttle/wall/corner/interior/dark
	icon_state = "gwall_floor"
/turf/simulated/shuttle/wall/corner/interior/dark/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/interior/dark/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/interior/dark/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/interior/dark/sw
	dir = SOUTH|WEST

/*
 * Exterior Corners
 */
/turf/simulated/shuttle/wall/corner/exterior
	var/corner_overlay_state = "diagonalWall"
	var/image/corner_overlay

/turf/simulated/shuttle/wall/corner/exterior/New()
	. = ..()
	reset_base_appearance()
	reset_overlay()

//Grabs the base turf type from our area and copies its appearance
/turf/simulated/shuttle/wall/corner/exterior/proc/reset_base_appearance()
	var/turf/base_type = get_base_turf_by_area(src)
	if(isnull(base_type))
		return

	icon = initial(base_type.icon)
	icon_state = initial(base_type.icon_state)
	copy_initial_plane_and_layer(base_type)

/turf/simulated/shuttle/wall/corner/exterior/proc/reset_overlay()
	if(isnotnull(corner_overlay))
		overlays.Remove(corner_overlay)
	else
		corner_overlay = image(icon = 'icons/turf/shuttle.dmi', icon_state = corner_overlay_state)
		corner_overlay.plane = TURF_PLANE
		corner_overlay.layer = TURF_BASE_LAYER
	overlays.Add(corner_overlay)

// Smooth white.
/turf/simulated/shuttle/wall/corner/exterior/smoothwhite
	icon_state = "swall_c" //for mapping preview
	corner_overlay_state = "swall_c"
/turf/simulated/shuttle/wall/corner/exterior/smoothwhite/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/exterior/smoothwhite/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/exterior/smoothwhite/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/exterior/smoothwhite/sw
	dir = SOUTH|WEST

// Smooth inverted.
/turf/simulated/shuttle/wall/corner/exterior/smoothinverted
	icon_state = "swall_cinv" //for mapping preview
	corner_overlay_state = "swall_cinv"
/turf/simulated/shuttle/wall/corner/exterior/smoothinverted/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/exterior/smoothinverted/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/exterior/smoothinverted/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/exterior/smoothinverted/sw
	dir = SOUTH|WEST

// Blocky white.
/turf/simulated/shuttle/wall/corner/exterior/blockwhite
	icon_state = "diagonalWall"
	corner_overlay_state = "diagonalWall"
/turf/simulated/shuttle/wall/corner/exterior/blockwhite/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/exterior/blockwhite/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/exterior/blockwhite/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/exterior/blockwhite/sw
	dir = SOUTH|WEST

// Blocky orange.
/turf/simulated/shuttle/wall/corner/exterior/blockorange
	icon_state = "diagonalWall2"
	corner_overlay_state = "diagonalWall2"
/turf/simulated/shuttle/wall/corner/exterior/blockorange/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/exterior/blockorange/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/exterior/blockorange/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/exterior/blockorange/sw
	dir = SOUTH|WEST

// Dark.
/turf/simulated/shuttle/wall/corner/exterior/dark
	icon_state = "diagonalWall3"
	corner_overlay_state = "diagonalWall3"
/turf/simulated/shuttle/wall/corner/exterior/dark/ne
	dir = NORTH|EAST
/turf/simulated/shuttle/wall/corner/exterior/dark/nw
	dir = NORTH|WEST
/turf/simulated/shuttle/wall/corner/exterior/dark/se
	dir = SOUTH|EAST
/turf/simulated/shuttle/wall/corner/exterior/dark/sw
	dir = SOUTH|WEST