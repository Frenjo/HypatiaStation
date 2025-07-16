/*
 * Coloured Grids
 */
/turf/open/floor/circuit_grid
	name = "circuit grid floor"
	icon = 'icons/turf/floors/circuit_grids.dmi'

/turf/open/floor/circuit_grid/attack_tool(obj/item/tool, mob/user)
	if(iscrowbar(tool))
		to_chat(user, SPAN_WARNING("You forcefully pry off the circuit grid, destroying it in the process."))
		playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
		make_plating()
		return TRUE

	if(isscrewdriver(tool))
		to_chat(user, SPAN_INFO("You unscrew the circuit grid."))
		playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
		new tile_path(src)
		make_plating()
		return TRUE

	return ..()

// Blue
/turf/open/floor/circuit_grid/blue
	name = "blue circuit grid floor"
	icon_state = "bcircuit"

	tile_path = /obj/item/stack/tile/circuit_grid/blue

/turf/open/floor/circuit_grid/blue/initialise()
	. = ..()
	if(iscontactlevel(z))
		GLOBL.contactable_blue_grid_turfs.Add(src)

/turf/open/floor/circuit_grid/blue/Destroy()
	if(iscontactlevel(z))
		GLOBL.contactable_blue_grid_turfs.Remove(src)
	return ..()

/turf/open/floor/circuit_grid/blue/airless
	name = "airless blue circuit grid floor"
	initial_gases = null
	temperature = TCMB

/turf/open/floor/circuit_grid/blue/airless/initialise()
	. = ..()
	name = "blue circuit grid floor"

/turf/open/floor/circuit_grid/blue/server
	name = "server base"
	initial_gases = list(/decl/xgm_gas/nitrogen = 500)
	temperature = 80

/turf/open/floor/circuit_grid/blue/mainframe
	name = "mainframe base"
	initial_gases = list(/decl/xgm_gas/nitrogen = 100)
	temperature = 80

// Green
/turf/open/floor/circuit_grid/green
	name = "green circuit grid floor"
	icon_state = "gcircuit"

	tile_path = /obj/item/stack/tile/circuit_grid/green

/turf/open/floor/circuit_grid/green/airless
	name = "airless green circuit grid floor"
	initial_gases = null
	temperature = TCMB

/turf/open/floor/circuit_grid/green/airless/initialise()
	. = ..()
	name = "green circuit grid floor"