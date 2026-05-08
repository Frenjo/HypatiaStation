/datum/chemical_reaction/glycerol
	name = "Glycerol"
	result = /datum/reagent/glycerol
	required_reagents = alist(/datum/reagent/cornoil = 3, /datum/reagent/toxin/acid = 1)
	result_amount = 1

// foam and foam precursor
/datum/chemical_reaction/surfactant
	name = "Foam surfactant"
	result = /datum/reagent/fluorosurfactant
	required_reagents = alist(/datum/reagent/carbon = 2, /datum/reagent/fluorine = 2, /datum/reagent/toxin/acid = 1)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	result = /datum/reagent/foaming_agent
	required_reagents = alist(/datum/reagent/hydrogen = 1, /datum/reagent/lithium = 1)
	result_amount = 1

// Synthesizing these two chemicals is pretty complex in real life, but fuck it, it's just a game!
/datum/chemical_reaction/ammonia
	name = "Ammonia"
	result = /datum/reagent/ammonia
	required_reagents = alist(/datum/reagent/hydrogen = 3, /datum/reagent/nitrogen = 1)
	result_amount = 3

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	result = /datum/reagent/diethylamine
	required_reagents = alist(/datum/reagent/ammonia = 1, /datum/reagent/ethanol = 1)
	result_amount = 2

// This is a horrible rip off based on /tg/'s chemical reactions for plastic-making.
/datum/chemical_reaction/oil
	name = "Oil"
	result = /datum/reagent/oil
	required_reagents = alist(/datum/reagent/carbon = 1, /datum/reagent/fuel = 1, /datum/reagent/hydrogen = 1)
	result_amount = 3

/datum/chemical_reaction/phenol
	name = "Phenol"
	result = /datum/reagent/phenol
	required_reagents = alist(/datum/reagent/chlorine = 1, /datum/reagent/oil = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/acetone
	name = "Acetone"
	result = /datum/reagent/acetone
	required_reagents = alist(/datum/reagent/fuel = 1, /datum/reagent/oil = 1, /datum/reagent/oxygen = 1)
	result_amount = 3

/datum/chemical_reaction/nitrous_oxide
	name = "Nitrous Oxide"
	result = /datum/reagent/nitrous_oxide
	required_reagents = alist(/datum/reagent/nitrogen = 2, /datum/reagent/oxygen = 1)
	required_catalysts = alist(/datum/reagent/ammonia = 2)
	result_amount = 3

/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	result = /datum/reagent/cryptobiolin
	required_reagents = alist(/datum/reagent/oxygen = 1, /datum/reagent/potassium = 1, /datum/reagent/sugar = 1)
	result_amount = 3