// Standardised the species is called 'Soghun' but their language is 'Sinta'unathi'. -Frenjo
/datum/species/soghun
	name = "Soghun"
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	language = "Sinta'unathi"
	tail = "sogtail"
	unarmed_types = list(
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/bite/strong
	)
	primitive = /mob/living/carbon/monkey/soghun
	darksight = 3
	gluttonous = 1

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	flags = IS_WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_TAIL | HAS_SKIN_COLOR | HAS_EYE_COLOR

	reagent_tag = IS_SOGHUN

	flesh_color = "#34AF10"