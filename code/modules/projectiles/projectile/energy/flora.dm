/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"

	damage_type = TOX
	nodamage = TRUE

/obj/item/projectile/energy/floramut/on_hit(atom/target, blocked = 0)
	var/mob/living/M = target
//	if(ishuman(target) && M.dna && M.dna.mutantrace == "plant") //Plantmen possibly get mutated and damaged by the rays.
	if(ishuman(target))
		var/mob/living/carbon/human/H = M
		if(HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_IS_PLANT) && H.nutrition < 500)
			if(prob(15))
				H.apply_effect(rand(30, 80), IRRADIATE)
				H.Weaken(5)
				H.visible_message(
					message = SPAN_WARNING("[H] writhes in pain as \his vacuoles boil."),
					blind_message = SPAN_WARNING("You hear the crunching of leaves.")
				)
			if(prob(35))
			//	for (var/mob/V in viewers(src)) //Public messages commented out to prevent possible metaish genetics experimentation and stuff. - Cheridan
			//		V.show_message("\red [M] is mutated by the radiation beam.", 3, "\red You hear the snapping of twigs.", 2)
				if(prob(80))
					randmutb(H)
					domutcheck(H, null)
				else
					randmutg(H)
					domutcheck(H, null)
			else
				H.adjustFireLoss(rand(5, 15))
				H.show_message(SPAN_WARNING("The radiation beam singes you!"))
			//	for (var/mob/V in viewers(src))
			//		V.show_message("\red [M] is singed by the radiation beam.", 3, "\red You hear the crackle of burning leaves.", 2)
	else if(iscarbon(target))
	//	for (var/mob/V in viewers(src))
	//		V.show_message("The radiation beam dissipates harmlessly through [M]", 3)
		M.show_message(SPAN_INFO("The radiation beam dissipates harmlessly through your body."))
	else
		return 1

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"

	damage_type = TOX
	nodamage = TRUE

/obj/item/projectile/energy/florayield/on_hit(atom/target, blocked = 0)
	var/mob/M = target
	if(ishuman(target)) //These rays make plantmen fat.
		var/mob/living/carbon/human/H = M
		if(HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_IS_PLANT) && H.nutrition < 500)
			H.nutrition += 30
	else if(iscarbon(target))
		M.show_message(SPAN_INFO("The radiation beam dissipates harmlessly through your body."))
	else
		return 1