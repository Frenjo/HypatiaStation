/obj/machinery/atmospherics/trinary
	dir = SOUTH
	initialize_directions = SOUTH|NORTH|WEST

	var/datum/gas_mixture/air1
	var/datum/gas_mixture/air2
	var/datum/gas_mixture/air3

	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2
	var/obj/machinery/atmospherics/node3

	var/datum/pipe_network/network1
	var/datum/pipe_network/network2
	var/datum/pipe_network/network3

/obj/machinery/atmospherics/trinary/New()
	. = ..()
	switch(dir)
		if(NORTH)
			initialize_directions = EAST | NORTH | SOUTH
		if(SOUTH)
			initialize_directions = SOUTH | WEST | NORTH
		if(EAST)
			initialize_directions = EAST | WEST | SOUTH
		if(WEST)
			initialize_directions = WEST | NORTH | EAST

	air1 = new /datum/gas_mixture()
	air2 = new /datum/gas_mixture()
	air3 = new /datum/gas_mixture()

	air1.volume = 200
	air2.volume = 200
	air3.volume = 200

/obj/machinery/atmospherics/trinary/atmos_initialise()
	if(isnotnull(node1) && isnotnull(node2) && isnotnull(node3))
		return

	var/node1_connect = turn(dir, -180)
	var/node2_connect = turn(dir, -90)
	var/node3_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src, node1_connect))
		if(target.initialize_directions & get_dir(target, src))
			node1 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src, node2_connect))
		if(target.initialize_directions & get_dir(target, src))
			node2 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src, node3_connect))
		if(target.initialize_directions & get_dir(target, src))
			node3 = target
			break

	update_icon()

/obj/machinery/atmospherics/trinary/Destroy()
	if(isnotnull(node1))
		node1.disconnect(src)
		node1 = null
		QDEL_NULL(network1)
	if(isnotnull(node2))
		node2.disconnect(src)
		node2 = null
		QDEL_NULL(network2)
	if(isnotnull(node3))
		node3.disconnect(src)
		node3 = null
		QDEL_NULL(network3)

	return ..()

// Housekeeping and pipe network stuff below
/obj/machinery/atmospherics/trinary/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node1)
		network1 = new_network

	else if(reference == node2)
		network2 = new_network

	else if(reference == node3)
		network3 = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members.Add(src)

	return null

/obj/machinery/atmospherics/trinary/build_network()
	if(isnull(network1) && isnotnull(node1))
		network1 = new /datum/pipe_network()
		network1.normal_members.Add(src)
		network1.build_network(node1, src)

	if(isnull(network2) && isnotnull(node2))
		network2 = new /datum/pipe_network()
		network2.normal_members.Add(src)
		network2.build_network(node2, src)

	if(isnull(network3) && isnotnull(node3))
		network3 = new /datum/pipe_network()
		network3.normal_members.Add(src)
		network3.build_network(node3, src)

/obj/machinery/atmospherics/trinary/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference == node1)
		return network1

	if(reference == node2)
		return network2

	if(reference == node3)
		return network3

	return null

/obj/machinery/atmospherics/trinary/reassign_network(datum/pipe_network/old_network, datum/pipe_network/new_network)
	if(network1 == old_network)
		network1 = new_network
	if(network2 == old_network)
		network2 = new_network
	if(network3 == old_network)
		network3 = new_network

	return 1

/obj/machinery/atmospherics/trinary/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(network1 == reference)
		results.Add(air1)
	if(network2 == reference)
		results.Add(air2)
	if(network3 == reference)
		results.Add(air3)

	return results

/obj/machinery/atmospherics/trinary/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		qdel(network1)
		node1 = null

	else if(reference == node2)
		qdel(network2)
		node2 = null

	else if(reference == node3)
		qdel(network3)
		node3 = null

	return null