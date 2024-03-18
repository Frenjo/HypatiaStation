/*
 * Reinforced ("Engine")
 */
/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000

/turf/simulated/floor/reinforced/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		user.visible_message(
			SPAN_NOTICE("[user] starts to unwrench the rods from \the [src]..."),
			SPAN_NOTICE("You start to unwrench the rods from \the [src]..."),
			SPAN_INFO("You hear a ratchet.")
		)
		playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
		if(do_after(user, 3 SECONDS))
			user.visible_message(
				SPAN_NOTICE("[user] unwrenches the rods from \the [src]."),
				SPAN_NOTICE("You unwrench the rods from \the [src]."),
				SPAN_INFO("You hear a ratchet.")
			)
			new /obj/item/stack/rods(src, 2)
			make_floor(/turf/simulated/floor/plating)
		return TRUE

	if(iscrowbar(tool))
		return TRUE
	return ..()

/turf/simulated/floor/reinforced/break_tile()
	SHOULD_CALL_PARENT(FALSE)

	return FALSE

/turf/simulated/floor/reinforced/burn_tile()
	SHOULD_CALL_PARENT(FALSE)

	return FALSE

/turf/simulated/floor/reinforced/make_plating()
	return

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