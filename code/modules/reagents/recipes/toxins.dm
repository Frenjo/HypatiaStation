///////////////////////////////////////////////////////////////////////////////////
/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	result = /datum/reagent/toxin/mutagen
	required_reagents = list("radium" = 1, "phosphorus" = 1, "chlorine" = 1)
	result_amount = 3

/datum/chemical_reaction/lexorin
	name = "Lexorin"
	result = /datum/reagent/toxin/lexorin
	required_reagents = list("plasma" = 1, "hydrogen" = 1, "nitrogen" = 1)
	result_amount = 3

/*
/datum/chemical_reaction/cyanide
	name = "Cyanide"
	result = /datum/reagent/toxin/cyanide
	required_reagents = list("hydrogen" = 1, "carbon" = 1, "nitrogen" = 1)
	result_amount = 1
*/

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	result = /datum/reagent/toxin/zombiepowder
	required_reagents = list("carpotoxin" = 5, "stoxin" = 5, "copper" = 5)
	result_amount = 2

/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	result = /datum/reagent/toxin/mindbreaker
	required_reagents = list("silicon" = 1, "hydrogen" = 1, "anti_toxin" = 1)
	result_amount = 3

// Synthesizing this chemical is pretty complex in real life, but fuck it, it's just a game!
/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	result = /datum/reagent/toxin/plantbgone
	required_reagents = list("toxin" = 1, "water" = 4)
	result_amount = 5

/datum/chemical_reaction/chloralhydrate
	name = "Chloral Hydrate"
	result = /datum/reagent/toxin/chloralhydrate
	required_reagents = list("ethanol" = 1, "chlorine" = 3, "water" = 1)
	result_amount = 1

/datum/chemical_reaction/potassium_chloride
	name = "Potassium Chloride"
	result = /datum/reagent/toxin/potassium_chloride
	required_reagents = list("sodiumchloride" = 1, "potassium" = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	result = /datum/reagent/toxin/potassium_chlorophoride
	required_reagents = list("potassium_chloride" = 1, "plasma" = 1, "chloralhydrate" = 1)
	result_amount = 4

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	result = /datum/reagent/toxin/acid/polyacid
	required_reagents = list("sacid" = 1, "chlorine" = 1, "potassium" = 1)
	result_amount = 3