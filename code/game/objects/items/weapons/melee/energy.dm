/obj/item/melee/energy
	var/active = 0
	atom_flags = ATOM_FLAG_NO_BLOODY

/obj/item/melee/energy/suicide_act(mob/user)
	user.visible_message(pick( \
		SPAN_DANGER("[user] is slitting \his stomach open with \the [src]! It looks like \he's trying to commit seppuku."), \
		SPAN_DANGER("[user] is falling on \the [src]! It looks like \he's trying to commit suicide."))
	)
	return (BRUTELOSS|FIRELOSS)

/*
 * Energy Axe
 */
/obj/item/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "axe0"
	force = 40.0
	throwforce = 25.0
	throw_speed = 1
	throw_range = 5
	obj_flags = OBJ_FLAG_CONDUCT
	item_flags = ITEM_FLAG_NO_SHIELD
	origin_tech = alist(/decl/tech/combat = 3)
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = 1

/obj/item/melee/energy/axe/suicide_act(mob/user)
	user.visible_message(SPAN_DANGER("[user] swings \the [src] towards \his head! It looks like \he's trying to commit suicide."))
	return (BRUTELOSS|FIRELOSS)

/obj/item/melee/energy/axe/attack_self(mob/user)
	active = !active
	if(active)
		to_chat(user, SPAN_INFO("The axe is now energised."))
		force = 150
		icon_state = "axe1"
		w_class = 5
	else
		to_chat(user, SPAN_INFO("The axe can now be concealed."))
		force = 40
		icon_state = "axe0"
		w_class = 5
	add_fingerprint(user)

/*
 * Energy Sword
 */
/obj/item/melee/energy/sword
	name = "energy sword"
	desc = "May the force be within you."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "sword0"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	item_flags = ITEM_FLAG_NO_SHIELD
	origin_tech = alist(/decl/tech/magnets = 3, /decl/tech/syndicate = 4)
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	sharp = 1
	edge = 1

/obj/item/melee/energy/sword/New()
	. = ..()
	item_color = pick("red", "blue", "green", "purple")

/obj/item/melee/energy/sword/IsShield()
	return active

/obj/item/melee/energy/sword/attack_self(mob/living/user)
	if((MUTATION_CLUMSY in user.mutations) && prob(50))
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
		playsound(user, 'sound/weapons/melee/saberon.ogg', 50, 1)
		to_chat(user, SPAN_INFO("[src] is now active."))

	else
		force = 3
		if(istype(src, /obj/item/melee/energy/sword/pirate))
			icon_state = "cutlass0"
		else
			icon_state = "sword0"
		w_class = 2
		playsound(user, 'sound/weapons/melee/saberoff.ogg', 50, 1)
		to_chat(user, SPAN_INFO("[src] can now be concealed."))

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)

/obj/item/melee/energy/sword/green/New()
	. = ..()
	item_color = "green"

/obj/item/melee/energy/sword/red/New()
	. = ..()
	item_color = "red"

/obj/item/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"

/*
 * Energy Blade
 */
/obj/item/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "blade"
	force = 70.0//Normal attacks deal very high damage.
	sharp = 1
	edge = 1
	throwforce = 1//Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = WEIGHT_CLASS_BULKY //So you can't hide it in your pocket or some such.
	item_flags = ITEM_FLAG_NO_SHIELD
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/datum/effect/system/spark_spread/spark_system

/obj/item/melee/energy/blade/New()
	spark_system = new /datum/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	. = ..()

/obj/item/melee/energy/blade/dropped()
	qdel(src)

/obj/item/melee/energy/blade/proc/thrown()
	qdel(src)