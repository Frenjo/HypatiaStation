///////////////////////////////////////////////////////////////////////////////////
// Basic stuff.
/datum/chemical_reaction/inaprovaline
	name = "Inaprovaline"
	result = /datum/reagent/inaprovaline
	required_reagents = alist(/datum/reagent/carbon = 1, /datum/reagent/oxygen = 1, /datum/reagent/sugar = 1)
	result_amount = 3

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	result = /datum/reagent/bicaridine
	required_reagents = alist(/datum/reagent/carbon = 1, /datum/reagent/inaprovaline = 1)
	result_amount = 2

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	result = /datum/reagent/kelotane
	required_reagents = alist(/datum/reagent/carbon = 1, /datum/reagent/silicon = 1)
	result_amount = 2

/datum/chemical_reaction/dylovene
	name = "Dylovene"
	result = /datum/reagent/dylovene
	required_reagents = alist(/datum/reagent/nitrogen = 1, /datum/reagent/potassium = 1, /datum/reagent/silicon = 1)
	result_amount = 3

/datum/chemical_reaction/dexalin
	name = "Dexalin"
	result = /datum/reagent/dexalin
	required_reagents = alist(/datum/reagent/oxygen = 2)
	required_catalysts = alist(/datum/reagent/plasma = 5)
	result_amount = 1

// Added cordrazine for fluff reasons, half as effective as tricordrazine. -Frenjo
/datum/chemical_reaction/cordrazine
	name = "Cordrazine"
	result = /datum/reagent/cordrazine
	required_reagents = alist(/datum/reagent/dylovene = 1, /datum/reagent/inaprovaline = 1)
	result_amount = 2

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	result = /datum/reagent/tricordrazine
	required_reagents = alist(/datum/reagent/cordrazine = 1, /datum/reagent/inaprovaline = 1)
	result_amount = 2

/datum/chemical_reaction/hyronalin
	name = "Hyronalin"
	result = /datum/reagent/hyronalin
	required_reagents = alist(/datum/reagent/dylovene = 1, /datum/reagent/radium = 1)
	result_amount = 2

/datum/chemical_reaction/spaceacillin
	name = "Spaceacillin"
	result = /datum/reagent/spaceacillin
	required_reagents = alist(/datum/reagent/cryptobiolin = 1, /datum/reagent/inaprovaline = 1)
	result_amount = 2

/datum/chemical_reaction/soporific
	name = "Soporific"
	result = /datum/reagent/toxin/soporific
	required_reagents = alist(/datum/reagent/toxin/chloralhydrate = 1, /datum/reagent/sugar = 4)
	result_amount = 5

// Advanced variants of basic stuff.
/datum/chemical_reaction/atropine
	name = "Atropine"
	result = /datum/reagent/atropine
	required_reagents = alist(
		/datum/reagent/acetone = 1, /datum/reagent/diethylamine = 1, /datum/reagent/ethanol = 1,
		/datum/reagent/phenol = 1, /datum/reagent/toxin/acid = 1
	)
	result_amount = 5

/datum/chemical_reaction/salicylic_acid
	name = "Salicylic Acid"
	result = /datum/reagent/salicylic_acid
	required_reagents = alist(
		/datum/reagent/carbon = 1, /datum/reagent/oxygen = 1, /datum/reagent/phenol = 1,
		/datum/reagent/sodium = 1, /datum/reagent/toxin/acid = 1
	)
	result_amount = 5

/datum/chemical_reaction/dermaline
	name = "Dermaline"
	result = /datum/reagent/dermaline
	required_reagents = alist(/datum/reagent/kelotane = 1, /datum/reagent/oxygen = 1, /datum/reagent/phosphorus = 1)
	result_amount = 3

/datum/chemical_reaction/thializid
	name = "Thializid"
	result = /datum/reagent/thializid
	required_reagents = alist(/datum/reagent/fluorine = 1, /datum/reagent/nitrous_oxide = 2, /datum/reagent/toxin = 1, /datum/reagent/sulfur = 1)
	result_amount = 5

/datum/chemical_reaction/dexalinp
	name = "Dexalin Plus"
	result = /datum/reagent/dexalinp
	required_reagents = alist(/datum/reagent/carbon = 1, /datum/reagent/dexalin = 1, /datum/reagent/iron = 1)
	result_amount = 3

/datum/chemical_reaction/arithrazine
	name = "Arithrazine"
	result = /datum/reagent/arithrazine
	required_reagents = alist(/datum/reagent/hydrogen = 1, /datum/reagent/hyronalin = 1)
	result_amount = 2

// Special stuff.
/datum/chemical_reaction/ryetalyn
	name = "Ryetalyn"
	result = /datum/reagent/ryetalyn
	required_reagents = alist(/datum/reagent/arithrazine = 1, /datum/reagent/carbon = 1)
	result_amount = 2

/datum/chemical_reaction/alkysine
	name = "Alkysine"
	result = /datum/reagent/alkysine
	required_reagents = alist(/datum/reagent/chlorine = 1, /datum/reagent/dylovene = 1, /datum/reagent/nitrogen = 1)
	result_amount = 2

/datum/chemical_reaction/imidazoline
	name = "Imidazoline"
	result = /datum/reagent/imidazoline
	required_reagents = alist(/datum/reagent/carbon = 1, /datum/reagent/dylovene = 1, /datum/reagent/hydrogen = 1)
	result_amount = 2

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	result = /datum/reagent/synaptizine
	required_reagents = alist(/datum/reagent/lithium = 1, /datum/reagent/sugar = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/leporazine
	name = "Leporazine"
	result = /datum/reagent/leporazine
	required_reagents = alist(/datum/reagent/copper = 1, /datum/reagent/silicon = 1)
	required_catalysts = alist(/datum/reagent/plasma = 5)
	result_amount = 2

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	result = /datum/reagent/rezadone
	required_reagents = alist(/datum/reagent/toxin/carpotoxin = 1, /datum/reagent/copper = 1, /datum/reagent/cryptobiolin = 1)
	result_amount = 3

/datum/chemical_reaction/peridaxon
	name = "Peridaxon"
	result = /datum/reagent/peridaxon
	required_reagents = alist(/datum/reagent/bicaridine = 2, /datum/reagent/clonexadone = 2)
	required_catalysts = alist(/datum/reagent/plasma = 5)
	result_amount = 2

/datum/chemical_reaction/ethylredoxrazine
	name = "Ethylredoxrazine"
	result = /datum/reagent/ethylredoxrazine
	required_reagents = alist(/datum/reagent/carbon = 1, /datum/reagent/dylovene = 1, /datum/reagent/oxygen = 1)
	result_amount = 3

/datum/chemical_reaction/ethanoloxidation
	name = "ethanoloxidation"	// Kind of a placeholder in case someone ever changes it so that chemicals
								// react in the body. Also it would be silly if it didn't exist.
	result = /datum/reagent/water
	required_reagents = alist(/datum/reagent/ethanol = 1, /datum/reagent/ethylredoxrazine = 1)
	result_amount = 2

// Cryocell chemicals.
/datum/chemical_reaction/cryoxadone
	name = "Cryoxadone"
	result = /datum/reagent/cryoxadone
	required_reagents = alist(/datum/reagent/dexalin = 1, /datum/reagent/oxygen = 1, /datum/reagent/water = 1)
	result_amount = 3

/datum/chemical_reaction/clonexadone
	name = "Clonexadone"
	result = /datum/reagent/clonexadone
	required_reagents = alist(/datum/reagent/cryoxadone = 1, /datum/reagent/sodium = 1)
	required_catalysts = alist(/datum/reagent/plasma = 5)
	result_amount = 2

// Misc stuff.
/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	result = /datum/reagent/sterilizine
	required_reagents = alist(/datum/reagent/chlorine = 1, /datum/reagent/dylovene = 1, /datum/reagent/ethanol = 1)
	result_amount = 3