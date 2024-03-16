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
 * Reinforced ("Engine")
 */
/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000

/turf/simulated/floor/reinforced/attackby(obj/item/C as obj, mob/user as mob)
	if(isnull(C))
		return
	if(isnull(user))
		return
	if(istype(C, /obj/item/wrench))
		to_chat(user, SPAN_INFO("Removing rods..."))
		playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
		if(do_after(user, 30))
			new /obj/item/stack/rods(src, 2)
			ChangeTurf(/turf/simulated/floor)
			var/turf/simulated/floor/F = src
			F.make_plating()

/turf/simulated/floor/reinforced/cult
	name = "engraved floor"
	icon_state = "cult"

// ATMOSPHERICS TANK FLOORS
// Added these for the atmos tanks. -Frenjo
// Vacuum
/turf/simulated/floor/reinforced/vacuum
	name = "vacuum floor"
	icon_state = "engine"
	initial_gases = null
	temperature = TCMB

// Oxygen
/turf/simulated/floor/reinforced/oxygen
	name = "o2 floor"
	initial_gases = list(/decl/xgm_gas/oxygen = 100000)

// Nitrogen
/turf/simulated/floor/reinforced/nitrogen
	name = "n2 floor"
	initial_gases = list(/decl/xgm_gas/nitrogen = 100000)

// Air
/turf/simulated/floor/reinforced/air
	name = "air floor"
	initial_gases = list(/decl/xgm_gas/oxygen = 2644, /decl/xgm_gas/nitrogen = 10580)

// Hydrogen
/turf/simulated/floor/reinforced/hydrogen
	name = "h2 floor"
	initial_gases = list(/decl/xgm_gas/hydrogen = 70000)

// Carbon Dioxide
/turf/simulated/floor/reinforced/co2
	name = "co2 floor"
	initial_gases = list(/decl/xgm_gas/carbon_dioxide = 50000)

// Plasma
/turf/simulated/floor/reinforced/plasma
	name = "plasma floor"
	initial_gases = list(/decl/xgm_gas/plasma = 70000)

// Oxygen Agent-B
/turf/simulated/floor/reinforced/oxygen_agent_b
	name = "o2a-b floor"
	initial_gases = list(/decl/xgm_gas/oxygen_agent_b = 2000)

// Nitrous Oxide
/turf/simulated/floor/reinforced/n2o
	name = "n2o floor"
	initial_gases = list(/decl/xgm_gas/sleeping_agent = 2000)
// END ATMOSPHERICS TANK FLOORS

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