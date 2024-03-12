/datum/species/tajaran
	name = SPECIES_TAJARAN
	icobase = 'icons/mob/human_races/r_tajaran.dmi'
	deform = 'icons/mob/human_races/r_def_tajaran.dmi'
	language = "Siik'maas"
	secondary_langs = list("Siik'tajr")
	tail = "tajtail"

	unarmed_attacks = list(
		/decl/unarmed_attack/claws,
		/decl/unarmed_attack/bite
	)

	darksight = 8

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80 //Default 120

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	primitive = /mob/living/carbon/monkey/tajara

	species_flags = SPECIES_FLAG_HAS_SKIN_TONE | SPECIES_FLAG_HAS_SKIN_COLOUR | SPECIES_FLAG_HAS_EYE_COLOUR | SPECIES_FLAG_HAS_HAIR_COLOUR \
		| SPECIES_FLAG_HAS_LIPS | SPECIES_FLAG_HAS_UNDERWEAR | SPECIES_FLAG_HAS_TAIL | SPECIES_FLAG_IS_WHITELISTED

	reagent_tag = IS_TAJARAN

	flesh_color = "#AFA59E"

/datum/species/tajaran/handle_post_spawn(mob/living/carbon/human/H)
	. = ..()
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/sandal(H), SLOT_ID_SHOES)