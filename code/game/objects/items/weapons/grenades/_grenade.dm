/obj/item/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "grenade"
	item_state = "flashbang"
	w_class = 2
	throw_speed = 4
	throw_range = 20
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT

	var/active = 0
	var/det_time = 50

/obj/item/grenade/proc/clown_check(mob/living/user)
	if((MUTATION_CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("Huh? How does this thing work?"))

		activate(user)
		add_fingerprint(user)
		spawn(5)
			prime()
		return 0
	return 1


/*/obj/item/grenade/afterattack(atom/target, mob/user)
	if (istype(target, /obj/item/storage)) return ..() // Trying to put it in a full container
	if (istype(target, /obj/item/gun/grenadelauncher)) return ..()
	if((user.get_active_hand() == src) && (!active) && (clown_check(user)) && target.loc != src.loc)
		to_chat(user, SPAN_WARNING("You prime the [name]! [det_time/10] seconds!"))
		active = 1
		icon_state = initial(icon_state) + "_active"
		playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
		spawn(det_time)
			prime()
			return
		user.dir = get_dir(user, target)
		user.drop_item()
		var/t = (isturf(target) ? target : target.loc)
		walk_towards(src, t, 3)
	return*/


/obj/item/grenade/examine()
	set src in usr
	to_chat(usr, desc)
	if(det_time > 1)
		to_chat(usr, "The timer is set to [det_time / 10] seconds.")
		return
	to_chat(usr, "\The [src] is set for instant detonation.")


/obj/item/grenade/attack_self(mob/user)
	if(!active)
		if(clown_check(user))
			to_chat(user, SPAN_WARNING("You prime \the [name]! [det_time/10] seconds!"))

			activate(user)
			add_fingerprint(user)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
	return


/obj/item/grenade/proc/activate(mob/user)
	if(active)
		return

	if(user)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	icon_state = initial(icon_state) + "_active"
	active = 1
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	spawn(det_time)
		prime()
		return


/obj/item/grenade/proc/prime()
//	playsound(loc, 'sound/items/Welder2.ogg', 25, 1)
	var/turf/T = GET_TURF(src)
	T?.hotspot_expose(700,125)

/obj/item/grenade/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		switch(det_time)
			if(1)
				det_time = 1 SECOND
				to_chat(user, SPAN_NOTICE("You set \the [src] for 1 second detonation time."))
			if(1 SECOND)
				det_time = 3 SECONDS
				to_chat(user, SPAN_NOTICE("You set \the [src] for 3 second detonation time."))
			if(3 SECONDS)
				det_time = 5 SECONDS
				to_chat(user, SPAN_NOTICE("You set \the [src] for 5 second detonation time."))
			if(5 SECONDS)
				det_time = 1
				to_chat(user, SPAN_NOTICE("You set \the [src] for instant detonation."))
		add_fingerprint(user)
		return TRUE

	return ..()

/obj/item/grenade/attack_hand()
	walk(src, null, null)
	..()
	return

/obj/item/grenade/attack_paw(mob/user)
	return attack_hand(user)
