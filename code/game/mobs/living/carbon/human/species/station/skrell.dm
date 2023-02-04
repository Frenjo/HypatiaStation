/datum/species/skrell
	name = SPECIES_SKRELL
	icobase = 'icons/mob/human_races/r_skrell.dmi'
	deform = 'icons/mob/human_races/r_def_skrell.dmi'
	language = "Skrellian"
	unarmed_types = list(
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite
	)
	primitive = /mob/living/carbon/monkey/skrell

	flags = IS_WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR

	reagent_tag = IS_SKRELL

	flesh_color = "#8CD7A3"

	abilities = list(/client/proc/skrell_remotesay) // Added Skrell telepathy. -Frenjo