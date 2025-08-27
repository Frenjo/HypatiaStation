///////////////////////////////////////////////////////////////////////////////////
// Precursor chemicals.
/datum/chemical_reaction/cryptobiolin
	name = "Cryptobiolin"
	result = /datum/reagent/cryptobiolin
	required_reagents = alist("potassium" = 1, "oxygen" = 1, "sugar" = 1)
	result_amount = 3

// Basic stuff.
/datum/chemical_reaction/inaprovaline
	name = "Inaprovaline"
	result = /datum/reagent/inaprovaline
	required_reagents = alist("oxygen" = 1, "carbon" = 1, "sugar" = 1)
	result_amount = 3

/datum/chemical_reaction/bicaridine
	name = "Bicaridine"
	result = /datum/reagent/bicaridine
	required_reagents = alist("inaprovaline" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/kelotane
	name = "Kelotane"
	result = /datum/reagent/kelotane
	required_reagents = alist("silicon" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/dylovene
	name = "Dylovene"
	result = /datum/reagent/dylovene
	required_reagents = alist("silicon" = 1, "potassium" = 1, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/dexalin
	name = "Dexalin"
	result = /datum/reagent/dexalin
	required_reagents = alist("oxygen" = 2)
	required_catalysts = list("plasma" = 5)
	result_amount = 1

// Added cordrazine for fluff reasons, half as effective as tricordrazine. -Frenjo
/datum/chemical_reaction/cordrazine
	name = "Cordrazine"
	result = /datum/reagent/cordrazine
	required_reagents = alist("inaprovaline" = 1, "dylovene" = 1)
	result_amount = 2

/datum/chemical_reaction/tricordrazine
	name = "Tricordrazine"
	result = /datum/reagent/tricordrazine
	required_reagents = alist("cordrazine" = 1, "inaprovaline" = 1)
	result_amount = 2

/datum/chemical_reaction/hyronalin
	name = "Hyronalin"
	result = /datum/reagent/hyronalin
	required_reagents = alist("radium" = 1, "dylovene" = 1)
	result_amount = 2

/datum/chemical_reaction/spaceacillin
	name = "Spaceacillin"
	result = /datum/reagent/spaceacillin
	required_reagents = alist("cryptobiolin" = 1, "inaprovaline" = 1)
	result_amount = 2

/datum/chemical_reaction/soporific
	name = "Soporific"
	result = /datum/reagent/toxin/soporific
	required_reagents = alist("chloralhydrate" = 1, "sugar" = 4)
	result_amount = 5

// Advanced variants of basic stuff.
/datum/chemical_reaction/dermaline
	name = "Dermaline"
	result = /datum/reagent/dermaline
	required_reagents = alist("oxygen" = 1, "phosphorus" = 1, "kelotane" = 1)
	result_amount = 3

/datum/chemical_reaction/dexalinp
	name = "Dexalin Plus"
	result = /datum/reagent/dexalinp
	required_reagents = alist("dexalin" = 1, "carbon" = 1, "iron" = 1)
	result_amount = 3

/datum/chemical_reaction/arithrazine
	name = "Arithrazine"
	result = /datum/reagent/arithrazine
	required_reagents = alist("hyronalin" = 1, "hydrogen" = 1)
	result_amount = 2

// Special stuff.
/datum/chemical_reaction/ryetalyn
	name = "Ryetalyn"
	result = /datum/reagent/ryetalyn
	required_reagents = alist("arithrazine" = 1, "carbon" = 1)
	result_amount = 2

/datum/chemical_reaction/alkysine
	name = "Alkysine"
	result = /datum/reagent/alkysine
	required_reagents = alist("chlorine" = 1, "nitrogen" = 1, "dylovene" = 1)
	result_amount = 2

/datum/chemical_reaction/imidazoline
	name = "Imidazoline"
	result = /datum/reagent/imidazoline
	required_reagents = alist("carbon" = 1, "hydrogen" = 1, "dylovene" = 1)
	result_amount = 2

/datum/chemical_reaction/synaptizine
	name = "Synaptizine"
	result = /datum/reagent/synaptizine
	required_reagents = alist("sugar" = 1, "lithium" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/leporazine
	name = "Leporazine"
	result = /datum/reagent/leporazine
	required_reagents = alist("silicon" = 1, "copper" = 1)
	required_catalysts = list("plasma" = 5)
	result_amount = 2

/datum/chemical_reaction/rezadone
	name = "Rezadone"
	result = /datum/reagent/rezadone
	required_reagents = alist("carpotoxin" = 1, "cryptobiolin" = 1, "copper" = 1)
	result_amount = 3

/datum/chemical_reaction/peridaxon
	name = "Peridaxon"
	result = /datum/reagent/peridaxon
	required_reagents = alist("bicaridine" = 2, "clonexadone" = 2)
	required_catalysts = list("plasma" = 5)
	result_amount = 2

/datum/chemical_reaction/ethylredoxrazine
	name = "Ethylredoxrazine"
	result = /datum/reagent/ethylredoxrazine
	required_reagents = alist("oxygen" = 1, "dylovene" = 1, "carbon" = 1)
	result_amount = 3

/datum/chemical_reaction/ethanoloxidation
	name = "ethanoloxidation"	// Kind of a placeholder in case someone ever changes it so that chemicals
								// react in the body. Also it would be silly if it didn't exist.
	result = /datum/reagent/water
	required_reagents = alist("ethylredoxrazine" = 1, "ethanol" = 1)
	result_amount = 2

// Cryocell chemicals.
/datum/chemical_reaction/cryoxadone
	name = "Cryoxadone"
	result = /datum/reagent/cryoxadone
	required_reagents = alist("dexalin" = 1, "water" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/clonexadone
	name = "Clonexadone"
	result = /datum/reagent/clonexadone
	required_reagents = alist("cryoxadone" = 1, "sodium" = 1)
	required_catalysts = list("plasma" = 5)
	result_amount = 2

// Painkillers.
/datum/chemical_reaction/paracetamol
	name = "Paracetamol"
	result = /datum/reagent/paracetamol
	required_reagents = alist("tramadol" = 1, "sugar" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/tramadol
	name = "Tramadol"
	result = /datum/reagent/tramadol
	required_reagents = alist("inaprovaline" = 1, "ethanol" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/oxycodone
	name = "Oxycodone"
	result = /datum/reagent/oxycodone
	required_reagents = alist("ethanol" = 1, "tramadol" = 1)
	required_catalysts = list("plasma" = 1)
	result_amount = 1

// Stimulants.
/datum/chemical_reaction/hyperzine
	name = "Hyperzine"
	result = /datum/reagent/hyperzine
	required_reagents = alist("sugar" = 1, "phosphorus" = 1, "sulfur" = 1,)
	result_amount = 3

// Misc stuff.
/datum/chemical_reaction/sterilizine
	name = "Sterilizine"
	result = /datum/reagent/sterilizine
	required_reagents = alist("ethanol" = 1, "dylovene" = 1, "chlorine" = 1)
	result_amount = 3