/datum/reagent/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "A highly addictive stimulant extracted from the tobacco plant."
	reagent_state = REAGENT_LIQUID
	color = "#181818" // rgb: 24, 24, 24

/datum/reagent/space_drugs
	name = "Space drugs"
	id = "space_drugs"
	description = "An illegal chemical compound used as drug."
	reagent_state = REAGENT_LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	overdose = REAGENTS_OVERDOSE

/datum/reagent/space_drugs/on_mob_life(mob/living/carbon/C)
	C.druggy = max(C.druggy, 15)
	if(isturf(C.loc) && !isspace(C.loc))
		if(C.canmove && !C.restrained())
			if(prob(10))
				step(C, pick(GLOBL.cardinal))
	if(prob(7))
		C.emote(pick("twitch", "drool", "moan", "giggle"))
	holder.remove_reagent(id, 0.5 * REAGENTS_METABOLISM)

/datum/reagent/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	reagent_state = REAGENT_LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/impedrezene/on_mob_life(mob/living/carbon/C)
	C.jitteriness = max(C.jitteriness - 5, 0)
	if(prob(80))
		C.adjustBrainLoss(1 * REM)
	if(prob(50))
		C.drowsyness = max(C.drowsyness, 3)
	if(prob(10))
		C.emote("drool")
	. = ..()

/datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	description = "A powerful hallucinogen, it can cause fatal effects in users."
	reagent_state = REAGENT_LIQUID
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE

/datum/reagent/toxin/mindbreaker/on_mob_life(mob/living/carbon/C)
	C.hallucination += 10
	. = ..()

/datum/reagent/hyperzine // Putting this here because Glu Furro told me to.
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
			C.emote(pick("twitch", "drool", "moan", "gasp"))
		holder.remove_reagent(id, 0.25 * REAGENTS_METABOLISM)