// RCD
/obj/item/mecha_part/equipment/tool/rcd
	name = "mounted RCD"
	desc = "An exosuit-mounted rapid-construction-device. (Can be attached to: Working Exosuits)"
	icon_state = "mecha_rcd"
	origin_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/engineering = 4,
		/datum/tech/power_storage = 4, /datum/tech/bluespace = 3
	)
	equip_cooldown = 10
	energy_drain = 250
	range = MELEE|RANGED
	construction_time = 1200
	construction_cost = list(
		MATERIAL_METAL = 30000, /decl/material/silver = 20000,
		/decl/material/gold = 20000, /decl/material/plasma = 25000
	)
	var/mode = 0 //0 - deconstruct, 1 - wall or floor, 2 - airlock.
	var/disabled = 0 //malf

/obj/item/mecha_part/equipment/tool/rcd/action(atom/target)
	if(istype(target, /turf/space/transit)) //>implying these are ever made -Sieve
		return
	if(!isturf(target) && !istype(target, /obj/machinery/door/airlock))
		target = GET_TURF(target)
	if(!action_checks(target) || disabled || get_dist(chassis, target) > 3)
		return
	playsound(chassis, 'sound/machines/click.ogg', 50, 1)
	//meh
	switch(mode)
		if(0)
			if(istype(target, /turf/closed/wall))
				occupant_message("Deconstructing [target]...")
				set_ready_state(0)
				if(do_after_cooldown(target))
					if(disabled)
						return
					chassis.spark_system.start()
					target:ChangeTurf(/turf/open/floor/plating/metal)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.use_power(energy_drain)
			else if(isfloorturf(target))
				occupant_message("Deconstructing [target]...")
				set_ready_state(0)
				if(do_after_cooldown(target))
					if(disabled)
						return
					chassis.spark_system.start()
					target:ChangeTurf(/turf/space)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.use_power(energy_drain)
			else if(istype(target, /obj/machinery/door/airlock))
				occupant_message("Deconstructing [target]...")
				set_ready_state(0)
				if(do_after_cooldown(target))
					if(disabled)
						return
					chassis.spark_system.start()
					qdel(target)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.use_power(energy_drain)
		if(1)
			if(isspace(target))
				occupant_message("Building Floor...")
				set_ready_state(0)
				if(do_after_cooldown(target))
					if(disabled)
						return
					target:ChangeTurf(/turf/open/floor/plating/metal)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.spark_system.start()
					chassis.use_power(energy_drain * 2)
			else if(isfloorturf(target))
				occupant_message("Building Wall...")
				set_ready_state(0)
				if(do_after_cooldown(target))
					if(disabled)
						return
					target:ChangeTurf(/turf/closed/wall/steel)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.spark_system.start()
					chassis.use_power(energy_drain * 2)
		if(2)
			if(isfloorturf(target))
				occupant_message("Building Airlock...")
				set_ready_state(0)
				if(do_after_cooldown(target))
					if(disabled)
						return
					chassis.spark_system.start()
					var/obj/machinery/door/airlock/T = new /obj/machinery/door/airlock(target)
					T.autoclose = TRUE
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					playsound(target, 'sound/effects/sparks2.ogg', 50, 1)
					chassis.use_power(energy_drain * 2)
	return

/obj/item/mecha_part/equipment/tool/rcd/Topic(href, href_list)
	. = ..()
	if(href_list["mode"])
		mode = text2num(href_list["mode"])
		switch(mode)
			if(0)
				occupant_message("Switched RCD to Deconstruct.")
			if(1)
				occupant_message("Switched RCD to Construct.")
			if(2)
				occupant_message("Switched RCD to Construct Airlock.")

/obj/item/mecha_part/equipment/tool/rcd/get_equip_info()
	return "[..()] \[<a href='byond://?src=\ref[src];mode=0'>D</a>|<a href='byond://?src=\ref[src];mode=1'>C</a>|<a href='byond://?src=\ref[src];mode=2'>A</a>\]"

// Cable Layer
/obj/item/mecha_part/equipment/tool/cable_layer
	name = "cable layer"
	desc = "An exosuit-mounted cable layer. (Can be attached to: Working Exosuits)"
	icon_state = "mecha_wire"

	var/datum/event/event
	var/turf/old_turf
	var/obj/structure/cable/last_piece
	var/obj/item/stack/cable_coil/cable
	var/max_cable = 1000

/obj/item/mecha_part/equipment/tool/cable_layer/New()
	. = ..()
	cable = new /obj/item/stack/cable_coil(src)
	cable.amount = 0

/obj/item/mecha_part/equipment/tool/cable_layer/Destroy()
	chassis.events.clearEvent("onMove", event)
	return ..()

/obj/item/mecha_part/equipment/tool/cable_layer/attach()
	. = ..()
	event = chassis.events.addEvent("onMove", src, "layCable")

/obj/item/mecha_part/equipment/tool/cable_layer/detach()
	chassis.events.clearEvent("onMove", event)
	return ..()

/obj/item/mecha_part/equipment/tool/cable_layer/action(obj/item/stack/cable_coil/target)
	if(!action_checks(target))
		return
	var/result = load_cable(target)
	var/message
	if(isnull(result))
		message = SPAN_WARNING("Unable to load \the [target] - no cable found.")
	else if(!result)
		message = "Reel is full."
	else
		message = "[result] meters of cable successfully loaded."
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())
	occupant_message(message)

/obj/item/mecha_part/equipment/tool/cable_layer/Topic(href,href_list)
	. = ..()
	if(href_list["toggle"])
		set_ready_state(!equip_ready)
		occupant_message("[src] [equip_ready ? "dea" : "a"]ctivated.")
		log_message("[equip_ready ? "Dea" : "A"]ctivated.")
		return
	if(href_list["cut"])
		if(cable && cable.amount)
			var/m = round(input(chassis.occupant, "Please specify the length of cable to cut", "Cut cable", min(cable.amount, 30)), 1)
			m = min(m, cable.amount)
			if(m)
				use_cable(m)
				new /obj/item/stack/cable_coil(GET_TURF(chassis), m)
		else
			occupant_message(SPAN_WARNING("There's no more cable on the reel."))

/obj/item/mecha_part/equipment/tool/cable_layer/get_equip_info()
	. = ..()
	if(.)
		. += " \[Cable: [cable ? cable.amount : 0] m\][(cable && cable.amount) ? "- <a href='byond://?src=\ref[src];toggle=1'>[!equip_ready ? "Dea" : "A"]ctivate</a>|<a href='byond://?src=\ref[src];cut=1'>Cut</a>" : null]"

/obj/item/mecha_part/equipment/tool/cable_layer/proc/load_cable(obj/item/stack/cable_coil/CC)
	if(istype(CC) && CC.amount)
		var/cur_amount = cable? cable.amount : 0
		var/to_load = max(max_cable - cur_amount, 0)
		if(to_load)
			to_load = min(CC.amount, to_load)
			if(isnull(cable))
				cable = new /obj/item/stack/cable_coil(src, 0)
			cable.amount += to_load
			CC.use(to_load)
			return to_load
	return null

/obj/item/mecha_part/equipment/tool/cable_layer/proc/use_cable(amount)
	if(isnull(cable) || cable.amount < 1)
		set_ready_state(1)
		occupant_message(SPAN_WARNING("Cable depleted, [src] deactivated."))
		log_message("Cable depleted, [src] deactivated.")
		return
	if(cable.amount < amount)
		occupant_message(SPAN_WARNING("No enough cable to finish the task."))
		return
	cable.use(amount)
	update_equip_info()
	return 1

/obj/item/mecha_part/equipment/tool/cable_layer/proc/reset()
	last_piece = null

/obj/item/mecha_part/equipment/tool/cable_layer/proc/dismantleFloor(turf/new_turf)
	if(isfloorturf(new_turf))
		var/turf/open/floor/T = new_turf
		if(!istype(new_turf, /turf/open/floor/plating/metal))
			if(!T.broken && !T.burnt)
				new T.tile_path(T)
			T.make_plating()
	return !new_turf.intact

/obj/item/mecha_part/equipment/tool/cable_layer/proc/layCable(turf/new_turf)
	if(equip_ready || !istype(new_turf) || !dismantleFloor(new_turf))
		return reset()
	var/fdirn = turn(chassis.dir, 180)
	for(var/obj/structure/cable/LC in new_turf)		// check to make sure there's not a cable there already
		if(LC.d1 == fdirn || LC.d2 == fdirn)
			return reset()
	if(!use_cable(1))
		return reset()
	var/obj/structure/cable/NC = new /obj/structure/cable(new_turf)
	NC.cableColor("red")
	NC.d1 = 0
	NC.d2 = fdirn
	NC.updateicon()

	var/datum/powernet/PN
	if(last_piece && last_piece.d2 != chassis.dir)
		last_piece.d1 = min(last_piece.d2, chassis.dir)
		last_piece.d2 = max(last_piece.d2, chassis.dir)
		last_piece.updateicon()
		PN = last_piece.powernet

	if(isnull(PN))
		PN = new /datum/powernet()
	PN.add_cable(NC)
	NC.mergeConnectedNetworks(NC.d2)

	//NC.mergeConnectedNetworksOnTurf()
	last_piece = NC
	return 1