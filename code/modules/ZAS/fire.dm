/*

Making Bombs with ZAS:
Make burny fire with lots of burning
Draw off 5000K gas from burny fire
Separate gas into oxygen and plasma components
Obtain plasma and oxygen tanks filled up about 50-75% with normal-temp gas
Fill rest with super hot gas from separated canisters, they should be about 125C now.
Attach to transfer valve and open. BOOM.

*/
/turf
	var/obj/fire/fire = null

//Some legacy definitions so fires can be started.
/atom/proc/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return null

/turf/proc/hotspot_expose(exposed_temperature, exposed_volume, soh = 0)

/turf/simulated/hotspot_expose(exposed_temperature, exposed_volume, soh)
	if(fire_protection > world.time - 300)
		return 0
	if(locate(/obj/fire) in src)
		return 1
	var/datum/gas_mixture/air_contents = return_air()
	if(!air_contents || exposed_temperature < PLASMA_MINIMUM_BURN_TEMPERATURE)
		return 0

	var/igniting = 0
	var/obj/effect/decal/cleanable/liquid_fuel/liquid = locate() in src

	if(air_contents.check_combustability(liquid))
		igniting = 1

		create_fire(1000)
	return igniting

/zone/proc/process_fire()
	if(!air.check_combustability())
		for(var/turf/simulated/T in fire_tiles)
			if(istype(T.fire))
				T.fire.RemoveFire()
			T.fire = null
		fire_tiles.Cut()

	if(!length(fire_tiles))
		global.CTair_system.active_fire_zones.Remove(src)
		return

	var/datum/gas_mixture/burn_gas = air.remove_ratio(global.vsc.fire_consuption_rate, length(fire_tiles))
	var/gm = burn_gas.group_multiplier

	burn_gas.group_multiplier = 1
	burn_gas.zburn(force_burn = 1, no_check = 1)
	burn_gas.group_multiplier = gm

	air.merge(burn_gas)

	var/firelevel = air.calculate_firelevel()

	for(var/turf/T in fire_tiles)
		if(T.fire)
			T.fire.firelevel = firelevel
		else
			fire_tiles.Remove(T)

/turf/proc/create_fire(fl)
	return 0

/turf/simulated/create_fire(fl)
	if(fire)
		fire.firelevel = max(fl, fire.firelevel)
		return 1

	if(!zone)
		return 1

	fire = new(src, fl)
	zone.fire_tiles |= src
	global.CTair_system.active_fire_zones |= zone
	return 0

/obj/fire
	//Icon for fire on turfs.

	anchored = TRUE
	mouse_opacity = FALSE

	blend_mode = BLEND_ADD

	icon = 'icons/effects/fire.dmi'
	icon_state = "1"

	light_color = "#ED9200"

	layer = TURF_LAYER

	var/firelevel = 10000 //Calculated by gas_mixture.calculate_firelevel()

/obj/fire/process()
	. = 1

	var/turf/simulated/my_tile = loc
	if(!istype(my_tile) || !my_tile.zone)
		if(my_tile.fire == src)
			my_tile.fire = null
		RemoveFire()
		return 1

	var/datum/gas_mixture/air_contents = my_tile.return_air()

	if(firelevel > 6)
		icon_state = "3"
		set_light(7, 3)
	else if(firelevel > 2.5)
		icon_state = "2"
		set_light(5, 2)
	else
		icon_state = "1"
		set_light(3, 1)

	//im not sure how to implement a version that works for every creature so for now monkeys are firesafe
	for(var/mob/living/carbon/human/M in loc)
		M.FireBurn(firelevel, air_contents.temperature, air_contents.return_pressure())  //Burn the humans!

	loc.fire_act(air_contents, air_contents.temperature, air_contents.volume)

	for(var/atom/A in loc)
		A.fire_act(air_contents, air_contents.temperature, air_contents.volume)

	//spread
	for(var/direction in GLOBL.cardinal)
		var/turf/simulated/enemy_tile = get_step(my_tile, direction)

		if(istype(enemy_tile))
			if(my_tile.open_directions & direction) //Grab all valid bordering tiles
				if(!enemy_tile.zone || enemy_tile.fire)
					continue

				if(!length(enemy_tile.zone.fire_tiles))
					var/datum/gas_mixture/acs = enemy_tile.return_air()
					if(!acs || !acs.check_combustability())
						continue

				//If extinguisher mist passed over the turf it's trying to spread to, don't spread and
				//reduce firelevel.
				if(enemy_tile.fire_protection > world.time-30)
					firelevel -= 1.5
					continue

				//Spread the fire.
				if(prob(50 + 50 * (firelevel / global.vsc.fire_firelevel_multiplier)) && my_tile.CanPass(null, enemy_tile, 0, 0) && enemy_tile.CanPass(null, my_tile, 0, 0))
					enemy_tile.create_fire(firelevel)
			else
				enemy_tile.adjacent_fire_act(loc, air_contents, air_contents.temperature, air_contents.volume)

	animate(src, color = heat2color(air_contents.temperature), 5)
	set_light(l_color = color)

/obj/fire/New(newLoc, fl)
	. = ..()

	if(!isturf(loc))
		qdel(src)

	dir = pick(GLOBL.cardinal)
	var/datum/gas_mixture/air_contents = loc.return_air()
	color = heat2color(air_contents.temperature)
	set_light(3, 1, color)

	firelevel = fl
	global.CTair_system.active_hotspots.Add(src)

/obj/fire/Destroy()
	if(istype(loc, /turf/simulated))
		set_light(0)

		loc = null
	global.CTair_system.active_hotspots.Remove(src)

	return ..()

/obj/fire/proc/RemoveFire()
	if(isturf(loc))
		set_light(0)
		loc = null
	global.CTair_system.active_hotspots.Remove(src)

/turf/simulated
	var/fire_protection = 0 //Protects newly extinguished tiles from being overrun again.

/turf/proc/apply_fire_protection()

/turf/simulated/apply_fire_protection()
	fire_protection = world.time

/datum/gas_mixture/proc/zburn(obj/effect/decal/cleanable/liquid_fuel/liquid, force_burn, no_check = 0)
	. = 0
	if((temperature > PLASMA_MINIMUM_BURN_TEMPERATURE || force_burn) && (no_check ||check_recombustability(liquid)))
		var/total_fuel = 0
		var/total_oxidizers = 0

		for(var/g in gas)
			if(GLOBL.gas_data.flags[g] & XGM_GAS_FUEL)
				total_fuel += gas[g]
			if(GLOBL.gas_data.flags[g] & XGM_GAS_OXIDIZER)
				total_oxidizers += gas[g]

		if(liquid)
		//Liquid Fuel
			if(liquid.amount <= 0.1)
				qdel(liquid)
			else
				total_fuel += liquid.amount

		//Calculate the firelevel.
		var/firelevel = calculate_firelevel(liquid, total_fuel, total_oxidizers, force = 1)

		//get the current inner energy of the gas mix
		//this must be taken here to prevent the addition or deletion of energy by a changing heat capacity
		var/starting_energy = temperature * heat_capacity()

		//determine the amount of oxygen used
		var/used_oxidizers = min(total_oxidizers, total_fuel / 2)

		//determine the amount of fuel actually used
		var/used_fuel_ratio = min(2 * total_oxidizers, total_fuel) / total_fuel
		total_fuel = total_fuel * used_fuel_ratio

		var/total_reactants = total_fuel + used_oxidizers

		//determine the amount of reactants actually reacting
		var/used_reactants_ratio = min(max(total_reactants * firelevel / global.vsc.fire_firelevel_multiplier, 0.2), total_reactants) / total_reactants

		//remove and add gasses as calculated
		remove_by_flag(XGM_GAS_OXIDIZER, used_oxidizers * used_reactants_ratio)
		remove_by_flag(XGM_GAS_FUEL, total_fuel * used_reactants_ratio)

		adjust_gas(GAS_CARBON_DIOXIDE, max(total_fuel * used_reactants_ratio, 0))

		if(liquid)
			liquid.amount -= (liquid.amount * used_fuel_ratio * used_reactants_ratio) * 5 // liquid fuel burns 5 times as quick

			if(liquid.amount <= 0)
				qdel(liquid)

		//calculate the energy produced by the reaction and then set the new temperature of the mix
		temperature = (starting_energy + global.vsc.fire_fuel_energy_release * total_fuel) / heat_capacity()

		update_values()
		. = total_reactants * used_reactants_ratio

/datum/gas_mixture/proc/check_recombustability(obj/effect/decal/cleanable/liquid_fuel/liquid)
	. = 0
	for(var/g in gas)
		if(GLOBL.gas_data.flags[g] & XGM_GAS_OXIDIZER && gas[g] >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(liquid)
		return 1

	. = 0
	for(var/g in gas)
		if(GLOBL.gas_data.flags[g] & XGM_GAS_FUEL && gas[g] >= 0.1)
			. = 1
			break

/datum/gas_mixture/proc/check_combustability(obj/effect/decal/cleanable/liquid_fuel/liquid)
	. = 0
	for(var/g in gas)
		if(GLOBL.gas_data.flags[g] & XGM_GAS_OXIDIZER && QUANTIZE(gas[g] * global.vsc.fire_consuption_rate) >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(liquid)
		return 1

	. = 0
	for(var/g in gas)
		if(GLOBL.gas_data.flags[g] & XGM_GAS_FUEL && QUANTIZE(gas[g] * global.vsc.fire_consuption_rate) >= 0.1)
			. = 1
			break

/datum/gas_mixture/proc/calculate_firelevel(obj/effect/decal/cleanable/liquid_fuel/liquid, total_fuel = null, total_oxidizers = null, force = 0)
	//Calculates the firelevel based on one equation instead of having to do this multiple times in different areas.
	var/firelevel = 0

	if(force || check_recombustability(liquid))
		if(isnull(total_fuel))
			for(var/g in gas)
				if(GLOBL.gas_data.flags[g] & XGM_GAS_FUEL)
					total_fuel += gas[g]
				if(GLOBL.gas_data.flags[g] & XGM_GAS_OXIDIZER)
					total_oxidizers += gas[g]
			if(liquid)
				total_fuel += liquid.amount

		var/total_combustables = (total_fuel + total_oxidizers)

		if(total_combustables > 0)
			//slows down the burning when the concentration of the reactants is low
			var/dampening_multiplier = total_combustables / total_moles
			//calculates how close the mixture of the reactants is to the optimum
			var/mix_multiplier = 1 / (1 + (5 * ((total_oxidizers / total_combustables) ** 2)))
			//toss everything together
			firelevel = global.vsc.fire_firelevel_multiplier * mix_multiplier * dampening_multiplier

	return max(0, firelevel)

/mob/living/proc/FireBurn(firelevel, last_temperature, pressure)
	var/mx = 5 * firelevel / global.vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)
	apply_damage(2.5 * mx, BURN)

/mob/living/carbon/human/FireBurn(firelevel, last_temperature, pressure)
	//Burns mobs due to fire. Respects heat transfer coefficients on various body parts.
	//Due to TG reworking how fireprotection works, this is kinda less meaningful.
	var/head_exposure = 1
	var/chest_exposure = 1
	var/groin_exposure = 1
	var/legs_exposure = 1
	var/arms_exposure = 1

	//Get heat transfer coefficients for clothing.

	for(var/obj/item/clothing/C in src)
		if(l_hand == C || r_hand == C)
			continue

		if(C.max_heat_protection_temperature >= last_temperature)
			if(C.body_parts_covered & HEAD)
				head_exposure = 0
			if(C.body_parts_covered & UPPER_TORSO)
				chest_exposure = 0
			if(C.body_parts_covered & LOWER_TORSO)
				groin_exposure = 0
			if(C.body_parts_covered & LEGS)
				legs_exposure = 0
			if(C.body_parts_covered & ARMS)
				arms_exposure = 0
	//minimize this for low-pressure enviroments
	var/mx = 5 * firelevel / global.vsc.fire_firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)

	//Always check these damage procs first if fire damage isn't working. They're probably what's wrong.

	apply_damage(2.5 * mx * head_exposure, BURN, "head", 0, 0, "Fire")
	apply_damage(2.5 * mx * chest_exposure, BURN, "chest", 0, 0, "Fire")
	apply_damage(2.0 * mx * groin_exposure, BURN, "groin", 0, 0, "Fire")
	apply_damage(0.6 * mx * legs_exposure, BURN, "l_leg", 0, 0, "Fire")
	apply_damage(0.6 * mx * legs_exposure, BURN, "r_leg", 0, 0, "Fire")
	apply_damage(0.4 * mx * arms_exposure, BURN, "l_arm", 0, 0, "Fire")
	apply_damage(0.4 * mx * arms_exposure, BURN, "r_arm", 0, 0, "Fire")