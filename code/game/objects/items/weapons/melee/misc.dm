/*
 * Chain of Command
 */
/obj/item/melee/chainofcommand
	name = "chain of command"
	desc = "A tool used by great men to placate the frothing masses."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "chain"
	item_state = "chain"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	force = 10
	throwforce = 7
	origin_tech = alist(/decl/tech/combat = 4)
	attack_verb = list("flogged", "whipped", "lashed", "disciplined")

/obj/item/melee/chainofcommand/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide."))
	return (OXYLOSS)

/*
 * Banhammer
 */
/obj/item/banhammer/attack(mob/M, mob/user)
	to_chat(M, SPAN_DANGER("You have been banned FOR NO REISIN by [user]!"))
	to_chat(user, SPAN_WARNING("You have <b>BANNED</b> [M]!"))

/*
 * Classic Baton
 */
/obj/item/melee/classic_baton
	name = "police baton"
	desc = "A wooden truncheon for beating criminal scum."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "baton"
	item_state = "classic_baton"
	slot_flags = SLOT_BELT
	force = 10

/obj/item/melee/classic_baton/attack(mob/M, mob/living/user)
	if((MUTATION_CLUMSY in user.mutations) && prob(50))
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
	M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been attacked with [src.name] by [user.name] ([user.ckey])</font>"
	user.attack_log += "\[[time_stamp()]\] <font color='red'>Used the [src.name] to attack [M.name] ([M.ckey])</font>"

	log_attack("<font color='red'>[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>")
*/
	if(user.a_intent == "hurt")
		if(!..())
			return
		playsound(src, "swing_hit", 50, 1, -1)
		if(M.stuttering < 8 && !(MUTATION_HULK in M.mutations) /*&& (!istype(H:wear_suit, /obj/item/clothing/suit/judgerobe))*/)
			M.stuttering = 8
		M.Stun(8)
		M.Weaken(8)

		M.visible_message(
			message = SPAN_DANGER("[M] has been beaten with \the [src] by [user]!"),
			blind_message = SPAN_WARNING("You hear someone fall.")
		)
	else
		playsound(src, 'sound/weapons/melee/genhit.ogg', 50, 1, -1)
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

/*
 * Telescopic Baton
 */
/obj/item/melee/telebaton
	name = "telescopic baton"
	desc = "A compact yet rebalanced personal defence weapon. Can be concealed when folded."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "telebaton_0"
	item_state = "telebaton_0"
	slot_flags = SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	force = 3
	var/on = 0

/obj/item/melee/telebaton/attack_self(mob/user)
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
		cut_overlays()//this might delete other item overlays as well but eeeeeeeh

		var/icon/I = new /icon(src.icon, src.icon_state)
		I.Blend(new /icon('icons/effects/decals/blood.dmi', rgb(255, 255, 255)), ICON_ADD)
		I.Blend(new /icon('icons/effects/decals/blood.dmi', "itemblood"), ICON_MULTIPLY)
		blood_overlay = I

		add_overlay(blood_overlay)

	return

/obj/item/melee/telebaton/attack(mob/target, mob/living/user)
	if(on)
		if((MUTATION_CLUMSY in user.mutations) && prob(50))
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