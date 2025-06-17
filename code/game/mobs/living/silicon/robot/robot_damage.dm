/mob/living/silicon/robot/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
		return
	health = maxHealth - (getBruteLoss() + getFireLoss())

/mob/living/silicon/robot/getBruteLoss()
	. = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 0)
			. += C.brute_damage

/mob/living/silicon/robot/getFireLoss()
	. = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 0)
			. += C.electronics_damage

/mob/living/silicon/robot/adjustBruteLoss(amount)
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)

/mob/living/silicon/robot/adjustFireLoss(amount)
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)

/mob/living/silicon/robot/proc/get_damaged_components(brute, burn, destroyed = 0)
	RETURN_TYPE(/list/datum/robot_component)

	. = list()
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1 || (C.installed == -1 && destroyed))
			if((brute && C.brute_damage) || (burn && C.electronics_damage) || (!C.toggled) || (!C.powered && C.toggled))
				. += C

/mob/living/silicon/robot/proc/get_damageable_components()
	RETURN_TYPE(/list/datum/robot_component)

	. = list()
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1)
			. += C

/mob/living/silicon/robot/proc/get_armour()
	if(!length(components))
		return 0
	var/datum/robot_component/C = components["armour"]
	if(C?.installed == 1)
		return C
	return 0

/mob/living/silicon/robot/heal_organ_damage(brute, burn)
	var/list/datum/robot_component/parts = get_damaged_components(brute, burn)
	if(!length(parts))
		return
	var/datum/robot_component/picked = pick(parts)
	picked.heal_damage(brute, burn)

/mob/living/silicon/robot/take_organ_damage(brute = 0, burn = 0, sharp = 0, edge = 0)
	var/list/components = get_damageable_components()
	if(!length(components))
		return

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	if(module_active && istype(module_active, /obj/item/robot_module/combat_shield))
		var/obj/item/robot_module/combat_shield/shield = module_active
		//Shields absorb a certain percentage of damage based on their power setting.
		var/absorb_brute = brute * shield.shield_level
		var/absorb_burn = burn * shield.shield_level
		var/cost = (absorb_brute + absorb_burn) * 100

		cell.charge -= cost
		if(cell.charge <= 0)
			cell.charge = 0
			to_chat(src, SPAN_WARNING("Your shield has overloaded!"))
		else
			brute -= absorb_brute
			burn -= absorb_burn
			to_chat(src, SPAN_WARNING("Your shield absorbs some of the impact!"))

	var/datum/robot_component/armour/A = get_armour()
	if(A)
		A.take_damage(brute, burn, sharp, edge)
		return

	var/datum/robot_component/C = pick(components)
	C.take_damage(brute, burn, sharp, edge)

/mob/living/silicon/robot/heal_overall_damage(brute, burn)
	var/list/datum/robot_component/parts = get_damaged_components(brute, burn)

	while(length(parts) && (brute > 0 || burn > 0))
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage

		picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_damage)
		burn -= (burn_was-picked.electronics_damage)

		parts -= picked

/mob/living/silicon/robot/take_overall_damage(brute = 0, burn = 0, sharp = 0, used_weapon = null)
	if(status_flags & GODMODE)
		return	//godmode
	var/list/datum/robot_component/parts = get_damageable_components()

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	if(module_active && istype(module_active, /obj/item/robot_module/combat_shield))
		var/obj/item/robot_module/combat_shield/shield = module_active
		//Shields absorb a certain percentage of damage based on their power setting.
		var/absorb_brute = brute * shield.shield_level
		var/absorb_burn = burn * shield.shield_level
		var/cost = (absorb_brute + absorb_burn) * 100

		cell.charge -= cost
		if(cell.charge <= 0)
			cell.charge = 0
			to_chat(src, SPAN_WARNING("Your shield has overloaded!"))
		else
			brute -= absorb_brute
			burn -= absorb_burn
			to_chat(src, SPAN_WARNING("Your shield absorbs some of the impact!"))

	var/datum/robot_component/armour/A = get_armour()
	if(A)
		A.take_damage(brute, burn, sharp)
		return

	while(length(parts) && (brute > 0 || burn > 0))
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage

		picked.take_damage(brute,burn)

		brute -= (picked.brute_damage - brute_was)
		burn -= (picked.electronics_damage - burn_was)

		parts -= picked