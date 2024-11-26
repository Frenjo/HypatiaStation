
/*
	apply_damage(a,b,c)
	args
	a:damage - How much damage to take
	b:damage_type - What type of damage to take, brute, burn
	c:def_zone - Where to take the damage if its brute or burn
	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(damage = 0, damagetype = BRUTE, def_zone = null, blocked = 0, used_weapon = null, sharp = 0, edge = 0)
	if(!damage || blocked >= 2)
		return 0
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage / (blocked + 1))
		if(BURN)
			if(MUTATION_COLD_RESISTANCE in mutations)
				damage = 0
			adjustFireLoss(damage / (blocked + 1))
		if(TOX)
			adjustToxLoss(damage / (blocked + 1))
		if(OXY)
			adjustOxyLoss(damage / (blocked + 1))
		if(CLONE)
			adjustCloneLoss(damage / (blocked + 1))
		if(HALLOSS)
			adjustHalLoss(damage / (blocked + 1))
	updatehealth()
	return 1


/mob/living/proc/apply_damages(brute = 0, burn = 0, tox = 0, oxy = 0, clone = 0, halloss = 0, def_zone = null, blocked = 0)
	if(blocked >= 2)
		return 0
	if(brute)
		apply_damage(brute, BRUTE, def_zone, blocked)
	if(burn)
		apply_damage(burn, BURN, def_zone, blocked)
	if(tox)
		apply_damage(tox, TOX, def_zone, blocked)
	if(oxy)
		apply_damage(oxy, OXY, def_zone, blocked)
	if(clone)
		apply_damage(clone, CLONE, def_zone, blocked)
	if(halloss)
		apply_damage(halloss, HALLOSS, def_zone, blocked)
	return 1



/mob/living/proc/apply_effect(effect = 0, effecttype = STUN, blocked = 0)
	if(!effect || blocked >= 2)
		return 0
	switch(effecttype)
		if(STUN)
			Stun(effect / (blocked + 1))
		if(WEAKEN)
			Weaken(effect / (blocked + 1))
		if(PARALYZE)
			Paralyse(effect / (blocked + 1))
		if(AGONY)
			halloss += effect // Useful for objects that cause "subdual" damage. PAIN!
		if(IRRADIATE)
			radiation += max((((effect - (effect * (getarmor(null, "rad") / 100)))) / (blocked + 1)), 0) //Rads auto check armor
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter
				stuttering = max(stuttering, (effect / (blocked + 1)))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry, (effect / (blocked + 1)))
		if(DROWSY)
			drowsyness = max(drowsyness, (effect / (blocked + 1)))
	updatehealth()
	return 1


/mob/living/proc/apply_effects(stun = 0, weaken = 0, paralyze = 0, irradiate = 0, stutter = 0, eyeblur = 0, drowsy = 0, agony = 0, blocked = 0)
	if(blocked >= 2)
		return 0
	if(stun)
		apply_effect(stun, STUN, blocked)
	if(weaken)
		apply_effect(weaken, WEAKEN, blocked)
	if(paralyze)
		apply_effect(paralyze, PARALYZE, blocked)
	if(irradiate)
		apply_effect(irradiate, IRRADIATE, blocked)
	if(stutter)
		apply_effect(stutter, STUTTER, blocked)
	if(eyeblur)
		apply_effect(eyeblur, EYE_BLUR, blocked)
	if(drowsy)
		apply_effect(drowsy, DROWSY, blocked)
	if(agony)
		apply_effect(agony, AGONY, blocked)
	return 1
