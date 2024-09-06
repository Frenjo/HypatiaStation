/*
 * Plating
 */
/turf/open/floor/plating
	name = "plating"
	plane = PLATING_PLANE

	tile_path = null
	intact = 0

/turf/open/floor/plating/attack_tool(obj/item/tool, mob/user)
	if(iscable(tool))
		var/obj/item/stack/cable_coil/coil = tool
		coil.turf_place(src, user)
		return TRUE
	return ..()

/turf/open/floor/plating/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if(R.amount >= 2)
			to_chat(user, SPAN_INFO("Reinforcing the floor..."))
			if(do_after(user, 3 SECONDS) && R && R.amount >= 2)
				make_floor(/turf/open/floor/reinforced)
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
			var/turf/open/floor/new_floor = make_floor(tile_stack.turf_path)
			if(istype(tile_stack, /obj/item/stack/tile/light))
				var/obj/item/stack/tile/light/light_stack = tile_stack
				var/turf/open/floor/light/light_floor = new_floor
				light_floor.set_state(light_stack.state)
				light_floor.set_on(light_stack.on)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
		else
			to_chat(user, SPAN_WARNING("This section is too damaged to support a tile. Use a welder to fix the damage."))
		return TRUE
	return ..()

/turf/open/floor/plating/update_icon()
	. = ..()
	if(!.)
		return FALSE
	if(broken || burnt)
		return FALSE

	icon_state = icon_plating // Because asteroids are 'platings' too.

/turf/open/floor/plating/make_plating()
	return // You can't make plating into plating.