/datum/species/human
	name = SPECIES_HUMAN
	language = "Sol Common"
	unarmed_types = list(
		/datum/unarmed_attack/punch,
		/datum/unarmed_attack/bite
	)
	primitive = /mob/living/carbon/monkey

	flags = HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	reagent_tag = IS_HUMAN

	//If you wanted to add a species-level ability:
	/*abilities = list(/client/proc/test_ability)*/