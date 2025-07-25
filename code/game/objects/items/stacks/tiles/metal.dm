/*
 * Metal Floor Tiles
 */
/obj/item/stack/tile/metal
	desc = "These could work as a pretty decent throwing weapon!"
	force = 6
	matter_amounts = alist(/decl/material/steel = (MATERIAL_AMOUNT_PER_SHEET / 4))
	throwforce = 15
	throw_speed = 5
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCT

// Grey
/obj/item/stack/tile/metal/grey
	name = "grey floor tile"
	singular_name = "grey floor tile"
	icon_state = "grey"
	turf_path = /turf/open/floor/tiled/grey

/obj/item/stack/tile/metal/grey/proc/build(turf/T)
	if(isspace(T))
		T.ChangeTurf(/turf/open/floor/plating/metal/airless)
	else
		T.ChangeTurf(/turf/open/floor/plating/metal)
	return

// White
/obj/item/stack/tile/metal/white
	name = "white floor tile"
	singular_name = "white floor tile"
	icon_state = "white"
	turf_path = /turf/open/floor/tiled/white

// Dark
/obj/item/stack/tile/metal/dark
	name = "dark floor tile"
	singular_name = "dark floor tile"
	icon_state = "dark"
	turf_path = /turf/open/floor/tiled/dark

// Dark Chapel
/obj/item/stack/tile/metal/dark_chapel
	name = "dark chapel floor tile"
	singular_name = "dark chapel floor tile"
	icon_state = "dark_chapel"
	turf_path = /turf/open/floor/tiled/dark_chapel

// Freezer
/obj/item/stack/tile/metal/freezer
	name = "freezer floor tile"
	singular_name = "freezer floor tile"
	icon_state = "freezer"
	turf_path = /turf/open/floor/tiled/freezer

// Showroom
/obj/item/stack/tile/metal/showroom
	name = "showroom floor tile"
	singular_name = "showroom floor tile"
	icon_state = "showroom"
	turf_path = /turf/open/floor/tiled/showroom

// Hydroponics
/obj/item/stack/tile/metal/hydroponics
	name = "hydroponics floor tile"
	singular_name = "hydroponics floor tile"
	icon_state = "hydroponics"
	turf_path = /turf/open/floor/tiled/hydroponics

// Cafeteria
/obj/item/stack/tile/metal/cafeteria
	name = "cafeteria floor tile"
	singular_name = "cafeteria floor tile"
	icon_state = "cafeteria"
	turf_path = /turf/open/floor/tiled/cafeteria

// Science
/obj/item/stack/tile/metal/science
	name = "science floor tile"
	singular_name = "science floor tile"
	icon_state = "science"
	turf_path = /turf/open/floor/tiled/science