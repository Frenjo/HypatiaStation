/datum/species/obsedai
	name = SPECIES_OBSEDAI
	icobase = 'icons/mob/human_races/r_obsedai.dmi'
	deform = 'icons/mob/human_races/r_obsedai.dmi'
	language = "Obsedaian"

	unarmed_attacks = list(
		/decl/unarmed_attack/punch/verystrong
	)

	slowdown = 7

	eyes = "blank_eyes"
	brute_mod = 0.1
	burn_mod = 0.1

	warning_low_pressure = 10
	hazard_low_pressure = -1

	cold_level_1 = 200 //Default 260
	cold_level_2 = 120 //Default 200
	cold_level_3 = 40 //Default 120

	heat_level_1 = 500 //Default 360
	heat_level_2 = 2000 //Default 400
	heat_level_3 = 4000 //Default 1000

	species_flags = SPECIES_FLAG_NO_BLOOD | SPECIES_FLAG_NO_BREATHE | SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_IS_WHITELISTED \
		| SPECIES_FLAG_IS_SYNTHETIC

	reagent_tag = IS_OBSEDAI

	blood_color = "#BD3AC2"
	flesh_color = "#4A4845"

	survival_kit = null