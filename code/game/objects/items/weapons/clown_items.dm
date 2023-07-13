/* Clown Items
 * Contains:
 * 		Banana Peels
 *		Soap
 *		Bike Horns
 */

/*
 * Banana Peals
 */
/obj/item/bananapeel/Crossed(AM as mob|obj)
	if(iscarbon(AM))
		var/mob/M =	AM
		if(ishuman(M))
			var/mob/living/carbon/human/human = M
			if(isobj(human.shoes) && (human.shoes.flags & NOSLIP))
				return

		M.stop_pulling()
		to_chat(M, SPAN_INFO("You slipped on the [name]!"))
		playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
		M.Stun(4)
		M.Weaken(2)


/*
 * Soap
 */
/obj/item/soap/Crossed(AM as mob|obj) //EXACTLY the same as bananapeel for now, so it makes sense to put it in the same dm -- Urist
	if(iscarbon(AM))
		var/mob/M =	AM
		if(ishuman(M))
			var/mob/living/carbon/human/human = M
			if(isobj(human.shoes) && (human.shoes.flags & NOSLIP))
				return

		M.stop_pulling()
		to_chat(M, SPAN_INFO("You slipped on the [name]!"))
		playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
		M.Stun(3)
		M.Weaken(2)

/obj/item/soap/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity)
		return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		to_chat(user, SPAN_NOTICE("You need to take that [target.name] off before cleaning it."))
	else if(istype(target, /obj/effect/decal/cleanable))
		to_chat(user, SPAN_NOTICE("You scrub \the [target.name] out."))
		qdel(target)
	else
		to_chat(user, SPAN_NOTICE("You clean \the [target.name]."))
		target.clean_blood()
	return

/obj/item/soap/attack(mob/target as mob, mob/user as mob)
	if(target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_sel &&user.zone_sel.selecting == "mouth")
		user.visible_message(SPAN_WARNING("\the [user] washes \the [target]'s mouth out with soap!"))
		return
	..()


/*
 * Bike Horns
 */
/obj/item/bikehorn/attack_self(mob/user as mob)
	if(spam_flag == 0)
		spam_flag = 1
		playsound(src, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return