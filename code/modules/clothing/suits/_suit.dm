/*
 * Suit
 */
/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"

	allowed = list(/obj/item/tank/emergency_oxygen)
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	slot_flags = SLOT_OCLOTHING

	siemens_coefficient = 0.9
	w_class = 3

	var/fire_resist = T0C + 100
	var/blood_overlay_type = "suit"