//Updates the mob's health from organs and mob damage variables
/mob/living/carbon/human/updatehealth()
	if(status_flags & GODMODE)
		health = species.total_health
		stat = CONSCIOUS
		return
	var/total_burn	= 0
	var/total_brute	= 0
	for(var/datum/organ/external/O in organs)	//hardcoded to streamline things a bit
		total_brute	+= O.brute_dam
		total_burn	+= O.burn_dam

	var/oxy_l = (HAS_SPECIES_FLAGS(species, SPECIES_FLAG_NO_BREATHE) ? 0 : getOxyLoss())
	var/tox_l = (HAS_SPECIES_FLAGS(species, SPECIES_FLAG_NO_POISON) ? 0 : getToxLoss())
	var/clone_l = getCloneLoss() //TODO: link this to RAD_ABSORB or NO_SCAN

	health = species.total_health - oxy_l - tox_l - clone_l - total_burn - total_brute
	//TODO: fix husking
	if(((species.total_health - total_burn) < CONFIG_GET(/decl/configuration_entry/health_threshold_dead)) && stat == DEAD)
		ChangeToHusk()
	return

/mob/living/carbon/human/getBrainLoss()
	var/res = brainloss
	var/datum/organ/internal/brain/sponge = internal_organs["brain"]
	if (sponge.is_bruised())
		res += 20
	if (sponge.is_broken())
		res += 50
	res = min(res,maxHealth*2)
	return res

//These procs fetch a cumulative total damage from all organs
/mob/living/carbon/human/getBruteLoss()
	var/amount = 0
	for(var/datum/organ/external/O in organs)
		amount += O.brute_dam
	return amount

/mob/living/carbon/human/getFireLoss()
	var/amount = 0
	for(var/datum/organ/external/O in organs)
		amount += O.burn_dam
	return amount

/mob/living/carbon/human/adjustBruteLoss(amount)
	if(species && species.brute_mod)
		amount = amount*species.brute_mod

	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)

	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/adjustFireLoss(amount)
	if(species && species.burn_mod)
		amount = amount*species.burn_mod

	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)

	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/proc/adjustBruteLossByPart(amount, organ_name, obj/damage_source = null)
	if(species && species.brute_mod)
		amount = amount * species.brute_mod

	if(organ_name in organs_by_name)
		var/datum/organ/external/O = get_organ(organ_name)

		if(amount > 0)
			O.take_damage(amount, 0, sharp = is_sharp(damage_source), edge = has_edge(damage_source), used_weapon = damage_source)
		else
			//if you don't want to heal robot organs, they you will have to check that yourself before using this proc.
			O.heal_damage(-amount, 0, internal = 0, robo_repair = (O.status & ORGAN_ROBOT))

	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/proc/adjustFireLossByPart(amount, organ_name, obj/damage_source = null)
	if(species && species.burn_mod)
		amount = amount * species.burn_mod

	if (organ_name in organs_by_name)
		var/datum/organ/external/O = get_organ(organ_name)

		if(amount > 0)
			O.take_damage(0, amount, sharp=is_sharp(damage_source), edge = has_edge(damage_source), used_weapon = damage_source)
		else
			//if you don't want to heal robot organs, they you will have to check that yourself before using this proc.
			O.heal_damage(0, -amount, internal = 0, robo_repair = (O.status & ORGAN_ROBOT))

	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/Stun(amount)
	if(MUTATION_HULK in mutations)
		return
	..()

/mob/living/carbon/human/Weaken(amount)
	if(MUTATION_HULK in mutations)
		return
	..()

/mob/living/carbon/human/Paralyse(amount)
	if(MUTATION_HULK in mutations)
		return
	..()

/mob/living/carbon/human/adjustCloneLoss(amount)
	..()

	if(HAS_SPECIES_FLAGS(species, SPECIES_FLAG_IS_SYNTHETIC))
		return

	var/heal_prob = max(0, 80 - getCloneLoss())
	var/mut_prob = min(80, getCloneLoss() + 10)
	if(amount > 0)
		if(prob(mut_prob))
			var/list/datum/organ/external/candidates = list()
			for(var/datum/organ/external/O in organs)
				if(!(O.status & ORGAN_MUTATED))
					candidates |= O
			if(length(candidates))
				var/datum/organ/external/O = pick(candidates)
				O.mutate()
				src << "<span class = 'notice'>Something is not right with your [O.display_name]...</span>"
				return
	else
		if(prob(heal_prob))
			for(var/datum/organ/external/O in organs)
				if(O.status & ORGAN_MUTATED)
					O.unmutate()
					src << "<span class = 'notice'>Your [O.display_name] is shaped normally again.</span>"
					return

	if(getCloneLoss() < 1)
		for(var/datum/organ/external/O in organs)
			if(O.status & ORGAN_MUTATED)
				O.unmutate()
				src << "<span class = 'notice'>Your [O.display_name] is shaped normally again.</span>"

	BITSET(hud_updateflag, HEALTH_HUD)

////////////////////////////////////////////

//Returns a list of damaged organs
/mob/living/carbon/human/proc/get_damaged_organs(brute, burn)
	var/list/datum/organ/external/parts = list()
	for(var/datum/organ/external/O in organs)
		if((brute && O.brute_dam) || (burn && O.burn_dam))
			parts += O
	return parts

//Returns a list of damageable organs
/mob/living/carbon/human/proc/get_damageable_organs()
	var/list/datum/organ/external/parts = list()
	for(var/datum/organ/external/O in organs)
		if(O.brute_dam + O.burn_dam < O.max_damage)
			parts += O
	return parts

//Heals ONE external organ, organ gets randomly selected from damaged ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/heal_organ_damage(brute, burn)
	var/list/datum/organ/external/parts = get_damaged_organs(brute, burn)
	if(!length(parts))
		return
	var/datum/organ/external/picked = pick(parts)
	if(picked.heal_damage(brute,burn))
		UpdateDamageIcon()
		BITSET(hud_updateflag, HEALTH_HUD)
	updatehealth()

//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/take_organ_damage(brute, burn, sharp = 0, edge = 0)
	var/list/datum/organ/external/parts = get_damageable_organs()
	if(!length(parts))
		return

	var/datum/organ/external/picked = pick(parts)
	if(picked.take_damage(brute, burn, sharp, edge))
		UpdateDamageIcon()
		BITSET(hud_updateflag, HEALTH_HUD)
	updatehealth()
	speech_problem_flag = 1

//Heal MANY external organs, in random order
/mob/living/carbon/human/heal_overall_damage(brute, burn)
	var/list/datum/organ/external/parts = get_damaged_organs(brute, burn)

	var/update = 0
	while(length(parts) && (brute > 0 || burn > 0))
		var/datum/organ/external/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_dam)
		burn -= (burn_was-picked.burn_dam)

		parts -= picked
	updatehealth()
	BITSET(hud_updateflag, HEALTH_HUD)
	speech_problem_flag = 1
	if(update)
		UpdateDamageIcon()

// damage MANY external organs, in random order
/mob/living/carbon/human/take_overall_damage(brute, burn, sharp = 0, edge = 0, used_weapon = null)
	if(status_flags & GODMODE)
		return	//godmode
	var/list/datum/organ/external/parts = get_damageable_organs()
	var/update = 0
	while(length(parts) && (brute > 0 || burn > 0))
		var/datum/organ/external/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.take_damage(brute, burn, sharp, edge, used_weapon)
		brute	-= (picked.brute_dam - brute_was)
		burn	-= (picked.burn_dam - burn_was)

		parts -= picked
	updatehealth()
	BITSET(hud_updateflag, HEALTH_HUD)
	if(update)
		UpdateDamageIcon()


////////////////////////////////////////////

/*
This function restores the subjects blood to max.
*/
/mob/living/carbon/human/proc/restore_blood()
	if(!HAS_SPECIES_FLAGS(species, SPECIES_FLAG_NO_BLOOD))
		var/blood_volume = vessel.get_reagent_amount("blood")
		vessel.add_reagent("blood", 560.0 - blood_volume)


/*
This function restores all organs.
*/
/mob/living/carbon/human/restore_all_organs()
	for(var/datum/organ/external/current_organ in organs)
		current_organ.rejuvenate()

/mob/living/carbon/human/proc/HealDamage(zone, brute, burn)
	var/datum/organ/external/E = get_organ(zone)
	if(isorgan(E))
		if(E.heal_damage(brute, burn))
			UpdateDamageIcon()
			BITSET(hud_updateflag, HEALTH_HUD)
	else
		return 0
	return

/mob/living/carbon/human/proc/get_organ(zone)
	if(!zone)
		zone = "chest"
	if(zone in list("eyes", "mouth"))
		zone = "head"
	return organs_by_name[zone]

/mob/living/carbon/human/apply_damage(damage = 0, damagetype = BRUTE, def_zone = null, blocked = 0, sharp = 0, edge = 0, obj/used_weapon = null)
	handle_suit_punctures(damagetype, damage)

	//visible_message("Hit debug. [damage] | [damagetype] | [def_zone] | [blocked] | [sharp] | [used_weapon]")
	if((damagetype != BRUTE) && (damagetype != BURN))
		..(damage, damagetype, def_zone, blocked)
		return 1

	if(blocked >= 2)
		return 0

	var/datum/organ/external/organ = null
	if(isorgan(def_zone))
		organ = def_zone
	else
		if(!def_zone)
			def_zone = ran_zone(def_zone)
		organ = get_organ(check_zone(def_zone))
	if(!organ)
		return 0

	if(blocked)
		damage = (damage / (blocked + 1))

	switch(damagetype)
		if(BRUTE)
			damageoverlaytemp = 20
			if(species && species.brute_mod)
				damage = damage * species.brute_mod
			if(organ.take_damage(damage, 0, sharp, edge, used_weapon))
				UpdateDamageIcon()
		if(BURN)
			damageoverlaytemp = 20
			if(species && species.burn_mod)
				damage = damage * species.burn_mod
			if(organ.take_damage(0, damage, sharp, edge, used_weapon))
				UpdateDamageIcon()

	// Will set our damageoverlay icon to the next level, which will then be set back to the normal level the next mob.Life().
	updatehealth()
	BITSET(hud_updateflag, HEALTH_HUD)

	//Embedded projectile code.
	if(!organ)
		return
	if(isitem(used_weapon))
		var/obj/item/W = used_weapon  //Sharp objects will always embed if they do enough damage.
		/*if( (damage > (10*W.w_class)) && ( (sharp && !ismob(W.loc)) || prob(damage/W.w_class) ) )
			organ.implants += W
			visible_message("<span class='danger'>\The [W] sticks in the wound!</span>")
			embedded_flag = 1
			src.verbs += /mob/proc/yank_out_object
			W.add_blood(src)
			if(ismob(W.loc))
				var/mob/living/H = W.loc
				H.drop_item()
			W.forceMove(src)
		*/
		if((damage > (4 * W.w_class)) && ((sharp && !ismob(W.loc)) || prob((damage * 1.5) / W.w_class)))
			organ.implants += W
			visible_message(SPAN_DANGER("\The [W] sticks in the wound!"))
			embedded_flag = 1
			src.verbs += /mob/proc/yank_out_object
			W.add_blood(src)
			if(ismob(W.loc))
				var/mob/living/H = W.loc
				H.drop_item()
			W.forceMove(src)
		else if((damage > (4 * W.w_class)) && ((!ismob(W.loc) && !sharp)) || (prob(damage / W.w_class)))
			organ.implants += W
			visible_message(SPAN_DANGER("\The [W] sticks in the wound!"))
			embedded_flag = 1
	return 1
