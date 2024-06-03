/*
 * Metal Plating
 */
/turf/simulated/floor/plating/metal
	name = "metal plating"

	icon_state = "plating"

/turf/simulated/floor/plating/metal/attack_tool(obj/item/tool, mob/user)
	if(iswelder(tool))
		var/obj/item/weldingtool/welder = tool
		if(welder.isOn())
			if(broken || burnt)
				if(welder.remove_fuel(0, user))
					to_chat(user, SPAN_WARNING("You fix some dents on the broken plating."))
					playsound(src, 'sound/items/Welder.ogg', 80, 1)
					icon_state = "plating"
					burnt = 0
					broken = 0
				else
					FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
		return TRUE
	return ..()

/turf/simulated/floor/plating/metal/break_tile()
	. = ..()
	if(.)
		icon_state = "platingdmg[pick(1, 2, 3)]"

/turf/simulated/floor/plating/metal/burn_tile()
	. = ..()
	if(.)
		icon_state = "panelscorched"

// Airless
/turf/simulated/floor/plating/metal/airless
	name = "airless metal plating"
	initial_gases = null
	temperature = TCMB

/turf/simulated/floor/plating/metal/airless/New()
	. = ..()
	name = "metal plating"

/*
 * Asteroid Plating
 *
 * Basically the default metal plating sprite but with asteroid-esque and stuff on it.
 */
/turf/simulated/floor/plating/metal/asteroid
	name = "dust-covered metal plating"
	icon_state = "asteroidplating"

// Airless
/turf/simulated/floor/plating/metal/asteroid/airless
	name = "airless dust-covered metal plating"
	initial_gases = null
	temperature = TCMB

/turf/simulated/floor/plating/metal/asteroid/airless/New()
	. = ..()
	name = "dust-covered metal plating"

/*
 * Shuttle Plating
 */
/turf/simulated/floor/plating/metal/shuttle
	name = "shuttle plating"

	explosion_resistance = 1

// Airless
/turf/simulated/floor/plating/metal/shuttle/airless
	name = "airless shuttle plating"
	initial_gases = null
	temperature = TCMB

	explosion_resistance = 1

/turf/simulated/floor/plating/metal/shuttle/airless/New()
	. = ..()
	name = "shuttle plating"