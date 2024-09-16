/obj/machinery/atmospherics/mains_pipe/simple
	name = "mains pipe"
	desc = "A one meter section of 3-line mains pipe"
	dir = SOUTH
	initialize_mains_directions = SOUTH|NORTH

/obj/machinery/atmospherics/mains_pipe/simple/New()
	nodes.len = 2
	. = ..()
	switch(dir)
		if(SOUTH, NORTH)
			initialize_mains_directions = SOUTH|NORTH
		if(EAST, WEST)
			initialize_mains_directions = EAST|WEST
		if(NORTHEAST)
			initialize_mains_directions = NORTH|EAST
		if(NORTHWEST)
			initialize_mains_directions = NORTH|WEST
		if(SOUTHEAST)
			initialize_mains_directions = SOUTH|EAST
		if(SOUTHWEST)
			initialize_mains_directions = SOUTH|WEST

/obj/machinery/atmospherics/mains_pipe/simple/atmos_initialise()
	normalize_dir()

	var/node1_dir
	var/node2_dir
	for(var/direction in GLOBL.cardinal)
		if(direction & initialize_mains_directions)
			if(!node1_dir)
				node1_dir = direction
			else if(!node2_dir)
				node2_dir = direction

	for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, node1_dir))
		if(target.initialize_mains_directions & get_dir(target, src))
			nodes[1] = target
			break
	for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, node2_dir))
		if(target.initialize_mains_directions & get_dir(target, src))
			nodes[2] = target
			break

	..() // initialize internal pipes

	var/turf/T = loc			// hide if turf is not intact
	hide(T.intact)
	update_icon()

/obj/machinery/atmospherics/mains_pipe/simple/proc/normalize_dir()
	if(dir == 3)
		dir = 1
	else if(dir == 12)
		dir = 4

/obj/machinery/atmospherics/mains_pipe/simple/update_icon()
	if(nodes[1] && nodes[2])
		icon_state = "intact[invisibility ? "-f" : "" ]"

		//var/node1_direction = get_dir(src, node1)
		//var/node2_direction = get_dir(src, node2)

		//dir = node1_direction|node2_direction

	else
		if(!nodes[1] && !nodes[2])
			qdel(src) //TODO: silent deleting looks weird
		var/have_node1 = nodes[1] ? 1 : 0
		var/have_node2 = nodes[2] ? 1 : 0
		icon_state = "exposed[have_node1][have_node2][invisibility ? "-f" : "" ]"

/obj/machinery/atmospherics/mains_pipe/simple/hidden
	level = 1
	icon_state = "intact-f"

/obj/machinery/atmospherics/mains_pipe/simple/visible
	level = 2
	icon_state = "intact"