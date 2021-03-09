/*
	Datum-based species. Should make for much cleaner and easier to maintain mutantrace code.
*/

//Some on_mob_life() procs check for alien races.
#define IS_HUMAN 0
#define IS_SOGHUN 1
#define IS_TAJARAN 2
#define IS_SKRELL 3
#define IS_VOX 4
#define IS_DIONA 5
#define IS_OBSEDAI 6
#define IS_PLASMAPERSON 7
#define IS_XENOMORPH 8

/datum/species
	var/name                     							// Species name.
	var/icobase = 'icons/mob/human_races/r_human.dmi'    	// Normal icon set.
	var/deform = 'icons/mob/human_races/r_def_human.dmi' 	// Mutated icon set.
	var/eyes = "eyes_s"                                  	// Icon for eyes.

	var/primitive                				// Lesser form, if any (ie. monkey for humans)
	var/tail                     				// Name of tail image in species effects icon file.
	var/language                 				// Default racial language, if any.
	var/datum/unarmed_attack/unarmed           // For empty hand harm-intent attack
	var/datum/unarmed_attack/secondary_unarmed // For empty hand harm-intent attack if the first fails.
	var/datum/hud_data/hud
	var/hud_type
	var/slowdown = 0
	var/gluttonous 								// Can eat some mobs. 1 for monkeys, 2 for people.

	var/unarmed_type =           /datum/unarmed_attack
	var/secondary_unarmed_type = /datum/unarmed_attack/bite

	var/mutantrace               				// Safeguard due to old code.
	var/has_fine_manipulation = 1 // Can use small items.
	var/insulated                 // Immune to electrocution.

	// Some species-specific gibbing data.
	var/gibbed_anim = "gibbed-h"
	var/dusted_anim = "dust-h"
	var/remains_type = /obj/effect/decal/remains/xeno
	var/death_sound
	var/death_message = "seizes up and falls limp, their eyes dead and lifeless..."

	var/breath_type = "oxygen"   // Non-oxygen gas inhaled, if any.
	var/exhale_type = "carbon_dioxide" // Non-carbon dioxide gas exhaled, if any.
	var/poison_type = "plasma" // Main toxic gas, usually plasma.

	var/total_health = 100  //Point at which the mob will enter crit.

	var/cold_level_1 = 260  // Cold damage level 1 below this point.
	var/cold_level_2 = 200  // Cold damage level 2 below this point.
	var/cold_level_3 = 120  // Cold damage level 3 below this point.

	var/heat_level_1 = 360  // Heat damage level 1 above this point.
	var/heat_level_2 = 400  // Heat damage level 2 above this point.
	var/heat_level_3 = 1000 // Heat damage level 2 above this point.

	var/body_temperature = 310.15	//non-IS_SYNTHETIC species will try to stabilize at this temperature. (also affects temperature processing)
	var/synth_temp_gain = 0			//IS_SYNTHETIC species will gain this much temperature every second
	var/reagent_tag                 //Used for metabolizing reagents.

	var/darksight = 2
	var/hazard_high_pressure = HAZARD_HIGH_PRESSURE   // Dangerously high pressure.
	var/warning_high_pressure = WARNING_HIGH_PRESSURE // High pressure warning.
	var/warning_low_pressure = WARNING_LOW_PRESSURE   // Low pressure warning.
	var/hazard_low_pressure = HAZARD_LOW_PRESSURE     // Dangerously low pressure.

	var/brute_mod = null    // Physical damage reduction/malus.
	var/burn_mod = null     // Burn damage reduction/malus.

	var/flags = 0       // Various specific features.

	var/list/abilities = list()	// For species-derived or admin-given powers

	var/blood_color = "#A10808" //Red.
	var/flesh_color = "#FFC896" //Pink.

	// Species-specific abilities.
	var/list/inherent_verbs
	var/list/has_organ = list(
		"heart" =    /datum/organ/internal/heart,
		"lungs" =    /datum/organ/internal/lungs,
		"liver" =    /datum/organ/internal/liver,
		"kidneys" =  /datum/organ/internal/kidney,
		"brain" =    /datum/organ/internal/brain,
		"eyes" =     /datum/organ/internal/eyes
		)

/datum/species/New()
	if(hud_type)
		hud = new hud_type()
	else
		hud = new()

	if(unarmed_type)
		unarmed = new unarmed_type()
	if(secondary_unarmed_type)
		secondary_unarmed = new secondary_unarmed_type()

/datum/species/proc/create_organs(var/mob/living/carbon/human/H) //Handles creation of mob organs.
	//Trying to work out why species changes aren't fixing organs properly.
	if(H.organs)                  H.organs.Cut()
	if(H.internal_organs)         H.internal_organs.Cut()
	if(H.organs_by_name)          H.organs_by_name.Cut()
	if(H.internal_organs_by_name) H.internal_organs_by_name.Cut()

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
			if(E.status & ORGAN_CUT_AWAY || E.status & ORGAN_DESTROYED) continue
			E.status |= ORGAN_ROBOT
		for(var/datum/organ/internal/I in H.internal_organs)
			I.mechanize()

/datum/species/proc/hug(var/mob/living/carbon/human/H,var/mob/living/target)
	var/t_him = "them"
	switch(target.gender)
		if(MALE)
			t_him = "him"
		if(FEMALE)
			t_him = "her"

	H.visible_message("<span class='notice'>[H] hugs [target] to make [t_him] feel better!</span>", \
					"<span class='notice'>You hug [target] to make [t_him] feel better!</span>")

/datum/species/proc/handle_post_spawn(var/mob/living/carbon/human/H) //Handles anything not already covered by basic species assignment.
//	add_inherent_verbs(H)

/datum/species/proc/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	if(flags & IS_SYNTHETIC)
		//H.make_jittery(200) //S-s-s-s-sytem f-f-ai-i-i-i-i-lure-ure-ure-ure
		H.h_style = ""
		spawn(100)
			//H.is_jittery = 0
			//H.jitteriness = 0
			H.update_hair()
	return

// Only used for alien plasma weeds atm, but could be used for Dionaea later.
/datum/species/proc/handle_environment_special(var/mob/living/carbon/human/H)
	return

// Used to update alien icons for aliens.
/datum/species/proc/handle_login_special(var/mob/living/carbon/human/H)
	return

// As above.
/datum/species/proc/handle_logout_special(var/mob/living/carbon/human/H)
	return

// Builds the HUD using species-specific icons and usable slots.
/datum/species/proc/build_hud(var/mob/living/carbon/human/H)
	return

// Grabs the window recieved when you click-drag someone onto you.
/datum/species/proc/get_inventory_dialogue(var/mob/living/carbon/human/H)
	return

/datum/species/human
	name = "Human"
	language = "Sol Common"
	unarmed_type = /datum/unarmed_attack/punch
	primitive = /mob/living/carbon/monkey

	flags = HAS_SKIN_TONE | HAS_LIPS | HAS_UNDERWEAR

	//If you wanted to add a species-level ability:
	/*abilities = list(/client/proc/test_ability)*/

// Standardised the species is called 'Soghun' but their language is 'Sinta'unathi'. -Frenjo
/datum/species/soghun
	name = "Soghun"
	icobase = 'icons/mob/human_races/r_lizard.dmi'
	deform = 'icons/mob/human_races/r_def_lizard.dmi'
	language = "Sinta'unathi"
	tail = "sogtail"
	unarmed_type = /datum/unarmed_attack/claws
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong
	primitive = /mob/living/carbon/monkey/soghun
	darksight = 3
	gluttonous = 1

	cold_level_1 = 280 //Default 260 - Lower is better
	cold_level_2 = 220 //Default 200
	cold_level_3 = 130 //Default 120

	heat_level_1 = 420 //Default 360 - Higher is better
	heat_level_2 = 480 //Default 400
	heat_level_3 = 1100 //Default 1000

	flags = IS_WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_TAIL

	flesh_color = "#34AF10"

/datum/species/tajaran
	name = "Tajaran"
	icobase = 'icons/mob/human_races/r_tajaran.dmi'
	deform = 'icons/mob/human_races/r_def_tajaran.dmi'
	language = "Siik'maas"
	tail = "tajtail"
	unarmed_type = /datum/unarmed_attack/claws
	darksight = 8

	cold_level_1 = 200 //Default 260
	cold_level_2 = 140 //Default 200
	cold_level_3 = 80 //Default 120

	heat_level_1 = 330 //Default 360
	heat_level_2 = 380 //Default 400
	heat_level_3 = 800 //Default 1000

	primitive = /mob/living/carbon/monkey/tajara

	flags = IS_WHITELISTED | HAS_LIPS | HAS_UNDERWEAR | HAS_TAIL | HAS_SKIN_TONE

	flesh_color = "#AFA59E"

/datum/species/skrell
	name = "Skrell"
	icobase = 'icons/mob/human_races/r_skrell.dmi'
	deform = 'icons/mob/human_races/r_def_skrell.dmi'
	language = "Skrellian"
	unarmed_type = /datum/unarmed_attack/punch
	primitive = /mob/living/carbon/monkey/skrell

	flags = IS_WHITELISTED | HAS_LIPS | HAS_UNDERWEAR

	flesh_color = "#8CD7A3"

	abilities = list(/client/proc/skrell_remotesay) // Added Skrell telepathy. -Frenjo

/datum/species/vox
	name = "Vox"
	icobase = 'icons/mob/human_races/r_vox.dmi'
	deform = 'icons/mob/human_races/r_def_vox.dmi'
	language = "Vox-Pidgin"
	unarmed_type = /datum/unarmed_attack/claws/strong
	secondary_unarmed_type = /datum/unarmed_attack/bite/strong

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	eyes = "vox_eyes_s"
	breath_type = "nitrogen"

	flags = IS_WHITELISTED | NO_SCAN | NO_BLOOD

	blood_color = "#2299FC"
	flesh_color = "#808D11"

	inherent_verbs = list(
		///mob/living/carbon/human/proc/leap
		)

	has_organ = list(
		"heart" =    /datum/organ/internal/heart,
		"lungs" =    /datum/organ/internal/lungs,
		"liver" =    /datum/organ/internal/liver,
		"kidneys" =  /datum/organ/internal/kidney,
		"brain" =    /datum/organ/internal/brain,
		"eyes" =     /datum/organ/internal/eyes
		)

/datum/species/vox/handle_post_spawn(var/mob/living/carbon/human/H)
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

	if(ticker.mode && ( istype( ticker.mode,/datum/game_mode/heist ) ) )
		var/datum/game_mode/heist/M = ticker.mode
		M.cortical_stacks += I
		M.raiders[H.mind] = I

	return ..()

/datum/species/diona
	name = "Diona"
	icobase = 'icons/mob/human_races/r_diona.dmi'
	deform = 'icons/mob/human_races/r_def_plant.dmi'
	language = "Rootspeak"
	unarmed_type = /datum/unarmed_attack/diona
	primitive = /mob/living/carbon/monkey/diona
	slowdown = 7

	has_organ = list(
		"nutrient channel" =   /datum/organ/internal/diona/nutrients,
		"neural strata" =      /datum/organ/internal/diona/strata,
		"response node" =      /datum/organ/internal/diona/node,
		"gas bladder" =        /datum/organ/internal/diona/bladder,
		"polyp segment" =      /datum/organ/internal/diona/polyp,
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

	flags = IS_WHITELISTED | NO_BREATHE | REQUIRE_LIGHT | NO_SCAN | IS_PLANT | RAD_ABSORB | NO_BLOOD | NO_PAIN | NO_SLIP

	blood_color = "#004400"
	flesh_color = "#907E4A"

/datum/species/diona/handle_post_spawn(var/mob/living/carbon/human/H)
	H.gender = NEUTER

/datum/species/diona/handle_death(var/mob/living/carbon/human/H)
	var/mob/living/carbon/monkey/diona/S = new(get_turf(H))

	if(H.mind)
		H.mind.transfer_to(S)
		S.key = H

	for(var/mob/living/carbon/monkey/diona/D in H.contents)
		if(D.client)
			D.loc = H.loc
		else
			qdel(D)

	H.visible_message("\red[H] splits apart with a wet slithering noise!")

/datum/species/machine
	name = "Machine"
	icobase = 'icons/mob/human_races/r_machine.dmi'
	deform = 'icons/mob/human_races/r_machine.dmi'
	language = "Binary Audio Language"
	unarmed_type = /datum/unarmed_attack/punch

	eyes = "blank_eyes"
	brute_mod = 0.5
	burn_mod = 1

	has_organ = list(
		"heart" =    /datum/organ/internal/heart,
		"brain" =    /datum/organ/internal/brain,
		)

	warning_low_pressure = 50
	hazard_low_pressure = 10

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	heat_level_1 = 2000
	heat_level_2 = 3000
	heat_level_3 = 4000

	synth_temp_gain = 10 //this should cause IPCs to stabilize at ~80 C in a 20 C environment.

	flags = IS_WHITELISTED | NO_BREATHE | NO_SCAN | NO_BLOOD | NO_PAIN | IS_SYNTHETIC

	blood_color = "#1F181F"
	flesh_color = "#575757"

/datum/species/obsedai
	name = "Obsedai"
	icobase = 'icons/mob/human_races/r_obsedai.dmi'
	deform = 'icons/mob/human_races/r_obsedai.dmi'
	language = "Obsedaian"
	unarmed_type = /datum/unarmed_attack/punch/strong
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

	blood_color = "#BD3AC2"
	flesh_color = "#4A4845"

/datum/species/plasmapeople
	name = "Plasmaperson"
	icobase = 'icons/mob/human_races/r_plasmapeople.dmi'
	deform = 'icons/mob/human_races/r_plasmapeople.dmi'
	language = "Plasmaperson"
	unarmed_type = /datum/unarmed_attack/punch
	slowdown = 3

	burn_mod = 1.5

	breath_type = "plasma"
	poison_type = "oxygen"

	flags = IS_WHITELISTED | NO_SCAN | NO_BLOOD | NO_PAIN | IS_PLASMA_IMMUNE

/datum/species/plasmapeople/handle_post_spawn(var/mob/living/carbon/human/H)
	if(!H)
		return 0

	H.equip_to_slot_or_del(new /obj/item/clothing/under/plasmapeople(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/plasmapeople(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/plasmapeople(H), slot_head)

	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), slot_wear_mask)
	H.equip_to_slot_or_del(new /obj/item/weapon/tank/plasma2(H), slot_belt)

	H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/plasmapeople(H), slot_r_hand)

	return ..()

// Called when using the shredding behavior.
/datum/species/proc/can_shred(var/mob/living/carbon/human/H)

	if(H.a_intent != "hurt")
		return 0

	if(unarmed.shredding && unarmed.is_usable(H))
		return 1
	else if(secondary_unarmed.shredding && secondary_unarmed.is_usable(H))
		return 1

	return 0

//Species unarmed attacks
/datum/unarmed_attack
	var/attack_verb = list("attack")	// Empty hand hurt intent verb.
	var/damage = 0						// Extra empty hand attack damage.
	var/attack_sound = "punch"
	var/miss_sound = 'sound/weapons/punchmiss.ogg'
	var/shredding = 0 // Calls the old attack_alien() behavior on objects/mobs when on harm intent.
	var/sharp = 0
	var/edge = 0

/datum/unarmed_attack/proc/is_usable(var/mob/living/carbon/human/user)
	if(user.restrained())
		return 0

	// Check if they have a functioning hand.
	var/datum/organ/external/E = user.organs_by_name["l_hand"]
	if(E && !(E.status & ORGAN_DESTROYED))
		return 1

	E = user.organs_by_name["r_hand"]
	if(E && !(E.status & ORGAN_DESTROYED))
		return 1

	return 0

/datum/unarmed_attack/bite
	attack_verb = list("bite") // 'x has biteed y', needs work.
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 1
	damage = 5
	sharp = 1
	edge = 1

/datum/unarmed_attack/bite/is_usable(var/mob/living/carbon/human/user)
	if (user.wear_mask && istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		return 0
	return 1

/datum/unarmed_attack/bite/strong
	attack_verb = list("maul")
	damage = 15
	shredding = 1

/datum/unarmed_attack/punch
	attack_verb = list("punch")
	damage = 3

/datum/unarmed_attack/punch/strong
	attack_verb = list("pound")
	damage = 6

/datum/unarmed_attack/diona
	attack_verb = list("lash", "bludgeon")
	damage = 5

/datum/unarmed_attack/claws
	attack_verb = list("scratch", "claw")
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	damage = 5
	sharp = 1
	edge = 1

/datum/unarmed_attack/claws/strong
	attack_verb = list("slash")
	damage = 10
	shredding = 1

/datum/hud_data
	var/icon              // If set, overrides ui_style.
	var/has_a_intent = 1  // Set to draw intent box.
	var/has_m_intent = 1  // Set to draw move intent box.
	var/has_warnings = 1  // Set to draw environment warnings.
	var/has_pressure = 1  // Draw the pressure indicator.
	var/has_nutrition = 1 // Draw the nutrition indicator.
	var/has_bodytemp = 1  // Draw the bodytemp indicator.
	var/has_hands = 1     // Set to draw shand.
	var/has_drop = 1      // Set to draw drop button.
	var/has_throw = 1     // Set to draw throw button.
	var/has_resist = 1    // Set to draw resist button.
	var/has_internals = 1 // Set to draw the internals toggle button.

	// Contains information on the position and tag for all inventory slots
	// to be drawn for the mob. This is fairly delicate, try to avoid messing with it
	// unless you know exactly what it does.
	var/list/gear = list(
		"i_clothing" =   list("loc" = ui_iclothing, "slot" = slot_w_uniform, "state" = "center", "toggle" = 1, "dir" = SOUTH),
		"o_clothing" =   list("loc" = ui_oclothing, "slot" = slot_wear_suit, "state" = "equip",  "toggle" = 1,  "dir" = SOUTH),
		"mask" =         list("loc" = ui_mask,      "slot" = slot_wear_mask, "state" = "equip",  "toggle" = 1,  "dir" = NORTH),
		"gloves" =       list("loc" = ui_gloves,    "slot" = slot_gloves,    "state" = "gloves", "toggle" = 1),
		"eyes" =         list("loc" = ui_glasses,   "slot" = slot_glasses,   "state" = "glasses","toggle" = 1),
		"l_ear" =        list("loc" = ui_l_ear,     "slot" = slot_l_ear,     "state" = "ears",   "toggle" = 1),
		"r_ear" =        list("loc" = ui_r_ear,     "slot" = slot_r_ear,     "state" = "ears",   "toggle" = 1),
		"head" =         list("loc" = ui_head,      "slot" = slot_head,      "state" = "hair",   "toggle" = 1),
		"shoes" =        list("loc" = ui_shoes,     "slot" = slot_shoes,     "state" = "shoes",  "toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "slot" = slot_s_store,   "state" = "belt",   "dir" = 8),
		"back" =         list("loc" = ui_back,      "slot" = slot_back,      "state" = "back",   "dir" = NORTH),
		"id" =           list("loc" = ui_id,        "slot" = slot_wear_id,   "state" = "id",     "dir" = NORTH),
		"storage1" =     list("loc" = ui_storage1,  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "slot" = slot_r_store,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "slot" = slot_belt,      "state" = "belt")
		)