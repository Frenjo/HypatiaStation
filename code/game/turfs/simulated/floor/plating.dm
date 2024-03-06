/*
 * Plating
 */
/turf/simulated/floor/plating
	name = "plating"
	icon_state = "plating"
	plane = PLATING_PLANE

	floor_type = null
	intact = FALSE

/turf/simulated/floor/plating/airless
	name = "airless plating"
	initial_gases = null
	temperature = TCMB

/turf/simulated/floor/plating/airless/New()
	. = ..()
	name = "plating"

/*
 * Shuttle Plating
 */
/turf/simulated/floor/plating/shuttle
	explosion_resistance = 1

/turf/simulated/floor/plating/airless/shuttle
	explosion_resistance = 1

/*
 * Iron Sand
 */
/turf/simulated/floor/plating/ironsand/New()
	. = ..()
	name = "iron sand"
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