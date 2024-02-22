/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"

	damage = 0
	damage_type = BURN
	nodamage = TRUE
	flag = "energy"

/obj/item/projectile/ion/on_hit(atom/target, blocked = 0)
	empulse(target, 1, 1)
	return 1

/obj/item/projectile/bullet/gyro
	name = "explosive bolt"
	icon_state = "bolter"

	damage = 50
	edge = TRUE

/obj/item/projectile/bullet/gyro/on_hit(atom/target, blocked = 0)
	explosion(target, -1, 0, 2)
	return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"

	damage = 0
	damage_type = BURN
	nodamage = TRUE
	flag = "energy"

	var/temperature = 300

/obj/item/projectile/temp/on_hit(atom/target, blocked = 0)//These two could likely check temp protection on the mob
	if(ismob(target))
		var/mob/M = target
		M.bodytemperature = temperature
	return 1

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"

	damage = 0
	nodamage = TRUE

/obj/item/projectile/meteor/Bump(atom/A as mob|obj|turf|area)
	if(A == firer)
		loc = A.loc
		return

	sleep(-1) // Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

	if(isnotnull(src)) // Do not add to this if() statement, otherwise the meteor won't delete them
		if(isnotnull(A))
			A.meteorhit(src)
			playsound(src, 'sound/effects/meteorimpact.ogg', 40, 1)

			for(var/mob/M in range(10, src))
				if(!M.stat && !isAI(M))
					shake_camera(M, 3, 1)
			qdel(src)
			return 1
	else
		return 0

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
		if(HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_IS_PLANT) && M.nutrition < 500)
			if(prob(15))
				M.apply_effect(rand(30, 80), IRRADIATE)
				M.Weaken(5)
				M.visible_message(
					message = SPAN_WARNING("[M] writhes in pain as \his vacuoles boil."),
					blind_message = SPAN_WARNING("You hear the crunching of leaves.")
				)
			if(prob(35))
			//	for (var/mob/V in viewers(src)) //Public messages commented out to prevent possible metaish genetics experimentation and stuff. - Cheridan
			//		V.show_message("\red [M] is mutated by the radiation beam.", 3, "\red You hear the snapping of twigs.", 2)
				if(prob(80))
					randmutb(M)
					domutcheck(M, null)
				else
					randmutg(M)
					domutcheck(M, null)
			else
				M.adjustFireLoss(rand(5, 15))
				M.show_message(SPAN_WARNING("The radiation beam singes you!"))
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
		if(HAS_SPECIES_FLAGS(H.species, SPECIES_FLAG_IS_PLANT) && M.nutrition < 500)
			M.nutrition += 30
	else if(iscarbon(target))
		M.show_message(SPAN_INFO("The radiation beam dissipates harmlessly through your body."))
	else
		return 1

/obj/item/projectile/energy/beam/mindflayer
	name = "flayer ray"

/obj/item/projectile/energy/beam/mindflayer/on_hit(atom/target, blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		M.adjustBrainLoss(20)
		M.hallucination += 20