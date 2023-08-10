GLOBAL_GLOBL_LIST_NEW(chemical_reactions_list)	// List of all /datum/chemical_reaction datums. Used during chemical reactions.
GLOBAL_GLOBL_LIST_NEW(chemical_reagents_list)	// List of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff.
GLOBAL_GLOBL_LIST_NEW(side_effects)				// List of all medical sideeffects types by thier names. |BS12

//feel free to add shit to lists below
//increases heart rate
GLOBAL_GLOBL_LIST_INIT(tachycardics, list(
	/datum/reagent/drink/coffee, /datum/reagent/inaprovaline, /datum/reagent/hyperzine,
	/datum/reagent/nitroglycerin, /datum/reagent/ethanol/thirteenloko, /datum/reagent/nicotine
))
//decreases heart rate
GLOBAL_GLOBL_LIST_INIT(bradycardics, list(
	/datum/reagent/neurotoxin, /datum/reagent/cryoxadone, /datum/reagent/clonexadone,
	/datum/reagent/space_drugs, /datum/reagent/toxin/stoxin
))
//stops the heart
GLOBAL_GLOBL_LIST_INIT(heartstopper, list(/datum/reagent/toxin/potassium_chlorophoride, /datum/reagent/toxin/zombiepowder))
//stops the heart when overdose is met -- c = conditional
GLOBAL_GLOBL_LIST_INIT(cheartstopper, list(/datum/reagent/toxin/potassium_chloride))