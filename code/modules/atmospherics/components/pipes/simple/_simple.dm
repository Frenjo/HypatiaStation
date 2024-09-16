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
	if(level == 1 && issimulated(loc))
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

		if(istype(loc, /turf/open/))
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
	make_smoke(1, FALSE, loc, 0)
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
			var/turf/T = GET_TURF(src)
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