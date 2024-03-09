/obj/item/clothing/suit/armor
	allowed = list(
		/obj/item/gun/energy, /obj/item/reagent_containers/spray/pepper, /obj/item/gun/projectile,
		/obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/handcuffs
	)
	body_parts_covered = UPPER_TORSO | LOWER_TORSO

	cold_protection = UPPER_TORSO | LOWER_TORSO
	min_cold_protection_temperature = ARMOR_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = UPPER_TORSO | LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.6


/obj/item/clothing/suit/armor/vest
	name = "armour"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	item_flags = ITEM_FLAG_ONE_SIZE_FITS_ALL
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/security
	name = "security armour"
	desc = "An armored vest that protects against some damage. This one has NanoTrasen corporate badge."
	icon_state = "armorsec"
	item_state = "armor"

/obj/item/clothing/suit/armor/vest/warden
	name = "warden's jacket"
	desc = "An armoured jacket with silver rank pips and livery."
	icon_state = "warden_jacket"
	item_state = "armor"


/obj/item/clothing/suit/armor/riot
	name = "riot suit"
	desc = "A suit of armour with heavy padding to protect against melee attacks. Looks like it might impair movement."
	icon_state = "riot"
	item_state = "swat_suit"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	slowdown = 1
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	inv_flags = INV_FLAG_HIDE_JUMPSUIT
	siemens_coefficient = 0.5


/obj/item/clothing/suit/armor/bulletproof
	name = "bulletproof vest"
	desc = "A vest that excels in protecting the wearer against high-velocity solid projectiles."
	icon_state = "bulletproof"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(melee = 10, bullet = 80, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/laserproof
	name = "ablative armor vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles."
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	blood_overlay_type = "armor"
	armor = list(melee = 10, bullet = 10, laser = 80, energy = 50, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/swat
	name = "\improper SWAT suit"
	desc = "A heavily armoured suit that protects against moderate damage. Used in special operations."
	icon_state = "deathsquad"
	item_state = "swat_suit"
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	allowed = list(
		/obj/item/gun, /obj/item/ammo_magazine, /obj/item/ammo_casing,
		/obj/item/melee/baton, /obj/item/handcuffs, /obj/item/tank/emergency/oxygen
	)
	slowdown = 1
	armor = list(melee = 80, bullet = 60, laser = 50, energy = 25, bomb = 50, bio = 0, rad = 0)
	inv_flags = INV_FLAG_HIDE_GLOVES | INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_SHOES
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5


/obj/item/clothing/suit/armor/swat/officer
	name = "officer jacket"
	desc = "An armoured jacket used in special operations."
	icon_state = "detective"
	item_state = "det_suit"
	blood_overlay_type = "coat"
	inv_flags = null


/obj/item/clothing/suit/armor/det_suit
	name = "armour"
	desc = "An armoured vest with a detective's badge on it."
	icon_state = "detective-armor"
	item_state = "armor"
	blood_overlay_type = "armor"
	item_flags = ITEM_FLAG_ONE_SIZE_FITS_ALL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)


//Reactive armor
//When the wearer gets hit, this armor will teleport the user a short distance away (to safety or to more danger, no one knows. That's the fun of it!)
/obj/item/clothing/suit/armor/reactive
	name = "reactive teleport armour"
	desc = "Someone separated our Research Director from his own head!"
	var/active = 0.0
	icon_state = "reactiveoff"
	item_state = "reactiveoff"
	blood_overlay_type = "armor"
	slowdown = 1
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/reactive/IsShield()
	if(active)
		return 1
	return 0

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user as mob)
	active = !active
	if(active)
		to_chat(user, SPAN_INFO("The reactive armour is now active."))
		icon_state = "reactive"
		item_state = "reactive"
	else
		to_chat(user, SPAN_INFO("The reactive armour is now inactive."))
		icon_state = "reactiveoff"
		item_state = "reactiveoff"
		add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	active = 0
	icon_state = "reactiveoff"
	item_state = "reactiveoff"
	..()


//All of the armor below is mostly unused
/obj/item/clothing/suit/armor/centcom
	name = "\improper CentCom armour"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	w_class = 4//bulky item
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	allowed = list(
		/obj/item/gun/energy, /obj/item/melee/baton, /obj/item/handcuffs,
		/obj/item/tank/emergency/oxygen
	)
	inv_flags = INV_FLAG_HIDE_GLOVES | INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_SHOES
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/heavy
	name = "heavy armour"
	desc = "A heavily armoured suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.90
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	slowdown = 3
	inv_flags = INV_FLAG_HIDE_GLOVES | INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_SHOES
	siemens_coefficient = 0

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	inv_flags = INV_FLAG_HIDE_GLOVES | INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_SHOES

/obj/item/clothing/suit/armor/tdome/red
	name = "red Thunderdome suit"
	desc = "Reddish armor."
	icon_state = "tdred"
	item_state = "tdred"
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/tdome/green
	name = "green Thunderdome suit"
	desc = "Pukish armor."
	icon_state = "tdgreen"
	item_state = "tdgreen"
	siemens_coefficient = 1

/obj/item/clothing/suit/armor/tactical
	name = "tactical armour"
	desc = "A suit of armour most often used by Special Weapons and Tactics squads. Includes padded vest with pockets along with shoulder and kneeguards."
	icon_state = "swatarmor"
	item_state = "armor"
	var/obj/item/gun/holstered = null
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS
	slowdown = 1
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 40, bomb = 20, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/suit/armor/tactical/verb/holster()
	set category = PANEL_OBJECT
	set name = "Holster"
	set src in usr

	if(!isliving(usr))
		return
	if(usr.stat)
		return

	if(!holstered)
		if(!istype(usr.get_active_hand(), /obj/item/gun))
			to_chat(usr, SPAN_INFO("You need your gun equipped to holster it."))
			return
		var/obj/item/gun/W = usr.get_active_hand()
		if(!W.isHandgun())
			to_chat(usr, SPAN_WARNING("This gun won't fit in \the belt!"))
			return
		holstered = usr.get_active_hand()
		usr.drop_item()
		holstered.loc = src
		usr.visible_message(SPAN_INFO("\The [usr] holsters \the [holstered]."), "You holster \the [holstered].")
	else
		if(isobj(usr.get_active_hand()) && isobj(usr.get_inactive_hand()))
			to_chat(usr, SPAN_WARNING("You need an empty hand to draw the gun!"))
		else
			if(usr.a_intent == "hurt")
				usr.visible_message(
					SPAN_WARNING("\The [usr] draws \the [holstered], ready to shoot!"),
					SPAN_WARNING("You draw \the [holstered], ready to shoot!")
				)
			else
				usr.visible_message(
					SPAN_INFO("\The [usr] draws \the [holstered], pointing it at the ground."),
					SPAN_INFO("You draw \the [holstered], pointing it at the ground.")
				)
			usr.put_in_hands(holstered)
		holstered = null