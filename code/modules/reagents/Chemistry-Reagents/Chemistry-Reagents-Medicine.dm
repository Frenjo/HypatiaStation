// Created this to separate medication out from general reagents, someone did it with antidepressants but not these in general! -Frenjo

/*
//Some on_mob_life() procs check for alien races.
#define IS_DIONA 1
#define IS_VOX 2
*/

//The reaction procs must ALWAYS set del(src), this detaches the proc from the object (the reagent)
//so that it can continue working when the reagent is deleted while the proc is still active.

// Category comments are mine, rest of them aren't. -Frenjo
// Precursor chemicals.
/datum/reagent/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	description = "Cryptobiolin causes confusion and dizzyness."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/cryptobiolin/on_mob_life(var/mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.make_dizzy(1)
	if(!M.confused)
		M.confused = 1
	M.confused = max(M.confused, 20)
	holder.remove_reagent(src.id, 0.5 * REAGENTS_METABOLISM)
	..()
	return


// Basic stuff.
/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE*2

/datum/reagent/inaprovaline/on_mob_life(var/mob/living/M as mob, var/alien)
	if(!M) M = holder.my_atom

	if(alien && alien == IS_VOX)
		M.adjustToxLoss(REAGENTS_METABOLISM)
	else
		if(M.losebreath >= 10)
			M.losebreath = max(10, M.losebreath-5)

	holder.remove_reagent(src.id, 0.5 * REAGENTS_METABOLISM)
	return


/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/bicaridine/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2.0)
		return
	if(!M) M = holder.my_atom
	if(alien != IS_DIONA)
		M.heal_organ_damage(2*REM,0)
	..()
	return


/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat burns."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/kelotane/on_mob_life(var/mob/living/M as mob)
	if(M.stat == 2.0)
		return
	if(!M) M = holder.my_atom
	//This needs a diona check but if one is added they won't be able to heal burn damage at all.
	M.heal_organ_damage(0,2*REM)
	..()
	return


/datum/reagent/anti_toxin
	name = "Anti-Toxin (Dylovene)"
	id = "anti_toxin"
	description = "Dylovene is a broad-spectrum antitoxin."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/anti_toxin/on_mob_life(var/mob/living/M as mob, var/alien)
	if(!M) M = holder.my_atom
	if(!alien || alien != IS_DIONA)
		M.reagents.remove_all_type(/datum/reagent/toxin, 1*REM, 0, 1)
		M.drowsyness = max(M.drowsyness-2*REM, 0)
		M.hallucination = max(0, M.hallucination - 5*REM)
		M.adjustToxLoss(-2*REM)
	..()
	return


/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/dexalin/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2.0)
		return  //See above, down and around. --Agouri
	if(!M) M = holder.my_atom

	if(alien && alien == IS_VOX)
		M.adjustToxLoss(2*REM)
	else if(!alien || alien != IS_DIONA)
		M.adjustOxyLoss(-2*REM)

	if(holder.has_reagent("lexorin"))
		holder.remove_reagent("lexorin", 2*REM)
	..()
	return


// Added cordrazine for fluff reasons, half as effective as tricordrazine. -Frenjo
/datum/reagent/cordrazine
	name = "Cordrazine"
	id = "cordrazine"
	description = "Cordrazine is a stimulant, originally derived from inaprovaline. Can be used to treat a wide range of injuries."
	reagent_state = REAGENT_LIQUID
	color = "#DDC8EA" // rgb: 221, 200, 234 - I was aiming for a lighter version of tricordrazine.

/datum/reagent/cordrazine/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2.0)
		return
	if(!M) M = holder.my_atom
	if(!alien || alien != IS_DIONA)
		if(M.getOxyLoss()) M.adjustOxyLoss(-0.5*REM)
		if(M.getBruteLoss() && prob(80)) M.heal_organ_damage(0.5*REM,0)
		if(M.getFireLoss() && prob(80)) M.heal_organ_damage(0,0.5*REM)
		if(M.getToxLoss() && prob(80)) M.adjustToxLoss(-0.5*REM)
	..()
	return


/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/tricordrazine/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2.0)
		return
	if(!M) M = holder.my_atom
	if(!alien || alien != IS_DIONA)
		if(M.getOxyLoss()) M.adjustOxyLoss(-1*REM)
		if(M.getBruteLoss() && prob(80)) M.heal_organ_damage(1*REM,0)
		if(M.getFireLoss() && prob(80)) M.heal_organ_damage(0,1*REM)
		if(M.getToxLoss() && prob(80)) M.adjustToxLoss(-1*REM)
	..()
	return


/datum/reagent/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE

/datum/reagent/hyronalin/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.radiation = max(M.radiation-3*REM,0)
	..()
	return


/datum/reagent/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "An all-purpose antiviral agent."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.01
	overdose = REAGENTS_OVERDOSE

/datum/reagent/spaceacillin/on_mob_life(var/mob/living/M as mob)
	..()
	return


/datum/reagent/toxin/stoxin
	name = "Sleep Toxin"
	id = "stoxin"
	description = "An effective hypnotic used to treat insomnia."
	reagent_state = REAGENT_LIQUID
	color = "#E895CC" // rgb: 232, 149, 204
	toxpwr = 0
	custom_metabolism = 0.1
	overdose = REAGENTS_OVERDOSE

/datum/reagent/toxin/stoxin/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(!data) data = 1
	switch(data)
		if(1 to 12)
			if(prob(5))
				M.emote("yawn")
		if(12 to 15)
			M.eye_blurry = max(M.eye_blurry, 10)
		if(15 to 49)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness  = max(M.drowsyness, 20)
		if(50 to INFINITY)
			M.Weaken(20)
			M.drowsyness  = max(M.drowsyness, 30)
	data++
	..()
	return


// Advanced variants of basic stuff.
/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE/2

/datum/reagent/dermaline/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2.0) //THE GUY IS **DEAD**! BEREFT OF ALL LIFE HE RESTS IN PEACE etc etc. He does NOT metabolise shit anymore, god DAMN
		return
	if(!M) M = holder.my_atom
	if(!alien || alien != IS_DIONA)
		M.heal_organ_damage(0,3*REM)
	..()
	return


/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE/2

/datum/reagent/dexalinp/on_mob_life(var/mob/living/M as mob, var/alien)
	if(M.stat == 2.0)
		return
	if(!M) M = holder.my_atom

	if(alien && alien == IS_VOX)
		M.adjustOxyLoss()
	else if(!alien || alien != IS_DIONA)
		M.adjustOxyLoss(-M.getOxyLoss())

	if(holder.has_reagent("lexorin"))
		holder.remove_reagent("lexorin", 2*REM)
	..()
	return


/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE

/datum/reagent/arithrazine/on_mob_life(var/mob/living/M as mob)
	if(M.stat == 2.0)
		return  //See above, down and around. --Agouri
	if(!M) M = holder.my_atom
	M.radiation = max(M.radiation-7*REM,0)
	M.adjustToxLoss(-1*REM)
	if(prob(15))
		M.take_organ_damage(1, 0)
	..()
	return


/datum/reagent/srejuvenate
	name = "Soporific Rejuvenant"
	id = "stoxin2"
	description = "Put people to sleep, and heals them."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/srejuvenate/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(!data) data = 1
	data++
	if(M.losebreath >= 10)
		M.losebreath = max(10, M.losebreath-10)
	holder.remove_reagent(src.id, 0.2)
	switch(data)
		if(1 to 15)
			M.eye_blurry = max(M.eye_blurry, 10)
		if(15 to 25)
			M.drowsyness  = max(M.drowsyness, 20)
		if(25 to INFINITY)
			M.sleeping += 1
			M.adjustOxyLoss(-M.getOxyLoss())
			M.SetWeakened(0)
			M.SetStunned(0)
			M.SetParalysis(0)
			M.dizziness = 0
			M.drowsyness = 0
			M.stuttering = 0
			M.confused = 0
			M.jitteriness = 0
	..()
	return


// Special stuff.
/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	reagent_state = REAGENT_SOLID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ryetalyn/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom

	var/needs_update = M.mutations.len > 0

	M.mutations = list()
	M.disabilities = 0
	M.sdisabilities = 0

	// Might need to update appearance for hulk etc.
	if(needs_update && isHuman(M))
		var/mob/living/carbon/human/H = M
		H.update_mutations()

	..()
	return


/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE

/datum/reagent/alkysine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.adjustBrainLoss(-3*REM)
	..()
	return


/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Heals eye damage"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/imidazoline/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.eye_blurry = max(M.eye_blurry-5 , 0)
	M.eye_blind = max(M.eye_blind-5 , 0)
	if(isHuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/organ/internal/eyes/E = H.internal_organs["eyes"]
		if(istype(E))
			if(E.damage > 0)
				E.damage -= 1
	..()
	return


/datum/reagent/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Synaptizine is used to treat various diseases."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.01
	overdose = REAGENTS_OVERDOSE

/datum/reagent/synaptizine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.drowsyness = max(M.drowsyness-5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	if(holder.has_reagent("mindbreaker"))
		holder.remove_reagent("mindbreaker", 5)
	M.hallucination = max(0, M.hallucination - 10)
	if(prob(60))	M.adjustToxLoss(1)
	..()
	return


/datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine can be use to stabilize an individual's body temperature."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/leporazine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()
	return


/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder derived from fish toxin, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	reagent_state = REAGENT_SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose = REAGENTS_OVERDOSE

/datum/reagent/rezadone/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(!data) data = 1
	data++
	switch(data)
		if(1 to 15)
			M.adjustCloneLoss(-1)
			M.heal_organ_damage(1,1)
		if(15 to 35)
			M.adjustCloneLoss(-2)
			M.heal_organ_damage(2,1)
			M.status_flags &= ~DISFIGURED
		if(35 to INFINITY)
			M.adjustToxLoss(1)
			M.make_dizzy(5)
			M.make_jittery(5)

	..()
	return


/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = 10

/datum/reagent/peridaxon/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(isHuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/organ/external/chest/C = H.get_organ("chest")
		for(var/datum/organ/internal/I in C.internal_organs)
			if(I.damage > 0)
				I.damage -= 0.20
	..()
	return


/datum/reagent/ethylredoxrazine	// FUCK YOU, ALCOHOL
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = REAGENT_SOLID
	color = "#605048" // rgb: 96, 80, 72
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ethylredoxrazine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.reagents.remove_all_type(/datum/reagent/ethanol, 1*REM, 0, 1)
	..()
	return


// Cryocell chemicals.
/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/cryoxadone/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-1)
		M.adjustOxyLoss(-1)
		M.heal_organ_damage(1,1)
		M.adjustToxLoss(-1)
	..()
	return


/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/clonexadone/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(M.bodytemperature < 170)
		M.adjustCloneLoss(-3)
		M.adjustOxyLoss(-3)
		M.heal_organ_damage(3,3)
		M.adjustToxLoss(-3)
	..()
	return


// Painkillers.
/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	reagent_state = REAGENT_LIQUID
	color = "#C855DC"
	overdose = 60

/datum/reagent/paracetamol/on_mob_life(var/mob/living/M as mob)
	if (volume > overdose)
		M.hallucination = max(M.hallucination, 2)


/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "A simple, yet effective painkiller."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	overdose = 30

/datum/reagent/tramadol/on_mob_life(var/mob/living/M as mob)
	if (volume > overdose)
		M.hallucination = max(M.hallucination, 2)


/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective and very addictive painkiller."
	reagent_state = REAGENT_LIQUID
	color = "#C805DC"
	overdose = 20

/datum/reagent/oxycodone/on_mob_life(var/mob/living/M as mob)
	if (volume > overdose)
		M.druggy = max(M.druggy, 10)
		M.hallucination = max(M.hallucination, 3)


// Stimulants.
/datum/reagent/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.03
	overdose = REAGENTS_OVERDOSE/2

/datum/reagent/hyperzine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(prob(5)) M.emote(pick("twitch","blink_r","shiver"))
	..()
	return


// Misc stuff.
/datum/reagent/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "Sterilizes wounds in preparation for surgery."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

	/*		reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
				del(src)
				if (method==TOUCH)
					if(istype(M, /mob/living/carbon/human))
						if(M.health >= -100 && M.health <= 0)
							M.crit_op_stage = 0.0
				if (method==INGEST)
					usr << "Well, that was stupid."
					M.adjustToxLoss(3)
				return
			on_mob_life(var/mob/living/M as mob)
				if(!M) M = holder.my_atom
					M.radiation += 3
					..()
					return
	*/

/datum/reagent/serotrotium
	name = "Serotrotium"
	id = "serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	reagent_state = REAGENT_LIQUID
	color = "#202040" // rgb: 20, 20, 40
	overdose = REAGENTS_OVERDOSE

/datum/reagent/serotrotium/on_mob_life(var/mob/living/M as mob)
	if(isHuman(M))
		if(prob(7)) M.emote(pick("twitch","drool","moan","gasp"))
		holder.remove_reagent(src.id, 0.25 * REAGENTS_METABOLISM)
	return


/datum/reagent/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	id = "adminordrazine"
	description = "It's magic. We don't have to explain it."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/adminordrazine/on_mob_life(var/mob/living/carbon/M as mob)
	if(!M)
		M = holder.my_atom ///This can even heal dead people.
	M.reagents.remove_all_type(/datum/reagent/toxin, 5 * REM, 0, 1)
	M.setCloneLoss(0)
	M.setOxyLoss(0)
	M.radiation = 0
	M.heal_organ_damage(5,5)
	M.adjustToxLoss(-5)
	M.hallucination = 0
	M.setBrainLoss(0)
	M.disabilities = 0
	M.sdisabilities = 0
	M.eye_blurry = 0
	M.eye_blind = 0
	M.SetWeakened(0)
	M.SetStunned(0)
	M.SetParalysis(0)
	M.silent = 0
	M.dizziness = 0
	M.drowsyness = 0
	M.stuttering = 0
	M.confused = 0
	M.sleeping = 0
	M.jitteriness = 0
	for(var/datum/disease/D in M.viruses)
		D.spread = "Remissive"
		D.stage--
		if(D.stage < 1)
			D.cure()
	..()
	return