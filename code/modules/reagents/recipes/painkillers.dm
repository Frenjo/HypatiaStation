/datum/chemical_reaction/paracetamol
	name = "Paracetamol"
	result = /datum/reagent/paracetamol
	required_reagents = alist(/datum/reagent/sugar = 1, /datum/reagent/tramadol = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/tramadol
	name = "Tramadol"
	result = /datum/reagent/tramadol
	required_reagents = alist(/datum/reagent/ethanol = 1, /datum/reagent/inaprovaline = 1, /datum/reagent/oxygen = 1)
	result_amount = 3

/datum/chemical_reaction/oxycodone
	name = "Oxycodone"
	result = /datum/reagent/oxycodone
	required_reagents = alist(/datum/reagent/ethanol = 1, /datum/reagent/tramadol = 1)
	required_catalysts = alist(/datum/reagent/plasma = 1)
	result_amount = 1