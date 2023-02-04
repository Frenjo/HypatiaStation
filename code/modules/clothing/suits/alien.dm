//Soghun clothing.
/obj/item/clothing/suit/soghun
	species_restricted = list("exclude", SPECIES_VOX, SPECIES_VOX_ARMALIS, SPECIES_OBSEDAI)
	sprite_sheets = list(
		SPECIES_HUMAN = 'icons/mob/species/soghun/suit.dmi',
		SPECIES_SOGHUN = 'icons/mob/species/soghun/suit.dmi',
		SPECIES_TAJARAN = 'icons/mob/species/soghun/suit.dmi',
		SPECIES_SKRELL = 'icons/mob/species/soghun/suit.dmi',
		SPECIES_PLASMALIN = 'icons/mob/species/soghun/suit.dmi'
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