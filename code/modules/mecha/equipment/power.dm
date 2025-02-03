// Tesla Energy Relay
/obj/item/mecha_part/equipment/tesla_energy_relay
	name = "tesla energy relay"
	desc = "Wirelessly drains energy from any available power channel in area. The performance index is quite low. (Can be attached to: Any Exosuit)"
	icon_state = "tesla"
	origin_tech = list(/decl/tech/magnets = 4, /decl/tech/syndicate = 2)

	equip_cooldown = 1 SECOND
	energy_drain = 0
	range = 0
	selectable = FALSE

	var/datum/global_iterator/pr_energy_relay
	var/coeff = 100
	var/list/use_channels = list(EQUIP, ENVIRON, LIGHT)

/obj/item/mecha_part/equipment/tesla_energy_relay/New()
	. = ..()
	pr_energy_relay = new /datum/global_iterator/mecha_energy_relay(list(src), 0)
	pr_energy_relay.set_delay(equip_cooldown)

/obj/item/mecha_part/equipment/tesla_energy_relay/Destroy()
	QDEL_NULL(pr_energy_relay)
	return ..()

/obj/item/mecha_part/equipment/tesla_energy_relay/detach()
	pr_energy_relay.stop()
	. = ..()

/obj/item/mecha_part/equipment/tesla_energy_relay/proc/get_power_channel(area/A)
	. = null
	if(isnull(A))
		return .
	for(var/channel in use_channels)
		if(A.powered(channel))
			. = channel
			break

/obj/item/mecha_part/equipment/tesla_energy_relay/Topic(href, href_list)
	. = ..()
	if(href_list["toggle_relay"])
		if(pr_energy_relay.toggle())
			set_ready_state(0)
			log_message("Activated.")
		else
			set_ready_state(1)
			log_message("Deactivated.")

/obj/item/mecha_part/equipment/tesla_energy_relay/get_equip_info()
	. = "[..()] - <a href='byond://?src=\ref[src];toggle_relay=1'>[pr_energy_relay.active() ? "Dea" : "A"]ctivate</a>"

/datum/global_iterator/mecha_energy_relay/process(obj/item/mecha_part/equipment/tesla_energy_relay/relay)
	if(!relay.chassis || relay.chassis.internal_damage & MECHA_INT_SHORT_CIRCUIT)
		stop()
		relay.set_ready_state(1)
		return

	var/cur_charge = relay.chassis.get_charge()
	if(isnull(cur_charge) || !relay.chassis.cell)
		stop()
		relay.set_ready_state(1)
		relay.occupant_message("No power cell detected.")
		return

	if(cur_charge > relay.chassis.cell.maxcharge)
		return
	var/area/current_area = GET_AREA(relay.chassis)
	var/power_channel = relay.get_power_channel(current_area)
	if(isnotnull(power_channel))
		var/delta = min(12, relay.chassis.cell.maxcharge - cur_charge)
		relay.chassis.give_power(delta)
		current_area.use_power(delta * relay.coeff, power_channel)

/*
 * Generators
 */
// Plasma
/obj/item/mecha_part/equipment/generator
	name = "plasma converter"
	desc = "Generates power using solid plasma as fuel. Pollutes the environment. (Can be attached to: Any Exosuit)"
	icon_state = "tesla"
	origin_tech = list(/decl/tech/engineering = 1, /decl/tech/power_storage = 2, /decl/tech/plasma = 2)
	equip_cooldown = 1 SECOND
	energy_drain = 0
	range = MELEE
	reliability = 1000

	var/datum/global_iterator/pr_mech_generator
	var/coeff = 100
	var/obj/item/stack/sheet/fuel
	var/max_fuel = 150000
	var/fuel_per_cycle_idle = 100
	var/fuel_per_cycle_active = 500
	var/power_per_cycle = 20

/obj/item/mecha_part/equipment/generator/New()
	. = ..()
	init()

/obj/item/mecha_part/equipment/generator/Destroy()
	QDEL_NULL(pr_mech_generator)
	return ..()

/obj/item/mecha_part/equipment/generator/proc/init()
	fuel = new /obj/item/stack/sheet/plasma(src)
	fuel.amount = 0
	pr_mech_generator = new /datum/global_iterator/mecha_generator(list(src), 0)
	pr_mech_generator.set_delay(equip_cooldown)

/obj/item/mecha_part/equipment/generator/detach()
	pr_mech_generator.stop()
	. = ..()

/obj/item/mecha_part/equipment/generator/Topic(href, href_list)
	. = ..()
	if(href_list["toggle"])
		if(pr_mech_generator.toggle())
			set_ready_state(0)
			log_message("Activated.")
		else
			set_ready_state(1)
			log_message("Deactivated.")

/obj/item/mecha_part/equipment/generator/get_equip_info()
	. = "[..()] \[[fuel]: [round(fuel.amount * fuel.perunit, 0.1)] cm<sup>3</sup>\] - <a href='byond://?src=\ref[src];toggle=1'>[pr_mech_generator.active() ? "Dea" : "A"]ctivate</a>"

/obj/item/mecha_part/equipment/generator/action(target)
	if(chassis)
		var/result = load_fuel(target)
		var/message
		if(isnull(result))
			message = SPAN_WARNING("[fuel] traces in target minimal. \The [target] cannot be used as fuel.")
		else if(!result)
			message = SPAN_WARNING("Unit is full.")
		else
			message = SPAN_INFO("[result] unit\s of [fuel] successfully loaded.")
			send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",get_equip_info())
		occupant_message(message)

/obj/item/mecha_part/equipment/generator/proc/load_fuel(obj/item/stack/sheet/P)
	if(P.type == fuel.type && P.amount)
		var/to_load = max(max_fuel - fuel.amount * fuel.perunit, 0)
		if(to_load)
			var/units = min(max(round(to_load / P.perunit), 1), P.amount)
			if(units)
				fuel.amount += units
				P.use(units)
				return units
		else
			return 0
	return null

/obj/item/mecha_part/equipment/generator/attack_by(obj/item/I, mob/user)
	var/result = load_fuel(I)
	if(isnull(result))
		user.visible_message(
			SPAN_WARNING("[user] tries to shove \the [I] into \the [src]. What a dumb-ass."),
			SPAN_WARNING("[fuel] traces minimal. \The [I] cannot be used as fuel.")
		)
		return ..()

	if(!result)
		to_chat(user, SPAN_WARNING("Unit is full."))
		return TRUE

	user.visible_message(
		SPAN_INFO("[user] loads \the [src] with [fuel]."),
		SPAN_INFO("[result] unit\s of [fuel] successfully loaded.")
	)
	return TRUE

/obj/item/mecha_part/equipment/generator/critfail()
	. = ..()
	var/turf/open/T = GET_TURF(src)
	if(isnull(T))
		return
	var/datum/gas_mixture/GM = new /datum/gas_mixture()
	if(prob(10))
		T.assume_gas(/decl/xgm_gas/plasma, 100, 1500 + T0C)
		T.visible_message(SPAN_WARNING("\The [src] suddenly disgorges a cloud of heated plasma."))
		qdel(src)
	else
		T.assume_gas(/decl/xgm_gas/plasma, 5, istype(T) ? T.air.temperature : T20C)
		T.visible_message(SPAN_WARNING("The [src] suddenly disgorges a cloud of plasma."))
	T.assume_air(GM)

/datum/global_iterator/mecha_generator/process(obj/item/mecha_part/equipment/generator/EG)
	if(!EG.chassis)
		stop()
		EG.set_ready_state(1)
		return 0
	if(EG.fuel.amount <= 0)
		stop()
		EG.log_message("Deactivated - no fuel.")
		EG.set_ready_state(1)
		return 0
	if(anyprob(EG.reliability))
		EG.critfail()
		stop()
		return 0
	var/cur_charge = EG.chassis.get_charge()
	if(isnull(cur_charge))
		EG.set_ready_state(1)
		EG.occupant_message("No powercell detected.")
		EG.log_message("Deactivated.")
		stop()
		return 0
	var/use_fuel = EG.fuel_per_cycle_idle
	if(cur_charge < EG.chassis.cell.maxcharge)
		use_fuel = EG.fuel_per_cycle_active
		EG.chassis.give_power(EG.power_per_cycle)
	EG.fuel.amount -= min(use_fuel / EG.fuel.perunit, EG.fuel.amount)
	EG.update_equip_info()
	return 1

// Nuclear
/obj/item/mecha_part/equipment/generator/nuclear
	name = "\improper ExoNuclear reactor"
	desc = "Generates power using uranium. Pollutes the environment. (Can be attached to: Any Exosuit)"
	icon_state = "tesla"
	origin_tech = list(/decl/tech/engineering = 3, /decl/tech/power_storage = 3)
	max_fuel = 50000
	fuel_per_cycle_idle = 10
	fuel_per_cycle_active = 30
	power_per_cycle = 50
	reliability = 1000

	var/rad_per_cycle = 0.3

/obj/item/mecha_part/equipment/generator/nuclear/init()
	fuel = new /obj/item/stack/sheet/uranium(src)
	fuel.amount = 0
	pr_mech_generator = new /datum/global_iterator/mecha_generator/nuclear(list(src), 0)
	pr_mech_generator.set_delay(equip_cooldown)

/obj/item/mecha_part/equipment/generator/nuclear/critfail()
	return

/datum/global_iterator/mecha_generator/nuclear/process(obj/item/mecha_part/equipment/generator/nuclear/EG)
	if(..())
		for(var/mob/living/carbon/M in view(EG.chassis))
			if(ishuman(M))
				M.apply_effect((EG.rad_per_cycle * 3), IRRADIATE, 0)
			else
				M.radiation += EG.rad_per_cycle
	return 1