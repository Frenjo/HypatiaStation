/obj/mecha/process()
	handle_internal_temperature() // Old delay was every 2 seconds.
	handle_tank_give_air() // Old delay was every 1.5 seconds.
	handle_internal_damage() // Old delay was every 1 second.

// Normalises cabin air temperature to 20 degrees celsius.
/obj/mecha/proc/handle_internal_temperature()
	if(internal_damage & MECHA_INT_TEMP_CONTROL)
		return

	if(cabin_air?.volume > 0)
		var/delta = cabin_air.temperature - T20C
		cabin_air.temperature -= max(-10, min(10, round(delta / 4, 0.1)))

// Moves air from the tank to the cabin.
/obj/mecha/proc/handle_tank_give_air()
	if(isnull(internal_tank))
		return

	var/datum/gas_mixture/tank_air = internal_tank.return_air()
	var/release_pressure = internal_tank_valve
	var/cabin_pressure = cabin_air.return_pressure()
	var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure) / 2)
	var/transfer_moles = 0
	if(pressure_delta > 0) //cabin pressure lower than release pressure
		if(tank_air.temperature > 0)
			transfer_moles = pressure_delta * cabin_air.volume / (cabin_air.temperature * R_IDEAL_GAS_EQUATION)
			var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
			cabin_air.merge(removed)
	else if(pressure_delta < 0) //cabin pressure higher than release pressure
		var/datum/gas_mixture/t_air = get_turf_air()
		pressure_delta = cabin_pressure - release_pressure
		if(isnotnull(t_air))
			pressure_delta = min(cabin_pressure - t_air.return_pressure(), pressure_delta)
		if(pressure_delta > 0) //if location pressure is lower than cabin pressure
			transfer_moles = pressure_delta * cabin_air.volume / (cabin_air.temperature * R_IDEAL_GAS_EQUATION)
			var/datum/gas_mixture/removed = cabin_air.remove(transfer_moles)
			if(isnotnull(t_air))
				t_air.merge(removed)
			else //just delete the cabin gas, we're in space or some shit
				qdel(removed)

// Processes internal damage.
/obj/mecha/proc/handle_internal_damage()
	if(!internal_damage)
		return

	if(internal_damage & MECHA_INT_FIRE)
		if(!(internal_damage & MECHA_INT_TEMP_CONTROL) && prob(5))
			clear_internal_damage(MECHA_INT_FIRE)
		if(isnotnull(internal_tank))
			if(internal_tank.return_pressure() > internal_tank.maximum_pressure && !(internal_damage & MECHA_INT_TANK_BREACH))
				set_internal_damage(MECHA_INT_TANK_BREACH)
			var/datum/gas_mixture/int_tank_air = internal_tank.return_air()
			if(int_tank_air && int_tank_air.volume > 0) //heat the air_contents
				int_tank_air.temperature = min(6000 + T0C, int_tank_air.temperature + rand(10, 15))
		if(cabin_air?.volume > 0)
			cabin_air.temperature = min(6000 + T0C, cabin_air.temperature + rand(10, 15))
			if(cabin_air.temperature > max_temperature / 2)
				take_damage(4 / round(max_temperature / cabin_air.temperature, 0.1), "fire")

	if(internal_damage & MECHA_INT_TANK_BREACH) //remove some air from internal tank
		if(isnotnull(internal_tank))
			var/datum/gas_mixture/int_tank_air = internal_tank.return_air()
			var/datum/gas_mixture/leaked_gas = int_tank_air.remove_ratio(0.10)
			if(hascall(loc, "assume_air"))
				loc.assume_air(leaked_gas)
			else
				qdel(leaked_gas)

	if(internal_damage & MECHA_INT_SHORT_CIRCUIT)
		if(get_charge())
			spark_system.start()
			cell.charge -= min(20, cell.charge)
			cell.maxcharge -= min(20, cell.maxcharge)