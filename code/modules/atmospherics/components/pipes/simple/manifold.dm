// Three-way.
/obj/machinery/atmospherics/pipe/manifold
	icon = 'icons/obj/pipes/manifold.dmi'

	name = "pipe manifold"
	desc = "A manifold composed of regular pipes"

	volume = 105

	dir = SOUTH
	initialize_directions = EAST|NORTH|WEST

	level = 1
	layer = 2.4 //under wires with their 2.44

	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2
	var/obj/machinery/atmospherics/node3

/obj/machinery/atmospherics/pipe/manifold/New()
	. = ..()
	alpha = 255
	switch(dir)
		if(NORTH)
			initialize_directions = EAST|SOUTH|WEST
		if(SOUTH)
			initialize_directions = WEST|NORTH|EAST
		if(EAST)
			initialize_directions = SOUTH|WEST|NORTH
		if(WEST)
			initialize_directions = NORTH|EAST|SOUTH

/obj/machinery/atmospherics/pipe/manifold/atmos_initialise()
	var/connect_directions = (NORTH|SOUTH|EAST|WEST) & (~dir)

	for(var/direction in GLOBL.cardinal)
		if(direction & connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src, direction))
				if(target.initialize_directions & get_dir(target, src))
					node1 = target
					connect_directions &= ~direction
					break
			if(node1)
				break

	for(var/direction in GLOBL.cardinal)
		if(direction & connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src, direction))
				if(target.initialize_directions & get_dir(target, src))
					node2 = target
					connect_directions &= ~direction
					break
			if(node2)
				break

	for(var/direction in GLOBL.cardinal)
		if(direction & connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src, direction))
				if(target.initialize_directions & get_dir(target, src))
					node3 = target
					connect_directions &= ~direction
					break
			if(node3)
				break

	var/turf/T = loc			// hide if turf is not intact
	hide(T.intact)
	update_icon()

/obj/machinery/atmospherics/pipe/manifold/Destroy()
	node1?.disconnect(src)
	node1 = null
	node2?.disconnect(src)
	node2 = null
	node3?.disconnect(src)
	node3 = null
	return ..()

/obj/machinery/atmospherics/pipe/manifold/hide(i)
	if(level == 1 && isopenturf(loc))
		invisibility = i ? 101 : 0
	update_icon()

/obj/machinery/atmospherics/pipe/manifold/pipeline_expansion()
	return list(node1, node2, node3)

/obj/machinery/atmospherics/pipe/manifold/process()
	if(isnull(parent))
		..()
	else
		. = PROCESS_KILL
/*
	if(!node1)
		parent.mingle_with_turf(loc, 70)
		if(!nodealert)
			//to_world("Missing node from [src] at [src.x],[src.y],[src.z]")
			nodealert = 1
	else if(!node2)
		parent.mingle_with_turf(loc, 70)
		if(!nodealert)
			//to_world("Missing node from [src] at [src.x],[src.y],[src.z]")
			nodealert = 1
	else if(!node3)
		parent.mingle_with_turf(loc, 70)
		if(!nodealert)
			//to_world("Missing node from [src] at [src.x],[src.y],[src.z]")
			nodealert = 1
	else if (nodealert)
		nodealert = 0
*/

/obj/machinery/atmospherics/pipe/manifold/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 = null

	if(reference == node2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node2 = null

	if(reference == node3)
		if(istype(node3, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node3 = null

	update_icon()
	..()

/obj/machinery/atmospherics/pipe/manifold/update_icon()
	if(isnotnull(node1) && isnotnull(node2) && isnotnull(node3))
		switch(pipe_color)
			if("red")
				color = COLOR_RED
			if("blue")
				color = COLOR_BLUE
			if("cyan")
				color = COLOR_CYAN
			if("green")
				color = COLOR_GREEN
			if("yellow")
				color = COLOR_YELLOW_PIPE
			if("purple")
				color = COLOR_PURPLE_PIPE
			if("grey")
				color = null
		icon_state = "manifold[invisibility ? "-f" : "" ]"
	else
		var/connected = 0
		var/unconnected = 0
		var/connect_directions = (NORTH|SOUTH|EAST|WEST) & (~dir)

		if(isnotnull(node1))
			connected |= get_dir(src, node1)
		if(isnotnull(node2))
			connected |= get_dir(src, node2)
		if(isnotnull(node3))
			connected |= get_dir(src, node3)

		unconnected = (~connected) & (connect_directions)

		icon_state = "manifold_[connected]_[unconnected]"

		if(!connected)
			src = null

// Added names to unnamed pipes to avoid confusion. -Frenjo
/obj/machinery/atmospherics/pipe/manifold/visible
	name = "grey pipe manifold"
	level = 2
	icon_state = "manifold"

/obj/machinery/atmospherics/pipe/manifold/visible/supply
	name = "air supply pipe manifold"
	color = COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/visible/scrubbers
	name = "scrubbers pipe manifold"
	color = COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/visible/yellow
	name = "yellow pipe manifold"
	color = COLOR_YELLOW_PIPE

/obj/machinery/atmospherics/pipe/manifold/visible/cyan
	name = "cyan pipe manifold"
	color = COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/visible/green
	name = "green pipe manifold"
	color = COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold/visible/purple
	name = "purple pipe manifold"
	color = COLOR_PURPLE_PIPE

/obj/machinery/atmospherics/pipe/manifold/hidden
	name = "grey pipe manifold"
	level = 1
	icon_state = "manifold-f"
	alpha = 192		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/manifold/hidden/supply
	name = "air supply pipe manifold"
	color = COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers
	name = "scrubbers pipe manifold"
	color = COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/hidden/yellow
	name = "yellow pipe manifold"
	color = COLOR_YELLOW_PIPE

/obj/machinery/atmospherics/pipe/manifold/hidden/cyan
	name = "cyan pipe manifold"
	color = COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/hidden/green
	name = "green pipe manifold"
	color = COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold/hidden/purple
	name = "purple pipe manifold"
	color = COLOR_PURPLE_PIPE

/obj/machinery/atmospherics/pipe/manifold/insulated
	name = "insulated pipe manifold"
	icon = 'icons/obj/pipes/insulated.dmi'
	icon_state = "manifold"

	//minimum_temperature_difference = 10000
	//thermal_conductivity = 0
	//maximum_pressure = 1000*ONE_ATMOSPHERE
	//fatigue_pressure = 900*ONE_ATMOSPHERE
	//alert_pressure = 900*ONE_ATMOSPHERE

	level = 2

// Four-way.
/obj/machinery/atmospherics/pipe/manifold4w
	icon = 'icons/obj/pipes/manifold.dmi'

	name = "4-way pipe manifold"
	desc = "A manifold composed of regular pipes"

	volume = 140

	dir = SOUTH
	initialize_directions = NORTH | SOUTH | EAST | WEST

	level = 1
	layer = 2.4 //under wires with their 2.44

	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2
	var/obj/machinery/atmospherics/node3
	var/obj/machinery/atmospherics/node4

/obj/machinery/atmospherics/pipe/manifold4w/New()
	. = ..()
	alpha = 255

/obj/machinery/atmospherics/pipe/manifold4w/atmos_initialise()
	for(var/obj/machinery/atmospherics/target in get_step(src, 1))
		if(target.initialize_directions & 2)
			node1 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src, 2))
		if(target.initialize_directions & 1)
			node2 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src, 4))
		if(target.initialize_directions & 8)
			node3 = target
			break

	for(var/obj/machinery/atmospherics/target in get_step(src, 8))
		if(target.initialize_directions & 4)
			node4 = target
			break

	var/turf/T = loc			// hide if turf is not intact
	hide(T.intact)
	update_icon()

/obj/machinery/atmospherics/pipe/manifold4w/Destroy()
	node1?.disconnect(src)
	node1 = null
	node2?.disconnect(src)
	node2 = null
	node3?.disconnect(src)
	node3 = null
	node4?.disconnect(src)
	node4 = null
	return ..()

/obj/machinery/atmospherics/pipe/manifold4w/hide(i)
	if(level == 1 && isopenturf(loc))
		invisibility = i ? 101 : 0
	update_icon()

/obj/machinery/atmospherics/pipe/manifold4w/pipeline_expansion()
	return list(node1, node2, node3, node4)

/obj/machinery/atmospherics/pipe/manifold4w/process()
	if(isnull(parent))
		..()
	else
		. = PROCESS_KILL
/*
	if(!node1)
		parent.mingle_with_turf(loc, 70)
		if(!nodealert)
			//to_world("Missing node from [src] at [src.x],[src.y],[src.z]")
			nodealert = 1
	else if(!node2)
		parent.mingle_with_turf(loc, 70)
		if(!nodealert)
			//to_world("Missing node from [src] at [src.x],[src.y],[src.z]")
			nodealert = 1
	else if(!node3)
		parent.mingle_with_turf(loc, 70)
		if(!nodealert)
			//to_world("Missing node from [src] at [src.x],[src.y],[src.z]")
			nodealert = 1
	else if (nodealert)
		nodealert = 0
*/

/obj/machinery/atmospherics/pipe/manifold4w/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 = null

	if(reference == node2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node2 = null

	if(reference == node3)
		if(istype(node3, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node3 = null

	if(reference == node4)
		if(istype(node4, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node4 = null

	update_icon()
	..()

/obj/machinery/atmospherics/pipe/manifold4w/update_icon()
	overlays.Cut()
	if(isnotnull(node1) && isnotnull(node2) && isnotnull(node3) && isnotnull(node4))
		switch(pipe_color)
			if("red")
				color = COLOR_RED
			if("blue")
				color = COLOR_BLUE
			if("cyan")
				color = COLOR_CYAN
			if("green")
				color = COLOR_GREEN
			if("yellow")
				color = COLOR_YELLOW_PIPE
			if("purple")
				color = COLOR_PURPLE_PIPE
			if("grey")
				color = null
		icon_state = "manifold4w[invisibility ? "-f" : "" ]"

	else
		icon_state = "manifold4w_ex"
		var/icon/con = new /icon('icons/obj/pipes/manifold.dmi',"manifold4w_con") //Since 4-ways are supposed to be directionless, they need an overlay instead it seems.

		if(isnotnull(node1))
			overlays.Add(new /image(con, dir = 1))
		if(isnotnull(node2))
			overlays.Add(new /image(con, dir = 2))
		if(isnotnull(node3))
			overlays.Add(new /image(con, dir = 4))
		if(isnotnull(node4))
			overlays.Add(new /image(con, dir = 8))

		if(isnull(node1) && isnull(node2) && isnull(node3) && isnull(node4))
			src = null
	return

// Added names to unnamed pipes to avoid confusion. -Frenjo
/obj/machinery/atmospherics/pipe/manifold4w/visible
	name = "grey 4-way pipe manifold"
	level = 2
	icon_state = "manifold4w"

/obj/machinery/atmospherics/pipe/manifold4w/visible/supply
	name = "air supply 4-way pipe manifold"
	color = COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/visible/scrubbers
	name = "scrubbers 4-way pipe manifold"
	color = COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/visible/yellow
	name = "yellow 4-way pipe manifold"
	color = COLOR_YELLOW_PIPE

/obj/machinery/atmospherics/pipe/manifold4w/visible/cyan
	name = "cyan 4-way pipe manifold"
	color = COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold4w/visible/green
	name = "green 4-way pipe manifold"
	color = COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold4w/visible/purple
	name = "purple 4-way pipe manifold"
	color = COLOR_PURPLE_PIPE

/obj/machinery/atmospherics/pipe/manifold4w/hidden
	name = "grey 4-way pipe manifold"
	level = 1
	icon_state = "manifold4w-f"
	alpha = 192		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/manifold4w/hidden/supply
	name = "air supply 4-way pipe manifold"
	color = COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers
	name = "scrubbers 4-way pipe manifold"
	color = COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/hidden/yellow
	name = "yellow 4-way pipe manifold"
	color = COLOR_YELLOW_PIPE

/obj/machinery/atmospherics/pipe/manifold4w/hidden/cyan
	name = "cyan 4-way pipe manifold"
	color = COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold4w/hidden/green
	name = "green 4-way pipe manifold"
	color = COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold4w/hidden/purple
	name = "purple 4-way pipe manifold"
	color = COLOR_PURPLE_PIPE

/obj/machinery/atmospherics/pipe/manifold4w/insulated
	name = "insulated 4-way pipe manifold"
	icon = 'icons/obj/pipes/insulated.dmi'
	icon_state = "manifold4w"

	//minimum_temperature_difference = 10000
	//thermal_conductivity = 0
	//maximum_pressure = 1000*ONE_ATMOSPHERE
	//fatigue_pressure = 900*ONE_ATMOSPHERE
	//alert_pressure = 900*ONE_ATMOSPHERE

	level = 2