/*
 * Clown Items
 * Contains:
 *	Banana Peel
 *	Soap
 *	Bike Horn
 */
// Banana Peel
/obj/item/bananapeel
	name = "banana peel"
	desc = "A peel from a banana."
	icon = 'icons/obj/items.dmi'
	icon_state = "banana_peel"
	item_state = "banana_peel"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/bananapeel/Crossed(atom/movable/AM)
	if(iscarbon(AM))
		var/mob/M =	AM
		if(ishuman(M))
			var/mob/living/carbon/human/human = M
			if(isobj(human.shoes) && HAS_ITEM_FLAGS(human.shoes, ITEM_FLAG_NO_SLIP))
				return

		M.stop_pulling()
		to_chat(M, SPAN_INFO("You slipped on the [name]!"))
		playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
		M.Stun(4)
		M.Weaken(2)

// Soap
/obj/item/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/soap/Crossed(atom/movable/AM) //EXACTLY the same as bananapeel for now, so it makes sense to put it in the same dm -- Urist
	if(iscarbon(AM))
		var/mob/M =	AM
		if(ishuman(M))
			var/mob/living/carbon/human/human = M
			if(isobj(human.shoes) && HAS_ITEM_FLAGS(human.shoes, ITEM_FLAG_NO_SLIP))
				return

		M.stop_pulling()
		to_chat(M, SPAN_INFO("You slipped on the [name]!"))
		playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
		M.Stun(3)
		M.Weaken(2)

/obj/item/soap/nanotrasen
	desc = "A NanoTrasen brand bar of soap. Smells of plasma."
	icon_state = "soapnt"

/obj/item/soap/deluxe
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of condoms."
	icon_state = "soapdeluxe"

/obj/item/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"

/obj/item/soap/afterattack(atom/target, mob/user, proximity)
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

/obj/item/soap/attack(mob/target, mob/user)
	if(target && user && ishuman(target) && ishuman(user) && !target.stat && !user.stat && user.zone_sel &&user.zone_sel.selecting == "mouth")
		user.visible_message(SPAN_WARNING("\the [user] washes \the [target]'s mouth out with soap!"))
		return
	..()

// Bike Horn
/obj/item/bikehorn
	name = "bike horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/items.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 15
	attack_verb = list("HONKED")

	var/spam_flag = 0

/obj/item/bikehorn/attack_self(mob/user)
	if(spam_flag == 0)
		spam_flag = 1
		playsound(src, 'sound/items/bikehorn.ogg', 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return