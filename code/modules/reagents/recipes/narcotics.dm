/datum/chemical_reaction/space_drugs
	name = "Space Drugs"
	result = /datum/reagent/space_drugs
	required_reagents = alist(/datum/reagent/lithium = 1, /datum/reagent/mercury = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/impedrezene
	name = "Impedrezene"
	result = /datum/reagent/impedrezene
	required_reagents = alist(/datum/reagent/mercury = 1, /datum/reagent/oxygen = 1, /datum/reagent/sugar = 1)
	result_amount = 2

/datum/chemical_reaction/mindbreaker
	name = "Mindbreaker Toxin"
	result = /datum/reagent/toxin/mindbreaker
	required_reagents = alist(/datum/reagent/dylovene = 1, /datum/reagent/hydrogen = 1, /datum/reagent/silicon = 1)
	result_amount = 3

/datum/chemical_reaction/hyperzine // Putting this here because Glu Furro told me to.
	name = "Hyperzine"
	result = /datum/reagent/hyperzine
	required_reagents = alist(/datum/reagent/phosphorus = 1, /datum/reagent/sugar = 1, /datum/reagent/sulfur = 1)
	result_amount = 3