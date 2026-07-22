/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller."

	reagent_state = REAGENT_LIQUID
	overdose = 60
	color = "#C855DC"

/datum/reagent/paracetamol/on_mob_life(mob/living/carbon/C)
	if(volume > overdose)
		C.hallucination = max(C.hallucination, 2)
	. = ..()

/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "A simple, yet effective painkiller."

	reagent_state = REAGENT_LIQUID
	overdose = 30
	color = "#C8A5DC"

/datum/reagent/tramadol/on_mob_life(mob/living/carbon/C)
	if(volume > overdose)
		C.hallucination = max(C.hallucination, 2)
	. = ..()

/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "An effective and very addictive painkiller."

	reagent_state = REAGENT_LIQUID
	overdose = 20
	color = "#C805DC"

/datum/reagent/oxycodone/on_mob_life(mob/living/carbon/C)
	if(volume > overdose)
		C.druggy = max(C.druggy, 10)
		C.hallucination = max(C.hallucination, 3)
	. = ..()