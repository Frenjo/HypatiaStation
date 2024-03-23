/*
 * Coloured Grids
 */
/turf/simulated/floor/grid
	name = "circuit grid floor"
	icon = 'icons/turf/floors/circuit_grids.dmi'

// Blue
/turf/simulated/floor/grid/blue
	icon_state = "bcircuit"

/turf/simulated/floor/grid/blue/New()
	. = ..()
	if(iscontactlevel(z))
		GLOBL.contactable_blue_grid_turfs.Add(src)

/turf/simulated/floor/grid/blue/Destroy()
	if(iscontactlevel(z))
		GLOBL.contactable_blue_grid_turfs.Remove(src)
	return ..()

// Server
/turf/simulated/floor/grid/blue/server
	name = "server base"
	initial_gases = list(/decl/xgm_gas/nitrogen = 500)
	temperature = 80

// Mainframe
/turf/simulated/floor/grid/blue/mainframe
	name = "mainframe base"
	initial_gases = list(/decl/xgm_gas/nitrogen = 100)
	temperature = 80

// Green
/turf/simulated/floor/grid/green
	icon_state = "gcircuit"

/turf/simulated/floor/grid/green/airless
	initial_gases = null
	temperature = TCMB