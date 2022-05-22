/obj/machinery/atmospherics/pipe/tank
	icon = 'icons/obj/atmospherics/pipe_tank.dmi'
	icon_state = "intact"

	name = "Pressure Tank"
	desc = "A large vessel containing pressurized gas."

	volume = 2000 //in liters, 1 meters by 1 meters by 2 meters

	dir = SOUTH
	initialize_directions = SOUTH
	density = TRUE

	var/obj/machinery/atmospherics/node1

/obj/machinery/atmospherics/pipe/tank/New()
	initialize_directions = dir
	..()

/obj/machinery/atmospherics/pipe/tank/initialize()
	var/connect_direction = dir

	for(var/obj/machinery/atmospherics/target in get_step(src, connect_direction))
		if(target.initialize_directions & get_dir(target, src))
			node1 = target
			break

	update_icon()

/obj/machinery/atmospherics/pipe/tank/Destroy()
	if(node1)
		node1.disconnect(src)
	return ..()

/obj/machinery/atmospherics/pipe/tank/pipeline_expansion()
	return list(node1)

/obj/machinery/atmospherics/pipe/tank/process()
	if(!parent)
		..()
	else
		. = PROCESS_KILL
/*			if(!node1)
		parent.mingle_with_turf(loc, 200)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1
	else if (nodealert)
		nodealert = 0
*/

/obj/machinery/atmospherics/pipe/tank/update_icon()
	if(node1)
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

/obj/machinery/atmospherics/pipe/tank/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/device/analyzer) && get_dist(user, src) <= 1)
		for(var/mob/O in viewers(user, null))
			to_chat(O, SPAN_WARNING("[user] has used the analyzer on \icon[icon]."))

		var/pressure = parent.air.return_pressure()
		var/total_moles = parent.air.total_moles

		to_chat(user, SPAN_INFO("Results of analysis of \icon[icon]"))
		if(total_moles > 0)
			to_chat(user, SPAN_INFO("Pressure: [round(pressure, 0.1)] kPa"))
			for(var/g in parent.air.gas)
				to_chat(user, SPAN_INFO("[gas_data.name[g]]: [round((parent.air.gas[g] / total_moles) * 100)]%"))
			to_chat(user, SPAN_INFO("Temperature: [round(parent.air.temperature - T0C)]&deg;C"))
		else
			to_chat(user, SPAN_INFO("Tank is empty!"))

/obj/machinery/atmospherics/pipe/tank/carbon_dioxide
	name = "Pressure Tank (Carbon Dioxide)"

/obj/machinery/atmospherics/pipe/tank/carbon_dioxide/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas(GAS_CARBON_DIOXIDE, (25 * ONE_ATMOSPHERE) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature))

	..()

/obj/machinery/atmospherics/pipe/tank/toxins
	icon = 'icons/obj/atmospherics/orange_pipe_tank.dmi'
	name = "Pressure Tank (Plasma)"

/obj/machinery/atmospherics/pipe/tank/toxins/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas(GAS_PLASMA, (25 * ONE_ATMOSPHERE) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature))

	..()

/obj/machinery/atmospherics/pipe/tank/oxygen_agent_b
	icon = 'icons/obj/atmospherics/red_orange_pipe_tank.dmi'
	name = "Pressure Tank (Oxygen + Plasma)"

/obj/machinery/atmospherics/pipe/tank/oxygen_agent_b/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T0C

	air_temporary.adjust_gas(GAS_OXYGEN_AGENT_B, (25 * ONE_ATMOSPHERE) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature))

	..()

/obj/machinery/atmospherics/pipe/tank/oxygen
	icon = 'icons/obj/atmospherics/blue_pipe_tank.dmi'
	name = "Pressure Tank (Oxygen)"

/obj/machinery/atmospherics/pipe/tank/oxygen/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas(GAS_OXYGEN, (25 * ONE_ATMOSPHERE) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature))

	..()

/obj/machinery/atmospherics/pipe/tank/nitrogen
	icon = 'icons/obj/atmospherics/red_pipe_tank.dmi'
	name = "Pressure Tank (Nitrogen)"

/obj/machinery/atmospherics/pipe/tank/nitrogen/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_gas(GAS_NITROGEN, (25 * ONE_ATMOSPHERE) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature))

	..()

/obj/machinery/atmospherics/pipe/tank/air
	icon = 'icons/obj/atmospherics/red_pipe_tank.dmi'
	name = "Pressure Tank (Air)"

/obj/machinery/atmospherics/pipe/tank/air/New()
	air_temporary = new
	air_temporary.volume = volume
	air_temporary.temperature = T20C

	air_temporary.adjust_multi(
		GAS_OXYGEN, (25 * ONE_ATMOSPHERE * O2STANDARD) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature),
		GAS_NITROGEN, (25 * ONE_ATMOSPHERE * N2STANDARD) * air_temporary.volume / (R_IDEAL_GAS_EQUATION * air_temporary.temperature)
	)

	..()