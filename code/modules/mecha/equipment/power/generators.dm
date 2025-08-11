/*
 * Generators
 */
// Plasma
/obj/item/mecha_equipment/generator
	name = "plasma converter"
	desc = "An exosuit module that generates power using solid plasma as fuel. Pollutes the environment. (Can be attached to: Any Exosuit)"
	icon_state = "tesla"

	matter_amounts = /datum/design/mechfab/equipment/general/plasma_generator::materials
	origin_tech = /datum/design/mechfab/equipment/general/plasma_generator::req_tech

	equip_cooldown = 1 SECOND

	var/coeff = 100
	var/obj/item/stack/sheet/fuel
	var/fuel_type = /obj/item/stack/sheet/plasma
	var/max_fuel = 150000
	var/fuel_per_cycle_idle = 100
	var/fuel_per_cycle_active = 500
	var/power_per_cycle = 20

/obj/item/mecha_equipment/generator/initialise()
	. = ..()
	fuel = new fuel_type(src, 0)

/obj/item/mecha_equipment/generator/Destroy()
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/item/mecha_equipment/generator/detach()
	STOP_PROCESSING(PCobj, src)
	. = ..()

/obj/item/mecha_equipment/generator/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("toggle"))
		if(equip_ready)
			START_PROCESSING(PCobj, src)
			log_message("Activated.")
			set_ready_state(FALSE)
		else
			STOP_PROCESSING(PCobj, src)
			log_message("Deactivated.")
			set_ready_state(TRUE)

/obj/item/mecha_equipment/generator/get_equip_info()
	. = "[..()] \[[fuel]: [round(fuel.amount * fuel.perunit, 0.1)] cm<sup>3</sup>\] - <a href='byond://?src=\ref[src];toggle=1'>[equip_ready ? "A" : "Dea"]ctivate</a>"

/obj/item/mecha_equipment/generator/action(target)
	if(!..())
		return FALSE
	if(isnull(chassis))
		return FALSE

	var/result = load_fuel(target)
	if(isnull(result))
		occupant_message(SPAN_WARNING("[fuel] traces in target minimal. \The [target] cannot be used as fuel."))
		return FALSE
	if(!result)
		occupant_message(SPAN_WARNING("Unit is full."))
		return FALSE

	occupant_message(SPAN_INFO("[result] unit\s of [fuel] successfully loaded."))
	send_byjax(chassis.occupant,"exosuit.browser", "\ref[src]", get_equip_info())
	return TRUE

/obj/item/mecha_equipment/generator/proc/load_fuel(obj/item/stack/sheet/P)
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

/obj/item/mecha_equipment/generator/attack_by(obj/item/I, mob/user)
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

/obj/item/mecha_equipment/generator/critfail()
	. = ..()
	var/turf/open/T = GET_TURF(src)
	if(isnull(T))
		return
	if(prob(10))
		T.assume_gas(/decl/xgm_gas/plasma, 100, 1500 + T0C)
		T.visible_message(SPAN_WARNING("\The [src] suddenly disgorges a cloud of heated plasma."))
		qdel(src)
	else
		T.assume_gas(/decl/xgm_gas/plasma, 5, istype(T) ? T.air.temperature : T20C)
		T.visible_message(SPAN_WARNING("The [src] suddenly disgorges a cloud of plasma."))

/obj/item/mecha_equipment/generator/process()
	. = ..()
	if(. == PROCESS_KILL)
		return .
	if(fuel.amount <= 0)
		log_message("Deactivated - no fuel.")
		set_ready_state(TRUE)
		return PROCESS_KILL
	if(anyprob(reliability))
		critfail()
		set_ready_state(TRUE)
		return PROCESS_KILL

	var/cur_charge = chassis.get_charge()
	if(isnull(cur_charge))
		occupant_message("No powercell detected.")
		log_message("Deactivated.")
		set_ready_state(TRUE)
		return PROCESS_KILL

	var/use_fuel = fuel_per_cycle_idle
	if(cur_charge < chassis.cell.maxcharge)
		use_fuel = fuel_per_cycle_active
		chassis.give_power(power_per_cycle)
	fuel.amount -= min(use_fuel / fuel.perunit, fuel.amount)
	update_equip_info()

// Nuclear
/obj/item/mecha_equipment/generator/nuclear
	name = "\improper ExoNuclear reactor"
	desc = "An exosuit module that generates power using uranium as fuel. Pollutes the environment. (Can be attached to: Any Exosuit)"
	icon_state = "tesla"

	matter_amounts = /datum/design/mechfab/equipment/general/nuclear_generator::materials
	origin_tech = /datum/design/mechfab/equipment/general/nuclear_generator::req_tech

	fuel_type = /obj/item/stack/sheet/uranium
	max_fuel = 50000
	fuel_per_cycle_idle = 10
	fuel_per_cycle_active = 30
	power_per_cycle = 50

	var/rad_per_cycle = 0.3

/obj/item/mecha_equipment/generator/nuclear/critfail()
	return

/obj/item/mecha_equipment/generator/nuclear/process()
	if(..() == PROCESS_KILL)
		return PROCESS_KILL

	for(var/mob/living/carbon/M in view(chassis))
		if(ishuman(M))
			M.apply_effect((rad_per_cycle * 3), IRRADIATE, 0)
		else
			M.radiation += rad_per_cycle