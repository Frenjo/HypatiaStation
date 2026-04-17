/datum/chemical_reaction/glycerol
	name = "Glycerol"
	result = /datum/reagent/glycerol
	required_reagents = alist("cornoil" = 3, "sacid" = 1)
	result_amount = 1

// foam and foam precursor
/datum/chemical_reaction/surfactant
	name = "Foam surfactant"
	result = /datum/reagent/fluorosurfactant
	required_reagents = alist("fluorine" = 2, "carbon" = 2, "sacid" = 1)
	result_amount = 5

/datum/chemical_reaction/foaming_agent
	name = "Foaming Agent"
	result = /datum/reagent/foaming_agent
	required_reagents = alist("lithium" = 1, "hydrogen" = 1)
	result_amount = 1

// Synthesizing these two chemicals is pretty complex in real life, but fuck it, it's just a game!
/datum/chemical_reaction/ammonia
	name = "Ammonia"
	result = /datum/reagent/ammonia
	required_reagents = alist("hydrogen" = 3, "nitrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/diethylamine
	name = "Diethylamine"
	result = /datum/reagent/diethylamine
	required_reagents = alist("ammonia" = 1, "ethanol" = 1)
	result_amount = 2

// This is a horrible rip off based on /tg/'s chemical reactions for plastic-making.
/datum/chemical_reaction/oil
	name = "Oil"
	result = /datum/reagent/oil
	required_reagents = alist("fuel" = 1, "carbon" = 1, "hydrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/phenol
	name = "Phenol"
	result = /datum/reagent/phenol
	required_reagents = alist("chlorine" = 1, "oil" = 1, "water" = 1)
	result_amount = 3

/datum/chemical_reaction/acetone
	name = "Acetone"
	result = /datum/reagent/acetone
	required_reagents = alist("fuel" = 1, "oil" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/nitrous_oxide
	name = "Nitrous Oxide"
	result = /datum/reagent/nitrous_oxide
	required_reagents = alist("nitrogen" = 2, "oxygen" = 1)
	required_catalysts = alist("ammonia" = 2)
	result_amount = 3