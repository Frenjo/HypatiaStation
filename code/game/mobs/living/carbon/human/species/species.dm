/*
	Datum-based species. Should make for much cleaner and easier to maintain mutantrace code.
*/

/datum/species
	var/name												// Species name.
	var/icobase = 'icons/mob/human_races/r_human.dmi'		// Normal icon set.
	var/deform = 'icons/mob/human_races/r_def_human.dmi'	// Mutated icon set.
	var/eyes = "eyes_s"										// Icon for eyes.

	var/primitive								// Lesser form, if any (ie. monkey for humans)
	var/tail									// Name of tail image in species effects icon file.
	var/language								// Default racial language, if any.
	var/secondary_langs = list()				// The names of secondary languages that are available to this species.
	var/list/unarmed_attacks					// For empty hand harm-intent attack
	var/datum/hud_data/hud
	var/hud_type
	var/slowdown = 0
	var/gluttonous								// Can eat some mobs. 1 for monkeys, 2 for people.

	var/list/unarmed_types = list(
		/datum/unarmed_attack,
		/datum/unarmed_attack/bite
	)

	var/mutantrace								// Safeguard due to old code.
	var/has_fine_manipulation = 1				// Can use small items.
	var/insulated								// Immune to electrocution.

	// Some species-specific gibbing data.
	var/gibbed_anim = "gibbed-h"
	var/dusted_anim = "dust-h"
	var/remains_type = /obj/effect/decal/remains/xeno
	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."

	var/breath_type = GAS_OXYGEN			// Non-oxygen gas inhaled, if any.
	var/exhale_type = GAS_CARBON_DIOXIDE	// Non-carbon dioxide gas exhaled, if any.
	var/poison_type = GAS_PLASMA			// Main toxic gas, usually plasma.

	var/total_health = 100	//Point at which the mob will enter crit.

	var/cold_level_1 = 260	// Cold damage level 1 below this point.
	var/cold_level_2 = 200	// Cold damage level 2 below this point.
	var/cold_level_3 = 120	// Cold damage level 3 below this point.

	var/heat_level_1 = 360	// Heat damage level 1 above this point.
	var/heat_level_2 = 400	// Heat damage level 2 above this point.
	var/heat_level_3 = 1000	// Heat damage level 2 above this point.

	var/body_temperature = 310.15	//non-IS_SYNTHETIC species will try to stabilize at this temperature. (also affects temperature processing)
	var/synth_temp_gain = 0			//IS_SYNTHETIC species will gain this much temperature every second
	var/reagent_tag					//Used for metabolizing reagents.

	var/darksight = 2
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE		// Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE	// High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE		// Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE		// Dangerously low pressure.

	var/brute_mod = null	// Physical damage reduction/malus.
	var/burn_mod = null		// Burn damage reduction/malus.

	var/flags = 0		// Various specific features.

	var/list/abilities = list()	// For species-derived or admin-given powers

	var/blood_color = "#A10808" //Red.
	var/flesh_color = "#FFC896" //Pink.

	//Used in icon caching.
	var/race_key = 0
	var/icon/icon_template

	// Species-specific abilities.
	var/list/inherent_verbs
	var/list/has_organ = list(
		"heart" =		/datum/organ/internal/heart,
		"lungs" =		/datum/organ/internal/lungs,
		"liver" =		/datum/organ/internal/liver,
		"kidneys" =		/datum/organ/internal/kidney,
		"brain" =		/datum/organ/internal/brain,
		"eyes" =		/datum/organ/internal/eyes
	)

	var/survival_kit = /obj/item/weapon/storage/box/survival // For species with custom survival kits, default is the standard kit.

	// Bump vars
	var/bump_flag = HUMAN		// What are we considered to be when bumped?
	var/push_flags = ALLMOBS	// What can we push?
	var/swap_flags = ALLMOBS	// What can we swap place with?

/datum/species/New()
	if(hud_type)
		hud = new hud_type()
	else
		hud = new()
	
	unarmed_attacks = list()
	for(var/datum/unarmed_attack/type in unarmed_types)
		unarmed_attacks += new type()

/datum/species/proc/create_organs(mob/living/carbon/human/H) //Handles creation of mob organs.
	//Trying to work out why species changes aren't fixing organs properly.
	if(H.organs)
		H.organs.Cut()
	if(H.internal_organs)
		H.internal_organs.Cut()
	if(H.organs_by_name)
		H.organs_by_name.Cut()
	if(H.internal_organs_by_name)
		H.internal_organs_by_name.Cut()

	H.organs = list()
	H.internal_organs = list()
	H.organs_by_name = list()
	H.internal_organs_by_name = list()

	//This is a basic humanoid limb setup.
	H.organs_by_name["chest"] = new/datum/organ/external/chest()
	H.organs_by_name["groin"] = new/datum/organ/external/groin(H.organs_by_name["chest"])
	H.organs_by_name["head"] = new/datum/organ/external/head(H.organs_by_name["chest"])
	H.organs_by_name["l_arm"] = new/datum/organ/external/l_arm(H.organs_by_name["chest"])
	H.organs_by_name["r_arm"] = new/datum/organ/external/r_arm(H.organs_by_name["chest"])
	H.organs_by_name["r_leg"] = new/datum/organ/external/r_leg(H.organs_by_name["groin"])
	H.organs_by_name["l_leg"] = new/datum/organ/external/l_leg(H.organs_by_name["groin"])
	H.organs_by_name["l_hand"] = new/datum/organ/external/l_hand(H.organs_by_name["l_arm"])
	H.organs_by_name["r_hand"] = new/datum/organ/external/r_hand(H.organs_by_name["r_arm"])
	H.organs_by_name["l_foot"] = new/datum/organ/external/l_foot(H.organs_by_name["l_leg"])
	H.organs_by_name["r_foot"] = new/datum/organ/external/r_foot(H.organs_by_name["r_leg"])

	for(var/organ in has_organ)
		var/organ_type = has_organ[organ]
		H.internal_organs_by_name[organ] = new organ_type(H)

	for(var/name in H.organs_by_name)
		H.organs += H.organs_by_name[name]

	for(var/datum/organ/external/O in H.organs)
		O.owner = H

	if(flags & IS_SYNTHETIC)
		for(var/datum/organ/external/E in H.organs)
			if(E.status & ORGAN_CUT_AWAY || E.status & ORGAN_DESTROYED)
				continue
			E.status |= ORGAN_ROBOT
		for(var/datum/organ/internal/I in H.internal_organs)
			I.mechanize()

/datum/species/proc/hug(mob/living/carbon/human/H, mob/living/target)
	var/t_him = "them"
	switch(target.gender)
		if(MALE)
			t_him = "him"
		if(FEMALE)
			t_him = "her"

	H.visible_message(
		SPAN_NOTICE("[H] hugs [target] to make [t_him] feel better!"),
		SPAN_NOTICE("You hug [target] to make [t_him] feel better!")
	)

/datum/species/proc/add_inherent_verbs(mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs |= verb_path
	return

/datum/species/proc/remove_inherent_verbs(mob/living/carbon/human/H)
	if(inherent_verbs)
		for(var/verb_path in inherent_verbs)
			H.verbs -= verb_path
	return

/datum/species/proc/handle_post_spawn(mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
	add_inherent_verbs(H)

/datum/species/proc/handle_death(mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	if(flags & IS_SYNTHETIC)
		//H.make_jittery(200) //S-s-s-s-sytem f-f-ai-i-i-i-i-lure-ure-ure-ure
		H.h_style = ""
		spawn(100)
			//H.is_jittery = 0
			//H.jitteriness = 0
			H.update_hair()
	return

// Only used for alien plasma weeds atm, but could be used for Dionaea later.
/datum/species/proc/handle_environment_special(mob/living/carbon/human/H)
	return

// Used to update alien icons for aliens.
/datum/species/proc/handle_login_special(mob/living/carbon/human/H)
	return

// As above.
/datum/species/proc/handle_logout_special(mob/living/carbon/human/H)
	return

// Builds the HUD using species-specific icons and usable slots.
/datum/species/proc/build_hud(mob/living/carbon/human/H)
	return

// Grabs the window recieved when you click-drag someone onto you.
/datum/species/proc/get_inventory_dialogue(mob/living/carbon/human/H)
	return

// Called when using the shredding behavior.
/datum/species/proc/can_shred(mob/living/carbon/human/H)
	if(H.a_intent != "hurt")
		return 0
	
	for(var/datum/unarmed_attack/attack in unarmed_attacks)
		if(!attack.is_usable(H))
			continue
		if(attack.shredding)
			return 1

	return 0