/obj/machinery/atmospherics/pipe/cap
	name = "pipe endcap"
	desc = "An endcap for pipes"
	icon = 'icons/obj/pipes/pipes.dmi'
	icon_state = "cap"
	level = 2
	layer = 2.4 //under wires with their 2.44

	volume = 35

	dir = SOUTH
	initialize_directions = NORTH

	var/obj/machinery/atmospherics/node

/obj/machinery/atmospherics/pipe/cap/New()
	. = ..()
	switch(dir)
		if(SOUTH)
		 initialize_directions = NORTH
		if(NORTH)
		 initialize_directions = SOUTH
		if(WEST)
		 initialize_directions = EAST
		if(EAST)
		 initialize_directions = WEST

/obj/machinery/atmospherics/pipe/cap/atmos_initialise()
	for(var/obj/machinery/atmospherics/target in get_step(src, dir))
		if(target.initialize_directions & get_dir(target, src))
			node = target
			break

	var/turf/T = loc			// hide if turf is not intact
	hide(T.intact)
	update_icon()

/obj/machinery/atmospherics/pipe/cap/Destroy()
	if(isnotnull(node))
		node.disconnect(src)
	return ..()

/obj/machinery/atmospherics/pipe/cap/hide(i)
	if(level == 1 && issimulated(loc))
		invisibility = i ? 101 : 0
	update_icon()

/obj/machinery/atmospherics/pipe/cap/pipeline_expansion()
	return list(node)

/obj/machinery/atmospherics/pipe/cap/process()
	if(isnull(parent))
		..()
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/cap/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node)
		if(istype(node, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node = null

	update_icon()
	..()

/obj/machinery/atmospherics/pipe/cap/update_icon()
	overlays = list()

	icon_state = "cap[invisibility ? "-f" : ""]"
	return

/obj/machinery/atmospherics/pipe/cap/visible
	level = 2
	icon_state = "cap"

/obj/machinery/atmospherics/pipe/cap/hidden
	level = 1
	icon_state = "cap-f"