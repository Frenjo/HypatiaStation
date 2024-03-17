/*
 * Light
 */
#define LIGHTFLOOR_ON_BIT 4

#define LIGHTFLOOR_STATE_OK 0
#define LIGHTFLOOR_STATE_FLICKER 1
#define LIGHTFLOOR_STATE_BREAKING 2
#define LIGHTFLOOR_STATE_BROKEN 3
#define LIGHTFLOOR_STATE_BITS 3

/turf/simulated/floor/light
	name = "light floor"
	light_range = 5
	icon_state = "light_on"
	tile_path = /obj/item/stack/tile/light

	var/state // The state of the tile. 0-7, 0x4 is on-bit - use the helper procs below

/turf/simulated/floor/light/initialise()
	. = ..()
	name = initial(name) // Just in case commands rename it in the ..() call.

/turf/simulated/floor/light/attack_hand(mob/user)
	toggle_on()
	update_icon()

/turf/simulated/floor/light/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/light/bulb)) //only for light tiles
		if(get_state())
			user.drop_item(I)
			qdel(I)
			set_state(0) //fixing it by bashing it with a light bulb, fun eh?
			update_icon()
			to_chat(user, SPAN_INFO("You replace the light bulb."))
		else
			to_chat(user, SPAN_WARNING("The lightbulb seems fine, no need to replace it."))
		return TRUE
	return ..()

/turf/simulated/floor/light/update_icon()
	if(get_on())
		switch(get_state())
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

/turf/simulated/floor/light/proc/get_state()
	return state & LIGHTFLOOR_STATE_BITS

/turf/simulated/floor/light/proc/get_on()
	return state & LIGHTFLOOR_ON_BIT

/turf/simulated/floor/light/proc/set_state(n)
	state = get_on() | (n & LIGHTFLOOR_STATE_BITS)

/turf/simulated/floor/light/proc/set_on(n)
	if(n)
		state |= LIGHTFLOOR_ON_BIT
	else
		state &= ~LIGHTFLOOR_ON_BIT

/turf/simulated/floor/light/proc/toggle_on()
	state ^= LIGHTFLOOR_ON_BIT

#undef LIGHTFLOOR_STATE_OK
#undef LIGHTFLOOR_STATE_FLICKER
#undef LIGHTFLOOR_STATE_BREAKING
#undef LIGHTFLOOR_STATE_BROKEN
#undef LIGHTFLOOR_STATE_BITS

#undef LIGHTFLOOR_ON_BIT