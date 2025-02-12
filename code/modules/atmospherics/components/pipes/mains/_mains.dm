// Originally from code/WorkInProgress/Tastyfish/mainspipe.dm.
// Moved on 31/12/2021. -Frenjo

// Internal pipe, don't actually place or use these.
/obj/machinery/atmospherics/pipe/mains_component
	var/obj/machinery/atmospherics/mains_pipe/parent_pipe = null
	var/list/nodes = list()

/obj/machinery/atmospherics/pipe/mains_component/New(loc)
	. = ..(loc)
	parent_pipe = loc

/obj/machinery/atmospherics/pipe/mains_component/Destroy()
	parent_pipe = null
	nodes.Cut()
	return ..()

/obj/machinery/atmospherics/pipe/mains_component/check_pressure(pressure)
	var/datum/gas_mixture/environment = loc.loc.return_air()
	var/pressure_difference = pressure - environment.return_pressure()
	if(pressure_difference > parent_pipe.maximum_pressure)
		mains_burst()

	else if(pressure_difference > parent_pipe.fatigue_pressure)
		//TODO: leak to turf, doing pfshhhhh
		if(prob(5))
			mains_burst()

	else
		return 1

/obj/machinery/atmospherics/pipe/mains_component/pipeline_expansion()
	return nodes

/obj/machinery/atmospherics/pipe/mains_component/disconnect(obj/machinery/atmospherics/reference)
	if(nodes.Find(reference))
		nodes.Remove(reference)

/obj/machinery/atmospherics/pipe/mains_component/proc/mains_burst()
	parent_pipe.burst()

// Standard mains pipes.
/obj/machinery/atmospherics/mains_pipe
	icon = 'icons/obj/pipes/mains.dmi'
	layer = 2.4 //under wires with their 2.5

	var/volume = 0

	var/initialize_mains_directions = 0

	var/list/nodes = list()
	var/obj/machinery/atmospherics/pipe/mains_component/supply
	var/obj/machinery/atmospherics/pipe/mains_component/scrubbers
	var/obj/machinery/atmospherics/pipe/mains_component/aux

	var/minimum_temperature_difference = 300
	var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

	var/maximum_pressure = 70 * ONE_ATMOSPHERE
	var/fatigue_pressure = 55 * ONE_ATMOSPHERE
	var/alert_pressure = 55 * ONE_ATMOSPHERE

/obj/machinery/atmospherics/mains_pipe/New()
	. = ..()

	supply = new /obj/machinery/atmospherics/pipe/mains_component(src)
	supply.volume = volume
	supply.nodes.len = length(nodes)

	scrubbers = new /obj/machinery/atmospherics/pipe/mains_component(src)
	scrubbers.volume = volume
	scrubbers.nodes.len = length(nodes)

	aux = new /obj/machinery/atmospherics/pipe/mains_component(src)
	aux.volume = volume
	aux.nodes.len = length(nodes)

/obj/machinery/atmospherics/mains_pipe/atmos_initialise()
	. = ..()
	for(var/i = 1 to length(nodes))
		var/obj/machinery/atmospherics/mains_pipe/node = nodes[i]
		if(isnotnull(node))
			supply.nodes[i] = node.supply
			scrubbers.nodes[i] = node.scrubbers
			aux.nodes[i] = node.aux

/obj/machinery/atmospherics/mains_pipe/Destroy()
	disconnect()
	QDEL_NULL(supply)
	QDEL_NULL(scrubbers)
	QDEL_NULL(aux)
	return ..()

/obj/machinery/atmospherics/mains_pipe/hide(i)
	if(level == 1 && isopenturf(loc))
		invisibility = i ? 101 : 0
	update_icon()

/obj/machinery/atmospherics/mains_pipe/proc/burst()
	for(var/obj/machinery/atmospherics/pipe/mains_component/pipe in contents)
		burst()

/obj/machinery/atmospherics/mains_pipe/proc/check_pressure(pressure)
	var/datum/gas_mixture/environment = loc.return_air()
	var/pressure_difference = pressure - environment.return_pressure()
	if(pressure_difference > maximum_pressure)
		burst()

	else if(pressure_difference > fatigue_pressure)
		//TODO: leak to turf, doing pfshhhhh
		if(prob(5))
			burst()

	else
		return 1

/obj/machinery/atmospherics/mains_pipe/disconnect()
	..()
	for(var/obj/machinery/atmospherics/pipe/mains_component/node in nodes)
		node.disconnect()