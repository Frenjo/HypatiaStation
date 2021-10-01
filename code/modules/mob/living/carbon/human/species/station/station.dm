/datum/species/human
	name = "Human"
	language = "Sol Common"
	unarmed_types = list(/datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	primitive = /mob/living/carbon/monkey

	flags = HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	reagent_tag = IS_HUMAN

	//If you wanted to add a species-level ability:
	/*abilities = list(/client/proc/test_ability)*/


// Standardised the species is called 'Soghun' but their language is 'Sinta'unathi'. -Frenjo
/datum/species/soghun
	name = "Soghun"
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	language = "Sinta'unathi"
	tail = "sogtail"
	unarmed_types = list(/datum/unarmed_attack/claws, /datum/unarmed_attack/bite/strong)
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


/datum/species/tajaran
	name = "Tajaran"
	icobase = 'icons/mob/human_races/r_tajaran.dmi'
	deform = 'icons/mob/human_races/r_def_tajaran.dmi'
	language = "Siik'maas"
	secondary_langs = list("Siik'tajr")
	tail = "tajtail"
	unarmed_types = list(/datum/unarmed_attack/claws, /datum/unarmed_attack/bite)
	darksight = 8

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80 //Default 120

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	primitive = /mob/living/carbon/monkey/tajara

	flags = IS_WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_TAIL | HAS_SKIN_COLOR | HAS_EYE_COLOR

	reagent_tag = IS_TAJARAN

	flesh_color = "#AFA59E"


/datum/species/skrell
	name = "Skrell"
	icobase = 'icons/mob/human_races/r_skrell.dmi'
	deform = 'icons/mob/human_races/r_def_skrell.dmi'
	language = "Skrellian"
	unarmed_types = list(/datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	primitive = /mob/living/carbon/monkey/skrell

	flags = IS_WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	reagent_tag = IS_SKRELL

	flesh_color = "#8CD7A3"

	abilities = list(/client/proc/skrell_remotesay) // Added Skrell telepathy. -Frenjo


/datum/species/machine
	name = "Machine"
	icobase = 'icons/mob/human_races/r_machine.dmi'
	deform = 'icons/mob/human_races/r_machine.dmi'
	language = "Binary Audio Language"
	unarmed_types = list(/datum/unarmed_attack/punch/strong)

	eyes = "blank_eyes"
	brute_mod = 0.5
	burn_mod = 1

	has_organ = list(
		"heart" =		/datum/organ/internal/heart,
		"brain" =		/datum/organ/internal/brain,
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

	survival_kit = null


/datum/species/obsedai
	name = "Obsedai"
	icobase = 'icons/mob/human_races/r_obsedai.dmi'
	deform = 'icons/mob/human_races/r_obsedai.dmi'
	language = "Obsedaian"
	unarmed_types = list(/datum/unarmed_attack/punch/verystrong)
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

	flags = IS_WHITELISTED | NO_BREATHE | NO_SCAN | NO_BLOOD | NO_PAIN | IS_SYNTHETIC

	reagent_tag = IS_OBSEDAI

	blood_color = "#BD3AC2"
	flesh_color = "#4A4845"

	survival_kit = null