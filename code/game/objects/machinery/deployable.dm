/*
 * CONTAINS:
 *
 * Deployable items
 * Barricades
 *
 * For access references, see code/game/datums/access/_access.dm.
*/

//Barricades, maybe there will be a metal one later...
/obj/structure/barricade/wooden
	name = "wooden barricade"
	desc = "This space is blocked off by a wooden barricade."
	icon_state = "woodenbarricade"
	anchored = TRUE
	density = TRUE

	var/health = 100.0
	var/maxhealth = 100.0

/obj/structure/barricade/wooden/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/stack/sheet/wood))
		if (src.health < src.maxhealth)
			visible_message("\red [user] begins to repair \the [src]!")
			if(do_after(user,20))
				src.health = src.maxhealth
				W:use(1)
				visible_message("\red [user] repairs \the [src]!")
				return
		else
			return
		return
	else
		switch(W.damtype)
			if("fire")
				src.health -= W.force * 1
			if("brute")
				src.health -= W.force * 0.75
			else
		if (src.health <= 0)
			visible_message("\red <B>The barricade is smashed apart!</B>")
			var/turf/T = GET_TURF(src)
			new /obj/item/stack/sheet/wood(T)
			new /obj/item/stack/sheet/wood(T)
			new /obj/item/stack/sheet/wood(T)
			qdel(src)
		..()

/obj/structure/barricade/wooden/ex_act(severity)
	switch(severity)
		if(1.0)
			visible_message("\red <B>The barricade is blown apart!</B>")
			qdel(src)
			return
		if(2.0)
			src.health -= 25
			if (src.health <= 0)
				visible_message("\red <B>The barricade is blown apart!</B>")
				var/turf/T = GET_TURF(src)
				new /obj/item/stack/sheet/wood(T)
				new /obj/item/stack/sheet/wood(T)
				new /obj/item/stack/sheet/wood(T)
				qdel(src)
			return

/obj/structure/barricade/wooden/meteorhit()
	visible_message("\red <B>The barricade is smashed apart!</B>")
	var/turf/T = GET_TURF(src)
	new /obj/item/stack/sheet/wood(T)
	new /obj/item/stack/sheet/wood(T)
	new /obj/item/stack/sheet/wood(T)
	qdel(src)
	return

/obj/structure/barricade/wooden/blob_act()
	src.health -= 25
	if (src.health <= 0)
		visible_message("\red <B>The blob eats through the barricade!</B>")
		qdel(src)
	return

/obj/structure/barricade/wooden/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0) //So bullets will fly over and stuff.
	if(air_group || height == 0)
		return TRUE
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_TABLE))
		return TRUE
	else
		return FALSE


//Actual Deployable machinery stuff

/obj/machinery/deployable
	name = "deployable"
	desc = "deployable"
	icon = 'icons/obj/objects.dmi'
	req_access = list(ACCESS_SECURITY)//I'm changing this until these are properly tested./N

/obj/machinery/deployable/barrier
	name = "deployable barrier"
	desc = "A deployable barrier. Swipe your ID card to lock/unlock it."
	icon = 'icons/obj/objects.dmi'
	anchored = FALSE
	density = TRUE
	icon_state = "barrier0"
	var/health = 100.0
	var/maxhealth = 100.0
	var/locked = 0.0
//	req_access = list(access_maint_tunnels)

/obj/machinery/deployable/barrier/New()
	..()

	src.icon_state = "barrier[src.locked]"

/obj/machinery/deployable/barrier/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged == 0)
		emagged = 1
		req_access.Cut()
		req_one_access.Cut()
		to_chat(user, SPAN_WARNING("You break the ID authentication lock on \the [src]."))
		make_sparks(2, TRUE, src)
		visible_message(SPAN_WARNING("BZZzZZzZZzZT"))
		return TRUE
	else if(emagged == 1)
		emagged = 2
		to_chat(user, SPAN_WARNING("You short out the anchoring mechanism on \the [src]."))
		make_sparks(2, TRUE, src)
		visible_message(SPAN_WARNING("BZZzZZzZZzZT"))
		return TRUE

	return FALSE

/obj/machinery/deployable/barrier/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/card/id/))
		if (src.allowed(user))
			if	(src.emagged < 2.0)
				src.locked = !src.locked
				src.anchored = !src.anchored
				src.icon_state = "barrier[src.locked]"
				if((src.locked == 1.0) && (src.emagged < 2.0))
					to_chat(user, SPAN_INFO("You lock \the [src]."))
					return
				else if((src.locked == 0.0) && (src.emagged < 2.0))
					to_chat(user, SPAN_INFO("You unlock \the [src]."))
					return
			else
				make_sparks(2, TRUE, src)
				visible_message("\red BZZzZZzZZzZT")
				return
		return
	else if(iswrench(W))
		if (src.health < src.maxhealth)
			src.health = src.maxhealth
			src.emagged = 0
			src.req_access = list(ACCESS_SECURITY)
			visible_message("\red [user] repairs \the [src]!")
			return
		else if (src.emagged > 0)
			src.emagged = 0
			src.req_access = list(ACCESS_SECURITY)
			visible_message("\red [user] repairs \the [src]!")
			return
		return
	else
		switch(W.damtype)
			if("fire")
				src.health -= W.force * 0.75
			if("brute")
				src.health -= W.force * 0.5
			else
		if (src.health <= 0)
			src.explode()
		..()

/obj/machinery/deployable/barrier/ex_act(severity)
	switch(severity)
		if(1.0)
			src.explode()
			return
		if(2.0)
			src.health -= 25
			if (src.health <= 0)
				src.explode()
			return

/obj/machinery/deployable/barrier/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		return
	if(prob(50/severity))
		locked = !locked
		anchored = !anchored
		icon_state = "barrier[src.locked]"

/obj/machinery/deployable/barrier/meteorhit()
	src.explode()
	return

/obj/machinery/deployable/barrier/blob_act()
	src.health -= 25
	if (src.health <= 0)
		src.explode()
	return

/obj/machinery/deployable/barrier/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0) //So bullets will fly over and stuff.
	if(air_group || height == 0)
		return TRUE
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_TABLE))
		return TRUE
	else
		return FALSE

/obj/machinery/deployable/barrier/proc/explode()
	visible_message("\red <B>[src] blows apart!</B>")

/*	var/obj/item/stack/rods/ =*/
	new /obj/item/stack/rods(GET_TURF(src))

	make_sparks(3, TRUE, src)

	explosion(src.loc,-1,-1,0)
	if(src)
		qdel(src)