/obj/machinery/atmospherics/pipe/simple/heat_exchanging
	icon = 'icons/obj/pipes/heat.dmi'
	icon_state = "intact"
	level = 2
	var/initialize_directions_he

	minimum_temperature_difference = 20
	thermal_conductivity = OPEN_HEAT_TRANSFER_COEFFICIENT

	// Ported this for heat exchange reasons, see big comment below. -Frenjo
	var/surface = 2 //surface area in m^2
	var/icon_temperature = T20C //stop small changes in temperature causing an icon refresh

// BubbleWrap
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/New()
	..()
	initialize_directions_he = initialize_directions	// The auto-detection from /pipe is good enough for a simple HE pipe
// BubbleWrap END

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/initialize()
	// Ported this for heat exchange reasons, see big comment below. -Frenjo
	color = "#404040" //we don't make use of the fancy overlay system for colours, use this to set the default.

	normalize_dir()
	var/node1_dir
	var/node2_dir

	for(var/direction in cardinal)
		if(direction&initialize_directions_he)
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
	return


/obj/machinery/atmospherics/pipe/simple/heat_exchanging/process()
	if(!parent)
		..()
	else
		var/environment_temperature = 0
		if(istype(loc, /turf/simulated))
			if(loc:blocks_air)
				environment_temperature = loc:temperature
			else
				var/datum/gas_mixture/environment = loc.return_air()
				environment_temperature = environment.temperature

		// Ported this for heat exchange reasons, see big comment below. -Frenjo
		else if(istype(loc, /turf/space))
			parent.radiate_heat_to_space(surface, 1)

		else
			environment_temperature = loc:temperature
		var/datum/gas_mixture/pipe_air = return_air()
		if(abs(environment_temperature - pipe_air.temperature) > minimum_temperature_difference)
			parent.temperature_interact(loc, volume, thermal_conductivity)

		// Ported this more for debugging reasons than actual looks...
		// And no it's not bay's code that went wrong it's me adapting it to old atmos...
		// I hate this, save me, but see big comment below for more details.

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
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/New()
	..()
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

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/update_icon()
	if(node1&&node2)
		icon_state = "intact"
	else
		var/have_node1 = node1?1:0
		var/have_node2 = node2?1:0
		icon_state = "exposed[have_node1][have_node2]"
	if(!node1&&!node2)
		qdel(src)

/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/initialize()
	// Ported this for heat exchange reasons, see big comment below. -Frenjo
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
	return

// Added this because some idiot forgot to way back when. -Frenjo
/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction/process()
	..()

// Ported all stuff below from modern Baystation12 (27/11/2019)...
// Because I would never figure this out myself.
// (Yes this is the big comment I was talking about up there.) -Frenjo

//surface must be the surface area in m^2
/datum/pipeline/proc/radiate_heat_to_space(surface, thermal_conductivity)
	var/gas_density = air.total_moles/air.volume
	thermal_conductivity *= min(gas_density / (RADIATOR_OPTIMUM_PRESSURE / (R_IDEAL_GAS_EQUATION * GAS_CRITICAL_TEMPERATURE)), 1) //mult by density ratio

	var/heat_gain = get_thermal_radiation(air.temperature, surface, RADIATOR_EXPOSED_SURFACE_AREA_RATIO, thermal_conductivity)

	// This is so patchwork and will probably break. -Frenjo
	//var/heat_capacity = air.heat_capacity()
	//air.temperature -= heat_gain/heat_capacity
	// I should probably just port the add_thermal_energy function, but like...
	// If I touch ZAS code the entire game will explode. -Frenjo

	// Okay so I ported it and shit didn't blow up, that's nice, but old atmos code sucks.
	// We have to multiply the effect because of the way things scaled over the years.
	// 6.5 is halfway between 5 which was too little, and eight which was too much. -Frenjo
	air.add_thermal_energy(heat_gain * 6)
	// Turns out 6.5 was also too much, being able to run the SM on 32 shots with 1 N2 canister. -Frenjo

	if(network)
		network.update = 1

//Returns the amount of heat gained while in space due to thermal radiation (usually a negative value)
//surface - the surface area in m^2
//exposed_surface_ratio - the proportion of the surface that is exposed to sunlight
//thermal_conductivity - a multipler on the heat transfer rate. See OPEN_HEAT_TRANSFER_COEFFICIENT and friends
/proc/get_thermal_radiation(surface_temperature, surface, exposed_surface_ratio, thermal_conductivity)
	//*** Gain heat from sunlight, then lose heat from radiation.

	// We only get heat from the star on the exposed surface area.
	// If the HE pipes gain more energy from AVERAGE_SOLAR_RADIATION than they can radiate, then they have a net heat increase.
	. = AVERAGE_SOLAR_RADIATION * (exposed_surface_ratio * surface) * thermal_conductivity

	// Previously, the temperature would enter equilibrium at 26C or 294K.
	// Only would happen if both sides (all 2 square meters of surface area) were exposed to sunlight.  We now assume it aligned edge on.
	// It currently should stabilise at 129.6K or -143.6C
	. -= surface * STEFAN_BOLTZMANN_CONSTANT * thermal_conductivity * (surface_temperature - COSMIC_RADIATION_TEMPERATURE) ** 4

// heat2color functions. Adapted from: http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
/proc/heat2color(temp)
	return rgb(heat2color_r(temp), heat2color_g(temp), heat2color_b(temp))

/proc/heat2color_r(temp)
	temp /= 100
	if(temp <= 66)
		. = 255
	else
		. = max(0, min(255, 329.698727446 * (temp - 60) ** -0.1332047592))

/proc/heat2color_g(temp)
	temp /= 100
	if(temp <= 66)
		. = max(0, min(255, 99.4708025861 * log(temp) - 161.1195681661))
	else
		. = max(0, min(255, 288.1221695283 * ((temp - 60) ** -0.0755148492)))

/proc/heat2color_b(temp)
	temp /= 100
	if(temp >= 66)
		. = 255
	else
		if(temp <= 16)
			. = 0
		else
			. = max(0, min(255, 138.5177312231 * log(temp - 10) - 305.0447927307))