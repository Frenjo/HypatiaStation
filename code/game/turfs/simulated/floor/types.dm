/*
 * Airless
 */
/turf/simulated/floor/airless
	name = "airless floor"
	icon_state = "floor"
	initial_gases = null
	temperature = TCMB

/turf/simulated/floor/airless/New()
	. = ..()
	name = "floor"

/turf/simulated/floor/airless/ceiling
	icon_state = "rockvault"

/*
 * Light
 */
/turf/simulated/floor/light
	name = "light floor"
	light_range = 5
	icon_state = "light_on"
	floor_type = /obj/item/stack/tile/light

/turf/simulated/floor/light/initialise()
	. = ..()
	if(isnotnull(src))
		update_icon()
		name = initial(name) // Just in case commands rename it in the ..() call.

/*
 * Vault
 */
/turf/simulated/floor/vault
	icon_state = "rockvault"

/turf/simulated/floor/vault/New(location, type)
	. = ..()
	icon_state = "[type]vault"

/turf/simulated/wall/vault
	icon_state = "rockvault"

/turf/simulated/wall/vault/New(location, type)
	. = ..()
	icon_state = "[type]vault"

/*
 * Coloured Grids
 */
/turf/simulated/floor/bluegrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "bcircuit"

/turf/simulated/floor/bluegrid/New()
	. = ..()
	if(iscontactlevel(z))
		GLOBL.contactable_blue_grid_turfs.Add(src)

/turf/simulated/floor/bluegrid/Destroy()
	if(iscontactlevel(z))
		GLOBL.contactable_blue_grid_turfs.Remove(src)
	return ..()

/turf/simulated/floor/greengrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "gcircuit"

/turf/simulated/floor/greengrid/airless
	name = "floor" // This doesn't seem to inherit properly for some reason.
	initial_gases = null
	temperature = TCMB

/*
 * Server
 */
/turf/simulated/floor/server
	name = "server walkway"
	icon_state = "dark"
	initial_gases = list(/decl/xgm_gas/nitrogen = 500)
	temperature = 80

/turf/simulated/floor/bluegrid/server
	name = "server base"
	initial_gases = list(/decl/xgm_gas/nitrogen = 500)
	temperature = 80

/turf/simulated/floor/mainframe
	name = "mainframe floor"
	icon_state = "dark"
	initial_gases = list(/decl/xgm_gas/nitrogen = 100)
	temperature = 80

/turf/simulated/floor/bluegrid/mainframe
	name = "mainframe base"
	initial_gases = list(/decl/xgm_gas/nitrogen = 100)
	temperature = 80