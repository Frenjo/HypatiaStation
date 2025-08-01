/obj/machinery/door/firedoor
	name = "emergency shutter"
	desc = "Emergency air-tight shutter, capable of sealing off breached areas."
	icon = 'icons/obj/doors/emergency/hazard.dmi'
	icon_state = "door_open"
	layer = 2
	opacity = FALSE
	density = FALSE

	req_one_access = list(ACCESS_ATMOSPHERICS, ACCESS_ENGINE_EQUIP)

	//These are frequenly used with windows, so make sure zones can pass.
	//Generally if a firedoor is at a place where there should be a zone boundery then there will be a regular door underneath it.
	block_air_zones = 0

	var/blocked = 0
	var/nextstate = null
	var/net_id
	var/list/area/areas_added
	var/list/users_to_open

/obj/machinery/door/firedoor/New()
	. = ..()
	for(var/obj/machinery/door/firedoor/F in loc)
		if(F != src)
			spawn(1)
				qdel(src)
			return
	var/area/A = GET_AREA(src)
	ASSERT(istype(A))

	A.doors_list.Add(src)
	areas_added = list(A)

	for(var/direction in GLOBL.cardinal)
		A = GET_AREA(get_step(src, direction))
		if(istype(A) && !(A in areas_added))
			A.doors_list.Add(src)
			areas_added.Add(A)

/obj/machinery/door/firedoor/Destroy()
	for_no_type_check(var/area/A, areas_added)
		areas_added.Remove(A)
		A.doors_list.Remove(src)
	return ..()

/obj/machinery/door/firedoor/get_examine_text()
	. = ..()
	if(!length(users_to_open))
		return
	var/users_to_open_string = users_to_open[1]
	if(length(users_to_open) >= 2)
		for(var/i = 2 to length(users_to_open))
			users_to_open_string += ", <em>[users_to_open[i]]</em>"
	. += "These people have opened \the [src] during an alert: [users_to_open_string]."

/obj/machinery/door/firedoor/Bumped(atom/AM)
	if(p_open || operating)
		return
	if(!density)
		return ..()
	if(ismecha(AM))
		var/obj/mecha/mecha = AM
		if(mecha.occupant)
			var/mob/M = mecha.occupant
			if(world.time - M.last_bumped <= 10)
				return //Can bump-open one airlock per second. This is to prevent popup message spam.
			M.last_bumped = world.time
			attack_hand(M)
	return 0

/obj/machinery/door/firedoor/power_change()
	if(powered(ENVIRON))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER
	return

/obj/machinery/door/firedoor/attack_hand(mob/user)
	add_fingerprint(user)
	if(operating)
		return//Already doing something.

	if(blocked)
		to_chat(user, SPAN_WARNING("\The [src] is welded solid!"))
		return

	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user)
		return

	var/alarmed = 0

	for(var/area/A in areas_added)		//Checks if there are fire alarms in any areas associated with that firedoor
		if(A.fire_alarm || A.air_doors_activated)
			alarmed = 1

	var/answer = alert(user, "Would you like to [density ? "open" : "close"] this [name]?[ alarmed && density ? "\nNote that by doing so, you acknowledge any damages from opening this\n[name] as being your own fault, and you will be held accountable under the law." : ""]",\
	"\The [src]", "Yes, [density ? "open" : "close"]", "No")
	if(answer == "No")
		return
	if(user.stat || user.stunned || user.weakened || user.paralysis || (!user.canmove && !isAI(user)) || (!in_range(src, user) && !issilicon(user)))
		to_chat(user, "Sorry, you must remain able bodied and close to \the [src] in order to use it.")
		return

	var/needs_to_close = 0
	if(density)
		if(alarmed)
			needs_to_close = 1
		spawn()
			open()
	else
		spawn()
			close()

	if(needs_to_close)
		spawn(50)
			alarmed = 0
			for(var/area/A in areas_added)		//Just in case a fire alarm is turned off while the firedoor is going through an autoclose cycle
				if(A.fire_alarm || A.air_doors_activated)
					alarmed = 1
			if(alarmed)
				nextstate = DOOR_CLOSED
				close()

/obj/machinery/door/firedoor/attackby(obj/item/C, mob/user)
	add_fingerprint(user)
	if(operating)
		return//Already doing something.
	if(iswelder(C))
		var/obj/item/weldingtool/W = C
		if(W.remove_fuel(0, user))
			blocked = !blocked
			user.visible_message(
				SPAN_WARNING("\The [user] [blocked ? "welds" : "unwelds"] \the [src] with \a [W]."),
				"You [blocked ? "weld" : "unweld"] \the [src] with \the [W].",
				"You hear something being welded."
			)
			update_icon()
			return

	if(blocked)
		to_chat(user, SPAN_WARNING("\The [src] is welded solid!"))
		return

	if(iscrowbar(C) || (istype(C, /obj/item/twohanded/fireaxe) && C:wielded == 1))
		if(operating)
			return

		if(blocked && iscrowbar(C))
			user.visible_message(
				SPAN_WARNING("\The [user] pries at \the [src] with \a [C], but \the [src] is welded in place!"),
				"You try to pry \the [src] [density ? "open" : "closed"], but it is welded in place!",
				"You hear someone struggle and metal straining."
			)
			return

		user.visible_message(
			SPAN_WARNING("\The [user] starts to force \the [src] [density ? "open" : "closed"] with \a [C]!"),
			"You start forcing \the [src] [density ? "open" : "closed"] with \the [C]!",
			"You hear metal strain."
			)
		if(do_after(user, 30))
			if(iscrowbar(C))
				if(stat & (BROKEN|NOPOWER) || !density)
					user.visible_message(
						SPAN_WARNING("\The [user] forces \the [src] [density ? "open" : "closed"] with \a [C]!"),
						"You force \the [src] [density ? "open" : "closed"] with \the [C]!",
						"You hear metal strain, and a door [density ? "open" : "close"]."
					)
			else
				user.visible_message(
					SPAN_WARNING("\The [user] forces \the [ blocked ? "welded" : "" ] [src] [density ? "open" : "closed"] with \a [C]!"),
					"You force \the [ blocked ? "welded" : "" ] [src] [density ? "open" : "closed"] with \the [C]!",
					"You hear metal strain and groan, and a door [density ? "open" : "close"]."
				)
			if(density)
				spawn(0)
					open()
			else
				spawn(0)
					close()
			return

/obj/machinery/door/firedoor/proc/latetoggle()
	if(operating || stat & NOPOWER || !nextstate)
		return
	switch(nextstate)
		if(DOOR_OPEN)
			nextstate = null
			open()
		if(DOOR_CLOSED)
			nextstate = null
			close()
	return

/obj/machinery/door/firedoor/close()
	latetoggle()
	return ..()

/obj/machinery/door/firedoor/open()
	latetoggle()
	return ..()

/obj/machinery/door/firedoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("door_opening", src)
		if("closing")
			flick("door_closing", src)
	return

/obj/machinery/door/firedoor/update_icon()
	cut_overlays()
	if(density)
		icon_state = "door_closed"
		if(blocked)
			add_overlay("welded")
	else
		icon_state = "door_open"
		if(blocked)
			add_overlay("welded_open")
	return

//These are playing merry hell on ZAS.  Sorry fellas :(
/obj/machinery/door/firedoor/border_only
/*
	icon = 'icons/obj/doors/edge_Doorfire.dmi'
	glass = 1 //There is a glass window so you can see through the door
			  //This is needed due to BYOND limitations in controlling visibility
	heat_proof = 1
	air_properties_vary_with_direction = 1

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
			return 1
		if(get_dir(loc, target) == dir) //Make sure looking at appropriate border
			if(air_group) return 0
			return !density
		else
			return 1

	CheckExit(atom/movable/move, turf/target)
		if(istype(mover) && mover.checkpass(PASS_FLAG_GLASS))
			return 1
		if(get_dir(loc, target) == dir)
			return !density
		else
			return 1


	update_nearby_tiles(need_rebuild)
		if(!air_master) return 0

		var/turf/open/source = loc
		var/turf/open/destination = get_step(source,dir)

		update_heat_protection(loc)

		if(istype(source)) air_master.tiles_to_update += source
		if(istype(destination)) air_master.tiles_to_update += destination
		return 1
*/

/obj/machinery/door/firedoor/multi_tile
	icon = 'icons/obj/doors/emergency/hazard_2x1.dmi'
	width = 2