/*
 * Plating
 */
/turf/simulated/floor/plating
	name = "plating"
	icon_state = "plating"
	plane = PLATING_PLANE

	tile_path = null
	intact = FALSE

/turf/simulated/floor/plating/attack_tool(obj/item/tool, mob/user)
	if(iswire(tool))
		var/obj/item/stack/cable_coil/coil = tool
		coil.turf_place(src, user)
		return TRUE

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

/turf/simulated/floor/plating/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if(R.amount >= 2)
			to_chat(user, SPAN_INFO("Reinforcing the floor..."))
			if(do_after(user, 3 SECONDS) && R && R.amount >= 2)
				make_floor(/turf/simulated/floor/reinforced)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				R.use(2)
				return TRUE
		else
			to_chat(user, SPAN_WARNING("You need more rods."))
		return TRUE

	if(istype(I, /obj/item/stack/tile))
		if(!broken && !burnt)
			var/obj/item/stack/tile/tile_stack = I
			tile_stack.use(1)
			var/turf/simulated/floor/new_floor = make_floor(tile_stack.turf_path)
			if(istype(tile_stack, /obj/item/stack/tile/light))
				var/obj/item/stack/tile/light/light_stack = tile_stack
				var/turf/simulated/floor/light/light_floor = new_floor
				light_floor.set_state(light_stack.state)
				light_floor.set_on(light_stack.on)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		else
			to_chat(user, SPAN_WARNING("This section is too damaged to support a tile. Use a welder to fix the damage."))
		return TRUE
	return ..()

/turf/simulated/floor/plating/update_icon()
	. = ..()
	if(!.)
		return FALSE
	if(broken || burnt)
		return FALSE

	icon_state = icon_plating // Because asteroids are 'platings' too.

/turf/simulated/floor/plating/break_tile()
	. = ..()
	if(.)
		icon_state = "platingdmg[pick(1, 2, 3)]"

/turf/simulated/floor/plating/burn_tile()
	. = ..()
	if(.)
		icon_state = "panelscorched"

/turf/simulated/floor/plating/make_plating()
	return // You can't make plating into plating.

// Airless
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