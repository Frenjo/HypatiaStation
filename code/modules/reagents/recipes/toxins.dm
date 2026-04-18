///////////////////////////////////////////////////////////////////////////////////
/datum/chemical_reaction/mutagen
	name = "Unstable mutagen"
	result = /datum/reagent/toxin/mutagen
	required_reagents = alist(/datum/reagent/chlorine = 1, /datum/reagent/phosphorus = 1, /datum/reagent/radium = 1)
	result_amount = 3

/datum/chemical_reaction/lexorin
	name = "Lexorin"
	result = /datum/reagent/toxin/lexorin
	required_reagents = alist(/datum/reagent/hydrogen = 1, /datum/reagent/nitrogen = 1, /datum/reagent/plasma = 1)
	result_amount = 3

/*
/datum/chemical_reaction/cyanide
	name = "Cyanide"
	result = /datum/reagent/toxin/cyanide
	required_reagents = alist(/datum/reagent/carbon = 1, /datum/reagent/hydrogen = 1, /datum/reagent/nitrogen = 1)
	result_amount = 1
*/

/datum/chemical_reaction/zombiepowder
	name = "Zombie Powder"
	result = /datum/reagent/toxin/zombiepowder
	required_reagents = alist(/datum/reagent/toxin/carpotoxin = 5, /datum/reagent/copper = 5, /datum/reagent/toxin/soporific = 5)
	result_amount = 2

// Synthesizing this chemical is pretty complex in real life, but fuck it, it's just a game!
/datum/chemical_reaction/plantbgone
	name = "Plant-B-Gone"
	result = /datum/reagent/toxin/plantbgone
	required_reagents = alist(/datum/reagent/toxin = 1, /datum/reagent/water = 4)
	result_amount = 5

/datum/chemical_reaction/chloralhydrate
	name = "Chloral Hydrate"
	result = /datum/reagent/toxin/chloralhydrate
	required_reagents = alist(/datum/reagent/chlorine = 3, /datum/reagent/ethanol = 1, /datum/reagent/water = 1)
	result_amount = 1

/datum/chemical_reaction/potassium_chloride
	name = "Potassium Chloride"
	result = /datum/reagent/toxin/potassium_chloride
	required_reagents = alist(/datum/reagent/potassium = 1, /datum/reagent/sodiumchloride = 1)
	result_amount = 2

/datum/chemical_reaction/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	result = /datum/reagent/toxin/potassium_chlorophoride
	required_reagents = alist(/datum/reagent/toxin/chloralhydrate = 1, /datum/reagent/plasma = 1, /datum/reagent/toxin/potassium_chloride = 1)
	result_amount = 4

/datum/chemical_reaction/pacid
	name = "Polytrinic acid"
	result = /datum/reagent/toxin/acid/polyacid
	required_reagents = alist(/datum/reagent/chlorine = 1, /datum/reagent/potassium = 1, /datum/reagent/toxin/acid = 1)
	result_amount = 3