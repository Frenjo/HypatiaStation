/obj/machinery/atmospherics/pipe
	force = 20

	layer = 2.4 //under wires with their 2.44
	use_power = 0

	var/datum/gas_mixture/air_temporary //used when reconstructing a pipeline that broke
	var/datum/pipeline/parent

	var/volume = 0

	var/alert_pressure = 80 * ONE_ATMOSPHERE
	//minimum pressure before check_pressure(...) should be called

/obj/machinery/atmospherics/pipe/Destroy()
	qdel(parent)
	if(isnotnull(air_temporary))
		loc.assume_air(air_temporary)
	return ..()

/obj/machinery/atmospherics/pipe/proc/pipeline_expansion()
	return null

/obj/machinery/atmospherics/pipe/proc/check_pressure(pressure)
	//Return 1 if parent should continue checking other pipes
	//Return null if parent should stop checking other pipes. Recall: src = null will by default return null
	return 1

/obj/machinery/atmospherics/pipe/return_air()
	if(isnull(parent))
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.air

/obj/machinery/atmospherics/pipe/build_network()
	if(isnull(parent))
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network()

/obj/machinery/atmospherics/pipe/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(isnull(parent))
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.network_expand(new_network, reference)

/obj/machinery/atmospherics/pipe/return_network(obj/machinery/atmospherics/reference)
	if(isnull(parent))
		parent = new /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network(reference)

/obj/machinery/atmospherics/pipe/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(src, /obj/machinery/atmospherics/pipe/tank))
		return ..()
	if(istype(src, /obj/machinery/atmospherics/pipe/vent))
		return ..()

	if(istype(W, /obj/item/device/pipe_painter))
		return 0

	if(!iswrench(W))
		return ..()
	var/turf/T = loc
	if(level == 1 && isturf(T) && T.intact)
		to_chat(user, SPAN_WARNING("You must remove the plating first."))
		return 1

	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if((int_air.return_pressure() - env_air.return_pressure()) > 2 * ONE_ATMOSPHERE)
		to_chat(user, SPAN_WARNING("You cannot unwrench [src], it is too exerted due to internal pressure."))
		add_fingerprint(user)
		return 1

	playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, SPAN_INFO("You begin to unfasten \the [src]..."))
	if(do_after(user, 40))
		user.visible_message(
			"[user] unfastens \the [src].",
			SPAN_INFO("You have unfastened \the [src]."),
			"You hear a ratchet."
		)
		new /obj/item/pipe(loc, make_from = src)
		for(var/obj/machinery/meter/meter in T)
			if(meter.target == src)
				new /obj/item/pipe_meter(T)
				qdel(meter)
		qdel(src)


/obj/machinery/atmospherics/pipe/simple
	icon = 'icons/obj/pipes/pipes.dmi'

	name = "pipe"
	desc = "A one meter section of regular pipe"

	volume = 70

	dir = SOUTH
	initialize_directions = SOUTH|NORTH

	alert_pressure = 55 * ONE_ATMOSPHERE

	level = 1

	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2

	var/minimum_temperature_difference = 300
	var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT No

	var/maximum_pressure = 70 * ONE_ATMOSPHERE
	var/fatigue_pressure = 55 * ONE_ATMOSPHERE

/obj/machinery/atmospherics/pipe/simple/New()
	. = ..()
	alpha = 255
	switch(dir)
		if(SOUTH, NORTH)
			initialize_directions = SOUTH|NORTH
		if(EAST, WEST)
			initialize_directions = EAST|WEST
		if(NORTHEAST)
			initialize_directions = NORTH|EAST
		if(NORTHWEST)
			initialize_directions = NORTH|WEST
		if(SOUTHEAST)
			initialize_directions = SOUTH|EAST
		if(SOUTHWEST)
			initialize_directions = SOUTH|WEST

/obj/machinery/atmospherics/pipe/simple/atmos_initialise()
	normalize_dir()
	var/node1_dir
	var/node2_dir

	for(var/direction in GLOBL.cardinal)
		if(direction & initialize_directions)
			if(!node1_dir)
				node1_dir = direction
			else if(!node2_dir)
				node2_dir = direction

	for(var/obj/machinery/atmospherics/target in get_step(src, node1_dir))
		if(target.initialize_directions & get_dir(target, src))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src, node2_dir))
		if(target.initialize_directions & get_dir(target, src))
			node2 = target
			break

	if(isnull(node1) && isnull(node2))
		qdel(src)
		return

	var/turf/T = loc			// hide if turf is not intact
	hide(T.intact)
	update_icon()

/obj/machinery/atmospherics/pipe/simple/Destroy()
	if(node1)
		node1.disconnect(src)
	if(node2)
		node2.disconnect(src)
	return ..()

/obj/machinery/atmospherics/pipe/simple/hide(i)
	if(level == 1 && istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

/obj/machinery/atmospherics/pipe/simple/process()
	if(isnull(parent)) //This should cut back on the overhead calling build_network thousands of times per cycle
		..()
	else
		. = PROCESS_KILL

	/*if(!node1)
		parent.mingle_with_turf(loc, volume)
		if(!nodealert)
			//to_world("Missing node from [src] at [src.x],[src.y],[src.z]")
			nodealert = 1

	else if(!node2)
		parent.mingle_with_turf(loc, volume)
		if(!nodealert)
			//to_world("Missing node from [src] at [src.x],[src.y],[src.z]")
			nodealert = 1
	else if (nodealert)
		nodealert = 0


	else if(parent)
		var/environment_temperature = 0

		if(istype(loc, /turf/simulated/))
			if(loc:blocks_air)
				environment_temperature = loc:temperature
			else
				var/datum/gas_mixture/environment = loc.return_air()
				environment_temperature = environment.temperature

		else
			environment_temperature = loc:temperature

		var/datum/gas_mixture/pipe_air = return_air()

		if(abs(environment_temperature-pipe_air.temperature) > minimum_temperature_difference)
			parent.temperature_interact(loc, volume, thermal_conductivity)
	*/  //Screw you heat lag

/obj/machinery/atmospherics/pipe/simple/check_pressure(pressure)
	var/datum/gas_mixture/environment = loc.return_air()

	var/pressure_difference = pressure - environment.return_pressure()

	if(pressure_difference > maximum_pressure)
		burst()

	else if(pressure_difference > fatigue_pressure)
		//TODO: leak to turf, doing pfshhhhh
		if(prob(5))
			burst()

	else return 1

/obj/machinery/atmospherics/pipe/simple/proc/burst()
	visible_message(SPAN_DANGER("[src] bursts!"));
	playsound(src, 'sound/effects/bang.ogg', 25, 1)
	var/datum/effect/system/smoke_spread/smoke = new /datum/effect/system/smoke_spread()
	smoke.set_up(1, 0, loc, 0)
	smoke.start()
	qdel(src)

/obj/machinery/atmospherics/pipe/simple/proc/normalize_dir()
	if(dir == 3)
		dir = 1
	else if(dir == 12)
		dir = 4

/obj/machinery/atmospherics/pipe/simple/pipeline_expansion()
	return list(node1, node2)

/obj/machinery/atmospherics/pipe/simple/update_icon()
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
	if(isnotnull(node1) && isnotnull(node2))
		icon_state = "intact[invisibility ? "-f" : "" ]"

		//var/node1_direction = get_dir(src, node1)
		//var/node2_direction = get_dir(src, node2)

		//dir = node1_direction|node2_direction
	else
		if(isnull(node1) && isnull(node2))
			var/turf/T = get_turf(src)
			new /obj/item/pipe(loc, make_from = src)
			for(var/obj/machinery/meter/meter in T)
				if(meter.target == src)
					new /obj/item/pipe_meter(T)
					qdel(meter)
			qdel(src)
		var/have_node1 = isnotnull(node1)
		var/have_node2 = isnotnull(node2)
		icon_state = "exposed[have_node1][have_node2][invisibility ? "-f" : "" ]"

/obj/machinery/atmospherics/pipe/simple/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 = null

	if(reference == node2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node2 = null

	update_icon()

	return null

 // Added names to unnamed pipes to avoid confusion. -Frenjo
/obj/machinery/atmospherics/pipe/simple/visible
	name = "grey pipe"
	level = 2
	icon_state = "intact"

/obj/machinery/atmospherics/pipe/simple/visible/scrubbers
	name = "scrubbers pipe"
	color = COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/supply
	name = "air supply pipe"
	color = COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/visible/yellow
	name = "yellow pipe"
	color = COLOR_YELLOW_PIPE

/obj/machinery/atmospherics/pipe/simple/visible/cyan
	name = "cyan pipe"
	color = COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/visible/green
	name = "green pipe"
	color = COLOR_GREEN

/obj/machinery/atmospherics/pipe/simple/visible/purple
	name = "purple pipe"
	color = COLOR_PURPLE_PIPE

/obj/machinery/atmospherics/pipe/simple/hidden
	name = "grey pipe"
	level = 1
	icon_state = "intact-f"
	alpha = 192		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/simple/hidden/scrubbers
	name = "scrubbers pipe"
	color = COLOR_RED

/obj/machinery/atmospherics/pipe/simple/hidden/supply
	name = "air supply pipe"
	color = COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/hidden/yellow
	name = "yellow pipe"
	color = COLOR_YELLOW_PIPE

/obj/machinery/atmospherics/pipe/simple/hidden/cyan
	name = "cyan pipe"
	color = COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/hidden/green
	name = "green pipe"
	color = COLOR_GREEN

/obj/machinery/atmospherics/pipe/simple/hidden/purple
	name = "purple pipe"
	color = COLOR_PURPLE_PIPE

/obj/machinery/atmospherics/pipe/simple/insulated
	name = "insulated pipe"
	icon = 'icons/obj/pipes/insulated.dmi'
	icon_state = "intact"

	minimum_temperature_difference = 10000
	thermal_conductivity = 0
	maximum_pressure = 1000 * ONE_ATMOSPHERE
	fatigue_pressure = 900 * ONE_ATMOSPHERE
	alert_pressure = 900 * ONE_ATMOSPHERE

	level = 2


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
	if(isnotnull(node1))
		node1.disconnect(src)
	if(isnotnull(node2))
		node2.disconnect(src)
	if(isnotnull(node3))
		node3.disconnect(src)
	return ..()

/obj/machinery/atmospherics/pipe/manifold/hide(i)
	if(level == 1 && istype(loc, /turf/simulated))
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
	if(isnotnull(node1))
		node1.disconnect(src)
	if(isnotnull(node2))
		node2.disconnect(src)
	if(isnotnull(node3))
		node3.disconnect(src)
	if(isnotnull(node4))
		node4.disconnect(src)
	return ..()

/obj/machinery/atmospherics/pipe/manifold4w/hide(i)
	if(level == 1 && istype(loc, /turf/simulated))
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
	if(level == 1 && istype(loc, /turf/simulated))
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