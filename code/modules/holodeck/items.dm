// Contains: Holographic Items
// Boxing Gloves
/obj/item/clothing/gloves/boxing/hologlove
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state = "boxing"

// Base
/obj/item/holo
	damtype = HALLOSS

// Energy Sword
/obj/item/holo/esword
	desc = "May the force be within you. Sorta."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "sword0"
	force = 3.0
	throw_speed = 1
	throw_range = 5
	throwforce = 0
	w_class = 2.0
	item_flags = ITEM_FLAG_NO_SHIELD

	var/active = 0

/obj/item/holo/esword/New()
	item_color = pick("red", "blue", "green", "purple")

/obj/item/holo/esword/attack_self(mob/living/user as mob)
	active = !active
	if(active)
		force = 30
		icon_state = "sword[item_color]"
		w_class = 4
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, SPAN_INFO("[src] is now active."))
	else
		force = 3
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

/obj/item/holo/esword/IsShield()
	if(active)
		return 1
	return 0

/obj/item/holo/esword/green/New()
	item_color = "green"

/obj/item/holo/esword/red/New()
	item_color = "red"