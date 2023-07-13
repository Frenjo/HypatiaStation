/datum/species/machine
	name = SPECIES_MACHINE
	icobase = 'icons/mob/human_races/r_machine.dmi'
	deform = 'icons/mob/human_races/r_machine.dmi'
	language = "Binary Audio Language"

	unarmed_attacks = list(
		/decl/unarmed_attack/punch/strong
	)

	eyes = "blank_eyes"
	brute_mod = 0.5
	burn_mod = 1

	has_organ = list(
		"heart" =	/datum/organ/internal/heart,
		"brain" =	/datum/organ/internal/brain,
	)

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 500		//gives them about 25 seconds in space before taking damage
	heat_level_2 = 1000
	heat_level_3 = 2000

	synth_temp_gain = 10 //this should cause IPCs to stabilize at ~80 C in a 20 C environment.

	flags = IS_WHITELISTED | NO_BREATHE | NO_SCAN | NO_BLOOD | NO_PAIN | IS_SYNTHETIC

	blood_color = "#1F181F"
	flesh_color = "#575757"

	survival_kit = /obj/item/storage/box/survival/machine