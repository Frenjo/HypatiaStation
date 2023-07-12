/* Weapons
 * Contains:
 *		Banhammer
 *		Sword
 *		Classic Baton
 *		Energy Blade
 *		Energy Axe
 *		Energy Shield
 */

/*
 * Banhammer
 */
/obj/item/banhammer/attack(mob/M as mob, mob/user as mob)
	to_chat(M, SPAN_DANGER("You have been banned FOR NO REISIN by [user]!"))
	to_chat(user, SPAN_WARNING("You have <b>BANNED</b> [M]!"))


/*
 * Sword
 */
/obj/item/melee/energy/sword/IsShield()
	if(active)
		return 1
	return 0

/obj/item/melee/energy/sword/New()
	item_color = pick("red", "blue", "green", "purple")

/obj/item/melee/energy/sword/attack_self(mob/living/user as mob)
	if((CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("You accidentally cut yourself with [src]."))
		user.take_organ_damage(5, 5)
	active = !active
	if(active)
		force = 30
		if(istype(src, /obj/item/melee/energy/sword/pirate))
			icon_state = "cutlass1"
		else
			icon_state = "sword[item_color]"
		w_class = 4
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, SPAN_INFO("[src] is now active."))

	else
		force = 3
		if(istype(src, /obj/item/melee/energy/sword/pirate))
			icon_state = "cutlass0"
		else
			icon_state = "sword0"
		w_class = 2
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, SPAN_INFO("[src] can now be concealed."))

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return


/*
 * Classic Baton
 */
/obj/item/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon_state = "baton"
	item_state = "classic_baton"
	slot_flags = SLOT_BELT
	force = 10

/obj/item/melee/classic_baton/attack(mob/M as mob, mob/living/user as mob)
	if((CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("You club yourself over the head."))
		user.Weaken(3 * force)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			H.apply_damage(2 * force, BRUTE, "head")
		else
			user.take_organ_damage(2 * force)
		return
/*this is already called in ..()
	src.add_fingerprint(user)
	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")

	log_attack("<font color='red'>[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>")
*/
	if(user.a_intent == "hurt")
		if(!..())
			return
		playsound(src, "swing_hit", 50, 1, -1)
		if(M.stuttering < 8 && !(HULK in M.mutations) /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.stuttering = 8
		M.Stun(8)
		M.Weaken(8)

		M.visible_message(
			message = SPAN_DANGER("[M] has been beaten with \the [src] by [user]!"),
			blind_message = SPAN_WARNING("You hear someone fall.")
		)
	else
		playsound(src, 'sound/weapons/Genhit.ogg', 50, 1, -1)
		M.Stun(5)
		M.Weaken(5)
		M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>")
		msg_admin_attack("[key_name(user)] attacked [key_name(user)] with [src.name] (INTENT: [uppertext(user.a_intent)])")
		src.add_fingerprint(user)

		M.visible_message(
			message = SPAN_DANGER("[M] has been stunned with \the [src] by [user]!"),
			blind_message = SPAN_WARNING("You hear someone fall.")
		)


//Telescopic baton
/obj/item/melee/telebaton
	name = "telescopic baton"
	desc = "A compact yet rebalanced personal defense weapon. Can be concealed when folded."
	icon_state = "telebaton_0"
	item_state = "telebaton_0"
	slot_flags = SLOT_BELT
	w_class = 2
	force = 3
	var/on = 0

/obj/item/melee/telebaton/attack_self(mob/user as mob)
	on = !on
	if(on)
		user.visible_message(
			SPAN_WARNING("With a flick of their wrist, [user] extends their telescopic baton."),
			SPAN_WARNING("You extend the baton."),
			"You hear an ominous click."
		)
		icon_state = "telebaton_1"
		item_state = "telebaton_1"
		w_class = 3
		force = 15//quite robust
		attack_verb = list("smacked", "struck", "slapped")
	else
		user.visible_message(
			SPAN_INFO("[user] collapses their telescopic baton."),
			SPAN_INFO("You collapse the baton."),
			"You hear a click."
		)
		icon_state = "telebaton_0"
		item_state = "telebaton_0"
		w_class = 2
		force = 3//not so robust now
		attack_verb = list("hit", "punched")

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	playsound(src, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)

	if(blood_overlay && length(blood_DNA)) //updates blood overlay, if any
		overlays.Cut()//this might delete other item overlays as well but eeeeeeeh

		var/icon/I = new /icon(src.icon, src.icon_state)
		I.Blend(new /icon('icons/effects/blood.dmi', rgb(255, 255, 255)), ICON_ADD)
		I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"), ICON_MULTIPLY)
		blood_overlay = I

		overlays += blood_overlay

	return

/obj/item/melee/telebaton/attack(mob/target as mob, mob/living/user as mob)
	if(on)
		if((CLUMSY in user.mutations) && prob(50))
			to_chat(user, SPAN_WARNING("You club yourself over the head."))
			user.Weaken(3 * force)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.apply_damage(2 * force, BRUTE, "head")
			else
				user.take_organ_damage(2 * force)
			return
		if(..())
			playsound(src, "swing_hit", 50, 1, -1)
			return
	else
		return ..()


/*
 *Energy Blade
 */
//Most of the other special functions are handled in their own files.
/obj/item/melee/energy/sword/green/New()
	item_color = "green"

/obj/item/melee/energy/sword/red/New()
	item_color = "red"

/obj/item/melee/energy/blade/New()
	spark_system = new /datum/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	return

/obj/item/melee/energy/blade/dropped()
	qdel(src)
	return

/obj/item/melee/energy/blade/proc/thrown()
	qdel(src)
	return


/*
 * Energy Axe
 */
/obj/item/melee/energy/axe/attack_self(mob/user as mob)
	src.active = !src.active
	if(src.active)
		to_chat(user, SPAN_INFO("The axe is now energised."))
		src.force = 150
		src.icon_state = "axe1"
		src.w_class = 5
	else
		to_chat(user, SPAN_INFO("The axe can now be concealed."))
		src.force = 40
		src.icon_state = "axe0"
		src.w_class = 5
	src.add_fingerprint(user)
	return


/*
 * Energy Shield
 */
/obj/item/shield/energy/IsShield()
	if(active)
		return 1
	else
		return 0

/obj/item/shield/energy/attack_self(mob/living/user as mob)
	if((CLUMSY in user.mutations) && prob(50))
		to_chat(user, SPAN_WARNING("You beat yourself in the head with [src]."))
		user.take_organ_damage(5)
	active = !active
	if(active)
		force = 10
		icon_state = "eshield[active]"
		w_class = 4
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, SPAN_INFO("[src] is now active."))

	else
		force = 3
		icon_state = "eshield[active]"
		w_class = 1
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, SPAN_INFO("[src] can now be concealed."))

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return