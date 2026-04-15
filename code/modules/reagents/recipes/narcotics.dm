/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	result = /datum/reagent/space_drugs
	required_reagents = alist("mercury" = 1, "sugar" = 1, "lithium" = 1)
	result_amount = 3

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	result = /datum/reagent/impedrezene
	required_reagents = alist("mercury" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 2

/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	result = /datum/reagent/toxin/mindbreaker
	required_reagents = alist("silicon" = 1, "hydrogen" = 1, "dylovene" = 1)
	result_amount = 3

/datum/chemical_reaction/hyperzine // Putting this here because Glu Furro told me to.
	name = "Hyperzine"
	result = /datum/reagent/hyperzine
	required_reagents = alist("sugar" = 1, "phosphorus" = 1, "sulfur" = 1,)
	result_amount = 3