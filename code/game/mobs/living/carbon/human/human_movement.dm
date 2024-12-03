/mob/living/carbon/human/movement_delay()
	. = ..()

	if(species.slowdown)
		. = species.slowdown

	if(isspace(loc))
		return -1 // It's hard to be slowed down in space by... anything

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	if(isnotnull(reagents))
		if(reagents.has_reagent("hyperzine") || reagents.has_reagent("nuka_cola"))
			return -1

	var/health_deficiency = (100 - health + halloss)
	if(health_deficiency >= 40)
		. += (health_deficiency / 25)

	var/hungry = (500 - nutrition) / 5 // So overeat would be 100 and default level would be 80
	if(hungry >= 70)
		. += hungry / 50

	if(isnotnull(wear_suit))
		. += wear_suit.slowdown

	if(isnotnull(shoes))
		. += shoes.slowdown

	for(var/organ_name in list("l_foot", "r_foot", "l_leg", "r_leg"))
		var/datum/organ/external/E = get_organ(organ_name)
		if(isnull(E) || (E.status & ORGAN_DESTROYED))
			. += 4
		else if(E.status & ORGAN_SPLINTED)
			. += 0.5
		else if(E.status & ORGAN_BROKEN)
			. += 1.5

	if(shock_stage >= 10)
		. += 3

	if(MUTATION_FAT in src.mutations)
		. += 1.5
	if(bodytemperature < 283.222)
		. += (283.222 - bodytemperature) / 10 * 1.75

	if(MUTATION_NO_SLOWDOWN in mutations)
		. = 0

	. += CONFIG_GET(/decl/configuration_entry/human_delay)

/mob/living/carbon/human/Process_Spacemove(check_drift = 0)
	//Can we act
	if(restrained())
		return FALSE

	//Do we have a working jetpack
	if(istype(back, /obj/item/tank/jetpack))
		var/obj/item/tank/jetpack/J = back
		if(((!check_drift) || (check_drift && J.stabilization_on)) && !lying && J.allow_thrust(0.01, src))
			inertia_dir = 0
			return TRUE
//		if(!check_drift && J.allow_thrust(0.01, src))
//			return 1

	//If no working jetpack then use the other checks
	if(..())
		return TRUE
	return FALSE

/mob/living/carbon/human/Process_Spaceslipping(prob_slip = 5)
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.
	if(HAS_SPECIES_FLAGS(species, SPECIES_FLAG_NO_SLIP))
		return

	if(stat)
		prob_slip = 0 // Changing this to zero to make it line up with the comment, and also, make more sense.

	//Do we have magboots or such on if so no slip
	if(istype(shoes, /obj/item/clothing/shoes/magboots) && HAS_ITEM_FLAGS(shoes, ITEM_FLAG_NO_SLIP))
		prob_slip = 0

	//Check hands and mod slip
	if(!l_hand)
		prob_slip -= 2
	else if(l_hand.w_class <= 2)
		prob_slip -= 1
	if(!r_hand)
		prob_slip -= 2
	else if(r_hand.w_class <= 2)
		prob_slip -= 1

	prob_slip = round(prob_slip)
	return(prob_slip)