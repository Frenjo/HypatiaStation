/*
 * Tiled... Tiles?
 * The most common type of flooring.
 */
/turf/simulated/floor/tiled
	name = "tiled floor"

/turf/simulated/floor/tiled/update_icon()
	if(!broken && !burnt)
		icon_state = icon_regular_floor

/turf/simulated/floor/tiled/break_tile()
	icon_state = "damaged[pick(1,2,3,4,5)]"
	broken = 1

/turf/simulated/floor/tiled/burn_tile()
	if(prob(50))
		icon_state = "damaged[pick(1,2,3,4,5)]"
	else
		icon_state = "floorscorched[pick(1,2)]"
	burnt = 1

// Grey Tiles - The standard ones.
/turf/simulated/floor/tiled/grey
	icon_state = "floor"
	tile_path = /obj/item/stack/tile/plasteel

// White Tiles - The medical and science ones.
/turf/simulated/floor/tiled/white
	icon_state = "white"

// Dark Tiles - The ominous ones.
/turf/simulated/floor/tiled/dark
	icon_state = "dark"

// Dark Chapel Tiles - The religiously ominous ones.
/turf/simulated/floor/tiled/dark_chapel
	icon_state = "darkchapel"

// Freezer Tiles - The chilly ones.
/turf/simulated/floor/tiled/freezer
	icon_state = "freezerfloor"

// Showroom Tiles - The fancy ones.
/turf/simulated/floor/tiled/showroom
	icon_state = "showroomfloor"

// Hydroponics Tiles - The slightly green ones.
/turf/simulated/floor/tiled/hydroponics
	icon_state = "hydrofloor"