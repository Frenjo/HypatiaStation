/datum/species/plasmalin
	name = "Plasmalin"
	icobase = 'icons/mob/human_races/r_plasmalin.dmi'
	deform = 'icons/mob/human_races/r_plasmalin.dmi'
	language = "Plasmalin"
	unarmed_types = list(/datum/unarmed_attack/punch)
	slowdown = 1

	brute_mod = 1.5
	burn_mod = 1.5

	breath_type = "plasma"
	poison_type = "oxygen"

	body_temperature = T0C - 3

	flags = IS_WHITELISTED | NO_SCAN | NO_BLOOD | NO_PAIN | NO_POISON

	reagent_tag = IS_PLASMALIN

	survival_kit = /obj/item/weapon/storage/box/survival_plasmalin

/datum/species/plasmalin/handle_post_spawn(mob/living/carbon/human/H)
	if(!H)
		return 0

	H.gender = NEUTER

	H.equip_to_slot_or_del(new /obj/item/clothing/under/plasmalin(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/plasmalin(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/space/plasmalin(H), slot_head)

	return ..()

/datum/species/plasmalin/handle_environment_special(mob/living/carbon/human/H)
	if(!H.loc)
		return

	var/atmos_sealed = (H.wear_suit && H.wear_suit.flags & STOPSPRESSUREDAMAGE) && (H.head && H.head.flags & STOPSPRESSUREDAMAGE)
	if(!atmos_sealed && (!istype(H.w_uniform, /obj/item/clothing/under/plasmalin) || !istype(H.head, /obj/item/clothing/head/helmet/space/plasmalin) || !istype(H.gloves, /obj/item/clothing/gloves)))
		var/datum/gas_mixture/environment = H.loc.return_air()
		if(environment.total_moles > 0)
			// TODO: Make this loop through all gases checking for an XGM_GAS_OXIDIZER flag.
			// Potentially won't actually do this because it's more authentic to /tg/ like this. -Frenjo
			if(environment.gas["oxygen"] >= 1)
				H.adjust_fire_stacks(1)
				if(!H.on_fire && H.fire_stacks > 0)
					H.visible_message(
						SPAN_DANGER("[H]'s body reacts with the atmosphere and bursts into flames!"),
						SPAN_DANGER("Your body reacts with the atmosphere and bursts into flame!")
					)
				H.IgniteMob()
	else if(H.fire_stacks)
		if(istype(H.w_uniform, /obj/item/clothing/under/plasmalin))
			var/obj/item/clothing/under/plasmalin/P = H.w_uniform
			P.Extinguish(H)
	H.update_fire()