// Three-way.
/obj/machinery/atmospherics/mains_pipe/manifold
	name = "mains manifold pipe"
	desc = "A manifold composed of mains pipes"
	dir = SOUTH
	initialize_mains_directions = EAST|NORTH|WEST
	volume = 105

/obj/machinery/atmospherics/mains_pipe/manifold/New()
	nodes.len = 3
	. = ..()
	initialize_mains_directions = (NORTH|SOUTH|EAST|WEST) & ~dir

/obj/machinery/atmospherics/mains_pipe/manifold/atmos_initialise()
	var/connect_directions = initialize_mains_directions

	for(var/direction in GLOBL.cardinal)
		if(direction & connect_directions)
			for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, direction))
				if(target.initialize_mains_directions & get_dir(target, src))
					nodes[1] = target
					connect_directions &= ~direction
					break
			if(nodes[1])
				break

	for(var/direction in GLOBL.cardinal)
		if(direction & connect_directions)
			for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, direction))
				if(target.initialize_mains_directions & get_dir(target, src))
					nodes[2] = target
					connect_directions &= ~direction
					break
			if(nodes[2])
				break

	for(var/direction in GLOBL.cardinal)
		if(direction & connect_directions)
			for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, direction))
				if(target.initialize_mains_directions & get_dir(target, src))
					nodes[3] = target
					connect_directions &= ~direction
					break
			if(nodes[3])
				break

	..() // initialize internal pipes

	var/turf/T = loc			// hide if turf is not intact
	hide(T.intact)
	update_icon()

/obj/machinery/atmospherics/mains_pipe/manifold/update_icon()
	icon_state = "manifold[invisibility ? "-f" : "" ]"

/obj/machinery/atmospherics/mains_pipe/manifold/hidden
	level = 1
	icon_state = "manifold-f"

/obj/machinery/atmospherics/mains_pipe/manifold/visible
	level = 2
	icon_state = "manifold"

// Four-way.
/obj/machinery/atmospherics/mains_pipe/manifold4w
	name = "mains 4-way manifold pipe"
	desc = "A manifold composed of mains pipes"
	dir = SOUTH
	initialize_mains_directions = EAST|NORTH|WEST|SOUTH
	volume = 105

/obj/machinery/atmospherics/mains_pipe/manifold4w/New()
	nodes.len = 4
	. = ..()

/obj/machinery/atmospherics/mains_pipe/manifold4w/atmos_initialise()
	for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, NORTH))
		if(target.initialize_mains_directions & get_dir(target, src))
			nodes[1] = target
			break

	for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, SOUTH))
		if(target.initialize_mains_directions & get_dir(target, src))
			nodes[2] = target
			break

	for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, EAST))
		if(target.initialize_mains_directions & get_dir(target, src))
			nodes[3] = target
			break

	for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, WEST))
		if(target.initialize_mains_directions & get_dir(target, src))
			nodes[3] = target
			break

	..() // initialize internal pipes

	var/turf/T = loc			// hide if turf is not intact
	hide(T.intact)
	update_icon()

/obj/machinery/atmospherics/mains_pipe/manifold4w/update_icon()
	icon_state = "manifold4w[invisibility ? "-f" : "" ]"

/obj/machinery/atmospherics/mains_pipe/manifold4w/hidden
	level = 1
	icon_state = "manifold4w-f"

/obj/machinery/atmospherics/mains_pipe/manifold4w/visible
	level = 2
	icon_state = "manifold4w"