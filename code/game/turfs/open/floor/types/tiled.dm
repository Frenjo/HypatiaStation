/*
 * Tiled... Tiles?
 * The most common type of flooring.
 */
/turf/open/floor/tiled
	name = "tiled floor"

/turf/open/floor/tiled/update_icon()
	. = ..()
	if(!.)
		return FALSE
	if(broken || burnt)
		return FALSE

	icon_state = icon_regular_floor

/turf/open/floor/tiled/break_tile()
	. = ..()
	if(.)
		icon_state = "damaged[pick(1, 2, 3, 4, 5)]"

/turf/open/floor/tiled/burn_tile()
	. = ..()
	if(.)
		if(prob(50))
			icon_state = "damaged[pick(1, 2, 3, 4, 5)]"
		else
			icon_state = "floorscorched[pick(1, 2)]"

// Grey Tiles - The standard ones.
/turf/open/floor/tiled/grey
	icon_state = "floor"
	tile_path = /obj/item/stack/tile/metal/grey

// Dust-covered asteroid variant
/turf/open/floor/tiled/grey/asteroid
	name = "dust-covered tiled floor"
	icon_state = "asteroidfloor"

/turf/open/floor/tiled/grey/asteroid/airless
	name = "airless dust-covered tiled floor"
	initial_gases = null
	temperature = TCMB

/turf/open/floor/tiled/grey/asteroid/airless/initialise()
	. = ..()
	name = "dust-covered tiled floor"

// White Tiles - The medical and science ones.
/turf/open/floor/tiled/white
	icon_state = "white"
	tile_path = /obj/item/stack/tile/metal/white

// Dark Tiles - The ominous ones.
/turf/open/floor/tiled/dark
	icon_state = "dark"
	tile_path = /obj/item/stack/tile/metal/dark

/turf/open/floor/tiled/dark/server
	name = "server walkway"
	initial_gases = list(/decl/xgm_gas/nitrogen = 500)
	temperature = 80

/turf/open/floor/tiled/dark/mainframe
	name = "mainframe floor"
	initial_gases = list(/decl/xgm_gas/nitrogen = 100)
	temperature = 80

// Dark Chapel Tiles - The religiously ominous ones.
/turf/open/floor/tiled/dark_chapel
	icon_state = "darkchapel"
	tile_path = /obj/item/stack/tile/metal/dark_chapel

// Freezer Tiles - The chilly ones.
/turf/open/floor/tiled/freezer
	icon_state = "freezerfloor"
	tile_path = /obj/item/stack/tile/metal/freezer

// Showroom Tiles - The fancy ones.
/turf/open/floor/tiled/showroom
	icon_state = "showroomfloor"
	tile_path = /obj/item/stack/tile/metal/showroom

// Hydroponics Tiles - The slightly green ones.
/turf/open/floor/tiled/hydroponics
	icon_state = "hydrofloor"
	tile_path = /obj/item/stack/tile/metal/hydroponics

// Cafeteria Tiles - The kitchen ones.
/turf/open/floor/tiled/cafeteria
	icon_state = "cafeteria"
	tile_path = /obj/item/stack/tile/metal/cafeteria

// Science Tiles - The purple and white ones.
/turf/open/floor/tiled/science
	icon_state = "science"
	tile_path = /obj/item/stack/tile/metal/science