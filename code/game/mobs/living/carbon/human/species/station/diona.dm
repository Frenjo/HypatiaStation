/datum/species/diona
	name = SPECIES_DIONA
	icobase = 'icons/mob/human_races/r_diona.dmi'
	deform = 'icons/mob/human_races/r_def_plant.dmi'
	language = "Rootspeak"

	unarmed_attacks = list(
		/decl/unarmed_attack/diona
	)

	primitive = /mob/living/carbon/monkey/diona
	slowdown = 7

	has_organ = list(
		"nutrient channel" = /datum/organ/internal/diona/nutrients,
		"neural strata" = /datum/organ/internal/diona/strata,
		"response node" = /datum/organ/internal/diona/node,
		"gas bladder" = /datum/organ/internal/diona/bladder,
		"polyp segment" = /datum/organ/internal/diona/polyp,
		"anchoring ligament" = /datum/organ/internal/diona/ligament
	)

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	body_temperature = T0C + 15		//make the plant people have a bit lower body temperature, why not

	flags = IS_WHITELISTED | NO_BREATHE | REQUIRE_LIGHT | NO_SCAN | IS_PLANT | RAD_ABSORB | NO_BLOOD | NO_PAIN | NO_SLIP | HAS_EYE_COLOR

	reagent_tag = IS_DIONA

	blood_color = "#004400"
	flesh_color = "#907E4A"

	survival_kit = /obj/item/weapon/storage/box/survival/diona

/datum/species/diona/handle_post_spawn(mob/living/carbon/human/H)
	if(isnull(H))
		return

	H.gender = NEUTER

	return ..()

/datum/species/diona/handle_death(mob/living/carbon/human/H)
	var/mob/living/carbon/monkey/diona/S = new(get_turf(H))

	if(isnotnull(H.mind))
		H.mind.transfer_to(S)
		S.key = H

	for(var/mob/living/carbon/monkey/diona/D in H.contents)
		if(isnotnull(D.client))
			D.loc = H.loc
		else
			qdel(D)

	H.visible_message(SPAN_WARNING("[H] splits apart with a wet slithering noise!"))