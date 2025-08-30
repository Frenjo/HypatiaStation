/obj/item/shield
	name = "shield"

/obj/item/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "riot"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BACK
	force = 5.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = WEIGHT_CLASS_BULKY
	matter_amounts = alist(/decl/material/plastic = 1000, /decl/material/glass = 7500)
	origin_tech = alist(/decl/tech/materials = 2)
	attack_verb = list("shoved", "bashed")

	COOLDOWN_DECLARE(bash_cooldown) // shield bash cooldown

/obj/item/shield/riot/IsShield()
	return 1

/obj/item/shield/riot/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/melee/baton))
		if(COOLDOWN_FINISHED(src, bash_cooldown))
			user.visible_message(
				SPAN_WARNING("[user] bashes \the [src] with \the [I]!"),
				SPAN_WARNING("You bash \the [src] with \the [I]!")
			)
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			COOLDOWN_START(src, bash_cooldown, 2.5 SECONDS)
		return TRUE
	return ..()

/obj/item/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'icons/obj/weapons/weapons.dmi'
	icon_state = "eshield0" // eshield1 for expanded
	obj_flags = OBJ_FLAG_CONDUCT
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = WEIGHT_CLASS_TINY
	origin_tech = alist(/decl/tech/materials = 4, /decl/tech/magnets = 3, /decl/tech/syndicate = 4)
	attack_verb = list("shoved", "bashed")

	var/active = 0


/obj/item/cloaking_device
	name = "cloaking device"
	desc = "Use this to become invisible to the human eyesocket."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "shield0"
	obj_flags = OBJ_FLAG_CONDUCT
	item_state = "electronic"
	throwforce = 10.0
	throw_speed = 2
	throw_range = 10
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = alist(/decl/tech/magnets = 3, /decl/tech/syndicate = 4)

	var/active = 0

/obj/item/cloaking_device/attack_self(mob/user)
	active = !active
	if(active)
		to_chat(user, SPAN_INFO("The cloaking device is now active."))
		icon_state = "shield1"
	else
		to_chat(user, SPAN_INFO("The cloaking device is now inactive."))
		icon_state = "shield0"
	add_fingerprint(user)
	return

/obj/item/cloaking_device/emp_act(severity)
	active = 0
	icon_state = "shield0"
	if(ismob(loc))
		var/mob/M = loc
		M.update_icons()
	..()