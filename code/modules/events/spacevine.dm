GLOBAL_GLOBL_INIT(spacevines_spawned, FALSE)

/datum/round_event/spacevine
	oneShot = TRUE

/datum/round_event/spacevine/start()
	//biomass is basically just a resprited version of space vines
	if(prob(50))
		spacevine_infestation()
	else
		biomass_infestation()
	GLOBL.spacevines_spawned = TRUE