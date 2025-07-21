/*
 * Suit
 */
/obj/item/clothing/suit
	icon = 'icons/obj/items/clothing/suits.dmi'
	name = "suit"

	slot_flags = SLOT_OCLOTHING

	siemens_coefficient = 0.9
	w_class = 3

	var/fire_resist = T0C + 100
	var/blood_overlay_type = "suit"

	var/list/allowed = list(/obj/item/tank/emergency/oxygen) // Things that can be put into this suit's storage.