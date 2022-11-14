/datum/species/vox
	name = "Vox"
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	language = "Vox-Pidgin"
	unarmed_types = list(
		/datum/unarmed_attack/claws/strong,
		/datum/unarmed_attack/bite/strong
	)

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	eyes = "vox_eyes_s"
	breath_type = GAS_NITROGEN
	poison_type = GAS_OXYGEN

	flags = IS_WHITELISTED | NO_SCAN | HAS_EYE_COLOR

	reagent_tag = IS_VOX

	blood_color = "#2299FC"
	flesh_color = "#808D11"

	inherent_verbs = list(
		/mob/living/carbon/human/proc/leap
	)

	has_organ = list(
		"heart" =	/datum/organ/internal/heart,
		"lungs" =	/datum/organ/internal/lungs,
		"liver" =	/datum/organ/internal/liver,
		"kidneys" =	/datum/organ/internal/kidney,
		"brain" =	/datum/organ/internal/brain,
		"eyes" =	/datum/organ/internal/eyes
	)

/datum/species/vox/armalis
	name = "Vox Armalis"
	icobase = 'icons/mob/human_races/r_armalis.dmi'
	deform = 'icons/mob/human_races/r_armalis.dmi'
	language = "Vox-pidgin"
	unarmed_types = list(
		/datum/unarmed_attack/claws/strong,
		/datum/unarmed_attack/bite/strong
	)

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	brute_mod = 0.2
	burn_mod = 0.2

	eyes = "blank_eyes"
	breath_type = GAS_NITROGEN
	poison_type = GAS_OXYGEN

	flags = NO_SCAN | NO_BLOOD | HAS_TAIL | NO_PAIN | IS_WHITELISTED

	blood_color = "#2299FC"
	flesh_color = "#808D11"

	tail = "armalis_tail"
	icon_template = 'icons/mob/human_races/r_armalis.dmi'

/datum/species/vox/create_organs(mob/living/carbon/human/H)
	..() //create organs first.

	//Now apply cortical stack.
	var/datum/organ/external/affected = H.get_organ("head")

	//To avoid duplicates.
	for(var/obj/item/weapon/implant/cortical/imp in H.contents)
		affected.implants -= imp
		qdel(imp)

	var/obj/item/weapon/implant/cortical/I = new(H)
	I.imp_in = H
	I.implanted = 1
	affected.implants += I
	I.part = affected

	if(global.CTgame_ticker.mode && istype(global.CTgame_ticker.mode, /datum/game_mode/heist))
		var/datum/game_mode/heist/M = global.CTgame_ticker.mode
		M.cortical_stacks += I
		M.raiders[H.mind] = I