/* Two-handed Weapons
 * Contains:
 * 		Twohanded
 *		Fireaxe
 *		Double-Bladed Energy Swords
 */

/*##################################################################
##################### TWO HANDED WEAPONS BE HERE~ -Agouri :3 ########
####################################################################*/

//Rewrote TwoHanded weapons stuff and put it all here. Just copypasta fireaxe to make new ones ~Carn
//This rewrite means we don't have two variables for EVERY item which are used only by a few weapons.
//It also tidies stuff up elsewhere.

/*
 * Twohanded
 */
/obj/item/twohanded
	var/wielded = 0
	var/force_unwielded = 0
	var/force_wielded = 0
	var/wieldsound = null
	var/unwieldsound = null

/obj/item/twohanded/proc/unwield()
	wielded = 0
	force = force_unwielded
	name = "[initial(name)]"
	update_icon()

/obj/item/twohanded/proc/wield()
	wielded = 1
	force = force_wielded
	name = "[initial(name)] (Wielded)"
	update_icon()

/obj/item/twohanded/mob_can_equip(mob/M, slot)
	//Cannot equip wielded items.
	if(wielded)
		to_chat(M, SPAN_WARNING("Unwield the [initial(name)] first!"))
		return 0

	return ..()

/obj/item/twohanded/dropped(mob/user)
	//handles unwielding a twohanded weapon when dropped as well as clearing up the offhand
	if(user)
		var/obj/item/twohanded/O = user.get_inactive_hand()
		if(istype(O))
			O.unwield()
	return	unwield()

/obj/item/twohanded/update_icon()
	return

/obj/item/twohanded/pickup(mob/user)
	unwield()

/obj/item/twohanded/attack_self(mob/user)
	if(ismonkey(user))
		to_chat(user, SPAN_WARNING("It's too heavy for you to wield fully."))
		return

	..()
	if(wielded) //Trying to unwield it
		unwield()
		to_chat(user, SPAN_NOTICE("You are now carrying the [name] with one hand."))
		if(src.unwieldsound)
			playsound(src, unwieldsound, 50, 1)

		var/obj/item/twohanded/offhand/O = user.get_inactive_hand()
		if(O && istype(O))
			O.unwield()
		return

	else //Trying to wield it
		if(user.get_inactive_hand())
			to_chat(user, SPAN_WARNING("You need your other hand to be empty."))
			return
		wield()
		to_chat(user, SPAN_WARNING("You grab the [initial(name)] with both hands."))
		if(src.wieldsound)
			playsound(src, wieldsound, 50, 1)

		var/obj/item/twohanded/offhand/O = new(user) ////Let's reserve his other hand~
		O.name = "[initial(name)] - offhand"
		O.desc = "Your second grip on the [initial(name)]"
		user.put_in_inactive_hand(O)
		return

///////////OFFHAND///////////////
/obj/item/twohanded/offhand
	w_class = 5.0
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "offhand"
	name = "offhand"

/obj/item/twohanded/offhand/unwield()
	qdel(src)

/obj/item/twohanded/offhand/wield()
	qdel(src)


/*
 * Fireaxe
 */
/obj/item/twohanded/fireaxe  // DEM AXES MAN, marker -Agouri
	name = "fire axe"
	desc = "Truly, the weapon of a madman. Who would think to fight fire with an axe?"
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "fireaxe0"
	force = 5
	sharp = 1
	edge = 1
	w_class = 4.0
	slot_flags = SLOT_BACK
	force_unwielded = 10
	force_wielded = 40
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")

/obj/item/twohanded/fireaxe/update_icon()  //Currently only here to fuck with the on-mob icons.
	icon_state = "fireaxe[wielded]"
	return

/obj/item/twohanded/fireaxe/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	..()
	if(A && wielded && (istype(A, /obj/structure/window) || istype(A, /obj/structure/grille))) //destroys windows and grilles in one hit
		if(istype(A, /obj/structure/window)) //should just make a window.Break() proc but couldn't bother with it
			var/obj/structure/window/W = A

			new /obj/item/shard(W.loc)
			if(W.reinf)
				new /obj/item/stack/rods(W.loc)

			if(W.dir == SOUTHWEST)
				new /obj/item/shard(W.loc)
				if(W.reinf)
					new /obj/item/stack/rods(W.loc)
		qdel(A)


/*
 * Double-Bladed Energy Swords - Cheridan
 */
/obj/item/twohanded/dualsaber
	name = "double-bladed energy sword"
	desc = "Handle with care."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "dualsaber0"
	force = 3
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	force_unwielded = 3
	force_wielded = 30
	wieldsound = 'sound/weapons/saberon.ogg'
	unwieldsound = 'sound/weapons/saberoff.ogg'
	item_flags = ITEM_FLAG_NO_SHIELD
	origin_tech = alist(/decl/tech/magnets = 3, /decl/tech/syndicate = 4)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharp = 1
	edge = 1

/obj/item/twohanded/dualsaber/update_icon()
	icon_state = "dualsaber[wielded]"
	return

/obj/item/twohanded/dualsaber/attack(mob/target, mob/living/user)
	..()
	if((MUTATION_CLUMSY in user.mutations) && wielded && prob(40))
		to_chat(user, SPAN_WARNING("You twirl around a bit before losing your balance and impaling yourself on the [src]."))
		user.take_organ_damage(20, 25)
		return
	if(wielded && prob(50))
		spawn(0)
			for(var/i in list(1, 2, 4, 8, 4, 2, 1, 2, 4, 8, 4, 2))
				user.set_dir(i)
				sleep(1)

/obj/item/twohanded/dualsaber/IsShield()
	if(wielded)
		return 1
	else
		return 0