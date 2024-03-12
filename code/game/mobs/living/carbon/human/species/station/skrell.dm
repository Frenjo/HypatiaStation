/datum/species/skrell
	name = SPECIES_SKRELL
	icobase = 'icons/mob/human_races/r_skrell.dmi'
	deform = 'icons/mob/human_races/r_def_skrell.dmi'
	language = "Skrellian"
	primitive = /mob/living/carbon/monkey/skrell

	species_flags = SPECIES_FLAG_HAS_SKIN_COLOUR | SPECIES_FLAG_HAS_EYE_COLOUR | SPECIES_FLAG_HAS_HAIR_COLOUR | SPECIES_FLAG_HAS_LIPS \
		| SPECIES_FLAG_HAS_UNDERWEAR | SPECIES_FLAG_IS_WHITELISTED

	reagent_tag = IS_SKRELL

	flesh_color = "#8CD7A3"

	abilities = list(/client/proc/skrell_remotesay) // Added Skrell telepathy. -Frenjo