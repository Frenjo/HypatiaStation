//Soghun clothing.

/obj/item/clothing/suit/soghun
	species_restricted = list("exclude", "Vox", "Vox Armalis", "Obsedai")
	sprite_sheets = list(
		"Human" = 'icons/mob/species/soghun/suit.dmi',
		"Soghun" = 'icons/mob/species/soghun/suit.dmi',
		"Tajaran" = 'icons/mob/species/soghun/suit.dmi',
		"Skrell" = 'icons/mob/species/soghun/suit.dmi',
		"Plasmalin" = 'icons/mob/species/soghun/suit.dmi'
	)

/obj/item/clothing/suit/soghun/robe
	name = "roughspun robes"
	desc = "A traditional Soghun garment."
	icon_state = "robe-soghun"
	item_state = "robe-soghun"
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS

/obj/item/clothing/suit/soghun/mantle
	name = "hide mantle"
	desc = "A rather grisly selection of cured hides and skin, sewn together to form a ragged mantle."
	icon_state = "mantle-soghun"
	item_state = "mantle-soghun"
	body_parts_covered = UPPER_TORSO