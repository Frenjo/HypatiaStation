/datum/species/plasmalin
	name = SPECIES_PLASMALIN
	icobase = 'icons/mob/human_races/r_plasmalin.dmi'
	deform = 'icons/mob/human_races/r_plasmalin.dmi'
	language = "Plasmalin"

	unarmed_attacks = list(
		/decl/unarmed_attack/punch
	)

	slowdown = 1

	brute_mod = 1.5
	burn_mod = 1.5

	breath_type = /decl/xgm_gas/plasma
	poison_type = /decl/xgm_gas/oxygen

	body_temperature = T0C - 3

	species_flags = SPECIES_FLAG_NO_BLOOD | SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_IS_WHITELISTED

	reagent_tag = IS_PLASMALIN

	survival_kit = /obj/item/storage/box/survival/plasmalin

/datum/species/plasmalin/handle_post_spawn(mob/living/carbon/human/H)
	. = ..()

	H.gender = NEUTER

	// Equips the standard Plasmalin clothing.
	H.equip_to_slot_or_del(new /obj/item/clothing/under/plasmalin(H), SLOT_ID_WEAR_UNIFORM)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/plasmalin(H), SLOT_ID_GLOVES)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/plasmalin(H), SLOT_ID_HEAD)

	// Equips a set of plasma internals and activates them.
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/breath(H), SLOT_ID_WEAR_MASK)
	if(isnull(H.r_hand))
		H.equip_to_slot_or_del(new /obj/item/tank/plasma2(H), SLOT_ID_R_HAND)
		H.internal = H.r_hand
	else if(isnull(H.l_hand))
		H.equip_to_slot_or_del(new /obj/item/tank/plasma2(H), SLOT_ID_L_HAND)
		H.internal = H.l_hand
	spawn(20) // I hate the fact that this is necessary but I don't have the will to track down where HUD initialisation happens.
		H.internals.icon_state = "internal1"

/datum/species/plasmalin/handle_environment_special(mob/living/carbon/human/H)
	if(isnull(H.loc))
		return

	var/clothed = isnotnull(H.wear_suit) && isnotnull(H.head)
	var/atmos_sealed = clothed && HAS_ITEM_FLAGS(H.wear_suit, ITEM_FLAG_STOPS_PRESSURE_DAMAGE) && HAS_ITEM_FLAGS(H.head, ITEM_FLAG_STOPS_PRESSURE_DAMAGE)
	if(!atmos_sealed && (!istype(H.wear_uniform, /obj/item/clothing/under/plasmalin) || !istype(H.head, /obj/item/clothing/head/helmet/space/plasmalin) || !istype(H.gloves, /obj/item/clothing/gloves)))
		var/datum/gas_mixture/environment = H.loc.return_air()
		if(environment.total_moles > 0)
			// TODO: Make this loop through all gases checking for an XGM_GAS_OXIDIZER flag.
			// Potentially won't actually do this because it's more authentic to /tg/ like this. -Frenjo
			if(environment.gas[/decl/xgm_gas/oxygen] >= 1)
				H.adjust_fire_stacks(1)
				if(!H.on_fire && H.fire_stacks > 0)
					H.visible_message(
						SPAN_DANGER("[H]'s body reacts with the atmosphere and bursts into flames!"),
						SPAN_DANGER("Your body reacts with the atmosphere and bursts into flame!")
					)
				H.IgniteMob()
	else if(H.fire_stacks)
		if(istype(H.wear_uniform, /obj/item/clothing/under/plasmalin))
			var/obj/item/clothing/under/plasmalin/P = H.wear_uniform
			P.extinguish(H)
	H.update_fire()