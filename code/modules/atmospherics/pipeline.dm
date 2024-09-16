/datum/pipeline
	var/datum/gas_mixture/air

	var/list/obj/machinery/atmospherics/pipe/members
	var/list/obj/machinery/atmospherics/pipe/edges //Used for building networks

	var/datum/pipe_network/network

	var/alert_pressure = 0

/datum/pipeline/Destroy()
	if(isnotnull(network))
		qdel(network)

	if(air?.volume)
		temporarily_store_air()
		qdel(air)

	return ..()

/datum/pipeline/proc/process()//This use to be called called from the pipe networks
	//Check to see if pressure is within acceptable limits
	var/pressure = air.return_pressure()
	if(pressure > alert_pressure)
		for(var/obj/machinery/atmospherics/pipe/member in members)
			if(!member.check_pressure(pressure))
				break //Only delete 1 pipe per process

	//Allow for reactions
	//air.react() //Should be handled by pipe_network now

/datum/pipeline/proc/temporarily_store_air()
	//Update individual gas_mixtures by volume ratio
	for(var/obj/machinery/atmospherics/pipe/member in members)
		member.air_temporary = new /datum/gas_mixture()
		member.air_temporary.copy_from(air)
		member.air_temporary.volume = member.volume
		member.air_temporary.multiply(member.volume / air.volume)

/datum/pipeline/proc/build_pipeline(obj/machinery/atmospherics/pipe/base)
	var/list/obj/machinery/atmospherics/pipe/possible_expansions = list(base)
	members = list(base)
	edges = list()

	var/volume = base.volume
	base.parent = src
	alert_pressure = base.alert_pressure

	if(isnotnull(base.air_temporary))
		air = base.air_temporary
		base.air_temporary = null
	else
		air = new /datum/gas_mixture()

	while(length(possible_expansions))
		for_no_type_check(var/obj/machinery/atmospherics/pipe/borderline, possible_expansions)
			var/list/result = borderline.pipeline_expansion()
			var/edge_check = length(result)

			if(edge_check)
				for(var/obj/machinery/atmospherics/pipe/item in result)
					if(!members.Find(item))
						members.Add(item)
						possible_expansions.Add(item)

						volume += item.volume
						item.parent = src

						alert_pressure = min(alert_pressure, item.alert_pressure)

						if(isnotnull(item.air_temporary))
							air.merge(item.air_temporary)

					edge_check--

			if(edge_check > 0)
				edges.Add(borderline)

			possible_expansions.Remove(borderline)

	air.volume = volume

/datum/pipeline/proc/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(new_network.line_members.Find(src))
		return 0

	new_network.line_members.Add(src)

	network = new_network

	for_no_type_check(var/obj/machinery/atmospherics/pipe/edge, edges)
		for(var/obj/machinery/atmospherics/result in edge.pipeline_expansion()) // This can't be converted to for_no_type_check() since there are nulls involved.
			if(!istype(result, /obj/machinery/atmospherics/pipe) && result != reference)
				result.network_expand(new_network, edge)

	return 1

/datum/pipeline/proc/return_network(obj/machinery/atmospherics/reference)
	if(isnull(network))
		network = new /datum/pipe_network()
		network.build_network(src, null)
			//technically passing these parameters should not be allowed
			//however pipe_network.build_network(..) and pipeline.network_extend(...)
			//		were setup to properly handle this case
	return network

/datum/pipeline/proc/mingle_with_turf(turf/open/target, mingle_volume)
	var/datum/gas_mixture/air_sample = air.remove_ratio(mingle_volume / air.volume)
	air_sample.volume = mingle_volume

	if(isnotnull(target?.zone))
		//Have to consider preservation of group statuses
		var/datum/gas_mixture/turf_copy = new /datum/gas_mixture()

		turf_copy.copy_from(target.zone.air)
		turf_copy.volume = target.zone.air.volume //Copy a good representation of the turf from parent group

		equalize_gases(list(air_sample, turf_copy))
		air.merge(air_sample)

		turf_copy.subtract(target.zone.air)

		target.zone.air.merge(turf_copy)

	else
		var/datum/gas_mixture/turf_air = target.return_air()

		equalize_gases(list(air_sample, turf_air))
		air.merge(air_sample)
		//turf_air already modified by equalize_gases()

	if(isnotnull(network))
		network.update = TRUE

/datum/pipeline/proc/temperature_interact(turf/target, share_volume, thermal_conductivity)
	var/total_heat_capacity = air.heat_capacity()
	var/partial_heat_capacity = total_heat_capacity * (share_volume / air.volume)

	if(issimulated(target))
		var/turf/open/modeled_location = target

		if(HAS_TURF_FLAGS(modeled_location, TURF_FLAG_BLOCKS_AIR))
			if(modeled_location.heat_capacity > 0 && partial_heat_capacity > 0)
				var/delta_temperature = air.temperature - modeled_location.temperature

				var/heat = thermal_conductivity * delta_temperature * \
					(partial_heat_capacity * modeled_location.heat_capacity / (partial_heat_capacity + modeled_location.heat_capacity))

				air.temperature -= heat / total_heat_capacity
				modeled_location.temperature += heat / modeled_location.heat_capacity

		else
			var/delta_temperature = 0
			var/sharer_heat_capacity = 0

			if(isnotnull(modeled_location.zone))
				delta_temperature = (air.temperature - modeled_location.zone.air.temperature)
				sharer_heat_capacity = modeled_location.zone.air.heat_capacity()
			else
				delta_temperature = (air.temperature - modeled_location.air.temperature)
				sharer_heat_capacity = modeled_location.air.heat_capacity()

			var/self_temperature_delta = 0
			var/sharer_temperature_delta = 0

			if(sharer_heat_capacity > 0 && partial_heat_capacity > 0)
				var/heat = thermal_conductivity * delta_temperature * \
					(partial_heat_capacity * sharer_heat_capacity / (partial_heat_capacity + sharer_heat_capacity))

				self_temperature_delta = -heat/total_heat_capacity
				sharer_temperature_delta = heat/sharer_heat_capacity
			else
				return 1

			air.temperature += self_temperature_delta

			if(isnotnull(modeled_location.zone))
				modeled_location.zone.air.temperature += sharer_temperature_delta / modeled_location.zone.air.group_multiplier
			else
				modeled_location.air.temperature += sharer_temperature_delta

	else
		if(target.heat_capacity > 0 && partial_heat_capacity > 0)
			var/delta_temperature = air.temperature - target.temperature

			var/heat = thermal_conductivity * delta_temperature * \
				(partial_heat_capacity * target.heat_capacity / (partial_heat_capacity + target.heat_capacity))

			air.temperature -= heat / total_heat_capacity
	if(isnotnull(network))
		network.update = TRUE

// Ported from Baystation12 on 27/11/2019. -Frenjo
//surface must be the surface area in m^2
/datum/pipeline/proc/radiate_heat_to_space(surface, thermal_conductivity)
	var/gas_density = air.total_moles / air.volume
	thermal_conductivity *= min(gas_density / (RADIATOR_OPTIMUM_PRESSURE / (R_IDEAL_GAS_EQUATION * GAS_CRITICAL_TEMPERATURE)), 1) //mult by density ratio

	var/heat_gain = get_thermal_radiation(air.temperature, surface, RADIATOR_EXPOSED_SURFACE_AREA_RATIO, thermal_conductivity)

	air.add_thermal_energy(heat_gain)

	if(isnotnull(network))
		network.update = TRUE