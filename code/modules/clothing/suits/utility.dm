/*
 * Contains:
 *		Fire protection
 *		Bomb protection
 *		Radiation protection
 */

/*
 * Fire protection
 */
/obj/item/clothing/suit/fire
	name = "firesuit"
	desc = "A suit that protects against fire and heat."
	icon_state = "fire"
	item_state = "fire_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	allowed = list(/obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/fire_extinguisher)
	slowdown = 1.0
	inv_flags = INV_FLAG_HIDE_GLOVES | INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_SHOES | INV_FLAG_HIDE_TAIL
	item_flags = ITEM_FLAG_STOPS_PRESSURE_DAMAGE
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET| ARMS | HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS

/obj/item/clothing/suit/fire/firefighter
	icon_state = "firesuit"
	item_state = "firefighter"

/obj/item/clothing/suit/fire/heavy
	name = "firesuit"
	desc = "A suit that protects against extreme fire and heat."
	//icon_state = "thermal"
	item_state = "ro_suit"
	w_class = 4//bulky item
	slowdown = 1.5

/*
 * Bomb protection
 */
/obj/item/clothing/head/bomb_hood
	name = "bomb hood"
	desc = "Use in case of bomb."
	icon_state = "bombsuit"
	item_flags = ITEM_FLAG_COVERS_EYES | ITEM_FLAG_COVERS_MOUTH
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 100, bio = 0, rad = 0)
	inv_flags = INV_FLAG_HIDE_MASK | INV_FLAG_HIDE_EARS | INV_FLAG_HIDE_EYES | INV_FLAG_BLOCK_HAIR
	siemens_coefficient = 0

/obj/item/clothing/suit/bomb_suit
	name = "bomb suit"
	desc = "A suit designed for safety when handling explosives."
	icon_state = "bombsuit"
	item_state = "bombsuit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	slowdown = 2
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 100, bio = 0, rad = 0)
	inv_flags = INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_TAIL
	heat_protection = UPPER_TORSO | LOWER_TORSO
	max_heat_protection_temperature = ARMOR_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0

/obj/item/clothing/head/bomb_hood/security
	icon_state = "bombsuitsec"
	item_state = "bombsuitsec"

/obj/item/clothing/suit/bomb_suit/security
	icon_state = "bombsuitsec"
	item_state = "bombsuitsec"
	allowed = list(/obj/item/gun/energy, /obj/item/melee/baton, /obj/item/handcuffs)

/*
 * Radiation protection
 */
/obj/item/clothing/head/radiation
	name = "radiation hood"
	icon_state = "rad"
	desc = "A hood with radiation protective properties. Label: Made with lead, do not eat insulation"
	item_flags = ITEM_FLAG_COVERS_EYES | ITEM_FLAG_COVERS_MOUTH
	inv_flags = INV_FLAG_BLOCK_HAIR
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 60, rad = 100)

/obj/item/clothing/suit/radiation
	name = "radiation suit"
	desc = "A suit that protects against radiation. Label: Made with lead, do not eat insulation."
	icon_state = "rad"
	item_state = "rad_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	allowed = list(/obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/clothing/head/radiation, /obj/item/clothing/mask/gas)
	slowdown = 1.5
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 60, rad = 100)
	inv_flags = INV_FLAG_HIDE_JUMPSUIT | INV_FLAG_HIDE_TAIL