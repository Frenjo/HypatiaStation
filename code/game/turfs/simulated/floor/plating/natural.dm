/*
 * Iron Sand
 */
/turf/simulated/floor/plating/iron_sand
	name = "iron sand"
	icon_state = "ironsand1"

/turf/simulated/floor/plating/iron_sand/New()
	. = ..()
	icon_state = "ironsand[rand(1, 15)]"

/*
 * Snow
 */
/turf/simulated/floor/plating/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/simulated/floor/plating/snow/ex_act(severity)
	return