/datum/species/vox
	name = SPECIES_VOX
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	language = "Vox-Pidgin"

	unarmed_attacks = list(
		/decl/unarmed_attack/claws/strong,
		/decl/unarmed_attack/bite/strong
	)

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	eyes = "vox_eyes_s"
	breath_type = /decl/xgm_gas/nitrogen
	poison_type = /decl/xgm_gas/oxygen

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
	name = SPECIES_VOX_ARMALIS
	icobase = 'icons/mob/human_races/r_armalis.dmi'
	deform = 'icons/mob/human_races/r_armalis.dmi'
	language = "Vox-pidgin"

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
	breath_type = /decl/xgm_gas/nitrogen
	poison_type = /decl/xgm_gas/oxygen

	flags = NO_SCAN | NO_BLOOD | HAS_TAIL | NO_PAIN | IS_WHITELISTED

	blood_color = "#2299FC"
	flesh_color = "#808D11"

	tail = "armalis_tail"
	icon_template = 'icons/mob/human_races/r_armalis.dmi'

/datum/species/vox/create_organs(mob/living/carbon/human/H)
	. = ..() // Create organs first.

	// Now apply cortical stack.
	var/datum/organ/external/affected = H.get_organ("head")

	// To avoid duplicates.
	for(var/obj/item/implant/cortical/imp in H.contents)
		affected.implants.Remove(imp)
		qdel(imp)

	var/obj/item/implant/cortical/I = new /obj/item/implant/cortical(H)
	I.imp_in = H
	I.implanted = 1
	affected.implants.Add(I)
	I.part = affected

	if(IS_GAME_MODE(/datum/game_mode/heist))
		var/datum/game_mode/heist/M = global.PCticker.mode
		M.cortical_stacks.Add(I)
		M.raiders[H.mind] = I

/datum/species/vox/handle_post_spawn(mob/living/carbon/human/H)
	. = ..()

	// Equips a set of nitrogen internals and activates them.
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath/vox(src), SLOT_ID_WEAR_MASK)
	if(isnull(H.r_hand))
		H.equip_to_slot_or_del(new /obj/item/tank/nitrogen(src), SLOT_ID_R_HAND)
		H.internal = H.r_hand
	else if(isnull(H.l_hand))
		H.equip_to_slot_or_del(new /obj/item/tank/nitrogen(src), SLOT_ID_L_HAND)
		H.internal = H.l_hand
	spawn(20) // I hate the fact that this is necessary but I don't have the will to track down where HUD initialisation happens.
		H.internals.icon_state = "internal1"