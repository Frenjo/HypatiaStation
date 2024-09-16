/obj/machinery/atmospherics/mains_pipe/split
	name = "mains splitter"
	desc = "A splitter for connecting to a single pipe off a mains."

	var/obj/machinery/atmospherics/pipe/mains_component/split_node
	var/obj/machinery/atmospherics/node3
	var/icon_type

/obj/machinery/atmospherics/mains_pipe/split/New()
	nodes.len = 2
	. = ..()
	initialize_mains_directions = turn(dir, 90) | turn(dir, -90)
	initialize_directions = dir // actually have a normal connection too

/obj/machinery/atmospherics/mains_pipe/split/atmos_initialise()
	var/node1_dir = turn(dir, 90)
	var/node2_dir = turn(dir, -90)
	var/node3_dir = dir

	for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, node1_dir))
		if(target.initialize_mains_directions & get_dir(target, src))
			nodes[1] = target
			break
	for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, node2_dir))
		if(target.initialize_mains_directions & get_dir(target, src))
			nodes[2] = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src, node3_dir))
		if(target.initialize_directions & get_dir(target, src))
			node3 = target
			break

	..() // initialize internal pipes

	// bind them
	spawn(5)
		if(node3 && split_node)
			var/datum/pipe_network/N1 = node3.return_network(src)
			var/datum/pipe_network/N2 = split_node.return_network(split_node)
			if(N1 && N2)
				N1.merge(N2)

	var/turf/T = loc			// hide if turf is not intact
	hide(T.intact)
	update_icon()

/obj/machinery/atmospherics/mains_pipe/split/update_icon()
	icon_state = "split-[icon_type][invisibility ? "-f" : "" ]"

/obj/machinery/atmospherics/mains_pipe/split/return_network(A)
	return split_node.return_network(A)


/obj/machinery/atmospherics/mains_pipe/split/supply
	name = "mains supply splitter"
	icon_type = "supply"

/obj/machinery/atmospherics/mains_pipe/split/supply/New()
	. = ..()
	split_node = supply

/obj/machinery/atmospherics/mains_pipe/split/supply/hidden
	level = 1
	icon_state = "split-supply-f"

/obj/machinery/atmospherics/mains_pipe/split/supply/visible
	level = 2
	icon_state = "split-supply"


/obj/machinery/atmospherics/mains_pipe/split/scrubbers
	name = "mains scrubbers splitter"
	icon_type = "scrubbers"

/obj/machinery/atmospherics/mains_pipe/split/scrubbers/New()
	. = ..()
	split_node = scrubbers

/obj/machinery/atmospherics/mains_pipe/split/scrubbers/hidden
	level = 1
	icon_state = "split-scrubbers-f"

/obj/machinery/atmospherics/mains_pipe/split/scrubbers/visible
	level = 2
	icon_state = "split-scrubbers"


/obj/machinery/atmospherics/mains_pipe/split/aux
	name = "mains aux splitter"
	icon_type = "aux"

/obj/machinery/atmospherics/mains_pipe/split/aux/New()
	. = ..()
	split_node = aux

/obj/machinery/atmospherics/mains_pipe/split/aux/hidden
	level = 1
	icon_state = "split-aux-f"

/obj/machinery/atmospherics/mains_pipe/split/aux/visible
	level = 2
	icon_state = "split-aux"


/obj/machinery/atmospherics/mains_pipe/split3
	name = "triple mains splitter"
	desc = "A splitter for connecting to the 3 pipes on a mainline."

	var/obj/machinery/atmospherics/supply_node
	var/obj/machinery/atmospherics/scrubbers_node
	var/obj/machinery/atmospherics/aux_node

/obj/machinery/atmospherics/mains_pipe/split3/New()
	nodes.len = 1
	. = ..()
	initialize_mains_directions = dir
	initialize_directions = GLOBL.cardinal & ~dir // actually have a normal connection too

/obj/machinery/atmospherics/mains_pipe/split3/atmos_initialise()
	var/node1_dir = dir
	var/supply_node_dir
	var/scrubbers_node_dir
	var/aux_node_dir = turn(dir, 180)

	if(dir & (NORTH|SOUTH))
		supply_node_dir = EAST
		scrubbers_node_dir = WEST
	else
		supply_node_dir = SOUTH
		scrubbers_node_dir = NORTH

	for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, node1_dir))
		if(target.initialize_mains_directions & get_dir(target, src))
			nodes[1] = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src, supply_node_dir))
		if(target.initialize_directions & get_dir(target, src))
			supply_node = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src, scrubbers_node_dir))
		if(target.initialize_directions & get_dir(target, src))
			scrubbers_node = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src, aux_node_dir))
		if(target.initialize_directions & get_dir(target, src))
			aux_node = target
			break

	..() // initialize internal pipes

	// bind them
	spawn(5)
		if(isnotnull(supply_node))
			var/datum/pipe_network/N1 = supply_node.return_network(src)
			var/datum/pipe_network/N2 = supply.return_network(supply)
			if(isnotnull(N1) && isnotnull(N2))
				N1.merge(N2)
		if(isnotnull(scrubbers_node))
			var/datum/pipe_network/N1 = scrubbers_node.return_network(src)
			var/datum/pipe_network/N2 = scrubbers.return_network(scrubbers)
			if(isnotnull(N1) && isnotnull(N2))
				N1.merge(N2)
		if(isnotnull(aux_node))
			var/datum/pipe_network/N1 = aux_node.return_network(src)
			var/datum/pipe_network/N2 = aux.return_network(aux)
			if(isnotnull(N1) && isnotnull(N2))
				N1.merge(N2)

	var/turf/T = loc			// hide if turf is not intact
	hide(T.intact)
	update_icon()

/obj/machinery/atmospherics/mains_pipe/split3/update_icon()
	icon_state = "split-t[invisibility ? "-f" : "" ]"

/obj/machinery/atmospherics/mains_pipe/split3/return_network(obj/machinery/atmospherics/reference)
	var/obj/machinery/atmospherics/A = supply_node.return_network(reference)
	if(isnull(A))
		A = scrubbers_node.return_network(reference)
	if(isnull(A))
		A = aux_node.return_network(reference)

	return A

/obj/machinery/atmospherics/mains_pipe/split3/hidden
	level = 1
	icon_state = "split-t-f"

/obj/machinery/atmospherics/mains_pipe/split3/visible
	level = 2
	icon_state = "split-t"