/* Diffrent misc types of tiles
 * Contains:
 *		Grass
 *		Wood
 *		Carpet
 */

/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "grass tile"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they often use on golf courses."
	icon_state = "tile_grass"
	force = 1
	throwforce = 1
	throw_speed = 5
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCT
	origin_tech = list(RESEARCH_TECH_BIOTECH = 1)
	turf_path = /turf/simulated/floor/grass

/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wood floor tile"
	singular_name = "wood floor tile"
	desc = "An easy to fit wooden floor tile."
	icon_state = "tile-wood"
	force = 1
	throwforce = 1
	throw_speed = 5
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCT
	turf_path = /turf/simulated/floor/wood

/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "carpet"
	singular_name = "carpet"
	desc = "A piece of carpet. It is the same size as a normal floor tile!"
	icon_state = "tile-carpet"
	force = 1
	throwforce = 1
	throw_speed = 5
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCT
	turf_path = /turf/simulated/floor/carpet