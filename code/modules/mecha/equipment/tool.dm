// Hydraulic Clamp
/obj/item/mecha_part/equipment/tool/hydraulic_clamp
	name = "hydraulic clamp"
	desc = "An exosuit-mounted hydraulic clamp with cargo loading capability. (Can be attached to: Working Exosuits)"
	icon_state = "mecha_clamp"
	equip_cooldown = 15
	energy_drain = 10

	var/dam_force = 20
	var/obj/mecha/working/cargo_holder

/obj/item/mecha_part/equipment/tool/hydraulic_clamp/attach(obj/mecha/M)
	. = ..()
	cargo_holder = M

/obj/item/mecha_part/equipment/tool/hydraulic_clamp/action(atom/target)
	if(!action_checks(target))
		return
	if(!cargo_holder)
		return
	if(istype(target, /obj/structure/stool))
		return
	for(var/M in target.contents)
		if(isliving(M))
			return

	if(isobj(target))
		var/obj/O = target
		if(!O.anchored)
			if(length(cargo_holder.cargo) < cargo_holder.cargo_capacity)
				occupant_message("You lift [target] and start to load it into cargo compartment.")
				chassis.visible_message("[chassis] lifts [target] and starts to load it into cargo compartment.")
				set_ready_state(0)
				chassis.use_power(energy_drain)
				O.anchored = TRUE
				var/T = chassis.loc
				if(do_after_cooldown(target))
					if(T == chassis.loc && src == chassis.selected)
						cargo_holder.cargo += O
						O.loc = chassis
						O.anchored = FALSE
						occupant_message("<font color='blue'>[target] succesfully loaded.</font>")
						log_message("Loaded [O]. Cargo compartment capacity: [cargo_holder.cargo_capacity - length(cargo_holder.cargo)]")
					else
						occupant_message("<font color='red'>You must hold still while handling objects.</font>")
						O.anchored = initial(O.anchored)
			else
				occupant_message("<font color='red'>Not enough room in cargo compartment.</font>")
		else
			occupant_message("<font color='red'>[target] is firmly secured.</font>")

	else if(isliving(target))
		var/mob/living/M = target
		if(M.stat > 1)
			return
		if(chassis.occupant.a_intent == "hurt")
			M.take_overall_damage(dam_force)
			M.adjustOxyLoss(round(dam_force / 2))
			M.updatehealth()
			occupant_message(SPAN_WARNING("You squeeze [target] with [name]. Something cracks."))
			chassis.visible_message(SPAN_WARNING("[chassis] squeezes [target]."))
		else
			step_away(M, chassis)
			occupant_message("You push [target] out of the way.")
			chassis.visible_message("[chassis] pushes [target] out of the way.")
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
	return 1

// Safety Clamp (Kill Clamp)
// This is pretty much just for the death-ripley so that it is harmless.
/obj/item/mecha_part/equipment/tool/safety_clamp
	name = "kill clamp"
	desc = "An exosuit-mounted hydraulic clamp with KILL CAPABILITY. (Can be attached to: Working Exosuits)"
	icon_state = "mecha_clamp"
	equip_cooldown = 15
	energy_drain = 0

	var/dam_force = 0
	var/obj/mecha/working/cargo_holder

/obj/item/mecha_part/equipment/tool/safety_clamp/attach(obj/mecha/M)
	. = ..()
	cargo_holder = M

/obj/item/mecha_part/equipment/tool/safety_clamp/action(atom/target)
	if(!action_checks(target))
		return
	if(!cargo_holder)
		return
	if(isobj(target))
		var/obj/O = target
		if(!O.anchored)
			if(length(cargo_holder.cargo) < cargo_holder.cargo_capacity)
				chassis.occupant_message("You lift [target] and start to load it into cargo compartment.")
				chassis.visible_message("[chassis] lifts [target] and starts to load it into cargo compartment.")
				set_ready_state(0)
				chassis.use_power(energy_drain)
				O.anchored = TRUE
				var/T = chassis.loc
				if(do_after_cooldown(target))
					if(T == chassis.loc && src == chassis.selected)
						cargo_holder.cargo += O
						O.loc = chassis
						O.anchored = FALSE
						chassis.occupant_message("<font color='blue'>[target] succesfully loaded.</font>")
						chassis.log_message("Loaded [O]. Cargo compartment capacity: [cargo_holder.cargo_capacity - length(cargo_holder.cargo)]")
					else
						chassis.occupant_message("<font color='red'>You must hold still while handling objects.</font>")
						O.anchored = initial(O.anchored)
			else
				chassis.occupant_message("<font color='red'>Not enough room in cargo compartment.</font>")
		else
			chassis.occupant_message("<font color='red'>[target] is firmly secured.</font>")

	else if(isliving(target))
		var/mob/living/M = target
		if(M.stat > 1)
			return
		if(chassis.occupant.a_intent == "hurt")
			chassis.occupant_message("\red You obliterate [target] with [name], leaving blood and guts everywhere.")
			chassis.visible_message("\red [chassis] destroys [target] in an unholy fury.")
		if(chassis.occupant.a_intent == "disarm")
			chassis.occupant_message("\red You tear [target]'s limbs off with [name].")
			chassis.visible_message("\red [chassis] rips [target]'s arms off.")
		else
			step_away(M,chassis)
			chassis.occupant_message("You smash into [target], sending them flying.")
			chassis.visible_message("[chassis] tosses [target] like a piece of paper.")
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
	return 1

// Drill
/obj/item/mecha_part/equipment/tool/drill
	name = "drill"
	desc = "This is the drill that'll pierce the heavens! (Can be attached to: Working and Combat Exosuits)"
	icon_state = "mecha_drill"
	equip_cooldown = 30
	energy_drain = 10
	force = 15

/obj/item/mecha_part/equipment/tool/drill/action(atom/target)
	if(!action_checks(target))
		return
	if(isobj(target))
		var/obj/target_obj = target
		if(!target_obj.vars.Find("unacidable") || target_obj.unacidable)
			return
	set_ready_state(0)
	chassis.use_power(energy_drain)
	chassis.visible_message("<font color='red'><b>[chassis] starts to drill [target]</b></font>", "You hear the drill.")
	occupant_message("<font color='red'><b>You start to drill [target]</b></font>")
	var/T = chassis.loc
	var/C = target.loc	//why are these backwards? we may never know -Pete
	if(do_after_cooldown(target))
		if(T == chassis.loc && src == chassis.selected)
			if(istype(target, /turf/closed/wall/reinforced))
				occupant_message("<font color='red'>[target] is too durable to drill through.</font>")
			else if(istype(target, /turf/closed/rock))
				for(var/turf/closed/rock/M in range(chassis, 1))
					if(get_dir(chassis, M) & chassis.dir)
						M.get_drilled()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_part/equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/ore/ore in range(chassis, 1))
							if(get_dir(chassis,ore)&chassis.dir)
								ore.Move(ore_box)
			else if(istype(target, /turf/open/floor/plating/asteroid/airless))
				for(var/turf/open/floor/plating/asteroid/airless/M in range(chassis, 1))
					if(get_dir(chassis, M) & chassis.dir)
						M.gets_dug()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_part/equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/ore/ore in range(chassis, 1))
							if(get_dir(chassis, ore) & chassis.dir)
								ore.Move(ore_box)
			else if(target.loc == C)
				log_message("Drilled through [target]")
				target.ex_act(2)
	return 1

// Diamond Drill
/obj/item/mecha_part/equipment/tool/drill/diamond
	name = "diamond drill"
	desc = "This is an upgraded version of the drill that'll pierce the heavens! (Can be attached to: Working and Combat Exosuits)"
	icon_state = "mecha_diamond_drill"
	origin_tech = list(/datum/tech/materials = 4, /datum/tech/engineering = 3)
	construction_cost = list(MATERIAL_METAL = 10000, /decl/material/diamond = 6500)
	equip_cooldown = 20
	force = 15

/obj/item/mecha_part/equipment/tool/drill/diamond/action(atom/target)
	if(!action_checks(target))
		return
	if(isobj(target))
		var/obj/target_obj = target
		if(target_obj.unacidable)
			return
	set_ready_state(0)
	chassis.use_power(energy_drain)
	chassis.visible_message("<font color='red'><b>[chassis] starts to drill [target]</b></font>", "You hear the drill.")
	occupant_message("<font color='red'><b>You start to drill [target]</b></font>")
	var/T = chassis.loc
	var/C = target.loc	//why are these backwards? we may never know -Pete
	if(do_after_cooldown(target))
		if(T == chassis.loc && src == chassis.selected)
			if(istype(target, /turf/closed/wall/reinforced))
				if(do_after_cooldown(target))//To slow down how fast mechs can drill through the station
					log_message("Drilled through [target]")
					target.ex_act(3)
			else if(istype(target, /turf/closed/rock))
				for(var/turf/closed/rock/M in range(chassis, 1))
					if(get_dir(chassis, M) & chassis.dir)
						M.get_drilled()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_part/equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/ore/ore in range(chassis, 1))
							if(get_dir(chassis, ore) & chassis.dir)
								ore.Move(ore_box)
			else if(istype(target,/turf/open/floor/plating/asteroid/airless))
				for(var/turf/open/floor/plating/asteroid/airless/M in range(target, 1))
					M.gets_dug()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_part/equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/ore/ore in range(target, 1))
							ore.Move(ore_box)
			else if(target.loc == C)
				log_message("Drilled through [target]")
				target.ex_act(2)
	return 1

// Extinguisher
/obj/item/mecha_part/equipment/tool/extinguisher
	name = "extinguisher"
	desc = "An exosuit-mounted fire extinguisher. (Can be attached to: Working Exosuits)"
	icon_state = "mecha_exting"
	equip_cooldown = 5
	energy_drain = 0
	range = MELEE|RANGED

/obj/item/mecha_part/equipment/tool/extinguisher/New()
	create_reagents(200)
	reagents.add_reagent("water", 200)
	. = ..()

/obj/item/mecha_part/equipment/tool/extinguisher/action(atom/target) //copypasted from extinguisher. TODO: Rewrite from scratch.
	if(!action_checks(target) || get_dist(chassis, target) > 3)
		return
	if(get_dist(chassis, target) > 2)
		return
	set_ready_state(0)
	if(do_after_cooldown(target))
		if(istype(target, /obj/structure/reagent_dispensers/watertank) && get_dist(chassis, target) <= 1)
			var/obj/o = target
			o.reagents.trans_to(src, 200)
			occupant_message("\blue Extinguisher refilled")
			playsound(chassis, 'sound/effects/refill.ogg', 50, 1, -6)
		else
			if(reagents.total_volume > 0)
				playsound(chassis, 'sound/effects/extinguish.ogg', 75, 1, -3)
				var/direction = get_dir(chassis,target)
				var/turf/T = GET_TURF(target)
				var/turf/T1 = get_step(T, turn(direction, 90))
				var/turf/T2 = get_step(T, turn(direction, -90))

				var/list/the_targets = list(T, T1, T2)
				spawn(0)
					for(var/a = 0, a < 5, a++)
						var/obj/effect/water/W = new /obj/effect/water(GET_TURF(chassis))
						if(isnull(W))
							return
						var/turf/my_target = pick(the_targets)
						W.create_reagents(5)
						reagents.trans_to(W, 1)
						for(var/b = 0, b < 4, b++)
							if(isnull(W))
								return
							step_towards(W, my_target)
							if(isnull(W))
								return
							var/turf/W_turf = GET_TURF(W)
							W.reagents.reaction(W_turf)
							for_no_type_check(var/atom/movable/mover, W_turf)
								W.reagents.reaction(mover)
							if(W.loc == my_target)
								break
							sleep(2)
	return 1

/obj/item/mecha_part/equipment/tool/extinguisher/get_equip_info()
	return "[..()] \[[reagents.total_volume]\]"

/obj/item/mecha_part/equipment/tool/extinguisher/on_reagent_change()
	return

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
			else if(istype(target, /turf/open/floor))
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
			else if(istype(target, /turf/open/floor))
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
			if(istype(target, /turf/open/floor))
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

// Mime RCD
/obj/item/mecha_part/equipment/tool/mimercd
	name = "mounted MRCD"
	desc = "An exosuit-mounted mime-rapid-construction-device. (Can be attached to: Reticence)"
	icon_state = "mecha_rcd"
	origin_tech = list(
		/datum/tech/materials = 4, /datum/tech/magnets = 4, /datum/tech/engineering = 4,
		/datum/tech/power_storage = 4, /datum/tech/bluespace = 3
	)
	equip_cooldown = 10
	energy_drain = 250
	range = MELEE | RANGED

	construction_time = 1200
	construction_cost = list(
		MATERIAL_METAL = 30000, /decl/material/silver = 20000,
		/decl/material/gold = 20000, /decl/material/plasma = 25000,
		/decl/material/bananium = 10000 // This is a placeholder for tranquilite.
	)

/obj/item/mecha_part/equipment/tool/mimercd/can_attach(obj/mecha/combat/reticence/M)
	if(!istype(M))
		return FALSE
	return ..()

/obj/item/mecha_part/equipment/tool/mimercd/action(atom/target)
	if(istype(target, /turf/space/transit)) //>implying these are ever made -Sieve
		return
	if(!action_checks(target) || get_dist(chassis, target) > 3)
		return
	if(!isturf(target))
		target = GET_TURF(target)

	if(istype(target, /turf/open/floor))
		occupant_message("Miming Wall...")
		if(do_after_cooldown(target))
			new /obj/effect/forcefield/mime(target)
			chassis.visible_message(
				SPAN_INFO("[chassis] looks as if a wall is in front of it.")
			)
			chassis.spark_system.start()

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

/obj/item/mecha_part/equipment/tool/cable_layer/attach()
	. = ..()
	event = chassis.events.addEvent("onMove", src, "layCable")

/obj/item/mecha_part/equipment/tool/cable_layer/detach()
	chassis.events.clearEvent("onMove", event)
	return ..()

/obj/item/mecha_part/equipment/tool/cable_layer/destroy()
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
	if(istype(new_turf, /turf/open/floor))
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