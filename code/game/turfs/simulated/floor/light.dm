/*
 * Light
 */
/turf/simulated/floor/light
	name = "light floor"
	light_range = 5
	icon_state = "light_on"
	floor_type = /obj/item/stack/tile/light

/turf/simulated/floor/light/initialise()
	. = ..()
	name = initial(name) // Just in case commands rename it in the ..() call.

/turf/simulated/floor/light/attack_hand(mob/user)
	toggle_on()
	update_icon()

/turf/simulated/floor/light/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/light/bulb)) //only for light tiles
		if(get_lightfloor_state())
			user.drop_item(I)
			qdel(I)
			set_lightfloor_state(0) //fixing it by bashing it with a light bulb, fun eh?
			update_icon()
			to_chat(user, SPAN_INFO("You replace the light bulb."))
		else
			to_chat(user, SPAN_WARNING("The lightbulb seems fine, no need to replace it."))
		return TRUE
	return ..()

/turf/simulated/floor/light/update_icon()
	if(get_lightfloor_on())
		switch(get_lightfloor_state())
			if(LIGHTFLOOR_STATE_OK)
				icon_state = "light_on"
				set_light(5)
			if(LIGHTFLOOR_STATE_FLICKER)
				var/num = pick("1","2","3","4")
				icon_state = "light_on_flicker[num]"
				set_light(5)
			if(LIGHTFLOOR_STATE_BREAKING)
				icon_state = "light_on_broken"
				set_light(5)
			if(LIGHTFLOOR_STATE_BROKEN)
				icon_state = "light_off"
				set_light(0)
	else
		set_light(0)
		icon_state = "light_off"

/turf/simulated/floor/light/break_tile()
	icon_state = "light_broken"
	broken = 1

/turf/simulated/floor/light/proc/toggle_on()
	lightfloor_state ^= LIGHTFLOOR_ON_BIT

#undef LIGHTFLOOR_STATE_OK
#undef LIGHTFLOOR_STATE_FLICKER
#undef LIGHTFLOOR_STATE_BREAKING
#undef LIGHTFLOOR_STATE_BROKEN
#undef LIGHTFLOOR_STATE_BITS

#undef LIGHTFLOOR_ON_BIT