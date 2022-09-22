GLOBAL_GLOBL_LIST_NEW(chemical_reactions_list)	// List of all /datum/chemical_reaction datums. Used during chemical reactions.
GLOBAL_GLOBL_LIST_NEW(chemical_reagents_list)	// List of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff.
GLOBAL_GLOBL_LIST_NEW(side_effects)				// List of all medical sideeffects types by thier names. |BS12

//feel free to add shit to lists below
GLOBAL_GLOBL_LIST_INIT(tachycardics, list("coffee", "inaprovaline", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine")) //increase heart rate
GLOBAL_GLOBL_LIST_INIT(bradycardics, list("neurotoxin", "cryoxadone", "clonexadone", "space_drugs", "stoxin")) //decrease heart rate
GLOBAL_GLOBL_LIST_INIT(heartstopper, list("potassium_phorochloride", "zombie_powder")) //this stops the heart
GLOBAL_GLOBL_LIST_INIT(cheartstopper, list("potassium_chloride")) //this stops the heart when overdose is met -- c = conditional