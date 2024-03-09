/*
 * Spacesuit
 *
 * Note: All suit and helmet combos should have the entire suit grouped together.
 *	Meaning the suit is defined directly after the corresponding helmet. Just like below!
 */
/obj/item/clothing/head/helmet/space
	name = "space helmet"
	icon_state = "space"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE | ITEM_FLAG_COVERS_EYES | ITEM_FLAG_COVERS_MOUTH
	item_state = "space"
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 50)
	inv_flags = INV_FLAG_HIDE_MASK | INV_FLAG_HIDE_EARS | INV_FLAG_HIDE_EYES | INV_FLAG_HIDE_FACE | INV_FLAG_BLOCK_HAIR
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	species_restricted = list("exclude", SPECIES_DIONA, SPECIES_VOX)

/obj/item/clothing/suit/space
	name = "space suit"
	desc = "A suit that protects against low pressure environments. Has a big 13 on the back."
	icon_state = "space"
	item_state = "s_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	allowed = list(/obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/suit_cooling_unit)
	slowdown = 3
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 50)
	inv_flags = INV_FLAG_HIDE_GLOVES | INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_SHOES | INV_FLAG_HIDE_TAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	species_restricted = list("exclude", SPECIES_DIONA, SPECIES_VOX)