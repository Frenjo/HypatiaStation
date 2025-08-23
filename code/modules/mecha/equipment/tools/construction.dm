// RCD
/obj/item/mecha_equipment/tool/rcd
	name = "mounted RCD"
	desc = "An exosuit-mounted rapid-construction-device. (Can be attached to: Working Exosuits)"
	icon_state = "rcd"
	matter_amounts = /datum/design/mechfab/equipment/working/rcd::materials
	origin_tech = /datum/design/mechfab/equipment/working/rcd::req_tech

	equip_cooldown = 1 SECOND
	energy_drain = 250
	equip_range = MECHA_EQUIP_MELEE | MECHA_EQUIP_RANGED

	var/mode = 0 //0 - deconstruct, 1 - wall or floor, 2 - airlock.
	var/disabled = 0 //malf

/obj/item/mecha_equipment/tool/rcd/action(atom/target)
	if(!..())
		return FALSE
	if(istype(target, /turf/space/transit)) //>implying these are ever made -Sieve
		return FALSE
	if(!isturf(target) && !istype(target, /obj/machinery/door/airlock))
		target = GET_TURF(target)
	if(disabled || get_dist(chassis, target) > 3)
		return FALSE
	playsound(chassis, 'sound/machines/click.ogg', 50, 1)
	//meh
	switch(mode)
		if(0)
			if(istype(target, /turf/closed/wall))
				occupant_message("Deconstructing [target]...")
				if(do_after_cooldown(target))
					if(disabled)
						return FALSE
					chassis.spark_system.start()
					target:ChangeTurf(/turf/open/floor/plating/metal)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
			else if(isfloorturf(target))
				occupant_message("Deconstructing [target]...")
				if(do_after_cooldown(target))
					if(disabled)
						return FALSE
					chassis.spark_system.start()
					target:ChangeTurf(/turf/space)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
			else if(istype(target, /obj/machinery/door/airlock))
				occupant_message("Deconstructing [target]...")
				if(do_after_cooldown(target))
					if(disabled)
						return FALSE
					chassis.spark_system.start()
					qdel(target)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
		if(1)
			if(isspace(target))
				occupant_message("Building Floor...")
				if(do_after_cooldown(target, 2))
					if(disabled)
						return FALSE
					target:ChangeTurf(/turf/open/floor/plating/metal)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.spark_system.start()
			else if(isfloorturf(target))
				occupant_message("Building Wall...")
				if(do_after_cooldown(target, 2))
					if(disabled)
						return FALSE
					target:ChangeTurf(/turf/closed/wall/steel)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.spark_system.start()
		if(2)
			if(isfloorturf(target))
				occupant_message("Building Airlock...")
				if(do_after_cooldown(target, 2))
					if(disabled)
						return FALSE
					chassis.spark_system.start()
					var/obj/machinery/door/airlock/T = new /obj/machinery/door/airlock(target)
					T.autoclose = TRUE
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					playsound(target, 'sound/effects/sparks/sparks2.ogg', 50, 1)
	return TRUE

/obj/item/mecha_equipment/tool/rcd/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("mode"))
		mode = topic.get_num("mode")
		switch(mode)
			if(0)
				occupant_message("Switched RCD to Deconstruct.")
			if(1)
				occupant_message("Switched RCD to Construct.")
			if(2)
				occupant_message("Switched RCD to Construct Airlock.")

/obj/item/mecha_equipment/tool/rcd/get_equip_info()
	. = "[..()] \[<a href='byond://?src=\ref[src];mode=0'>D</a>|<a href='byond://?src=\ref[src];mode=1'>C</a>|<a href='byond://?src=\ref[src];mode=2'>A</a>\]"

// Cable Layer
/obj/item/mecha_equipment/tool/cable_layer
	name = "mounted cable layer"
	desc = "An exosuit-mounted cable layer. (Can be attached to: Working Exosuits)"
	icon_state = "cable_layer"

	equip_range = MECHA_EQUIP_MELEE

	var/turf/old_turf
	var/obj/structure/cable/last_piece
	var/obj/item/stack/cable_coil/cable
	var/max_cable = 1000

/obj/item/mecha_equipment/tool/cable_layer/initialise()
	. = ..()
	cable = new /obj/item/stack/cable_coil(src, 0)

/obj/item/mecha_equipment/tool/cable_layer/Destroy()
	last_piece = null
	QDEL_NULL(cable)
	return ..()

/obj/item/mecha_equipment/tool/cable_layer/action(obj/item/stack/cable_coil/target)
	if(!..())
		return FALSE
	var/result = load_cable(target)
	if(isnull(result))
		occupant_message(SPAN_WARNING("Unable to load \the [target] - no cable found."))
		return FALSE
	if(!result)
		occupant_message("Reel is full.")
		return FALSE

	occupant_message("[result] meters of cable successfully loaded.")
	send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())
	return TRUE

/obj/item/mecha_equipment/tool/cable_layer/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("toggle"))
		set_ready_state(!equip_ready)
		occupant_message("[src] [equip_ready ? "dea" : "a"]ctivated.")
		log_message("[equip_ready ? "Dea" : "A"]ctivated.")
		return
	if(topic.has("cut"))
		if(cable?.amount)
			var/m = round(input(chassis.occupant, "Please specify the length of cable to cut", "Cut cable", min(cable.amount, 30)), 1)
			m = min(m, cable.amount)
			if(m)
				use_cable(m)
				new /obj/item/stack/cable_coil(GET_TURF(chassis), m)
		else
			occupant_message(SPAN_WARNING("There's no more cable on the reel."))

/obj/item/mecha_equipment/tool/cable_layer/get_equip_info()
	. = "[..()] \[Cable: [cable ? cable.amount : 0] m\][cable?.amount ? "- <a href='byond://?src=\ref[src];toggle=1'>[!equip_ready ? "Dea" : "A"]ctivate</a>|<a href='byond://?src=\ref[src];cut=1'>Cut</a>" : null]"

/obj/item/mecha_equipment/tool/cable_layer/proc/load_cable(obj/item/stack/cable_coil/CC)
	if(istype(CC) && CC.amount)
		var/cur_amount = cable ? cable.amount : 0
		var/to_load = max(max_cable - cur_amount, 0)
		if(to_load)
			to_load = min(CC.amount, to_load)
			if(isnull(cable))
				cable = new /obj/item/stack/cable_coil(src, 0)
			cable.amount += to_load
			CC.use(to_load)
			return to_load
	return null

/obj/item/mecha_equipment/tool/cable_layer/proc/use_cable(amount)
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

/obj/item/mecha_equipment/tool/cable_layer/proc/reset()
	last_piece = null

/obj/item/mecha_equipment/tool/cable_layer/proc/dismantle_floor(turf/new_turf)
	if(isfloorturf(new_turf))
		var/turf/open/floor/T = new_turf
		if(!istype(new_turf, /turf/open/floor/plating/metal))
			if(!T.broken && !T.burnt)
				new T.tile_path(T)
			T.make_plating()
	return !new_turf.intact

/obj/item/mecha_equipment/tool/cable_layer/handle_movement_action()
	var/turf/new_turf = GET_TURF(chassis)

	if(equip_ready || !istype(new_turf) || !dismantle_floor(new_turf))
		return reset()

	var/fdirn = turn(chassis.dir, 180)
	for(var/obj/structure/cable/existing_cable in new_turf) // check to make sure there's not a cable there already
		if(existing_cable.d1 == fdirn || existing_cable.d2 == fdirn)
			return reset()

	if(!use_cable(1))
		return reset()

	var/obj/structure/cable/new_cable = new /obj/structure/cable(new_turf)
	new_cable.cableColor("red")
	new_cable.d1 = 0
	new_cable.d2 = fdirn
	new_cable.updateicon()

	var/datum/powernet/power_net
	if(last_piece && last_piece.d2 != chassis.dir)
		last_piece.d1 = min(last_piece.d2, chassis.dir)
		last_piece.d2 = max(last_piece.d2, chassis.dir)
		last_piece.updateicon()
		power_net = last_piece.powernet

	if(isnull(power_net))
		power_net = new /datum/powernet()
	power_net.add_cable(new_cable)
	new_cable.mergeConnectedNetworks(new_cable.d2)

	//new_cable.mergeConnectedNetworksOnTurf()
	last_piece = new_cable
	return 1