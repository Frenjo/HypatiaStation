// Heat exchange pipes, radiation to space functionality was ported from Baystation12 on 27/11/2019. -Frenjo
/obj/machinery/atmospherics/pipe/simple/heat_exchanging
	icon = 'icons/obj/pipes/heat.dmi'
	icon_state = "intact"
	level = 2

	minimum_temperature_difference = 20
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT

	var/initialize_directions_he

	var/surface = 2 //surface area in m^2
	var/icon_temperature = T20C //stop small changes in temperature causing an icon refresh

// BubbleWrap
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/initialise()
	. = ..()
	initialize_directions_he = initialize_directions	// The auto-detection from /pipe is good enough for a simple HE pipe
// BubbleWrap END

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/atmos_initialise()
	color = "#404040" //we don't make use of the fancy overlay system for colours, use this to set the default.
	normalize_dir()

	var/node1_dir
	var/node2_dir
	for(var/direction in GLOBL.cardinal)
		if(direction & initialize_directions_he)
			if(!node1_dir)
				node1_dir = direction
			else if(!node2_dir)
				node2_dir = direction

	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src, node1_dir))
		if(target.initialize_directions_he & get_dir(target, src))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src, node2_dir))
		if(target.initialize_directions_he & get_dir(target, src))
			node2 = target
			break
	update_icon()

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/process()
	if(!parent)
		..()
	else
		var/environment_temperature = 0
		if(isopenturf(loc))
			var/turf/open/T = loc
			if(HAS_TURF_FLAGS(T, TURF_FLAG_BLOCKS_AIR))
				environment_temperature = T.temperature
			else
				var/datum/gas_mixture/environment = loc.return_air()
				environment_temperature = environment.temperature

		else if(isspace(loc))
			parent.radiate_heat_to_space(surface, 1)

		else
			environment_temperature = loc:temperature
		var/datum/gas_mixture/pipe_air = return_air()
		if(abs(environment_temperature - pipe_air.temperature) > minimum_temperature_difference)
			parent.temperature_interact(loc, volume, thermal_conductivity)

		//fancy radiation glowing
		if(pipe_air.temperature && (icon_temperature > 500 || pipe_air.temperature > 500)) //start glowing at 500K
			if(abs(pipe_air.temperature - icon_temperature) > 10)
				icon_temperature = pipe_air.temperature

				var/h_r = heat2color_r(icon_temperature)
				var/h_g = heat2color_g(icon_temperature)
				var/h_b = heat2color_b(icon_temperature)

				if(icon_temperature < 2000) //scale up overlay until 2000K
					var/scale = (icon_temperature - 500) / 1500
					h_r = 64 + (h_r - 64)*scale
					h_g = 64 + (h_g - 64)*scale
					h_b = 64 + (h_b - 64)*scale

				animate(src, color = rgb(h_r, h_g, h_b), time = 20, easing = SINE_EASING)


/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction
	icon = 'icons/obj/pipes/junction.dmi'
	icon_state = "intact"
	level = 2
	minimum_temperature_difference = 300
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

// BubbleWrap
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/initialise()
	. = ..()
	switch(dir)
		if(SOUTH)
			initialize_directions = NORTH
			initialize_directions_he = SOUTH
		if(NORTH)
			initialize_directions = SOUTH
			initialize_directions_he = NORTH
		if(EAST)
			initialize_directions = WEST
			initialize_directions_he = EAST
		if(WEST)
			initialize_directions = EAST
			initialize_directions_he = WEST
// BubbleWrap END

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/atmos_initialise()
	color = "#404040" //we don't make use of the fancy overlay system for colours, use this to set the default.

	for(var/obj/machinery/atmospherics/target in get_step(src, initialize_directions))
		if(target.initialize_directions & get_dir(target, src))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src, initialize_directions_he))
		if(target.initialize_directions_he & get_dir(target, src))
			node2 = target
			break

	update_icon()

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/process()
	..()

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/update_icon()
	if(isnotnull(node1) && isnotnull(node2))
		icon_state = "intact"
	else
		var/have_node1 = isnotnull(node1)
		var/have_node2 = isnotnull(node2)
		icon_state = "exposed[have_node1][have_node2]"

	if(isnull(node1) && isnull(node2))
		qdel(src)