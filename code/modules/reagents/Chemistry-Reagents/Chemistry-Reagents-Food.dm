/////////////////////////Food Reagents////////////////////////////
// Part of the food code. Nutriment is used instead of the old "heal_amt" code. Also is where all the food
// 	condiments, additives, and such go.
/datum/reagent/nutriment
			name = "Nutriment"
			id = "nutriment"
			description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
			reagent_state = SOLID
			nutriment_factor = 15 * REAGENTS_METABOLISM
			color = "#664330" // rgb: 102, 67, 48

/datum/reagent/nutriment/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(prob(50)) M.heal_organ_damage(1,0)
	M.nutrition += nutriment_factor	// For hunger and fatness
/*
				// If overeaten - vomit and fall down
				// Makes you feel bad but removes reagents and some effect
				// from your body
				if (M.nutrition > 650)
					M.nutrition = rand (250, 400)
					M.weakened += rand(2, 10)
					M.jitteriness += rand(0, 5)
					M.dizziness = max (0, (M.dizziness - rand(0, 15)))
					M.druggy = max (0, (M.druggy - rand(0, 15)))
					M.adjustToxLoss(rand(-15, -5)))
					M.updatehealth()
*/
	..()
	return


// Added stokaline, which is basically a vitamin supplement.
// Gives more nutriment factor than nutriment itself (25 vs 15), but has an overdose threshold.
// Also like, only take this if you're undernourished or you'll get bad effects.
// Not sure whether to put this here or in Chemistry-Reagents-Medicine. -Frenjo
/datum/reagent/stokaline
	name = "Stokaline"
	id = "stokaline"
	description = "A synthetic vitamin supplement for the health conscious spacer. Don't take too much at once."
	reagent_state = LIQUID

	// Okay so this code is untested but I hope it works like I think it does. -Frenjo
	custom_metabolism = REAGENTS_METABOLISM
	nutriment_factor = 25 * REAGENTS_METABOLISM

	color = "#665145" // rgb: 102, 81, 69 - Sort of a more grey nutriment.
	overdose = REAGENTS_OVERDOSE / 3 // 30 becomes 10. -Frenjo

/datum/reagent/stokaline/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	//if(prob(50)) M.heal_organ_damage(1,0)
	M.nutrition += nutriment_factor	// For hunger and fatness

	// Basically a copy of the commented out nutriment code with added overdose condition.
	// I'll probably tweak this later to make it less severe after testing. -Frenjo
	/*if (M.nutrition > 650)
		M.nutrition = rand (250, 400)
		M.weakened += rand(2, 10)
		M.make_jittery(rand(0, 5))
		M.make_dizzy(max(0, (M.dizziness - rand(0, 15))))
		M.druggy = max(0, (M.druggy - rand(0, 15)))
		M.adjustToxLoss(rand(-15, -5))
		M.updatehealth()*/

	if(volume >= overdose)
		if(!M.stuttering) M.stuttering = 1
		M.make_jittery(10)
		M.make_dizzy(10)
		M.druggy = max(M.druggy, 15)
		M.adjustBrainLoss(1)
		M.updatehealth()
	..()
	return


/datum/reagent/lipozine
	name = "Lipozine" // The anti-nutriment.
	id = "lipozine"
	description = "A chemical compound that causes a powerful fat-burning reaction."
	reagent_state = LIQUID
	nutriment_factor = 10 * REAGENTS_METABOLISM
	color = "#BBEDA4" // rgb: 187, 237, 164
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lipozine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.nutrition -= nutriment_factor
	M.overeatduration = 0
	if(M.nutrition < 0)//Prevent from going into negatives.
		M.nutrition = 0
	..()
	return


/datum/reagent/soysauce
	name = "Soysauce"
	id = "soysauce"
	description = "A salty sauce made from the soy plant."
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#792300" // rgb: 121, 35, 0

/datum/reagent/ketchup
	name = "Ketchup"
	id = "ketchup"
	description = "Ketchup, catsup, whatever. It's tomato paste."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#731008" // rgb: 115, 16, 8

/datum/reagent/capsaicin
	name = "Capsaicin Oil"
	id = "capsaicin"
	description = "This is what makes chilis hot."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 179, 16, 8

/datum/reagent/capsaicin/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(!data) data = 1
	switch(data)
		if(1 to 15)
			M.bodytemperature += 5 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(holder.has_reagent("frostoil"))
				holder.remove_reagent("frostoil", 5)
			if(istype(M, /mob/living/carbon/slime))
				M.bodytemperature += rand(5,20)
		if(15 to 25)
			M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(istype(M, /mob/living/carbon/slime))
				M.bodytemperature += rand(10,20)
		if(25 to INFINITY)
			M.bodytemperature += 15 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(istype(M, /mob/living/carbon/slime))
				M.bodytemperature += rand(15,20)
	holder.remove_reagent(src.id, FOOD_METABOLISM)
	data++
	..()
	return


/datum/reagent/condensedcapsaicin
			name = "Condensed Capsaicin"
			id = "condensedcapsaicin"
			description = "A chemical agent used for self-defense and in police work."
			reagent_state = LIQUID
			color = "#B31008" // rgb: 179, 16, 8

/datum/reagent/condensedcapsaicin/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/victim = M
			var/mouth_covered = 0
			var/eyes_covered = 0
			var/obj/item/safe_thing = null
			if( victim.wear_mask )
				if ( victim.wear_mask.flags & MASKCOVERSEYES )
					eyes_covered = 1
					safe_thing = victim.wear_mask
				if ( victim.wear_mask.flags & MASKCOVERSMOUTH )
					mouth_covered = 1
					safe_thing = victim.wear_mask
			if( victim.head )
				if ( victim.head.flags & MASKCOVERSEYES )
					eyes_covered = 1
					safe_thing = victim.head
				if ( victim.head.flags & MASKCOVERSMOUTH )
					mouth_covered = 1
					safe_thing = victim.head
			if(victim.glasses)
				eyes_covered = 1
				if ( !safe_thing )
					safe_thing = victim.glasses
			if ( eyes_covered && mouth_covered )
				victim << "\red Your [safe_thing] protects you from the pepperspray!"
				return
			else if ( mouth_covered )	// Reduced effects if partially protected
				victim << "\red Your [safe_thing] protect you from most of the pepperspray!"
				victim.eye_blurry = max(M.eye_blurry, 15)
				victim.eye_blind = max(M.eye_blind, 5)
				victim.Stun(5)
				victim.Weaken(5)
				//victim.Paralyse(10)
				//victim.drop_item()
				return
			else if ( eyes_covered ) // Eye cover is better than mouth cover
				victim << "\red Your [safe_thing] protects your eyes from the pepperspray!"
				victim.emote("scream")
				victim.eye_blurry = max(M.eye_blurry, 5)
				return
			else // Oh dear :D
				victim.emote("scream")
				victim << "\red You're sprayed directly in the eyes with pepperspray!"
				victim.eye_blurry = max(M.eye_blurry, 25)
				victim.eye_blind = max(M.eye_blind, 10)
				victim.Stun(5)
				victim.Weaken(5)
				//victim.Paralyse(10)
				//victim.drop_item()

/datum/reagent/condensedcapsaicin/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(prob(5))
		M.visible_message("<span class='warning'>[M] [pick("dry heaves!","coughs!","splutters!")]</span>")
	return


/datum/reagent/frostoil
	name = "Frost Oil"
	id = "frostoil"
	description = "A special oil that noticably chills the body. Extracted from Ice Peppers."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 139, 166, 233

/datum/reagent/frostoil/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(!data) data = 1
	switch(data)
		if(1 to 15)
			M.bodytemperature -= 5 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(holder.has_reagent("capsaicin"))
				holder.remove_reagent("capsaicin", 5)
			if(istype(M, /mob/living/carbon/slime))
				M.bodytemperature -= rand(5,20)
		if(15 to 25)
			M.bodytemperature -= 10 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(istype(M, /mob/living/carbon/slime))
				M.bodytemperature -= rand(10,20)
		if(25 to INFINITY)
			M.bodytemperature -= 15 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(prob(1)) M.emote("shiver")
			if(istype(M, /mob/living/carbon/slime))
				M.bodytemperature -= rand(15,20)
	data++
	holder.remove_reagent(src.id, FOOD_METABOLISM)
	..()
	return

/datum/reagent/frostoil/reaction_turf(var/turf/simulated/T, var/volume)
	for(var/mob/living/carbon/slime/M in T)
		M.adjustToxLoss(rand(15,30))


/datum/reagent/sodiumchloride
	name = "Table Salt"
	id = "sodiumchloride"
	description = "A salt made of sodium chloride. Commonly used to season food."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	overdose = REAGENTS_OVERDOSE

/datum/reagent/blackpepper
	name = "Black Pepper"
	id = "blackpepper"
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	reagent_state = SOLID
	// no color (ie, black)

/datum/reagent/coco
	name = "Coco Powder"
	id = "coco"
	description = "A fatty, bitter paste made from coco beans."
	reagent_state = SOLID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/coco/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	..()
	return


/datum/reagent/hot_coco
	name = "Hot Chocolate"
	id = "hot_coco"
	description = "Made with love! And cocoa beans."
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#403010" // rgb: 64, 48, 16

/datum/reagent/hot_coco/on_mob_life(var/mob/living/M as mob)
	if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.nutrition += nutriment_factor
	..()
	return


/datum/reagent/psilocybin
	name = "Psilocybin"
	id = "psilocybin"
	description = "A strong psychotropic derived from certain species of mushroom."
	color = "#E700E7" // rgb: 231, 0, 231
	overdose = REAGENTS_OVERDOSE

/datum/reagent/psilocybin/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.druggy = max(M.druggy, 30)
	if(!data) data = 1
	switch(data)
		if(1 to 5)
			if (!M.stuttering) M.stuttering = 1
			M.make_dizzy(5)
			if(prob(10)) M.emote(pick("twitch","giggle"))
		if(5 to 10)
			if (!M.stuttering) M.stuttering = 1
			M.make_jittery(10)
			M.make_dizzy(10)
			M.druggy = max(M.druggy, 35)
			if(prob(20)) M.emote(pick("twitch","giggle"))
		if (10 to INFINITY)
			if (!M.stuttering) M.stuttering = 1
			M.make_jittery(20)
			M.make_dizzy(20)
			M.druggy = max(M.druggy, 40)
			if(prob(30)) M.emote(pick("twitch","giggle"))
	holder.remove_reagent(src.id, 0.2)
	data++
	..()
	return


/datum/reagent/sprinkles
	name = "Sprinkles"
	id = "sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FF00FF" // rgb: 255, 0, 255

/datum/reagent/sprinkles/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	if(istype(M, /mob/living/carbon/human) && M.job in list("Security Officer", "Head of Security", "Detective", "Warden"))
		if(!M) M = holder.my_atom
		M.heal_organ_damage(1,1)
		M.nutrition += nutriment_factor
		..()
		return
	..()

/*	//removed because of meta bullshit. this is why we can't have nice things.
		syndicream
			name = "Cream filling"
			id = "syndicream"
			description = "Delicious cream filling of a mysterious origin. Tastes criminally good."
			nutriment_factor = 1 * REAGENTS_METABOLISM
			color = "#AB7878" // rgb: 171, 120, 120

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				if(istype(M, /mob/living/carbon/human) && M.mind)
					if(M.mind.special_role)
						if(!M) M = holder.my_atom
						M.heal_organ_damage(1,1)
						M.nutrition += nutriment_factor
						..()
						return
				..()
*/
/datum/reagent/cornoil
	name = "Corn Oil"
	id = "cornoil"
	description = "An oil derived from various types of corn."
	reagent_state = LIQUID
	nutriment_factor = 20 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/cornoil/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	..()
	return

/datum/reagent/cornoil/reaction_turf(var/turf/simulated/T, var/volume)
	if (!istype(T)) return
	del(src)
	if(volume >= 3)
		if(T.wet >= 1) return
		T.wet = 1
		if(T.wet_overlay)
			T.overlays -= T.wet_overlay
			T.wet_overlay = null
		T.wet_overlay = image('icons/effects/water.dmi',T,"wet_floor")
		T.overlays += T.wet_overlay

		spawn(800)
			if (!istype(T)) return
			if(T.wet >= 2) return
			T.wet = 0
			if(T.wet_overlay)
				T.overlays -= T.wet_overlay
				T.wet_overlay = null
	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot)
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
		lowertemp.react()
		T.assume_air(lowertemp)
		del(hotspot)


/datum/reagent/enzyme
	name = "Universal Enzyme"
	id = "enzyme"
	description = "A universal enzyme used in the preperation of certain chemicals and foods."
	reagent_state = LIQUID
	color = "#365E30" // rgb: 54, 94, 48
	overdose = REAGENTS_OVERDOSE

/datum/reagent/dry_ramen
	name = "Dry Ramen"
	id = "dry_ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/dry_ramen/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	..()
	return


/datum/reagent/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/hot_ramen/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (10 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()
	return


/datum/reagent/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/hell_ramen/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT
	..()
	return


/* We're back to flour bags
		flour
			name = "flour"
			id = "flour"
			description = "This is what you rub all over yourself to pretend to be a ghost."
			reagent_state = SOLID
			nutriment_factor = 1 * REAGENTS_METABOLISM
			color = "#FFFFFF" // rgb: 0, 0, 0

			on_mob_life(var/mob/living/M as mob)
				M.nutrition += nutriment_factor
				..()
				return

			reaction_turf(var/turf/T, var/volume)
				del(src)
				if(!istype(T, /turf/space))
					new /obj/effect/decal/cleanable/flour(T)
*/

/datum/reagent/rice
	name = "Rice"
	id = "rice"
	description = "Enjoy the great taste of nothing."
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FFFFFF" // rgb: 0, 0, 0

/datum/reagent/rice/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	..()
	return

/datum/reagent/cherryjelly
	name = "Cherry Jelly"
	id = "cherryjelly"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	reagent_state = LIQUID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#801E28" // rgb: 128, 30, 40

/datum/reagent/cherryjelly/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	..()
	return