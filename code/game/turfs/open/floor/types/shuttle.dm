/turf/open/floor/shuttle
	icon = 'icons/turf/shuttle.dmi'

	thermal_conductivity = 0.05
	heat_capacity = 0
	explosion_resistance = 1

/turf/open/floor/shuttle/blue
	name = "blue floor"
	icon_state = "floor"

/turf/open/floor/shuttle/yellow
	name = "yellow floor"
	icon_state = "floor2"

/turf/open/floor/shuttle/white
	name = "white floor"
	icon_state = "floor3"

/turf/open/floor/shuttle/red
	name = "red floor"
	icon_state = "floor4"

/turf/open/floor/shuttle/red/vox
	initial_gases = list(/decl/xgm_gas/nitrogen = MOLES_N2STANDARD)

/turf/open/floor/shuttle/red/brig	// Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "brig floor"			// Also added it into the 2x3 brig area of the shuttle.

/turf/open/floor/shuttle/purple
	name = "purple floor"
	icon_state = "floor5"