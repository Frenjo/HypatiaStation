/obj/machinery/atmospherics/mains_pipe/cap
	name = "mains pipe cap"
	desc = "A cap for the end of a mains pipe"
	dir = SOUTH
	initialize_directions = SOUTH
	volume = 35

/obj/machinery/atmospherics/mains_pipe/cap/New()
	nodes.len = 1
	. = ..()
	initialize_mains_directions = dir

/obj/machinery/atmospherics/mains_pipe/cap/update_icon()
	icon_state = "cap[invisibility ? "-f" : ""]"

/obj/machinery/atmospherics/mains_pipe/cap/atmos_initialise()
	for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, dir))
		if(target.initialize_mains_directions & get_dir(target, src))
			nodes[1] = target
			break

	..()

	var/turf/T = loc	// hide if turf is not intact
	hide(T.intact)
	update_icon()

/obj/machinery/atmospherics/mains_pipe/cap/hidden
	level = 1
	icon_state = "cap-f"

/obj/machinery/atmospherics/mains_pipe/cap/visible
	level = 2
	icon_state = "cap"