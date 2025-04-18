//TODO: Generalize some kind of power pool so that other races can use it.
//Stand-in until this is made more lore-friendly.
/datum/species/xenos
	name = SPECIES_XENOMORPH
	language = "Hivemind"

	unarmed_attacks = list(
		/decl/unarmed_attack/claws/strong,
		/decl/unarmed_attack/bite/strong
	)

	hud_type = /datum/hud_data/alien

	eyes = "blank_eyes"

	brute_mod = 0.5	// Hardened carapace.
	burn_mod = 2	// Weak to fire.

	warning_low_pressure = 50
	hazard_low_pressure = -1

	cold_level_1 = 50
	cold_level_2 = -1
	cold_level_3 = -1

	species_flags = SPECIES_FLAG_NO_BREATHE | SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_POISON \
		| SPECIES_FLAG_IS_WHITELISTED | SPECIES_FLAG_RAD_ABSORB

	reagent_tag = IS_XENOMORPH

	blood_color = "#05EE05"
	flesh_color = "#282846"
	gibbed_anim = "gibbed-a"
	dusted_anim = "dust-a"
	death_message = "lets out a waning guttural screech, green blood bubbling from its maw."
	death_sound = 'sound/voice/hiss6.ogg'

	breath_type = null
	poison_type = null

	has_organ = list(
		"heart" =			/datum/organ/internal/heart,
		"lungs" =			/datum/organ/internal/lungs,
		"brain" =			/datum/organ/internal/brain,
		"plasma vessel" =	/datum/organ/internal/xenos/plasmavessel,
		"hive node" =		/datum/organ/internal/xenos/hivenode
	)

	bump_flag = ALIEN
	swap_flags = ALLMOBS
	push_flags = ALLMOBS ^ ROBOT

	var/alien_number = 0
	var/caste_name = "creature"	// Used to update alien name.
	var/weeds_heal_rate = 1		// Health regen on weeds.
	var/weeds_plasma_rate = 5	// Plasma regen on weeds.

/datum/species/xenos/hug(mob/living/carbon/human/H, mob/living/target)
	H.visible_message(
		SPAN_NOTICE("[H] caresses [target] with its scythe-like arm."),
		SPAN_NOTICE("You caress [target] with your scythe-like arm.")
	)

/datum/species/xenos/handle_post_spawn(mob/living/carbon/human/H)
	. = ..()
	if(isnotnull(H.mind))
		H.mind.assigned_role = "Alien"
		H.mind.special_role = "Alien"

	alien_number++ //Keep track of how many aliens we've had so far.
	H.real_name = "alien [caste_name] ([alien_number])"
	H.name = H.real_name

/datum/species/xenos/handle_environment_special(mob/living/carbon/human/H)
	if(isnull(H.loc))
		return

	if(locate(/obj/effect/alien/weeds) in H.loc)
		if(H.health >= H.maxHealth - H.getCloneLoss())
			var/datum/organ/internal/xenos/plasmavessel/P = H.internal_organs_by_name["plasma vessel"]
			P.stored_plasma += weeds_plasma_rate
			P.stored_plasma = min(max(P.stored_plasma, 0), P.max_plasma)
		else
			H.adjustBruteLoss(-weeds_heal_rate)
			H.adjustFireLoss(-weeds_heal_rate)
			H.adjustOxyLoss(-weeds_heal_rate)
			H.adjustToxLoss(-weeds_heal_rate)

/datum/species/xenos/handle_login_special(mob/living/carbon/human/H)
	H.AddInfectionImages()

/datum/species/xenos/handle_logout_special(mob/living/carbon/human/H)
	H.RemoveInfectionImages()

/datum/species/xenos/drone
	name = SPECIES_XENOMORPH_DRONE
	caste_name = "drone"
	weeds_plasma_rate = 15
	slowdown = 2
	tail = "xenos_drone_tail"

	icobase =	'icons/mob/human_races/xenos/r_xenos_drone.dmi'
	deform =	'icons/mob/human_races/xenos/r_xenos_drone.dmi'

	has_organ = list(
		"heart" =			/datum/organ/internal/heart,
		"lungs" =			/datum/organ/internal/lungs,
		"brain" =			/datum/organ/internal/brain,
		"plasma vessel" =	/datum/organ/internal/xenos/plasmavessel/queen,
		"acid gland" =		/datum/organ/internal/xenos/acidgland,
		"hive node" =		/datum/organ/internal/xenos/hivenode,
		"resin spinner" =	/datum/organ/internal/xenos/resinspinner
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/proc/plant,
		/mob/living/carbon/human/proc/transfer_plasma,
		/mob/living/carbon/human/proc/evolve,
		/mob/living/carbon/human/proc/resin,
		/mob/living/carbon/human/proc/corrosive_acid
	)

/datum/species/xenos/drone/handle_post_spawn(mob/living/carbon/human/H)
	var/mob/living/carbon/human/A = H
	if(!istype(A))
		return ..()

	return ..()

/datum/species/xenos/hunter
	name = SPECIES_XENOMORPH_HUNTER
	weeds_plasma_rate = 5
	caste_name = "hunter"
	slowdown = -1
	total_health = 150
	tail = "xenos_hunter_tail"

	icobase =	'icons/mob/human_races/xenos/r_xenos_hunter.dmi'
	deform =	'icons/mob/human_races/xenos/r_xenos_hunter.dmi'

	has_organ = list(
		"heart" =			/datum/organ/internal/heart,
		"lungs" =			/datum/organ/internal/lungs,
		"brain" =			/datum/organ/internal/brain,
		"plasma vessel" =	/datum/organ/internal/xenos/plasmavessel/hunter,
		"hive node" =		/datum/organ/internal/xenos/hivenode
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tackle,
		/mob/living/carbon/human/proc/gut,
		/mob/living/carbon/human/proc/leap,
		/mob/living/carbon/human/proc/psychic_whisper,
		/mob/living/carbon/human/proc/regurgitate
	)

/datum/species/xenos/sentinel
	name = SPECIES_XENOMORPH_SENTINEL
	weeds_plasma_rate = 10
	caste_name = "sentinel"
	slowdown = 1
	total_health = 125
	tail = "xenos_sentinel_tail"

	icobase =	'icons/mob/human_races/xenos/r_xenos_sentinel.dmi'
	deform =	'icons/mob/human_races/xenos/r_xenos_sentinel.dmi'

	has_organ = list(
		"heart" =			/datum/organ/internal/heart,
		"lungs" =			/datum/organ/internal/lungs,
		"brain" =			/datum/organ/internal/brain,
		"plasma vessel" =	/datum/organ/internal/xenos/plasmavessel/sentinel,
		"acid gland" =		/datum/organ/internal/xenos/acidgland,
		"hive node" =		/datum/organ/internal/xenos/hivenode
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/tackle,
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/proc/transfer_plasma,
		/mob/living/carbon/human/proc/corrosive_acid,
		/mob/living/carbon/human/proc/neurotoxin
	)

/datum/species/xenos/queen
	name = SPECIES_XENOMORPH_QUEEN
	weeds_heal_rate = 5
	weeds_plasma_rate = 20
	caste_name = "queen"
	slowdown = 5
	tail = "xenos_queen_tail"

	icobase =	'icons/mob/human_races/xenos/r_xenos_queen.dmi'
	deform =	'icons/mob/human_races/xenos/r_xenos_queen.dmi'

	has_organ = list(
		"heart" =			/datum/organ/internal/heart,
		"lungs" =			/datum/organ/internal/lungs,
		"brain" =			/datum/organ/internal/brain,
		"egg sac" =			/datum/organ/internal/xenos/eggsac,
		"plasma vessel" =	/datum/organ/internal/xenos/plasmavessel/queen,
		"acid gland" =		/datum/organ/internal/xenos/acidgland,
		"hive node" =		/datum/organ/internal/xenos/hivenode,
		"resin spinner" =	/datum/organ/internal/xenos/resinspinner
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/psychic_whisper,
		/mob/living/carbon/human/proc/regurgitate,
		/mob/living/carbon/human/proc/lay_egg,
		/mob/living/carbon/human/proc/plant,
		/mob/living/carbon/human/proc/transfer_plasma,
		/mob/living/carbon/human/proc/corrosive_acid,
		/mob/living/carbon/human/proc/neurotoxin,
		/mob/living/carbon/human/proc/resin
	)

	//maxHealth = 250
	//health = 250

/datum/species/xenos/queen/handle_login_special(mob/living/carbon/human/H)
	. = ..()
	// Make sure only one official queen exists at any point.
	if(!alien_queen_exists(1, H))
		H.real_name = "alien queen ([alien_number])"
		H.name = H.real_name
	else
		H.real_name = "alien princess ([alien_number])"
		H.name = H.real_name

/datum/hud_data/alien
	icon = 'icons/hud/screen1_alien.dmi'
	has_a_intent =	TRUE
	has_m_intent =	TRUE
	has_warnings =	TRUE
	has_hands =		TRUE
	has_drop =		TRUE
	has_throw =		TRUE
	has_resist =	TRUE
	has_pressure =	FALSE
	has_nutrition =	FALSE
	has_bodytemp =	FALSE
	has_internals =	FALSE

	gear = list(
		"o_clothing" =	list("loc" = UI_BELT,		"slot" = SLOT_ID_WEAR_SUIT,	"state" = "equip",	"dir" = SOUTH),
		"head" =		list("loc" = UI_ID_STORE,	"slot" = SLOT_ID_HEAD,		"state" = "hair"),
		"storage1" =	list("loc" = UI_STORAGE1,	"slot" = SLOT_ID_L_POCKET,	"state" = "pocket"),
		"storage2" =	list("loc" = UI_STORAGE2,	"slot" = SLOT_ID_R_POCKET,	"state" = "pocket"),
	)