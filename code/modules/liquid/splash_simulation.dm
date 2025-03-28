#define LIQUID_TRANSFER_THRESHOLD 0.05

var/liquid_delay = 4

var/list/datum/puddle/puddles = list()

/datum/puddle
	var/list/obj/effect/liquid/liquid_objects = list()

/datum/puddle/proc/process()
	//to_world("DEBUG: Puddle process!")
	for_no_type_check(var/obj/effect/liquid/L, liquid_objects)
		L.spread()

	for_no_type_check(var/obj/effect/liquid/L, liquid_objects)
		L.apply_calculated_effect()

	if(!length(liquid_objects))
		qdel(src)

/datum/puddle/New()
	. = ..()
	puddles.Add(src)

/datum/puddle/Destroy()
	puddles.Remove(src)
	for_no_type_check(var/obj/effect/liquid/L, liquid_objects)
		liquid_objects.Remove(L)
		qdel(L)
	return ..()

/client/proc/splash()
	set category = PANEL_DEBUG

	var/volume = input("Volume?","Volume?", 0 ) as num
	if(!isnum(volume)) return
	if(volume <= LIQUID_TRANSFER_THRESHOLD) return
	var/turf/T = GET_TURF(mob)
	if(!isturf(T)) return
	trigger_splash(T, volume)

/proc/trigger_splash(turf/epicenter, volume)
	if(!epicenter)
		return
	if(volume <= 0)
		return

	var/obj/effect/liquid/L = new/obj/effect/liquid(epicenter)
	L.volume = volume
	L.update_icon2()
	var/datum/puddle/P = new/datum/puddle()
	P.liquid_objects.Add(L)
	L.controller = P




/obj/effect/liquid
	icon = 'icons/effects/liquid.dmi'
	icon_state = "0"
	name = "liquid"
	var/volume = 0
	var/new_volume = 0
	var/datum/puddle/controller

/obj/effect/liquid/New()
	..()
	if( !isturf(loc) )
		qdel(src)

	for( var/obj/effect/liquid/L in loc )
		if(L != src)
			qdel(L)

/obj/effect/liquid/proc/spread()
	//to_world("DEBUG: liquid spread!")
	var/surrounding_volume = 0
	var/list/spread_directions = list(1,2,4,8)
	var/turf/loc_turf = loc
	for(var/direction in spread_directions)
		var/turf/T = get_step(src,direction)
		if(!T)
			spread_directions.Remove(direction)
			//to_world("ERROR: Map edge!")
			continue //Map edge
		if(!loc_turf.can_leave_liquid(direction)) //Check if this liquid can leave the tile in the direction
			spread_directions.Remove(direction)
			continue
		if(!T.can_accept_liquid(turn(direction,180))) //Check if this liquid can enter the tile
			spread_directions.Remove(direction)
			continue
		var/obj/effect/liquid/L = locate(/obj/effect/liquid) in T
		if(L)
			if(L.volume >= src.volume)
				spread_directions.Remove(direction)
				continue
			surrounding_volume += L.volume //If liquid already exists, add it's volume to our sum
		else
			var/obj/effect/liquid/NL = new(T) //Otherwise create a new object which we'll spread to.
			NL.controller = src.controller
			controller.liquid_objects.Add(NL)

	if(!length(spread_directions))
		//to_world("ERROR: No candidate to spread to.")
		return //No suitable candidate to spread to

	var/average_volume = (src.volume + surrounding_volume) / (length(spread_directions) + 1) //Average amount of volume on this and the surrounding tiles.
	var/volume_difference = src.volume - average_volume //How much more/less volume this tile has than the surrounding tiles.
	if(volume_difference <= (length(spread_directions) * LIQUID_TRANSFER_THRESHOLD)) //If we have less than the threshold excess liquid - then there is nothing to do as other tiles will be giving us volume.or the liquid is just still.
		//to_world("ERROR: transfer volume lower than THRESHOLD!")
		return

	var/volume_per_tile = volume_difference / length(spread_directions)

	for(var/direction in spread_directions)
		var/turf/T = get_step(src,direction)
		if(!T)
			//to_world("ERROR: Map edge 2!")
			continue //Map edge
		var/obj/effect/liquid/L = locate(/obj/effect/liquid) in T
		if(L)
			src.volume -= volume_per_tile //Remove the volume from this tile
			L.new_volume = L.new_volume + volume_per_tile //Add it to the volume to the other tile

/obj/effect/liquid/proc/apply_calculated_effect()
	volume += new_volume

	if(volume < LIQUID_TRANSFER_THRESHOLD)
		qdel(src)
	new_volume = 0
	update_icon2()

/obj/effect/liquid/Move()
	return 0

/obj/effect/liquid/Destroy()
	controller.liquid_objects.Remove(src)
	return ..()

/obj/effect/liquid/proc/update_icon2()
	//icon_state = num2text( max(1,min(7,(floor(volume),10)/10)) )

	switch(volume)
		if(0 to 0.1)
			qdel(src)
		if(0.1 to 5)
			icon_state = "1"
		if(5 to 10)
			icon_state = "2"
		if(10 to 20)
			icon_state = "3"
		if(20 to 30)
			icon_state = "4"
		if(30 to 40)
			icon_state = "5"
		if(40 to 50)
			icon_state = "6"
		if(50 to INFINITY)
			icon_state = "7"

/turf/proc/can_accept_liquid(from_direction)
	return 0
/turf/proc/can_leave_liquid(from_direction)
	return 0

/turf/space/can_accept_liquid(from_direction)
	return 1
/turf/space/can_leave_liquid(from_direction)
	return 1

/turf/open/floor/can_accept_liquid(from_direction)
	for(var/obj/structure/window/W in src)
		if(W.dir in list(5,6,9,10))
			return 0
		if(W.dir & from_direction)
			return 0
	for(var/obj/O in src)
		if(!O.liquid_pass())
			return 0
	return 1

/turf/open/floor/can_leave_liquid(to_direction)
	for(var/obj/structure/window/W in src)
		if(W.dir in list(5,6,9,10))
			return 0
		if(W.dir & to_direction)
			return 0
	for(var/obj/O in src)
		if(!O.liquid_pass())
			return 0
	return 1

/turf/closed/wall/can_accept_liquid(from_direction)
	return 0
/turf/closed/wall/can_leave_liquid(from_direction)
	return 0

/obj/proc/liquid_pass()
	return 1

/obj/machinery/door/liquid_pass()
	return !density

#undef LIQUID_TRANSFER_THRESHOLD