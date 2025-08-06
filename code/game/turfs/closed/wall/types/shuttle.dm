/turf/closed/wall/shuttle
	name = "wall"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall1"

	thermal_conductivity = 0.05
	heat_capacity = 0

/turf/closed/wall/shuttle/relativewall()
	return //or else we'd have wacky shuttle merging with walls action

/*
 * Interior Corners
 */
// Smooth white
/turf/closed/wall/shuttle/corner/interior/white
	icon_state = "swall_floor" //for mapping preview
/turf/closed/wall/shuttle/corner/interior/white/ne
	dir = NORTH|EAST
/turf/closed/wall/shuttle/corner/interior/white/nw
	dir = NORTH|WEST
/turf/closed/wall/shuttle/corner/interior/white/se
	dir = SOUTH|EAST
/turf/closed/wall/shuttle/corner/interior/white/sw
	dir = SOUTH|WEST

// Smooth inverted
/turf/closed/wall/shuttle/corner/interior/inverted
	icon_state = "swall_inv_floor" //for mapping preview
/turf/closed/wall/shuttle/corner/interior/inverted/ne
	dir = NORTH|EAST
/turf/closed/wall/shuttle/corner/interior/inverted/nw
	dir = NORTH|WEST
/turf/closed/wall/shuttle/corner/interior/inverted/se
	dir = SOUTH|EAST
/turf/closed/wall/shuttle/corner/interior/inverted/sw
	dir = SOUTH|WEST

// Blocky white
/turf/closed/wall/shuttle/corner/interior/white_old
	icon_state = "wall_floor"
/turf/closed/wall/shuttle/corner/interior/white_old/ne
	dir = NORTH|EAST
/turf/closed/wall/shuttle/corner/interior/white_old/nw
	dir = NORTH|WEST
/turf/closed/wall/shuttle/corner/interior/white_old/se
	dir = SOUTH|EAST
/turf/closed/wall/shuttle/corner/interior/white_old/sw
	dir = SOUTH|WEST

// Blocky orange
/turf/closed/wall/shuttle/corner/interior/orange_old
	icon_state = "wall2_floor"
/turf/closed/wall/shuttle/corner/interior/orange_old/ne
	dir = NORTH|EAST
/turf/closed/wall/shuttle/corner/interior/orange_old/nw
	dir = NORTH|WEST
/turf/closed/wall/shuttle/corner/interior/orange_old/se
	dir = SOUTH|EAST
/turf/closed/wall/shuttle/corner/interior/orange_old/sw
	dir = SOUTH|WEST

// Dark
/turf/closed/wall/shuttle/corner/interior/dark_old
	icon_state = "gwall_floor"
/turf/closed/wall/shuttle/corner/interior/dark_old/ne
	dir = NORTH|EAST
/turf/closed/wall/shuttle/corner/interior/dark_old/nw
	dir = NORTH|WEST
/turf/closed/wall/shuttle/corner/interior/dark_old/se
	dir = SOUTH|EAST
/turf/closed/wall/shuttle/corner/interior/dark_old/sw
	dir = SOUTH|WEST

/*
 * Exterior Corners
 */
/turf/closed/wall/shuttle/corner/exterior
	var/corner_overlay_state = "diagonalWall"
	var/image/corner_overlay

/turf/closed/wall/shuttle/corner/exterior/initialise()
	. = ..()
	reset_base_appearance()
	reset_overlay()

//Grabs the base turf type from our area and copies its appearance
/turf/closed/wall/shuttle/corner/exterior/proc/reset_base_appearance()
	var/turf/base_type = get_base_turf_by_area(src)
	if(isnull(base_type))
		return

	icon = initial(base_type.icon)
	icon_state = initial(base_type.icon_state)
	copy_initial_plane_and_layer(base_type)

/turf/closed/wall/shuttle/corner/exterior/proc/reset_overlay()
	if(isnotnull(corner_overlay))
		remove_overlay(corner_overlay)
	else
		corner_overlay = image(icon = 'icons/turf/shuttle.dmi', icon_state = corner_overlay_state)
		corner_overlay.plane = TURF_PLANE
		corner_overlay.layer = TURF_BASE_LAYER
	add_overlay(corner_overlay)

// Smooth white
/turf/closed/wall/shuttle/corner/exterior/white
	icon_state = "swall_c" //for mapping preview
	corner_overlay_state = "swall_c"
/turf/closed/wall/shuttle/corner/exterior/white/ne
	dir = NORTH|EAST
/turf/closed/wall/shuttle/corner/exterior/white/nw
	dir = NORTH|WEST
/turf/closed/wall/shuttle/corner/exterior/white/se
	dir = SOUTH|EAST
/turf/closed/wall/shuttle/corner/exterior/white/sw
	dir = SOUTH|WEST

// Smooth inverted
/turf/closed/wall/shuttle/corner/exterior/inverted
	icon_state = "swall_cinv" //for mapping preview
	corner_overlay_state = "swall_cinv"
/turf/closed/wall/shuttle/corner/exterior/inverted/ne
	dir = NORTH|EAST
/turf/closed/wall/shuttle/corner/exterior/inverted/nw
	dir = NORTH|WEST
/turf/closed/wall/shuttle/corner/exterior/inverted/se
	dir = SOUTH|EAST
/turf/closed/wall/shuttle/corner/exterior/inverted/sw
	dir = SOUTH|WEST

// Blocky white
/turf/closed/wall/shuttle/corner/exterior/white_old
	icon_state = "diagonalWall"
	corner_overlay_state = "diagonalWall"
/turf/closed/wall/shuttle/corner/exterior/white_old/ne
	dir = NORTH|EAST
/turf/closed/wall/shuttle/corner/exterior/white_old/nw
	dir = NORTH|WEST
/turf/closed/wall/shuttle/corner/exterior/white_old/se
	dir = SOUTH|EAST
/turf/closed/wall/shuttle/corner/exterior/white_old/sw
	dir = SOUTH|WEST

// Blocky orange
/turf/closed/wall/shuttle/corner/exterior/orange_old
	icon_state = "diagonalWall2"
	corner_overlay_state = "diagonalWall2"
/turf/closed/wall/shuttle/corner/exterior/orange_old/ne
	dir = NORTH|EAST
/turf/closed/wall/shuttle/corner/exterior/orange_old/nw
	dir = NORTH|WEST
/turf/closed/wall/shuttle/corner/exterior/orange_old/se
	dir = SOUTH|EAST
/turf/closed/wall/shuttle/corner/exterior/orange_old/sw
	dir = SOUTH|WEST

// Dark
/turf/closed/wall/shuttle/corner/exterior/dark_old
	icon_state = "diagonalWall3"
	corner_overlay_state = "diagonalWall3"
/turf/closed/wall/shuttle/corner/exterior/dark_old/ne
	dir = NORTH|EAST
/turf/closed/wall/shuttle/corner/exterior/dark_old/nw
	dir = NORTH|WEST
/turf/closed/wall/shuttle/corner/exterior/dark_old/se
	dir = SOUTH|EAST
/turf/closed/wall/shuttle/corner/exterior/dark_old/sw
	dir = SOUTH|WEST