/datum/gas_mixture
	// Associative list of gas moles.
	// Gases with 0 moles are not tracked and are pruned by update_values()
	var/list/gas
	// Temperature in Kelvin of this gas mix.
	var/temperature = 0

	// Sum of all the gas moles in this mix.  Updated by update_values()
	var/total_moles = 0
	// Volume of this mix.
	var/volume = CELL_VOLUME
	// Size of the group this gas_mixture is representing.  1 for singletons.
	var/group_multiplier = 1

	// List of active tile overlays for this gas_mixture.  Updated by check_tile_graphic()
	var/list/graphic

/datum/gas_mixture/New(vol = CELL_VOLUME)
	gas = list()
	graphic = list()
	. = ..()
	volume = vol

/*
 * adjust_gas()
 *
 * Takes a gas string, and the amount of moles to adjust by.
 * Calls update_values() if update is TRUE.
 */
/datum/gas_mixture/proc/adjust_gas(gasid, moles, update = TRUE)
	if(moles == 0)
		return

	gas[gasid] += moles

	if(update)
		update_values()

/*
 * adjust_gas_temp()
 *
 * Same as adjust_gas(), but takes a temperature which is mixed in with the gas.
 */
/datum/gas_mixture/proc/adjust_gas_temp(gasid, moles, temp, update = TRUE)
	if(moles == 0)
		return

	if(abs(temperature - temp) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity() * group_multiplier
		var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
		var/giver_heat_capacity = gas_data.specific_heat[gasid] * moles
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (temp * giver_heat_capacity + temperature * self_heat_capacity) / combined_heat_capacity

	gas[gasid] += moles

	if(update)
		update_values()

/*
 * adjust_multi()
 *
 * Variadic version of adjust_gas().
 * Takes any number of gas and mole pairs, and applies them.
 */
/datum/gas_mixture/proc/adjust_multi()
	ASSERT(!(length(args) % 2))

	for(var/i = 1; i < length(args); i += 2)
		adjust_gas(args[i], args[i + 1], update = FALSE)

	update_values()

/*
 * adjust_multi_temp()
 *
 * Variadic version of adjust_gas_temp().
 * Takes any number of gas, mole, and temperature tuples, and applies them.
 */
/datum/gas_mixture/proc/adjust_multi_temp()
	ASSERT(!(length(args) % 3))

	for(var/i = 1; i < length(args); i += 3)
		adjust_gas_temp(args[i], args[i + 1], args[i + 2], update = FALSE)

	update_values()

/*
 * merge()
 *
 * Merges all the gas from another mixture into this one.
 * Respects group_multipliers and adjusts temperature correctly.
 * Does not modify giver in any way.
 */
/datum/gas_mixture/proc/merge(const/datum/gas_mixture/giver)
	if(isnull(giver))
		return

	if(abs(temperature - giver.temperature) > MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER)
		var/self_heat_capacity = heat_capacity() * group_multiplier
		var/giver_heat_capacity = giver.heat_capacity() * giver.group_multiplier
		var/combined_heat_capacity = giver_heat_capacity + self_heat_capacity
		if(combined_heat_capacity != 0)
			temperature = (giver.temperature * giver_heat_capacity + temperature * self_heat_capacity) / combined_heat_capacity

	if(group_multiplier != 1 || giver.group_multiplier != 1)
		for(var/g in giver.gas)
			gas[g] += giver.gas[g] * giver.group_multiplier / group_multiplier
	else
		for(var/g in giver.gas)
			gas[g] += giver.gas[g]

	update_values()

/datum/gas_mixture/proc/equalize(datum/gas_mixture/sharer)
	. = TRUE
	for(var/g in sharer.gas)
		var/comb = gas[g] + sharer.gas[g]
		comb /= volume + sharer.volume
		gas[g] = comb * volume
		sharer.gas[g] = comb * sharer.volume

	var/our_heatcap = heat_capacity()
	var/share_heatcap = sharer.heat_capacity()

	temperature = 0
	if(our_heatcap + share_heatcap)
		temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
	sharer.temperature = temperature

// Returns the heat capacity of the gas mix based on the specific heat of the contained gases.
/datum/gas_mixture/proc/heat_capacity()
	. = 0
	var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
	for(var/g in gas)
		. += gas_data.specific_heat[g] * gas[g]

// Updates the total_moles count and trims any empty gases.
/datum/gas_mixture/proc/update_values()
	total_moles = 0
	for(var/g in gas)
		if(gas[g] <= 0)
			gas.Remove(g)
		else
			total_moles += gas[g]

/*
 * return_pressure()
 *
 * Returns the pressure of the gas mix.
 * Only accurate if there have been no gas modifications since update_values() has been called.
 */
/datum/gas_mixture/proc/return_pressure()
	if(volume)
		return total_moles * R_IDEAL_GAS_EQUATION * temperature / volume
	return 0

// Removes moles from the gas mix and returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/remove(amount)
	RETURN_TYPE(/datum/gas_mixture)

	var/sum = total_moles
	amount = min(amount, sum) // Cannot take more air than tile has!
	if(amount <= 0)
		return null

	var/datum/gas_mixture/removed = new /datum/gas_mixture()
	for(var/g in gas)
		removed.gas[g] = QUANTIZE((gas[g] / sum) * amount)
		gas[g] -= removed.gas[g] / group_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed

// Removes a ratio of gas from the mixture and returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/remove_ratio(ratio, out_group_multiplier = 1)
	RETURN_TYPE(/datum/gas_mixture)

	if(ratio <= 0)
		return null
	out_group_multiplier = max(1, min(group_multiplier, out_group_multiplier))

	ratio = min(ratio, 1)

	var/datum/gas_mixture/removed = new /datum/gas_mixture()
	removed.group_multiplier = out_group_multiplier

	for(var/g in gas)
		removed.gas[g] = QUANTIZE(gas[g] * ratio)
		gas[g] = ((gas[g] * group_multiplier) - (removed.gas[g] * out_group_multiplier)) / group_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed

/*
 * remove_by_flag()
 *
 * Removes moles from the gas mixture, limited by the given XGM_GAS_* flag.
 * Returns a gas_mixture containing the removed air.
 */
/datum/gas_mixture/proc/remove_by_flag(flag, amount)
	RETURN_TYPE(/datum/gas_mixture)

	if(!flag || amount <= 0)
		return

	var/sum = 0
	var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
	for(var/g in gas)
		if(gas_data.flags[g] & flag)
			sum += gas[g]

	var/datum/gas_mixture/removed = new /datum/gas_mixture()

	for(var/g in gas)
		if(gas_data.flags[g] & flag)
			removed.gas[g] = QUANTIZE((gas[g] / sum) * amount)
			gas[g] -= removed.gas[g] / group_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed

// Copies gas and temperature from another gas_mixture.
/datum/gas_mixture/proc/copy_from(const/datum/gas_mixture/sample)
	if(isnull(sample))
		return

	gas = sample.gas.Copy()
	temperature = sample.temperature

	update_values()

// Checks if we are within acceptable range of another gas_mixture to suspend processing.
/datum/gas_mixture/proc/compare(datum/gas_mixture/sample)
	if(isnull(sample))
		return FALSE

	var/list/marked = list()
	for(var/g in gas)
		if((abs(gas[g] - sample.gas[g]) > MINIMUM_AIR_TO_SUSPEND) && \
		((gas[g] < (1 - MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[g]) || \
		(gas[g] > (1 + MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[g])))
			return FALSE
		marked[g] = TRUE

	for(var/g in sample.gas)
		if(!marked[g])
			if((abs(gas[g] - sample.gas[g]) > MINIMUM_AIR_TO_SUSPEND) && \
			((gas[g] < (1 - MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[g]) || \
			(gas[g] > (1 + MINIMUM_AIR_RATIO_TO_SUSPEND) * sample.gas[g])))
				return FALSE

	if(total_moles > MINIMUM_AIR_TO_SUSPEND)
		if((abs(temperature - sample.temperature) > MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND) && \
		((temperature < (1 - MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND) * sample.temperature) || \
		(temperature > (1 + MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND) * sample.temperature)))
			return FALSE

	return TRUE

/datum/gas_mixture/proc/react(atom/dump_location)
	zburn(null)

// Rechecks the gas_mixture and adjusts the graphic list if needed.
/datum/gas_mixture/proc/check_tile_graphic()
	var/list/graphic_add = null // List of new overlays that weren't valid before.
	var/list/graphic_remove = null // List of overlays that need to be removed now that they're not valid.

	var/decl/xgm_gas_data/gas_data = GET_DECL_INSTANCE(/decl/xgm_gas_data)
	for(var/g in gas_data.overlay_limit)
		if(graphic.Find(gas_data.tile_overlay[g]))
			// Overlay is already applied for this gas, check if it's still valid.
			if(gas[g] <= gas_data.overlay_limit[g])
				LAZYADD(graphic_remove, gas_data.tile_overlay[g])
		else
			// Overlay isn't applied for this gas, check if it's valid and needs to be added.
			if(gas[g] > gas_data.overlay_limit[g])
				LAZYADD(graphic_add, gas_data.tile_overlay[g])

	. = FALSE
	// Applies changes.
	if(length(graphic_add))
		graphic.Add(graphic_add)
		. = TRUE
	if(length(graphic_remove))
		graphic.Remove(graphic_remove)
		. = TRUE

// Simpler version of merge(), adjusts gas amounts directly and doesn't account for temperature or group_multiplier.
/datum/gas_mixture/proc/add(datum/gas_mixture/right_side)
	for(var/g in right_side.gas)
		gas[g] += right_side.gas[g]

	update_values()

// Simpler version of remove(), adjusts gas amounts directly and doesn't account for group_multiplier.
/datum/gas_mixture/proc/subtract(datum/gas_mixture/right_side)
	for(var/g in right_side.gas)
		gas[g] -= right_side.gas[g]

	update_values()

// Multiplies all gas amounts by a factor.
/datum/gas_mixture/proc/multiply(factor)
	for(var/g in gas)
		gas[g] *= factor

	update_values()

// Divides all gas amounts by a factor.
/datum/gas_mixture/proc/divide(factor)
	for(var/g in gas)
		gas[g] /= factor

	update_values()

// Shares gas with another gas_mixture based on the amount of connecting tiles and a fixed lookup table.
/datum/gas_mixture/proc/share_ratio(datum/gas_mixture/other, connecting_tiles, share_size = null, one_way = 0)
	var/static/list/sharing_lookup_table = list(0.30, 0.40, 0.48, 0.54, 0.60, 0.66)
	// Shares a specific ratio of gas between mixtures using simple weighted averages.
	var/ratio = sharing_lookup_table[6]

	var/size = max(1, group_multiplier)
	if(isnull(share_size))
		share_size = max(1, other.group_multiplier)

	var/full_heat_capacity = heat_capacity() * size

	var/s_full_heat_capacity = other.heat_capacity() * share_size

	var/list/avg_gas = list()

	for(var/g in gas)
		avg_gas[g] += gas[g] * size

	for(var/g in other.gas)
		avg_gas[g] += other.gas[g] * share_size

	for(var/g in avg_gas)
		avg_gas[g] /= (size + share_size)

	var/temp_avg = 0
	if(full_heat_capacity + s_full_heat_capacity)
		temp_avg = (temperature * full_heat_capacity + other.temperature * s_full_heat_capacity) / (full_heat_capacity + s_full_heat_capacity)

	// WOOT WOOT TOUCH THIS AT YOUR OWN RISK.
	if(length(sharing_lookup_table) >= connecting_tiles) // 6 or more interconnecting tiles will max at 42% of air moved per tick.
		ratio = sharing_lookup_table[connecting_tiles]
	// WOOT WOOT TOUCH THIS AT YOUR OWN RISK.

	for(var/g in avg_gas)
		gas[g] = max(0, (gas[g] - avg_gas[g]) * (1 - ratio) + avg_gas[g])
		if(!one_way)
			other.gas[g] = max(0, (other.gas[g] - avg_gas[g]) * (1 - ratio) + avg_gas[g])

	temperature = max(0, (temperature - temp_avg) * (1-ratio) + temp_avg)
	if(!one_way)
		other.temperature = max(0, (other.temperature - temp_avg) * (1-ratio) + temp_avg)

	update_values()
	other.update_values()

	return compare(other)

// A wrapper around share_ratio for spacing gas at the same rate as if it were going into a large airless room.
/datum/gas_mixture/proc/share_space(datum/gas_mixture/unsim_air)
	return share_ratio(unsim_air, unsim_air.group_multiplier, max(1, max(group_multiplier + 3, 1) + unsim_air.group_multiplier), one_way = 1)

/*
 * equalize_gases()
 *
 * Equalizes a list of gas mixtures.
 * Used for pipe networks.
 */
/proc/equalize_gases(list/gases)
	// Calculates totals from individual components.
	var/total_volume = 0
	var/total_thermal_energy = 0
	var/total_heat_capacity = 0

	var/list/total_gas = list()
	for(var/datum/gas_mixture/gasmix in gases)
		total_volume += gasmix.volume
		var/temp_heatcap = gasmix.heat_capacity()
		total_thermal_energy += gasmix.temperature * temp_heatcap
		total_heat_capacity += temp_heatcap
		for(var/g in gasmix.gas)
			total_gas[g] += gasmix.gas[g]

	if(total_volume > 0)
		// Averages out the gases.
		for(var/g in total_gas)
			total_gas[g] /= total_volume

		// Calculates temperature.
		var/temperature = 0
		if(total_heat_capacity > 0)
			temperature = total_thermal_energy / total_heat_capacity

		// Updates individual gas_mixtures.
		for(var/datum/gas_mixture/gasmix in gases)
			gasmix.gas = total_gas.Copy()
			gasmix.temperature = temperature
			gasmix.multiply(gasmix.volume)

/*
 * add_thermal_energy()
 *
 * Adds or removes thermal energy.
 * Returns the actual thermal energy change, as in the case of removing energy we can't go below TCMB.
 */
/datum/gas_mixture/proc/add_thermal_energy(thermal_energy)
	if(total_moles == 0)
		return 0

	var/heat_capacity = heat_capacity()
	if(thermal_energy < 0)
		if(temperature < TCMB)
			return 0
		var/thermal_energy_limit = -(temperature - TCMB) * heat_capacity	//ensure temperature does not go below TCMB
		thermal_energy = max(thermal_energy, thermal_energy_limit)	//thermal_energy and thermal_energy_limit are negative here.
	temperature += thermal_energy / heat_capacity

	return thermal_energy

/*
 * get_thermal_energy_change()
 *
 * Purpose: Determining how much thermal energy is required.
 * Called by: Anyone. Machines that want to adjust the temperature of a gas mix.
 * Inputs: The target temperature.
 * Outputs: The amount of energy required to get to the new temperature in J. A negative value means that energy needs to be removed.
 */
/datum/gas_mixture/proc/get_thermal_energy_change(new_temperature)
	return heat_capacity() * (new_temperature - temperature)