/*
 * Iron Sand
 */
/turf/open/floor/plating/iron_sand
	name = "iron sand"
	icon_state = "ironsand1"

/turf/open/floor/plating/iron_sand/initialise()
	. = ..()
	icon_state = "ironsand[rand(1, 15)]"

/*
 * Snow
 */
/turf/open/floor/plating/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/open/floor/plating/snow/ex_act(severity)
	return