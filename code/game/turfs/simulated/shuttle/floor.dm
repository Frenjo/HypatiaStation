/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"
	explosion_resistance = 1

/turf/simulated/shuttle/floor/vox
	icon_state = "floor4"
	initial_gases = list(/decl/xgm_gas/nitrogen = MOLES_N2STANDARD)

/turf/simulated/shuttle/floor/brig	// Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "brig floor"			// Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"