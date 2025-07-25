/obj/machinery/atmospherics/unary
	dir = SOUTH
	initialize_directions = SOUTH
	layer = TURF_LAYER + 0.1

	var/datum/gas_mixture/air_contents

	var/obj/machinery/atmospherics/node

	var/datum/pipe_network/network

/obj/machinery/atmospherics/unary/initialise()
	. = ..()
	initialize_directions = dir
	air_contents = new /datum/gas_mixture()

	air_contents.volume = 200

/obj/machinery/atmospherics/unary/atmos_initialise()
	if(isnotnull(node))
		return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src, node_connect))
		if(target.initialize_directions & get_dir(target, src))
			node = target
			break

	update_icon()

/obj/machinery/atmospherics/unary/Destroy()
	QDEL_NULL(air_contents)
	if(isnotnull(node))
		node.disconnect(src)
		node = null
		QDEL_NULL(network)

	return ..()

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/unary/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node)
		network = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members.Add(src)

	return null

/obj/machinery/atmospherics/unary/build_network()
	if(isnull(network) && isnotnull(node))
		network = new /datum/pipe_network()
		network.normal_members.Add(src)
		network.build_network(node, src)

/obj/machinery/atmospherics/unary/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference == node)
		return network

	return null

/obj/machinery/atmospherics/unary/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network == old_network)
		network = new_network

	return 1

/obj/machinery/atmospherics/unary/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(network == reference)
		results.Add(air_contents)

	return results

/obj/machinery/atmospherics/unary/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node)
		qdel(network)
		node = null

	return null

/obj/machinery/atmospherics/unary/proc/broadcast_status()
	return