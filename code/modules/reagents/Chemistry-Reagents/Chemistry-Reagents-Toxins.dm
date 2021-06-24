//////////////////////////Poison stuff///////////////////////

/datum/reagent/toxin
	name = "Toxin"
	id = "toxin"
	description = "A toxic chemical."
	reagent_state = REAGENT_LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	var/toxpwr = 0.7 // Toxins are really weak, but without being treated, last very long.
	custom_metabolism = 0.1

/datum/reagent/toxin/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(toxpwr)
		M.adjustToxLoss(toxpwr * REM)
	..()
	return


/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	id = "amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	reagent_state = REAGENT_LIQUID
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 1

/datum/reagent/toxin/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	reagent_state = REAGENT_LIQUID
	color = "#13BC5E" // rgb: 19, 188, 94
	toxpwr = 0

/datum/reagent/toxin/mutagen/reaction_mob(mob/living/carbon/M, method = TOUCH, volume)
	if(!..())
		return
	if(!istype(M) || !M.dna)
		return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	qdel(src)
	if((method == TOUCH && prob(33)) || method == INGEST)
		randmuti(M)
		if(prob(98))
			randmutb(M)
		else
			randmutg(M)
		domutcheck(M, null)
		M.UpdateAppearance()
	return

/datum/reagent/toxin/mutagen/on_mob_life(mob/living/carbon/M)
	if(!istype(M))
		return
	if(!M)
		M = holder.my_atom
	M.apply_effect(10, IRRADIATE, 0)
	..()
	return


/datum/reagent/plasma
	name = "Plasma"
	id = "plasma"
	description = "Plasma in its liquid form."
	reagent_state = REAGENT_LIQUID
	color = "#E71B00" // rgb: 231, 27, 0
	var/toxpwr = 3
	custom_metabolism = 0.1

/datum/reagent/plasma/on_mob_life(mob/living/M as mob, alien)
	if(!M)
		M = holder.my_atom
	if(alien && alien == IS_PLASMAPERSON)
		M.adjustBruteLoss(-5)
		M.adjustFireLoss(-5)
	if(!alien || alien != IS_PLASMAPERSON)
		M.adjustToxLoss(toxpwr * REM)

	if(holder.has_reagent("inaprovaline"))
		holder.remove_reagent("inaprovaline", 2 * REM)
	..()
	return

/datum/reagent/plasma/reaction_obj(obj/O, volume)
	qdel(src)
	/*if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/egg/slime))
		var/obj/item/weapon/reagent_containers/food/snacks/egg/slime/egg = O
		if (egg.grown)
			egg.Hatch()*/
	if((!O) || (!volume))
		return 0
	var/turf/the_turf = get_turf(O)
	the_turf.assume_gas("volatile_fuel", volume, T20C)

/datum/reagent/plasma/reaction_turf(turf/T, volume)
	qdel(src)
	T.assume_gas("volatile_fuel", volume, T20C)
	return

/datum/reagent/toxin/lexorin
	name = "Lexorin"
	id = "lexorin"
	description = "Lexorin temporarily stops respiration. Causes tissue damage."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	toxpwr = 0
	overdose = REAGENTS_OVERDOSE

/datum/reagent/toxin/lexorin/on_mob_life(mob/living/M as mob)
	if(M.stat == DEAD)
		return
	if(!M)
		M = holder.my_atom
	if(prob(33))
		M.take_organ_damage(1 * REM, 0)
	M.adjustOxyLoss(3)
	if(prob(20))
		M.emote("gasp")
	..()
	return


/datum/reagent/toxin/slimejelly
	name = "Slime Jelly"
	id = "slimejelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	reagent_state = REAGENT_LIQUID
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 0

/datum/reagent/toxin/slimejelly/on_mob_life(mob/living/M as mob)
	if(prob(10))
		to_chat(M, SPAN_WARNING("Your insides are burning!"))
		M.adjustToxLoss(rand(20, 60) * REM)
	else if(prob(40))
		M.heal_organ_damage(5 * REM, 0)
	..()
	return


/datum/reagent/toxin/cyanide //Fast and Lethal
	name = "Cyanide"
	id = "cyanide"
	description = "A highly toxic chemical."
	reagent_state = REAGENT_LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 4
	custom_metabolism = 0.4

/datum/reagent/toxin/cyanide/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.adjustOxyLoss(4 * REM)
	M.sleeping += 1
	..()
	return


/datum/reagent/toxin/minttoxin
	name = "Mint Toxin"
	id = "minttoxin"
	description = "Useful for dealing with undesirable customers."
	reagent_state = REAGENT_LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 0

/datum/reagent/toxin/minttoxin/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(FAT in M.mutations)
		M.gib()
	..()
	return


/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded space carp."
	reagent_state = REAGENT_LIQUID
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 2

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = REAGENT_SOLID
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5

/datum/reagent/toxin/zombiepowder/on_mob_life(mob/living/carbon/M as mob)
	if(!M)
		M = holder.my_atom
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(0.5 * REM)
	M.Weaken(10)
	M.silent = max(M.silent, 10)
	M.tod = worldtime2text()
	..()
	return

/datum/reagent/toxin/zombiepowder/Destroy()
	if(holder && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		M.status_flags &= ~FAKEDEATH
	..()


/datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	description = "A powerful hallucinogen, it can cause fatal effects in users."
	reagent_state = REAGENT_LIQUID
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE

/datum/reagent/toxin/mindbreaker/on_mob_life(mob/living/M)
	if(!M) M = holder.my_atom
	M.hallucination += 10
	..()
	return


/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	reagent_state = REAGENT_LIQUID
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1

	// Clear off wallrot fungi
/datum/reagent/toxin/plantbgone/reaction_turf(turf/T, volume)
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/W = T
		if(W.rotting)
			W.rotting = 0
			for(var/obj/effect/E in W)
				if(E.name == "Wallrot")
					qdel(E)

			for(var/mob/O in viewers(W, null))
				O.show_message(SPAN_INFO("The fungi are completely dissolved by the solution!"), 1)

/datum/reagent/toxin/plantbgone/reaction_obj(obj/O, volume)
	if(istype(O, /obj/effect/alien/weeds/))
		var/obj/effect/alien/weeds/alien_weeds = O
		alien_weeds.health -= rand(15, 35) // Kills alien weeds pretty fast
		alien_weeds.healthcheck()
	else if(istype(O, /obj/effect/glowshroom)) //even a small amount is enough to kill it
		qdel(O)
	else if(istype(O, /obj/effect/spacevine))
		if(prob(50))
			qdel(O) //Kills kudzu too.
	// Damage that is done to growing plants is separately at code/game/machinery/hydroponics at obj/item/hydroponics

/datum/reagent/toxin/plantbgone/reaction_mob(mob/living/M, method = TOUCH, volume)
	qdel(src)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(!C.wear_mask) // If not wearing a mask
			C.adjustToxLoss(2) // 4 toxic damage per application, doubled for some reason
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.dna)
				if(H.species.flags & IS_PLANT) //plantmen take a LOT of damage
					H.adjustToxLoss(50)


/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "A powerful sedative."
	reagent_state = REAGENT_SOLID
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 1
	custom_metabolism = 0.1 //Default 0.2
	overdose = 15
	overdose_dam = 5

/datum/reagent/toxin/chloralhydrate/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(!data)
		data = 1
	data++
	switch(data)
		if(1)
			M.confused += 2
			M.drowsyness += 2
		if(2 to 199)
			M.Weaken(30)
		if(200 to INFINITY)
			M.sleeping += 1
	..()
	return


/datum/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	description = "A delicious salt that stops the heart when injected into cardiac muscle."
	reagent_state = REAGENT_SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	toxpwr = 0
	overdose = 30

/datum/reagent/toxin/potassium_chloride/on_mob_life(mob/living/carbon/M as mob)
	var/mob/living/carbon/human/H = M
	if(H.stat != 1)
		if(volume >= overdose)
			if(H.losebreath >= 10)
				H.losebreath = max(10, H.losebreath - 10)
			H.adjustOxyLoss(2)
			H.Weaken(10)
	..()
	return


/datum/reagent/toxin/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	description = "A specific chemical based on Potassium Chloride to stop the heart for surgery. Not safe to eat!"
	reagent_state = REAGENT_SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	toxpwr = 2
	overdose = 20

/datum/reagent/toxin/potassium_chlorophoride/on_mob_life(mob/living/carbon/M as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != 1)
			if(H.losebreath >= 10)
				H.losebreath = max(10, M.losebreath - 10)
			H.adjustOxyLoss(2)
			H.Weaken(10)
	..()
	return


/datum/reagent/toxin/beer2	//disguised as normal beer for use by emagged brobots
	name = "Beer"
	id = "beer2"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. The fermentation appears to be imcomplete." //If the players manage to analyze this, they deserve to know something is wrong.
	reagent_state = REAGENT_LIQUID
	color = "#664300" // rgb: 102, 67, 0
	custom_metabolism = 0.15 // Sleep toxins should always be consumed pretty fast
	overdose = REAGENTS_OVERDOSE/2

/datum/reagent/toxin/beer2/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(!data)
		data = 1
	switch(data)
		if(1)
			M.confused += 2
			M.drowsyness += 2
		if(2 to 50)
			M.sleeping += 1
		if(51 to INFINITY)
			M.sleeping += 1
			M.adjustToxLoss((data - 50) * REM)
	data++
	..()
	return


/datum/reagent/toxin/acid
	name = "Sulphuric acid"
	id = "sacid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	reagent_state = REAGENT_LIQUID
	color = "#DB5008" // rgb: 219, 80, 8
	toxpwr = 1
	var/meltprob = 10

/datum/reagent/toxin/acid/on_mob_life(mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.take_organ_damage(0, 1 * REM)
	..()
	return

/datum/reagent/toxin/acid/reaction_mob(mob/living/M, method = TOUCH, volume)//magic numbers everywhere
	if(!isliving(M))
		return
	if(method == TOUCH)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.head)
				if(prob(meltprob) && !H.head.unacidable)
					to_chat(H, SPAN_DANGER("Your headgear melts away but protects you from the acid!"))
					qdel(H.head)
					H.update_inv_head(0)
					H.update_hair(0)
				else
					to_chat(H, SPAN_WARNING("Your headgear protects you from the acid."))
				return

			if(H.wear_mask)
				if(prob(meltprob) && !H.wear_mask.unacidable)
					to_chat(H, SPAN_DANGER("Your mask melts away but protects you from the acid!"))
					qdel(H.wear_mask)
					H.update_inv_wear_mask(0)
					H.update_hair(0)
				else
					to_chat(H, SPAN_WARNING("Your mask protects you from the acid."))
				return

			if(H.glasses) //Doesn't protect you from the acid but can melt anyways!
				if(prob(meltprob) && !H.glasses.unacidable)
					to_chat(H, SPAN_DANGER("Your glasses melt away!"))
					qdel(H.glasses)
					H.update_inv_glasses(0)

		else if(ismonkey(M))
			var/mob/living/carbon/monkey/MK = M
			if(MK.wear_mask)
				if(!MK.wear_mask.unacidable)
					to_chat(MK, SPAN_DANGER("Your mask melts away but protects you from the acid!"))
					qdel(MK.wear_mask)
					MK.update_inv_wear_mask(0)
				else
					to_chat(MK, SPAN_WARNING("Your mask protects you from the acid."))
				return

		if(!M.unacidable)
			if(istype(M, /mob/living/carbon/human) && volume >= 10)
				var/mob/living/carbon/human/H = M
				var/datum/organ/external/affecting = H.get_organ("head")
				if(affecting)
					if(affecting.take_damage(4 * toxpwr, 2 * toxpwr))
						H.UpdateDamageIcon()
					if(prob(meltprob)) //Applies disfigurement
						H.emote("scream")
						H.status_flags |= DISFIGURED
			else
				M.take_organ_damage(min(6 * toxpwr, volume * toxpwr)) // uses min() and volume to make sure they aren't being sprayed in trace amounts (1 unit != insta rape) -- Doohl
	else
		if(!M.unacidable)
			M.take_organ_damage(min(6 * toxpwr, volume * toxpwr))

/datum/reagent/toxin/acid/reaction_obj(obj/O, volume)
	if((istype(O, /obj/item) || istype(O, /obj/effect/glowshroom)) && prob(meltprob * 3))
		if(!O.unacidable)
			var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(O.loc)
			I.desc = "Looks like this was \an [O] some time ago."
			for(var/mob/M in viewers(5, O))
				to_chat(M, SPAN_WARNING("\the [O] melts."))
			qdel(O)


/datum/reagent/toxin/acid/polyacid
	name = "Polytrinic acid"
	id = "pacid"
	description = "Polytrinic acid is a an extremely corrosive chemical substance."
	reagent_state = REAGENT_LIQUID
	color = "#8E18A9" // rgb: 142, 24, 169
	toxpwr = 2
	meltprob = 30