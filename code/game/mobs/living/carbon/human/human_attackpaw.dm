/mob/living/carbon/human/attack_paw(mob/M)
	. = ..()
	if(M.a_intent == "help")
		help_shake_act(M)
	else
		if(istype(wear_mask, /obj/item/clothing/mask/muzzle))
			return

		// "bites" sounds much better than "has bit" or "has bitten"
		visible_message(SPAN_DANGER("[M] bites [src]!"))

		var/damage = rand(1, 3)
		var/dam_zone = pick("chest", "l_hand", "r_hand", "l_leg", "r_leg")
		var/datum/organ/external/affecting = get_organ(ran_zone(dam_zone))
		apply_damage(damage, BRUTE, affecting, run_armor_check(affecting, "melee"))

		for(var/datum/disease/D in M.viruses)
			if(!istype(D, /datum/disease/jungle_fever))
				continue
			var/mob/living/carbon/human/H = src
			qdel(src)
			src = H.monkeyize()
			contract_disease(D, 1, 0)