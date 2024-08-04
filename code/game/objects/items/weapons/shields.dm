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
	w_class = 4.0
	matter_amounts = list(MATERIAL_METAL = 1000, /decl/material/glass = 7500)
	origin_tech = list(/datum/tech/materials = 2)
	attack_verb = list("shoved", "bashed")

	var/cooldown = 0 //shield bash cooldown. based on world.time

/obj/item/shield/riot/IsShield()
	return 1

/obj/item/shield/riot/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/melee/baton))
		if(cooldown < (world.time - (2.5 SECONDS)))
			user.visible_message(
				SPAN_WARNING("[user] bashes \the [src] with \the [I]!"),
				SPAN_WARNING("You bash \the [src] with \the [I]!")
			)
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
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
	w_class = 1
	origin_tech = list(/datum/tech/materials = 4, /datum/tech/magnets = 3, /datum/tech/syndicate = 4)
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
	w_class = 2.0
	origin_tech = list(/datum/tech/magnets = 3, /datum/tech/syndicate = 4)

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