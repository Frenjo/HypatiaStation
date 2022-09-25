GLOBAL_GLOBL_INIT(spacevines_spawned, 0)

/datum/event/spacevine
	oneShot			= 1

/datum/event/spacevine/start()
	//biomass is basically just a resprited version of space vines
	if(prob(50))
		spacevine_infestation()
	else
		biomass_infestation()
	GLOBL.spacevines_spawned = 1