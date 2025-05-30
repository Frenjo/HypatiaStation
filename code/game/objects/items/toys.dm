/* Toys!
 * Contains
 *		Balloons
 *		Fake telebeacon
 *		Fake singularity
 *		Toy gun
 *		Toy crossbow
 *		Toy swords
 *		Crayons
 *		Snap pops
 *		Water flower
 */
/obj/item/toy
	icon = 'icons/obj/items/toy.dmi'
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	force = 0

/*
 * Balloons
 */
/obj/item/toy/balloon
	name = "water balloon"
	desc = "A translucent balloon. There's nothing in it."
	icon_state = "waterballoon-e"
	item_state = "balloon-empty"

/obj/item/toy/balloon/New()
	. = ..()
	create_reagents(10)

/obj/item/toy/balloon/attack(mob/living/carbon/human/M, mob/user)
	return

/obj/item/toy/balloon/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if(istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src, A) <= 1)
		A.reagents.trans_to(src, 10)
		to_chat(user, SPAN_INFO("You fill the balloon with the contents of [A]."))
		src.desc = "A translucent balloon with some form of liquid sloshing around in it."
		src.update_icon()
	return

/obj/item/toy/balloon/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/reagent_holder/glass))
		if(O.reagents)
			if(O.reagents.total_volume < 1)
				to_chat(user, "The [O] is empty.")
			else if(O.reagents.total_volume >= 1)
				if(O.reagents.has_reagent("pacid", 1))
					to_chat(user, "The acid chews through the balloon!")
					O.reagents.reaction(user)
					qdel(src)
				else
					src.desc = "A translucent balloon with some form of liquid sloshing around in it."
					to_chat(user, SPAN_INFO("You fill the balloon with the contents of [O]."))
					O.reagents.trans_to(src, 10)
	src.update_icon()
	return

/obj/item/toy/balloon/throw_impact(atom/hit_atom)
	if(src.reagents.total_volume >= 1)
		src.visible_message(SPAN_WARNING("The [src] bursts!"), "You hear a pop and a splash.")
		var/turf/hit_turf = GET_TURF(hit_atom)
		reagents.reaction(hit_turf)
		for_no_type_check(var/atom/movable/mover, hit_turf)
			reagents.reaction(mover)
		src.icon_state = "burst"
		spawn(5)
			if(src)
				qdel(src)
	return

/obj/item/toy/balloon/update_icon()
	if(src.reagents.total_volume >= 1)
		icon_state = "waterballoon"
		item_state = "balloon"
	else
		icon_state = "waterballoon-e"
		item_state = "balloon-empty"

/obj/item/toy/syndicateballoon
	name = "syndicate balloon"
	desc = "There is a tag on the back that reads \"FUK NT!11!\"."
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	force = 0
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "syndballoon"
	item_state = "syndballoon"
	w_class = 4.0

/*
 * Fake telebeacon
 */
/obj/item/toy/blink
	name = "electronic blink toy game"
	desc = "Blink. Blink. Blink. Ages 8 and up."
	icon = 'icons/obj/items/devices/radio.dmi'
	icon_state = "beacon"
	item_state = "signaler"

/*
 * Fake singularity
 */
/obj/item/toy/spinningtoy
	name = "gravitational singularity"
	desc = "\"Singulo\" brand spinning toy."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "singularity_s1"

/*
 * Toy gun: Why isnt this an /obj/item/gun?
 */
/obj/item/toy/gun
	name = "cap gun"
	desc = "There are 0 caps left. Looks almost like the real thing! Ages 8 and up. Please recycle in an autolathe when you're out of caps!"
	icon = 'icons/obj/weapons/gun.dmi'
	icon_state = "revolver"
	item_state = "gun"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	w_class = 3.0
	matter_amounts = alist(/decl/material/steel = 10, /decl/material/plastic = 10)
	attack_verb = list("struck", "pistol whipped", "hit", "bashed")

	var/bullets = 7.0

/obj/item/toy/gun/examine()
	set src in usr
	src.desc = "There are [src.bullets] caps\s left. Looks almost like the real thing! Ages 8 and up."
	..()
	return

/obj/item/toy/gun/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/toy/ammo/gun))
		var/obj/item/toy/ammo/gun/A = I
		if(bullets >= 7)
			to_chat(user, SPAN_WARNING("It's already fully loaded!"))
			return TRUE
		if(A.amount_left <= 0)
			to_chat(user, SPAN_WARNING("There are no more caps!"))
			return TRUE
		if(A.amount_left < (7 - bullets))
			bullets += A.amount_left
			to_chat(user, SPAN_INFO("You reload [A.amount_left] caps\s!"))
			A.amount_left = 0
		else
			to_chat(user, SPAN_INFO("You reload [7 - bullets] caps\s!"))
			A.amount_left -= 7 - bullets
			bullets = 7
		A.update_icon()
		return TRUE
	return ..()

/obj/item/toy/gun/afterattack(atom/target, mob/user, flag)
	if(flag)
		return
	if(!ishuman(user) && !IS_GAME_MODE(/datum/game_mode/monkey))
		FEEDBACK_NOT_ENOUGH_DEXTERITY(user)
		return
	src.add_fingerprint(user)
	if(src.bullets < 1)
		user.show_message(SPAN_WARNING("*click* *click*"), 2)
		playsound(user, 'sound/weapons/empty.ogg', 100, 1)
		return
	playsound(user, 'sound/weapons/gun/gunshot.ogg', 100, 1)
	src.bullets--
	user.visible_message(
		message = SPAN_DANGER("[user] fires a cap gun at [target]!"),
		blind_message = SPAN_WARNING("You hear a gunshot.")
	)

/obj/item/toy/ammo/gun
	name = "ammo-caps"
	desc = "There are 7 caps left! Make sure to recyle the box in an autolathe when it gets empty."
	icon = 'icons/obj/weapons/ammo.dmi'
	icon_state = "357-7"
	obj_flags = OBJ_FLAG_CONDUCT
	w_class = 1.0
	matter_amounts = alist(/decl/material/plastic = 20)

	var/amount_left = 7.0

/obj/item/toy/ammo/gun/update_icon()
	src.icon_state = "357-[src.amount_left]"
	src.desc = "There are [src.amount_left] caps\s left! Make sure to recycle the box in an autolathe when it gets empty."
	return

/*
 * Toy crossbow
 */

/obj/item/toy/crossbow
	name = "foam dart crossbow"
	desc = "A weapon favored by many overactive children. Ages 8 and up."
	icon = 'icons/obj/weapons/gun.dmi'
	icon_state = "crossbow"
	item_state = "crossbow"
	w_class = 2.0
	attack_verb = list("attacked", "struck", "hit")
	var/bullets = 5

/obj/item/toy/crossbow/examine()
	set src in view(2)
	..()
	if(bullets)
		to_chat(usr, SPAN_INFO("It is loaded with [bullets] foam darts!"))

/obj/item/toy/crossbow/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/toy/ammo/crossbow))
		if(bullets >= 5)
			to_chat(user, SPAN_WARNING("It's already fully loaded."))
			return TRUE
		user.drop_item()
		qdel(I)
		bullets++
		to_chat(user, SPAN_INFO("You load the foam dart into the crossbow."))
		return TRUE
	return ..()


/obj/item/toy/crossbow/afterattack(atom/target, mob/user, flag)
	if(!isturf(target.loc) || target == user)
		return
	if(flag)
		return
	if(locate(/obj/structure/table, src.loc))
		return

	else if(bullets)
		var/turf/trg = GET_TURF(target)
		var/obj/effect/foam_dart_dummy/D = new/obj/effect/foam_dart_dummy(GET_TURF(src))
		bullets--
		D.icon_state = "foamdart"
		D.name = "foam dart"
		playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)

		for(var/i = 0, i < 6, i++)
			if(isnotnull(D))
				if(D.loc == trg)
					break
				step_towards(D, trg)

				for(var/mob/living/M in D.loc)
					if(!isliving(M))
						continue
					if(M == user)
						continue
					for(var/mob/O in viewers(world.view, D))
						O.show_message(SPAN_WARNING("[M] was hit by the foam dart!"), 1)
					new /obj/item/toy/ammo/crossbow(M.loc)
					qdel(D)
					return

				for(var/atom/A in D.loc)
					if(A == user)
						continue
					if(A.density)
						new /obj/item/toy/ammo/crossbow(A.loc)
						qdel(D)

			sleep(1)

		spawn(10)
			if(D)
				new /obj/item/toy/ammo/crossbow(D.loc)
				qdel(D)

		return
	else if(bullets == 0)
		user.Weaken(5)
		for(var/mob/O in viewers(world.view, user))
			O.show_message(SPAN_WARNING("[user] realized they were out of ammo and starting scrounging for some!"), 1)


/obj/item/toy/crossbow/attack(mob/M, mob/user)
	src.add_fingerprint(user)

// ******* Check
	if(src.bullets > 0 && M.lying)
		for(var/mob/O in viewers(M, null))
			if(O.client)
				O.show_message(SPAN_DANGER("[user] casually lines up a shot with [M]'s head and pulls the trigger!"), 1, SPAN_WARNING("You hear the sound of foam against skull."), 2)
				O.show_message(SPAN_WARNING("[M] was hit in the head by the foam dart!"), 1)

		playsound(user.loc, 'sound/items/syringeproj.ogg', 50, 1)
		new /obj/item/toy/ammo/crossbow(M.loc)
		src.bullets--
	else if(M.lying && src.bullets == 0)
		for(var/mob/O in viewers(M, null))
			if(O.client)
				O.show_message(SPAN_DANGER("[user] casually lines up a shot with [M]'s head, pulls the trigger, then realizes they are out of ammo and drops to the floor in search of some!</B>"), 1, SPAN_WARNING("You hear someone fall."), 2)
		user.Weaken(5)
	return

/obj/item/toy/ammo/crossbow
	name = "foam dart"
	desc = "It's nerf or nothing! Ages 8 and up."
	icon_state = "foamdart"
	w_class = 1.0

/obj/effect/foam_dart_dummy
	name = ""
	desc = ""
	icon_state = "null"
	anchored = TRUE
	density = FALSE

/*
 * Toy swords
 */
/obj/item/toy/sword
	name = "toy sword"
	desc = "A cheap, plastic replica of an energy sword. Realistic sounds! Ages 8 and up."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "sword0"
	item_state = "sword0"
	w_class = 2.0
	item_flags = ITEM_FLAG_NO_SHIELD
	attack_verb = list("attacked", "struck", "hit")

	var/active = 0

/obj/item/toy/sword/attack_self(mob/user)
	src.active = !(src.active)
	if(src.active)
		to_chat(user, SPAN_INFO("You extend the plastic blade with a quick flick of your wrist."))
		playsound(user, 'sound/weapons/melee/saberon.ogg', 50, 1)
		src.icon_state = "swordblue"
		src.item_state = "swordblue"
		src.w_class = 4
	else
		to_chat(user, SPAN_INFO("You push the plastic blade back down into the handle."))
		playsound(user, 'sound/weapons/melee/saberoff.ogg', 50, 1)
		src.icon_state = "sword0"
		src.item_state = "sword0"
		src.w_class = 2

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	src.add_fingerprint(user)
	return

/obj/item/toy/katana
	name = "replica katana"
	desc = "Woefully underpowered in D20."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "katana"
	item_state = "katana"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT | SLOT_BACK
	force = 5
	throwforce = 5
	w_class = 3
	attack_verb = list("attacked", "slashed", "stabbed", "sliced")

/*
 * Crayons
 */
/obj/item/toy/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/items/crayons.dmi'
	icon_state = "crayonred"
	w_class = 1.0
	attack_verb = list("attacked", "coloured")
	var/colour = "#FF0000" //RGB
	var/shadeColour = "#220000" //RGB
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes

/obj/item/toy/crayon/suicide_act(mob/user)
	viewers(user) << SPAN_DANGER("[user] is jamming the [src.name] up \his nose and into \his brain. It looks like \he's trying to commit suicide.")
	return (BRUTELOSS | OXYLOSS)

/*
 * Snap pops
 */
/obj/item/toy/snappop
	name = "snap pop"
	desc = "Wow!"
	icon_state = "snappop"
	w_class = 1

/obj/item/toy/snappop/throw_impact(atom/hit_atom)
	..()
	make_sparks(3, TRUE, src)
	new /obj/effect/decal/cleanable/ash(src.loc)
	src.visible_message(SPAN_WARNING("The [src.name] explodes!"), SPAN_WARNING("You hear a snap!"))
	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	qdel(src)

/obj/item/toy/snappop/Crossed(atom/movable/AM)
	if((ishuman(AM))) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = AM
		if(IS_RUNNING(M))
			to_chat(M, SPAN_WARNING("You step on the snap pop!"))

			make_sparks(2, FALSE, src)
			new /obj/effect/decal/cleanable/ash(src.loc)
			src.visible_message(SPAN_WARNING("The [src.name] explodes!"), SPAN_WARNING("You hear a snap!"))
			playsound(src, 'sound/effects/snap.ogg', 50, 1)
			qdel(src)

/*
 * Water flower
 */
/obj/item/toy/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/flora/harvest.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"

	var/empty = 0

/obj/item/toy/waterflower/New()
	. = ..()
	create_reagents(10)
	reagents.add_reagent("water", 10)

/obj/item/toy/waterflower/attack(mob/living/carbon/human/M, mob/user)
	return

/obj/item/toy/waterflower/afterattack(atom/A, mob/user)
	if(istype(A, /obj/item/storage/backpack))
		return

	else if(locate(/obj/structure/table, src.loc))
		return

	else if(istype(A, /obj/structure/reagent_dispensers/watertank) && get_dist(src, A) <= 1)
		A.reagents.trans_to(src, 10)
		to_chat(user, SPAN_INFO("You refill your flower!"))
		return

	else if(src.reagents.total_volume < 1)
		src.empty = 1
		to_chat(user, SPAN_INFO("Your flower has run dry!"))
		return

	else
		src.empty = 0

		var/obj/effect/decal/D = new/obj/effect/decal/(GET_TURF(src))
		D.name = "water"
		D.icon = 'icons/obj/chemical.dmi'
		D.icon_state = "chempuff"
		D.create_reagents(5)
		src.reagents.trans_to(D, 1)
		playsound(src, 'sound/effects/spray3.ogg', 50, 1, -6)

		spawn(0)
			for(var/i = 0, i < 1, i++)
				step_towards(D, A)
				var/turf/D_turf = GET_TURF(D)
				D.reagents.reaction(D_turf)
				for_no_type_check(var/atom/movable/mover, D_turf)
					D.reagents.reaction(mover)
					if(ismob(mover))
						var/mob/M = mover
						if(isnotnull(M.client))
							to_chat(M, SPAN_WARNING("[user] has sprayed you with water!"))
				sleep(4)
			qdel(D)

		return

/obj/item/toy/waterflower/examine()
	set src in usr
	to_chat(usr, "\icon[src] [src.reagents.total_volume] units of water left!")
	..()
	return

/*
 * Mech prizes
 */
/obj/item/toy/prize
	icon_state = "ripleytoy"

	var/cooldown = 0

//all credit to skasi for toy mech fun ideas
/obj/item/toy/prize/attack_self(mob/user)
	if(cooldown < world.time - 8)
		to_chat(user, SPAN_NOTICE("You play with [src]."))
		playsound(user, 'sound/mecha/movement/mechstep.ogg', 20, 1)
		cooldown = world.time

/obj/item/toy/prize/attack_hand(mob/user)
	if(loc == user)
		if(cooldown < world.time - 8)
			to_chat(user, SPAN_NOTICE("You play with [src]."))
			playsound(user, 'sound/mecha/movement/mechturn.ogg', 20, 1)
			cooldown = world.time
			return
	..()

/obj/item/toy/prize/ripley
	name = "toy ripley"
	desc = "Mini-Mecha action figure! Collect them all! 1/11."

/obj/item/toy/prize/fireripley
	name = "toy firefighting ripley"
	desc = "Mini-Mecha action figure! Collect them all! 2/11."
	icon_state = "fireripleytoy"

/obj/item/toy/prize/deathripley
	name = "toy deathsquad ripley"
	desc = "Mini-Mecha action figure! Collect them all! 3/11."
	icon_state = "deathripleytoy"

/obj/item/toy/prize/gygax
	name = "toy gygax"
	desc = "Mini-Mecha action figure! Collect them all! 4/11."
	icon_state = "gygaxtoy"

/obj/item/toy/prize/durand
	name = "toy durand"
	desc = "Mini-Mecha action figure! Collect them all! 5/11."
	icon_state = "durandprize"

/obj/item/toy/prize/honk
	name = "toy H.O.N.K."
	desc = "Mini-Mecha action figure! Collect them all! 6/11."
	icon_state = "honkprize"

/obj/item/toy/prize/marauder
	name = "toy marauder"
	desc = "Mini-Mecha action figure! Collect them all! 7/11."
	icon_state = "marauderprize"

/obj/item/toy/prize/seraph
	name = "toy seraph"
	desc = "Mini-Mecha action figure! Collect them all! 8/11."
	icon_state = "seraphprize"

/obj/item/toy/prize/mauler
	name = "toy mauler"
	desc = "Mini-Mecha action figure! Collect them all! 9/11."
	icon_state = "maulerprize"

/obj/item/toy/prize/odysseus
	name = "toy odysseus"
	desc = "Mini-Mecha action figure! Collect them all! 10/11."
	icon_state = "odysseusprize"

/obj/item/toy/prize/phazon
	name = "toy phazon"
	desc = "Mini-Mecha action figure! Collect them all! 11/11."
	icon_state = "phazonprize"

/* NYET.
/obj/item/toddler
	name = "toddler"
	desc = "This baby looks almost real. Wait, did it just burp?"
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "toddler"
	force = 5
	w_class = 4.0
	slot_flags = SLOT_BACK
*/