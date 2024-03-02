//Captain's Spacesuit
/obj/item/clothing/head/helmet/space/capspace
	name = "space helmet"
	icon_state = "capspace"
	item_state = "capspacehelmet"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment. Only for the most fashionable of military figureheads."
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE | ITEM_FLAG_COVERS_EYES
	inv_flags = INV_FLAG_HIDE_FACE | INV_FLAG_BLOCK_HAIR
	permeability_coefficient = 0.01
	armor = list(melee = 65, bullet = 50, laser = 50,energy = 25, bomb = 50, bio = 100, rad = 50)

//Captain's space suit This is not the proper path but I don't currently know enough about how this all works to mess with it.
/obj/item/clothing/suit/armor/captain
	name = "Captain's armor"
	desc = "A bulky, heavy-duty piece of exclusive NanoTrasen armor. YOU are in charge!"
	icon_state = "caparmor"
	item_state = "capspacesuit"
	w_class = 4
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS
	allowed = list(
		/obj/item/tank/emergency/oxygen, /obj/item/flashlight, /obj/item/gun/energy,
		/obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing,
		/obj/item/melee/baton,/obj/item/handcuffs
	)
	slowdown = 1.5
	armor = list(melee = 65, bullet = 50, laser = 50, energy = 25, bomb = 50, bio = 100, rad = 50)
	inv_flags = INV_FLAG_HIDE_GLOVES| INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_SHOES | INV_FLAG_HIDE_TAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7