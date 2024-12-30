//////////////////////////////////////////
////////  Mecha global iterators  ////////
//////////////////////////////////////////
/datum/global_iterator/mecha_preserve_temp  //normalizing cabin air temperature to 20 degrees celsium
	delay = 2 SECONDS

/datum/global_iterator/mecha_preserve_temp/process(obj/mecha/mecha)
	if(mecha.cabin_air && mecha.cabin_air.volume > 0)
		var/delta = mecha.cabin_air.temperature - T20C
		mecha.cabin_air.temperature -= max(-10, min(10, round(delta / 4, 0.1)))
	return

/datum/global_iterator/mecha_tank_give_air
	delay = 1.5 SECONDS

/datum/global_iterator/mecha_tank_give_air/process(obj/mecha/mecha)
	if(isnotnull(mecha.internal_tank))
		var/datum/gas_mixture/tank_air = mecha.internal_tank.return_air()
		var/datum/gas_mixture/cabin_air = mecha.cabin_air

		var/release_pressure = mecha.internal_tank_valve
		var/cabin_pressure = cabin_air.return_pressure()
		var/pressure_delta = min(release_pressure - cabin_pressure, (tank_air.return_pressure() - cabin_pressure) / 2)
		var/transfer_moles = 0
		if(pressure_delta > 0) //cabin pressure lower than release pressure
			if(tank_air.temperature > 0)
				transfer_moles = pressure_delta * cabin_air.volume / (cabin_air.temperature * R_IDEAL_GAS_EQUATION)
				var/datum/gas_mixture/removed = tank_air.remove(transfer_moles)
				cabin_air.merge(removed)
		else if(pressure_delta < 0) //cabin pressure higher than release pressure
			var/datum/gas_mixture/t_air = mecha.get_turf_air()
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
	else
		return stop()

/datum/global_iterator/mecha_inertial_movement //inertial movement in space
	delay = 0.7 SECONDS

/datum/global_iterator/mecha_inertial_movement/process(obj/mecha/mecha, direction)
	if(direction)
		if(!step(mecha, direction)||mecha.check_for_support())
			stop()
	else
		stop()

/datum/global_iterator/mecha_internal_damage // processing internal damage

/datum/global_iterator/mecha_internal_damage/process(obj/mecha/mecha)
	if(!mecha.internal_damage)
		return stop()

	if(mecha.internal_damage & MECHA_INT_FIRE)
		if(!(mecha.internal_damage & MECHA_INT_TEMP_CONTROL) && prob(5))
			mecha.clear_internal_damage(MECHA_INT_FIRE)
		if(mecha.internal_tank)
			if(mecha.internal_tank.return_pressure() > mecha.internal_tank.maximum_pressure && !(mecha.internal_damage & MECHA_INT_TANK_BREACH))
				mecha.set_internal_damage(MECHA_INT_TANK_BREACH)
			var/datum/gas_mixture/int_tank_air = mecha.internal_tank.return_air()
			if(int_tank_air && int_tank_air.volume > 0) //heat the air_contents
				int_tank_air.temperature = min(6000 + T0C, int_tank_air.temperature + rand(10, 15))
		if(mecha.cabin_air && mecha.cabin_air.volume > 0)
			mecha.cabin_air.temperature = min(6000 + T0C, mecha.cabin_air.temperature + rand(10, 15))
			if(mecha.cabin_air.temperature>mecha.max_temperature / 2)
				mecha.take_damage(4 / round(mecha.max_temperature / mecha.cabin_air.temperature, 0.1), "fire")

	if(mecha.internal_damage & MECHA_INT_TEMP_CONTROL) //stop the mecha_preserve_temp loop datum
		mecha.pr_int_temp_processor.stop()

	if(mecha.internal_damage & MECHA_INT_TANK_BREACH) //remove some air from internal tank
		if(mecha.internal_tank)
			var/datum/gas_mixture/int_tank_air = mecha.internal_tank.return_air()
			var/datum/gas_mixture/leaked_gas = int_tank_air.remove_ratio(0.10)
			if(mecha.loc && hascall(mecha.loc, "assume_air"))
				mecha.loc.assume_air(leaked_gas)
			else
				qdel(leaked_gas)

	if(mecha.internal_damage & MECHA_INT_SHORT_CIRCUIT)
		if(mecha.get_charge())
			mecha.spark_system.start()
			mecha.cell.charge -= min(20, mecha.cell.charge)
			mecha.cell.maxcharge -= min(20, mecha.cell.maxcharge)