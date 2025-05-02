// Base type for reagents which delete themselves and infect a mob with a given disease.
/datum/reagent/disease
	var/disease_path = null

/datum/reagent/disease/reaction_mob(mob/M, method = TOUCH, volume)
	del(src)
	if((prob(10) && method == TOUCH) || method == INGEST)
		M.contract_disease(new disease_path(FALSE), 1)

/datum/reagent/disease/nanites
	name = "Nanomachines"
	id = "nanites"
	description = "Microscopic construction robots."
	reagent_state = REAGENT_LIQUID
	color = "#535E66" // rgb: 83, 94, 102
	disease_path = /datum/disease/robotic_transformation

/datum/reagent/disease/xenomicrobes
	name = "Xenomicrobes"
	id = "xenomicrobes"
	description = "Microbes with an entirely alien cellular structure."
	reagent_state = REAGENT_LIQUID
	color = "#535E66" // rgb: 83, 94, 102
	disease_path = /datum/disease/xeno_transformation