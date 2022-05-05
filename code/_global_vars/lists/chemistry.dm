/var/global/list/chemical_reactions_list				//list of all /datum/chemical_reaction datums. Used during chemical reactions
/var/global/list/chemical_reagents_list				//list of all /datum/reagent datums indexed by reagent id. Used by chemistry stuff
/var/global/list/side_effects = list()				//list of all medical sideeffects types by thier names |BS12

//feel free to add shit to lists below
/var/global/list/tachycardics = list("coffee", "inaprovaline", "hyperzine", "nitroglycerin", "thirteenloko", "nicotine")	//increase heart rate
/var/global/list/bradycardics = list("neurotoxin", "cryoxadone", "clonexadone", "space_drugs", "stoxin")					//decrease heart rate
/var/global/list/heartstopper = list("potassium_phorochloride", "zombie_powder") //this stops the heart
/var/global/list/cheartstopper = list("potassium_chloride") //this stops the heart when overdose is met -- c = conditional