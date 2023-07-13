/datum/disease2/effectholder
	var/name = "Holder"
	var/datum/disease2/effect/effect
	var/chance = 0 //Chance in percentage each tick
	var/cure = "" //Type of cure it requires
	var/happensonce = 0
	var/multiplier = 1 //The chance the effects are WORSE
	var/stage = 0

/datum/disease2/effectholder/proc/runeffect(var/mob/living/carbon/human/mob,var/stage)
	if(happensonce > -1 && effect.stage <= stage && prob(chance))
		effect.activate(mob)
		if(happensonce == 1)
			happensonce = -1

/datum/disease2/effectholder/proc/getrandomeffect(var/badness = 1)
	var/list/datum/disease2/effect/list = list()
	for(var/e in SUBTYPESOF(/datum/disease2/effect))
		var/datum/disease2/effect/f = new e
		if (f.badness > badness)	//we don't want such strong effects
			continue
		if(f.stage == src.stage)
			list += f
	effect = pick(list)
	chance = rand(0,effect.chance_maxm)
	multiplier = rand(1,effect.maxm)

/datum/disease2/effectholder/proc/minormutate()
	switch(pick(1,2,3,4,5))
		if(1)
			chance = rand(0,effect.chance_maxm)
		if(2)
			multiplier = rand(1,effect.maxm)

/datum/disease2/effectholder/proc/majormutate()
	getrandomeffect(2)

////////////////////////////////////////////////////////////////
////////////////////////EFFECTS/////////////////////////////////
////////////////////////////////////////////////////////////////

/datum/disease2/effect
	var/chance_maxm = 50
	var/name = "Blanking effect"
	var/stage = 4
	var/maxm = 1
	var/badness = 1

/datum/disease2/effect/proc/activate(var/mob/living/carbon/mob,var/multiplier)
/datum/disease2/effect/proc/deactivate(var/mob/living/carbon/mob)

/datum/disease2/effect/invisible
	name = "Waiting Syndrome"
	stage = 1

/datum/disease2/effect/invisible/activate(var/mob/living/carbon/mob,var/multiplier)
	return

////////////////////////STAGE 4/////////////////////////////////

/datum/disease2/effect/gibbingtons
	name = "Gibbingtons Syndrome"
	stage = 4
	badness = 2

/datum/disease2/effect/gibbingtons/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.gib()


/datum/disease2/effect/radian
	name = "Radian's Syndrome"
	stage = 4
	maxm = 3

/datum/disease2/effect/radian/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.radiation += (2 * multiplier)


/datum/disease2/effect/deaf
	name = "Dead Ear Syndrome"
	stage = 4

/datum/disease2/effect/deaf/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.ear_deaf += 20

/datum/disease2/effect/monkey
	name = "Monkism Syndrome"
	stage = 4
	badness = 2

/datum/disease2/effect/monkey/activate(var/mob/living/carbon/mob, var/multiplier)
	if(ishuman(mob))
		var/mob/living/carbon/human/h = mob
		h.monkeyize()


/datum/disease2/effect/suicide
	name = "Suicidal Syndrome"
	stage = 4
	badness = 2

/datum/disease2/effect/suicide/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.suiciding = 1
	//instead of killing them instantly, just put them at -175 health and let 'em gasp for a while
	viewers(mob) << "\red <b>[mob.name] is holding \his breath. It looks like \he's trying to commit suicide.</b>"
	mob.adjustOxyLoss(175 - mob.getToxLoss() - mob.getFireLoss() - mob.getBruteLoss() - mob.getOxyLoss())
	mob.updatehealth()
	spawn(200) //in case they get revived by cryo chamber or something stupid like that, let them suicide again in 20 seconds
		mob.suiciding = 0


/datum/disease2/effect/killertoxins
	name = "Toxification Syndrome"
	stage = 4

/datum/disease2/effect/killertoxins/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.adjustToxLoss(15 * multiplier)


/datum/disease2/effect/dna
	name = "Reverse Pattern Syndrome"
	stage = 4

/datum/disease2/effect/dna/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.bodytemperature = max(mob.bodytemperature, 350)
	scramble(0,mob,10)
	mob.apply_damage(10, CLONE)


/datum/disease2/effect/organs
	name = "Shutdown Syndrome"
	stage = 4

/datum/disease2/effect/organs/activate(var/mob/living/carbon/mob, var/multiplier)
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		var/organ = pick(list("r_arm","l_arm","r_leg","r_leg"))
		var/datum/organ/external/E = H.organs_by_name[organ]
		if(!(E.status & ORGAN_DEAD))
			E.status |= ORGAN_DEAD
			to_chat(H, SPAN_NOTICE("You can't feel your [E.display_name] anymore..."))
			for(var/datum/organ/external/C in E.children)
				C.status |= ORGAN_DEAD
		H.update_body(1)
	mob.adjustToxLoss(15 * multiplier)

/datum/disease2/effect/organs/deactivate(var/mob/living/carbon/mob, var/multiplier)
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		for(var/datum/organ/external/E in H.organs)
			E.status &= ~ORGAN_DEAD
			for(var/datum/organ/external/C in E.children)
				C.status &= ~ORGAN_DEAD
		H.update_body(1)


/datum/disease2/effect/immortal
	name = "Longevity Syndrome"
	stage = 4

/datum/disease2/effect/immortal/activate(var/mob/living/carbon/mob, var/multiplier)
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		for(var/datum/organ/external/E in H.organs)
			if (E.status & ORGAN_BROKEN && prob(30))
				E.status ^= ORGAN_BROKEN
	var/heal_amt = -5*multiplier
	mob.apply_damages(heal_amt, heal_amt, heal_amt, heal_amt)

/datum/disease2/effect/immortal/deactivate(var/mob/living/carbon/mob, var/multiplier)
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		to_chat(H, SPAN_NOTICE("You suddenly feel hurt and old..."))
		H.age += 8
	var/backlash_amt = 5 * multiplier
	mob.apply_damages(backlash_amt, backlash_amt, backlash_amt, backlash_amt)

////////////////////////STAGE 3/////////////////////////////////

/datum/disease2/effect/bones
	name = "Fragile Bones Syndrome"
	stage = 4

/datum/disease2/effect/bones/activate(var/mob/living/carbon/mob, var/multiplier)
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		for (var/datum/organ/external/E in H.organs)
			E.min_broken_damage = max(5, E.min_broken_damage - 30)

/datum/disease2/effect/bones/deactivate(var/mob/living/carbon/mob, var/multiplier)
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		for (var/datum/organ/external/E in H.organs)
			E.min_broken_damage = initial(E.min_broken_damage)


/datum/disease2/effect/toxins
	name = "Hyperacidity"
	stage = 3
	maxm = 3

/datum/disease2/effect/toxins/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.adjustToxLoss((2 * multiplier))


/datum/disease2/effect/shakey
	name = "World Shaking Syndrome"
	stage = 3
	maxm = 3

/datum/disease2/effect/shakey/activate(var/mob/living/carbon/mob, var/multiplier)
	shake_camera(mob,5 * multiplier)


/datum/disease2/effect/telepathic
	name = "Telepathy Syndrome"
	stage = 3

/datum/disease2/effect/telepathic/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.dna.check_integrity()
	mob.dna.SetSEState(REMOTETALKBLOCK, 1)
	domutcheck(mob, null)


/datum/disease2/effect/mind
	name = "Lazy Mind Syndrome"
	stage = 3

/datum/disease2/effect/mind/activate(var/mob/living/carbon/mob, var/multiplier)
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		var/datum/organ/internal/brain/B = H.internal_organs["brain"]
		if (B.damage < B.min_broken_damage)
			B.take_damage(5)
	else
		mob.setBrainLoss(50)


/datum/disease2/effect/hallucinations
	name = "Hallucinational Syndrome"
	stage = 3

/datum/disease2/effect/hallucinations/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.hallucination += 25


/datum/disease2/effect/deaf
	name = "Hard of Hearing Syndrome"
	stage = 3

/datum/disease2/effect/deaf/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.ear_deaf = 5


/datum/disease2/effect/giggle
	name = "Uncontrolled Laughter Effect"
	stage = 3

/datum/disease2/effect/giggle/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.say("*giggle")


/datum/disease2/effect/confusion
	name = "Topographical Cretinism"
	stage = 3

/datum/disease2/effect/confusion/activate(var/mob/living/carbon/mob, var/multiplier)
	to_chat(mob, SPAN_NOTICE("You have trouble telling right and left apart all of a sudden."))
	mob.confused += 10


/datum/disease2/effect/mutation
	name = "DNA Degradation"
	stage = 3

/datum/disease2/effect/mutation/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.apply_damage(2, CLONE)


/datum/disease2/effect/groan
	name = "Groaning Syndrome"
	stage = 3

/datum/disease2/effect/groan/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.say("*groan")

////////////////////////STAGE 2/////////////////////////////////

/datum/disease2/effect/scream
	name = "Loudness Syndrome"
	stage = 2

/datum/disease2/effect/scream/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.say("*scream")


/datum/disease2/effect/drowsness
	name = "Automated Sleeping Syndrome"
	stage = 2

/datum/disease2/effect/drowsness/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.drowsyness += 10


/datum/disease2/effect/sleepy
	name = "Resting Syndrome"
	stage = 2

/datum/disease2/effect/sleepy/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.say("*collapse")


/datum/disease2/effect/blind
	name = "Blackout Syndrome"
	stage = 2

/datum/disease2/effect/blind/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.eye_blind = max(mob.eye_blind, 4)


/datum/disease2/effect/cough
	name = "Anima Syndrome"
	stage = 2

/datum/disease2/effect/cough/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.say("*cough")
	for(var/mob/living/carbon/M in oview(2,mob))
		mob.spread_disease_to(M)


/datum/disease2/effect/hungry
	name = "Appetiser Effect"
	stage = 2

/datum/disease2/effect/hungry/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.nutrition = max(0, mob.nutrition - 200)


/datum/disease2/effect/fridge
	name = "Refridgerator Syndrome"
	stage = 2

/datum/disease2/effect/fridge/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*shiver")


/datum/disease2/effect/hair
	name = "Hair Loss"
	stage = 2

/datum/disease2/effect/hair/activate(var/mob/living/carbon/mob,var/multiplier)
	if(ishuman(mob))
		var/mob/living/carbon/human/H = mob
		if(H.species.name == SPECIES_HUMAN && !(H.h_style == "Bald") && !(H.h_style == "Balding Hair"))
			to_chat(H, SPAN_DANGER("Your hair starts to fall out in clumps..."))
			spawn(50)
				H.h_style = "Balding Hair"
				H.update_hair()


/datum/disease2/effect/stimulant
	name = "Adrenaline Extra"
	stage = 2

/datum/disease2/effect/stimulant/activate(var/mob/living/carbon/mob, var/multiplier)
	to_chat(mob, SPAN_NOTICE("You feel a rush of energy inside you!"))
	if(mob.reagents.get_reagent_amount("hyperzine") < 10)
		mob.reagents.add_reagent("hyperzine", 4)
	if(prob(30))
		mob.jitteriness += 10

////////////////////////STAGE 1/////////////////////////////////

/datum/disease2/effect/sneeze
	name = "Coldingtons Effect"
	stage = 1

/datum/disease2/effect/sneeze/activate(var/mob/living/carbon/mob, var/multiplier)
	if(prob(30))
		to_chat(mob, SPAN_WARNING("You feel like you are about to sneeze!"))
	sleep(5)
	mob.say("*sneeze")
	for(var/mob/living/carbon/M in get_step(mob,mob.dir))
		mob.spread_disease_to(M)
	if(prob(50))
		var/obj/effect/decal/cleanable/mucus/M = new(get_turf(mob))
		M.virus2 = virus_copylist(mob.virus2)


/datum/disease2/effect/gunck
	name = "Flemmingtons"
	stage = 1

/datum/disease2/effect/gunck/activate(var/mob/living/carbon/mob, var/multiplier)
	mob << "\red Mucous runs down the back of your throat."


/datum/disease2/effect/drool
	name = "Saliva Effect"
	stage = 1

/datum/disease2/effect/drool/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.say("*drool")


/datum/disease2/effect/twitch
	name = "Twitcher"
	stage = 1

/datum/disease2/effect/twitch/activate(var/mob/living/carbon/mob, var/multiplier)
	mob.say("*twitch")


/datum/disease2/effect/headache
	name = "Headache"
	stage = 1

/datum/disease2/effect/headache/activate(var/mob/living/carbon/mob, var/multiplier)
	to_chat(mob, SPAN_NOTICE("Your head hurts a bit"))