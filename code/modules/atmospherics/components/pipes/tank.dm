/obj/machinery/atmospherics/pipe/tank
	icon = 'icons/obj/atmospherics/pipe_tank.dmi'
	icon_state = "intact"

	name = "pressure tank"
	desc = "A large vessel containing pressurized gas."

	volume = 2000 //in liters, 1 meters by 1 meters by 2 meters

	dir = SOUTH
	initialize_directions = SOUTH
	density = TRUE

	var/obj/machinery/atmospherics/node1

/obj/machinery/atmospherics/pipe/tank/initialise()
	. = ..()
	initialize_directions = dir

/obj/machinery/atmospherics/pipe/tank/atmos_initialise()
	var/connect_direction = dir

	for(var/obj/machinery/atmospherics/target in get_step(src, connect_direction))
		if(target.initialize_directions & get_dir(target, src))
			node1 = target
			break

	update_icon()

/obj/machinery/atmospherics/pipe/tank/Destroy()
	node1?.disconnect(src)
	node1 = null
	return ..()

/obj/machinery/atmospherics/pipe/tank/pipeline_expansion()
	return list(node1)

/obj/machinery/atmospherics/pipe/tank/process()
	if(isnull(parent))
		..()
	else
		. = PROCESS_KILL
/*			if(!node1)
		parent.mingle_with_turf(loc, 200)
		if(!nodealert)
			//to_world("Missing node from [src] at [src.x],[src.y],[src.z]")
			nodealert = 1
	else if (nodealert)
		nodealert = 0
*/

/obj/machinery/atmospherics/pipe/tank/update_icon()
	if(isnotnull(node1))
		icon_state = "intact"

		dir = get_dir(src, node1)

	else
		icon_state = "exposed"

/obj/machinery/atmospherics/pipe/tank/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 = null

	update_icon()
	return null

/obj/machinery/atmospherics/pipe/tank/attack_tool(obj/item/tool, mob/user)
	if(istype(tool, /obj/item/gas_analyser))
		atmos_scan(user, src)
		return TRUE
	return ..()

/obj/machinery/atmospherics/pipe/tank/return_air()
	return parent?.air

/obj/machinery/atmospherics/pipe/tank/carbon_dioxide
	name = "pressure tank (Carbon Dioxide)"

/obj/machinery/atmospherics/pipe/tank/carbon_dioxide/initialise()
	. = ..()
	air_temporary = new /datum/gas_mixture()
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas(/decl/xgm_gas/carbon_dioxide, (25 * ONE_ATMOSPHERE) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature))

/obj/machinery/atmospherics/pipe/tank/toxins
	icon = 'icons/obj/atmospherics/orange_pipe_tank.dmi'
	name = "pressure tank (Plasma)"

/obj/machinery/atmospherics/pipe/tank/toxins/initialise()
	. = ..()
	air_temporary = new /datum/gas_mixture()
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas(/decl/xgm_gas/plasma, (25 * ONE_ATMOSPHERE) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature))

/obj/machinery/atmospherics/pipe/tank/oxygen_agent_b
	icon = 'icons/obj/atmospherics/red_orange_pipe_tank.dmi'
	name = "pressure tank (Oxygen + Plasma)"

/obj/machinery/atmospherics/pipe/tank/oxygen_agent_b/initialise()
	. = ..()
	air_temporary = new /datum/gas_mixture()
	air_temporary.volume = volume
	air_temporary.temperature = T0C

	air_temporary.adjust_gas(/decl/xgm_gas/oxygen_agent_b, (25 * ONE_ATMOSPHERE) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature))

/obj/machinery/atmospherics/pipe/tank/oxygen
	icon = 'icons/obj/atmospherics/blue_pipe_tank.dmi'
	name = "pressure tank (Oxygen)"

/obj/machinery/atmospherics/pipe/tank/oxygen/initialise()
	. = ..()
	air_temporary = new /datum/gas_mixture()
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas(/decl/xgm_gas/oxygen, (25 * ONE_ATMOSPHERE) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature))

/obj/machinery/atmospherics/pipe/tank/nitrogen
	icon = 'icons/obj/atmospherics/red_pipe_tank.dmi'
	name = "pressure tank (Nitrogen)"

/obj/machinery/atmospherics/pipe/tank/nitrogen/initialise()
	. = ..()
	air_temporary = new /datum/gas_mixture()
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas(/decl/xgm_gas/nitrogen, (25 * ONE_ATMOSPHERE) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature))

/obj/machinery/atmospherics/pipe/tank/air
	icon = 'icons/obj/atmospherics/red_pipe_tank.dmi'
	name = "pressure tank (Air)"

/obj/machinery/atmospherics/pipe/tank/air/initialise()
	. = ..()
	air_temporary = new /datum/gas_mixture()
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_multi(
		/decl/xgm_gas/oxygen, (25 * ONE_ATMOSPHERE * O2STANDARD) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature),
		/decl/xgm_gas/nitrogen, (25 * ONE_ATMOSPHERE * N2STANDARD) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature)
	)