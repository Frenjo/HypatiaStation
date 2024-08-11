/turf/open/floor/shuttle
	icon_state = "floor"
	icon = 'icons/turf/shuttle.dmi'

	thermal_conductivity = 0.05
	heat_capacity = 0
	explosion_resistance = 1

/turf/open/floor/shuttle/vox
	icon_state = "floor4"
	initial_gases = list(/decl/xgm_gas/nitrogen = MOLES_N2STANDARD)

/turf/open/floor/shuttle/brig	// Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "brig floor"			// Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"