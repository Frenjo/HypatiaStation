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

/datum/reagent/cryptobiolin/on_mob_life(mob/living/carbon/C)
	C.make_dizzy(1)
	if(!C.confused)
		C.confused = 1
	C.confused = max(C.confused, 20)
	holder.remove_reagent(id, 0.5 * REAGENTS_METABOLISM)
	. = ..()

// Basic stuff.
/datum/reagent/inaprovaline
	name = "Inaprovaline"
	id = "inaprovaline"
	description = "Inaprovaline is a synaptic stimulant and cardiostimulant. Commonly used to stabilize patients."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE*2

/datum/reagent/inaprovaline/on_mob_life(mob/living/carbon/C, alien)
	if(alien && alien == IS_VOX)
		C.adjustToxLoss(REAGENTS_METABOLISM)
	else
		if(C.losebreath >= 10)
			C.losebreath = max(10, C.losebreath - 5)

	holder.remove_reagent(id, 0.5 * REAGENTS_METABOLISM)

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/bicaridine/on_mob_life(mob/living/carbon/C, alien)
	if(C.stat == DEAD)
		return
	if(alien != IS_DIONA)
		C.heal_organ_damage(2 * REM, 0)
	. = ..()

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat burns."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/kelotane/on_mob_life(mob/living/carbon/C)
	if(C.stat == DEAD)
		return
	//This needs a diona check but if one is added they won't be able to heal burn damage at all.
	C.heal_organ_damage(0, 2 * REM)
	. = ..()

/datum/reagent/dylovene
	name = "Dylovene"
	id = "dylovene"
	description = "Dylovene is a broad-spectrum antitoxin."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/dylovene/on_mob_life(mob/living/carbon/C, alien)
	if(!alien || alien != IS_DIONA)
		C.reagents.remove_all_type(/datum/reagent/toxin, 1 * REM, 0, 1)
		C.drowsyness = max(C.drowsyness - 2 * REM, 0)
		C.hallucination = max(0, C.hallucination - 5 * REM)
		C.adjustToxLoss(-2 * REM)
	. = ..()

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/dexalin/on_mob_life(mob/living/carbon/C, alien)
	if(C.stat == DEAD)
		return // See above, down and around. --Agouri

	if(alien && alien == IS_VOX)
		C.adjustToxLoss(2 * REM)
	else if(!alien || alien != IS_DIONA)
		C.adjustOxyLoss(-2 * REM)

	if(holder.has_reagent("lexorin"))
		holder.remove_reagent("lexorin", 2 * REM)
	. = ..()

// Added cordrazine for fluff reasons, half as effective as tricordrazine. -Frenjo
/datum/reagent/cordrazine
	name = "Cordrazine"
	id = "cordrazine"
	description = "Cordrazine is a stimulant, originally derived from inaprovaline. Can be used to treat a wide range of injuries."
	reagent_state = REAGENT_LIQUID
	color = "#DDC8EA" // rgb: 221, 200, 234 - I was aiming for a lighter version of tricordrazine.

/datum/reagent/cordrazine/on_mob_life(mob/living/carbon/C, alien)
	if(C.stat == DEAD)
		return
	if(!alien || alien != IS_DIONA)
		if(C.getOxyLoss())
			C.adjustOxyLoss(-0.5 * REM)
		if(C.getBruteLoss() && prob(80))
			C.heal_organ_damage(0.5 * REM, 0)
		if(C.getFireLoss() && prob(80))
			C.heal_organ_damage(0, 0.5 * REM)
		if(C.getToxLoss() && prob(80))
			C.adjustToxLoss(-0.5 * REM)
	. = ..()

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/tricordrazine/on_mob_life(mob/living/carbon/C, alien)
	if(C.stat == DEAD)
		return
	if(!alien || alien != IS_DIONA)
		if(C.getOxyLoss())
			C.adjustOxyLoss(-1 * REM)
		if(C.getBruteLoss() && prob(80))
			C.heal_organ_damage(1*REM, 0)
		if(C.getFireLoss() && prob(80))
			C.heal_organ_damage(0,1 * REM)
		if(C.getToxLoss() && prob(80))
			C.adjustToxLoss(-1 * REM)
	. = ..()

/datum/reagent/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE

/datum/reagent/hyronalin/on_mob_life(mob/living/carbon/C)
	C.radiation = max(C.radiation - 3 * REM,0)
	. = ..()

/datum/reagent/spaceacillin
	name = "Spaceacillin"
	id = "spaceacillin"
	description = "An all-purpose antiviral agent."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.01
	overdose = REAGENTS_OVERDOSE

/datum/reagent/toxin/soporific
	name = "Soporific"
	id = "soporific"
	description = "An effective hypnotic used to treat insomnia."
	reagent_state = REAGENT_LIQUID
	color = "#E895CC" // rgb: 232, 149, 204
	toxpwr = 0
	custom_metabolism = 0.1
	overdose = REAGENTS_OVERDOSE

/datum/reagent/toxin/soporific/on_mob_life(mob/living/carbon/C)
	if(!data["special"])
		data["special"] = 1
	switch(data["special"])
		if(1 to 12)
			if(prob(5))
				C.emote("yawn")
		if(12 to 15)
			C.eye_blurry = max(C.eye_blurry, 10)
		if(15 to 49)
			if(prob(50))
				C.Weaken(2)
			C.drowsyness  = max(C.drowsyness, 20)
		if(50 to INFINITY)
			C.Weaken(20)
			C.drowsyness  = max(C.drowsyness, 30)
	data["special"]++
	. = ..()

// Advanced variants of basic stuff.
/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE/2

/datum/reagent/dermaline/on_mob_life(mob/living/carbon/C, alien)
	if(C.stat == DEAD) //THE GUY IS **DEAD**! BEREFT OF ALL LIFE HE RESTS IN PEACE etc etc. He does NOT metabolise shit anymore, god DAMN
		return
	if(!alien || alien != IS_DIONA)
		C.heal_organ_damage(0, 3 * REM)
	. = ..()

/datum/reagent/dexalinp
	name = "Dexalin Plus"
	id = "dexalinp"
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE/2

/datum/reagent/dexalinp/on_mob_life(mob/living/carbon/C, alien)
	if(C.stat == DEAD)
		return

	if(alien && alien == IS_VOX)
		C.adjustOxyLoss()
	else if(!alien || alien != IS_DIONA)
		C.adjustOxyLoss(-C.getOxyLoss())

	if(holder.has_reagent("lexorin"))
		holder.remove_reagent("lexorin", 2 * REM)
	. = ..()

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE

/datum/reagent/arithrazine/on_mob_life(mob/living/carbon/C)
	if(C.stat == DEAD)
		return // See above, down and around. --Agouri
	C.radiation = max(C.radiation - 7 * REM, 0)
	C.adjustToxLoss(-1 * REM)
	if(prob(15))
		C.take_organ_damage(1, 0)
	. = ..()

/datum/reagent/srejuvenate
	name = "Soporific Rejuvenant"
	id = "stoxin2"
	description = "Put people to sleep, and heals them."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/srejuvenate/on_mob_life(mob/living/carbon/C)
	if(!data["special"])
		data["special"] = 1
	data["special"]++
	if(C.losebreath >= 10)
		C.losebreath = max(10, C.losebreath - 10)
	holder.remove_reagent(id, 0.2)
	switch(data["special"])
		if(1 to 15)
			C.eye_blurry = max(C.eye_blurry, 10)
		if(15 to 25)
			C.drowsyness  = max(C.drowsyness, 20)
		if(25 to INFINITY)
			C.sleeping += 1
			C.adjustOxyLoss(-C.getOxyLoss())
			C.SetWeakened(0)
			C.SetStunned(0)
			C.SetParalysis(0)
			C.dizziness = 0
			C.drowsyness = 0
			C.stuttering = 0
			C.confused = 0
			C.jitteriness = 0
	. = ..()

// Special stuff.
/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
	reagent_state = REAGENT_SOLID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ryetalyn/on_mob_life(mob/living/carbon/C)
	var/needs_update = length(C.mutations)

	C.mutations = list()
	C.disabilities = 0
	C.sdisabilities = 0

	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(C))
		var/mob/living/carbon/human/H = C
		H.update_mutations()

	. = ..()

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE

/datum/reagent/alkysine/on_mob_life(mob/living/carbon/C)
	C.adjustBrainLoss(-3 * REM)
	. = ..()

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Heals eye damage"
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/imidazoline/on_mob_life(mob/living/carbon/C)
	C.eye_blurry = max(C.eye_blurry - 5 , 0)
	C.eye_blind = max(C.eye_blind - 5 , 0)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		var/datum/organ/internal/eyes/E = H.internal_organs["eyes"]
		if(istype(E))
			if(E.damage > 0)
				E.damage -= 1
	. = ..()

/datum/reagent/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Synaptizine is used to treat various diseases."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.01
	overdose = REAGENTS_OVERDOSE

/datum/reagent/synaptizine/on_mob_life(mob/living/carbon/C)
	C.drowsyness = max(C.drowsyness - 5, 0)
	C.AdjustParalysis(-1)
	C.AdjustStunned(-1)
	C.AdjustWeakened(-1)
	if(holder.has_reagent("mindbreaker"))
		holder.remove_reagent("mindbreaker", 5)
	C.hallucination = max(0, C.hallucination - 10)
	if(prob(60))
		C.adjustToxLoss(1)
	. = ..()

/datum/reagent/leporazine
	name = "Leporazine"
	id = "leporazine"
	description = "Leporazine can be use to stabilize an individual's body temperature."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/leporazine/on_mob_life(mob/living/carbon/C)
	if(C.bodytemperature > 310)
		C.bodytemperature = max(310, C.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(C.bodytemperature < 311)
		C.bodytemperature = min(310, C.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	. = ..()

/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder derived from fish toxin, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	reagent_state = REAGENT_SOLID
	color = "#669900" // rgb: 102, 153, 0
	overdose = REAGENTS_OVERDOSE

/datum/reagent/rezadone/on_mob_life(mob/living/carbon/C)
	if(!data["special"])
		data["special"] = 1
	data["special"]++
	switch(data["special"])
		if(1 to 15)
			C.adjustCloneLoss(-1)
			C.heal_organ_damage(1, 1)
		if(15 to 35)
			C.adjustCloneLoss(-2)
			C.heal_organ_damage(2, 1)
			C.status_flags &= ~DISFIGURED
		if(35 to INFINITY)
			C.adjustToxLoss(1)
			C.make_dizzy(5)
			C.make_jittery(5)
	. = ..()

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = 10

/datum/reagent/peridaxon/on_mob_life(mob/living/carbon/C)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		var/datum/organ/external/chest/chest = H.get_organ("chest")
		for(var/datum/organ/internal/I in chest.internal_organs)
			if(I.damage > 0)
				I.damage -= 0.20
	. = ..()

/datum/reagent/ethylredoxrazine	// FUCK YOU, ALCOHOL
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = REAGENT_SOLID
	color = "#605048" // rgb: 96, 80, 72
	overdose = REAGENTS_OVERDOSE

/datum/reagent/ethylredoxrazine/on_mob_life(mob/living/carbon/C)
	C.dizziness = 0
	C.drowsyness = 0
	C.stuttering = 0
	C.confused = 0
	C.reagents.remove_all_type(/datum/reagent/ethanol, 1 * REM, 0, 1)
	. = ..()

// Cryocell chemicals.
/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/cryoxadone/on_mob_life(mob/living/carbon/C)
	if(C.bodytemperature < 170)
		C.adjustCloneLoss(-1)
		C.adjustOxyLoss(-1)
		C.heal_organ_damage(1, 1)
		C.adjustToxLoss(-1)
	. = ..()

/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/clonexadone/on_mob_life(mob/living/carbon/C)
	if(C.bodytemperature < 170)
		C.adjustCloneLoss(-3)
		C.adjustOxyLoss(-3)
		C.heal_organ_damage(3,3)
		C.adjustToxLoss(-3)
	. = ..()

// Painkillers.
/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."
	reagent_state = REAGENT_LIQUID
	color = "#C855DC"
	overdose = 60

/datum/reagent/paracetamol/on_mob_life(mob/living/carbon/C)
	if(volume > overdose)
		C.hallucination = max(C.hallucination, 2)

/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "A simple, yet effective painkiller."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC"
	overdose = 30

/datum/reagent/tramadol/on_mob_life(mob/living/carbon/C)
	if(volume > overdose)
		C.hallucination = max(C.hallucination, 2)

/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective and very addictive painkiller."
	reagent_state = REAGENT_LIQUID
	color = "#C805DC"
	overdose = 20

/datum/reagent/oxycodone/on_mob_life(mob/living/carbon/C)
	if(volume > overdose)
		C.druggy = max(C.druggy, 10)
		C.hallucination = max(C.hallucination, 3)

// Stimulants.
/datum/reagent/hyperzine
	name = "Hyperzine"
	id = "hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	custom_metabolism = 0.03
	overdose = REAGENTS_OVERDOSE/2

/datum/reagent/hyperzine/on_mob_life(mob/living/carbon/C)
	if(prob(5))
		C.emote(pick("twitch", "blink_r", "shiver"))
	. = ..()

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
					if(ishuman(M))
						if(M.health >= -100 && M.health <= 0)
							M.crit_op_stage = 0.0
				if (method==INGEST)
					usr << "Well, that was stupid."
					M.adjustToxLoss(3)
				return
			on_mob_life(var/mob/living/M)
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

/datum/reagent/serotrotium/on_mob_life(mob/living/carbon/C)
	if(ishuman(C))
		if(prob(7))
			C.emote(pick("twitch","drool","moan","gasp"))
		holder.remove_reagent(id, 0.25 * REAGENTS_METABOLISM)

/datum/reagent/adminordrazine //An OP chemical for admins
	name = "Adminordrazine"
	id = "adminordrazine"
	description = "It's magic. We don't have to explain it."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220

/datum/reagent/adminordrazine/on_mob_life(mob/living/carbon/C)
	// This can even heal dead people.
	C.reagents.remove_all_type(/datum/reagent/toxin, 5 * REM, 0, 1)
	C.setCloneLoss(0)
	C.setOxyLoss(0)
	C.radiation = 0
	C.heal_organ_damage(5,5)
	C.adjustToxLoss(-5)
	C.hallucination = 0
	C.setBrainLoss(0)
	C.disabilities = 0
	C.sdisabilities = 0
	C.eye_blurry = 0
	C.eye_blind = 0
	C.SetWeakened(0)
	C.SetStunned(0)
	C.SetParalysis(0)
	C.silent = 0
	C.dizziness = 0
	C.drowsyness = 0
	C.stuttering = 0
	C.confused = 0
	C.sleeping = 0
	C.jitteriness = 0
	for(var/datum/disease/D in C.viruses)
		D.spread = "Remissive"
		D.stage--
		if(D.stage < 1)
			D.cure()
	. = ..()