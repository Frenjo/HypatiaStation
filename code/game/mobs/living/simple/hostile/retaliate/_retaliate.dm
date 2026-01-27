/mob/living/simple/hostile/retaliate
	var/list/enemies = list()

/mob/living/simple/hostile/retaliate/Found(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(!L.stat)
			stance = HOSTILE_STANCE_ATTACK
			return L
		else
			enemies -= L
	else if(ismecha(A))
		var/obj/mecha/M = A
		if(M.occupant)
			stance = HOSTILE_STANCE_ATTACK
			return A

/mob/living/simple/hostile/retaliate/list_targets()
	if(!length(enemies))
		return list()
	var/list/see = ..()
	see &= enemies // Remove all entries that aren't in enemies
	return see

/mob/living/simple/hostile/retaliate/proc/Retaliate()
	var/list/around = view(src, vision_range)

	for(var/atom/movable/A in around)
		if(A == src)
			continue
		if(isliving(A))
			var/mob/living/M = A
			if(!attack_same && !M.is_same_faction(factions))
				enemies |= M
		else if(ismecha(A))
			var/obj/mecha/M = A
			if(M.occupant)
				enemies |= M
				enemies |= M.occupant

	for(var/mob/living/simple/hostile/retaliate/H in around)
		if(!attack_same && !H.attack_same && H.is_same_faction(factions))
			H.enemies |= enemies
	return 0

/mob/living/simple/hostile/retaliate/adjustBruteLoss(damage)
	..(damage)
	Retaliate()