/obj/structure/displaycase
	name = "display case"
	desc = "A display case for prized possessions. It taunts you to kick it."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassbox1"
	density = TRUE
	anchored = TRUE
	obj_flags = OBJ_FLAG_UNACIDABLE //Dissolving the case would also delete the gun.

	var/health = 30
	var/occupied = 1
	var/destroyed = 0

/obj/structure/displaycase/ex_act(severity)
	switch(severity)
		if (1)
			new /obj/item/shard( src.loc )
			if (occupied)
				new /obj/item/gun/energy/laser/captain( src.loc )
				occupied = 0
			qdel(src)
		if (2)
			if (prob(50))
				src.health -= 15
				src.healthcheck()
		if (3)
			if (prob(50))
				src.health -= 5
				src.healthcheck()


/obj/structure/displaycase/bullet_act(obj/projectile/bullet)
	if(bullet.damage_type == BRUTE || bullet.damage_type == BURN)
		health -= bullet.damage
	..()
	healthcheck()


/obj/structure/displaycase/blob_act()
	if (prob(75))
		new /obj/item/shard( src.loc )
		if (occupied)
			new /obj/item/gun/energy/laser/captain( src.loc )
			occupied = 0
		qdel(src)


/obj/structure/displaycase/meteorhit(obj/O)
		new /obj/item/shard( src.loc )
		new /obj/item/gun/energy/laser/captain( src.loc )
		qdel(src)


/obj/structure/displaycase/proc/healthcheck()
	if (src.health <= 0)
		if (!( src.destroyed ))
			src.density = FALSE
			src.destroyed = 1
			new /obj/item/shard( src.loc )
			playsound(src, "shatter", 70, 1)
			update_icon()
	else
		playsound(src, 'sound/effects/glass/glass_hit.ogg', 75, 1)
	return

/obj/structure/displaycase/update_icon()
	if(src.destroyed)
		src.icon_state = "glassboxb[src.occupied]"
	else
		src.icon_state = "glassbox[src.occupied]"
	return


/obj/structure/displaycase/attackby(obj/item/W, mob/user)
	src.health -= W.force
	src.healthcheck()
	..()
	return

/obj/structure/displaycase/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/structure/displaycase/attack_hand(mob/user)
	if(src.destroyed && src.occupied)
		new /obj/item/gun/energy/laser/captain( src.loc )
		to_chat(user, SPAN_INFO("You deactivate the hover field built into the case."))
		src.occupied = 0
		src.add_fingerprint(user)
		update_icon()
		return
	else
		to_chat(user, SPAN_WARNING("You kick the display case."))
		for(var/mob/O in oviewers())
			if((O.client && !( O.blinded )))
				to_chat(O, SPAN_WARNING("[user] kicks the display case."))
		src.health -= 2
		healthcheck()
		return
