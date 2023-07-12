/obj/item/shield
	name = "shield"

/obj/item/shield/riot
	name = "riot shield"
	desc = "A shield adept at blocking blunt objects from connecting with the torso of the shield wielder."
	icon_state = "riot"
	flags = CONDUCT
	slot_flags = SLOT_BACK
	force = 5.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = 4.0
	matter_amounts = list(MATERIAL_METAL = 1000, MATERIAL_GLASS = 7500)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 2)
	attack_verb = list("shoved", "bashed")

	var/cooldown = 0 //shield bash cooldown. based on world.time

/obj/item/shield/riot/IsShield()
	return 1

/obj/item/shield/riot/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/melee/baton))
		if(cooldown < world.time - 25)
			user.visible_message(SPAN_WARNING("[user] bashes [src] with [W]!"))
			playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
			cooldown = world.time
	else
		..()

/obj/item/shield/energy
	name = "energy combat shield"
	desc = "A shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon_state = "eshield0" // eshield1 for expanded
	flags = CONDUCT
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 4
	w_class = 1
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_SYNDICATE = 4)
	attack_verb = list("shoved", "bashed")

	var/active = 0


/obj/item/cloaking_device
	name = "cloaking device"
	desc = "Use this to become invisible to the human eyesocket."
	icon = 'icons/obj/devices/device.dmi'
	icon_state = "shield0"
	flags = CONDUCT
	item_state = "electronic"
	throwforce = 10.0
	throw_speed = 2
	throw_range = 10
	w_class = 2.0
	origin_tech = list(RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_SYNDICATE = 4)

	var/active = 0

/obj/item/cloaking_device/attack_self(mob/user as mob)
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