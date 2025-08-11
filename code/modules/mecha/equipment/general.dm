// Repair Droid
/obj/item/mecha_equipment/repair_droid
	name = "repair droid"
	desc = "An automated repair droid which scans an exosuit for damage and repairs it. Can fix almost all types of external or internal damage. \
		(Can be attached to: Any Exosuit)"
	icon_state = "repair_droid"
	matter_amounts = /datum/design/mechfab/equipment/general/repair_droid::materials
	origin_tech = /datum/design/mechfab/equipment/general/repair_droid::req_tech

	equip_cooldown = 2 SECONDS
	energy_drain = 100
	selectable = FALSE

	allow_duplicates = FALSE

	var/health_boost = 2
	var/icon/droid_overlay
	var/list/repairable_damage = list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH)

/obj/item/mecha_equipment/repair_droid/Destroy()
	chassis?.remove_overlay(droid_overlay)
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/item/mecha_equipment/repair_droid/attach(obj/mecha/M)
	. = ..()
	droid_overlay = new /icon(icon, icon_state = "repair_droid_idle")
	M.add_overlay(droid_overlay)

/obj/item/mecha_equipment/repair_droid/detach()
	chassis.remove_overlay(droid_overlay)
	STOP_PROCESSING(PCobj, src)
	. = ..()

/obj/item/mecha_equipment/repair_droid/get_equip_info()
	. = "[..()] - <a href='byond://?src=\ref[src];toggle_repairs=1'>[equip_ready ? "A" : "Dea"]ctivate</a>"

/obj/item/mecha_equipment/repair_droid/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("toggle_repairs"))
		chassis.remove_overlay(droid_overlay)
		if(equip_ready)
			START_PROCESSING(PCobj, src)
			droid_overlay = new /icon(icon, icon_state = "repair_droid_a")
			log_message("Activated.")
			set_ready_state(FALSE)
		else
			STOP_PROCESSING(PCobj, src)
			droid_overlay = new /icon(icon, icon_state = "repair_droid_idle")
			log_message("Deactivated.")
			set_ready_state(TRUE)
		chassis.add_overlay(droid_overlay)
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())

/obj/item/mecha_equipment/repair_droid/process()
	if(..() == PROCESS_KILL)
		return PROCESS_KILL

	var/repaired = FALSE
	if(chassis.internal_damage & MECHA_INT_SHORT_CIRCUIT)
		health_boost *= -2
	else if(chassis.internal_damage && prob(15))
		for(var/int_dam_flag in repairable_damage)
			if(chassis.internal_damage & int_dam_flag)
				chassis.clear_internal_damage(int_dam_flag)
				repaired = TRUE
				break

	if(health_boost < 0 || chassis.health < initial(chassis.health))
		chassis.health += min(health_boost, initial(chassis.health) - chassis.health)
		repaired = TRUE

	if(repaired)
		if(!chassis.use_power(energy_drain))
			set_ready_state(TRUE)
			return PROCESS_KILL
	else // Turns off if no repairs are needed.
		set_ready_state(TRUE)
		return PROCESS_KILL

// Teleporter
/obj/item/mecha_equipment/teleporter
	name = "teleporter"
	desc = "An exosuit module that allows limited teleportation to any position in view. (Can be attached to: Any Exosuit)"
	icon_state = "teleporter"
	matter_amounts = /datum/design/mechfab/equipment/general/teleporter::materials
	origin_tech = /datum/design/mechfab/equipment/general/teleporter::req_tech

	equip_cooldown = 15 SECONDS
	energy_drain = 1000
	equip_range = MECHA_EQUIP_RANGED

/obj/item/mecha_equipment/teleporter/action(atom/target)
	if(!..() || loc.z == 2)
		return FALSE
	var/turf/T = GET_TURF(target)
	if(isnull(T))
		return FALSE
	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_teleport(chassis, T, 4)
	start_cooldown()
	return TRUE

// Wormhole Generator
/obj/item/mecha_equipment/wormhole_generator
	name = "wormhole generator"
	desc = "An exosuit module that allows the generation of small quasi-stable wormholes. (Can be attached to: Any Exosuit)"
	icon_state = "wholegen"
	matter_amounts = /datum/design/mechfab/equipment/general/wormhole_gen::materials
	origin_tech = /datum/design/mechfab/equipment/general/wormhole_gen::req_tech

	equip_cooldown = 5 SECONDS
	energy_drain = 300
	equip_range = MECHA_EQUIP_RANGED

/obj/item/mecha_equipment/wormhole_generator/action(atom/target)
	if(!..() || loc.z == 2)
		return FALSE
	var/list/theareas = list()
	for(var/area/AR in orange(100, chassis))
		if(AR in theareas)
			continue
		theareas += AR
	if(!length(theareas))
		return FALSE
	var/area/thearea = pick(theareas)
	var/list/L = list()
	var/turf/pos = GET_TURF(src)
	for_no_type_check(var/turf/T, get_area_turfs(thearea.type))
		if(!T.density && pos.z == T.z)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L += T
	if(!length(L))
		return FALSE
	var/turf/target_turf = pick(L)
	if(!target_turf)
		return FALSE
	var/obj/effect/portal/P = new /obj/effect/portal(GET_TURF(target))
	P.target = target_turf
	P.creator = null
	P.icon = 'icons/obj/objects.dmi'
	P.failchance = 0
	P.icon_state = "anom"
	P.name = "wormhole"
	start_cooldown()
	qdel(src)
	spawn(rand(15 SECONDS, 30 SECONDS))
		qdel(P)
	return TRUE

// Gravitational Catapult
/obj/item/mecha_equipment/gravcatapult
	name = "gravitational catapult"
	desc = "An exosuit mounted Gravitational Catapult. (Can be attached to: Any Exosuit)"
	icon_state = "catapult"
	matter_amounts = /datum/design/mechfab/equipment/general/gravcatapult::materials
	origin_tech = /datum/design/mechfab/equipment/general/gravcatapult::req_tech

	equip_cooldown = 1 SECOND
	energy_drain = 100
	equip_range = MECHA_EQUIP_MELEE | MECHA_EQUIP_RANGED

	var/atom/movable/locked
	var/mode = 1 //1 - gravsling 2 - gravpush

	var/last_fired = 0  //Concept stolen from guns.
	var/fire_delay = 10 //Used to prevent spam-brute against humans.

/obj/item/mecha_equipment/gravcatapult/action(atom/movable/target)
	if(world.time >= last_fired + fire_delay)
		last_fired = world.time
	else
		if(world.time % 3)
			occupant_message(SPAN_WARNING("[src] is not ready to fire again!"))
		return FALSE

	if(!..())
		return FALSE

	switch(mode)
		if(1)
			if(!locked)
				if(!istype(target) || target.anchored)
					occupant_message("Unable to lock on [target].")
					return FALSE
				locked = target
				occupant_message("Locked on [target].")
				send_byjax(chassis.occupant, "exosuit.browser","\ref[src]", get_equip_info())
				return TRUE
			else if(target != locked)
				if(locked in view(chassis))
					locked.throw_at(target, 14, 1.5)
					locked = null
					send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())
					start_cooldown()
				else
					locked = null
					occupant_message("Lock on [locked] disengaged.")
					send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())
		if(2)
			var/list/atom/movable/atoms = null
			if(isturf(target))
				atoms = range(target, 3)
			else
				atoms = orange(target, 3)
			for_no_type_check(var/atom/movable/mover, atoms)
				if(mover.anchored)
					continue
				spawn(0)
					var/iter = 5 - get_dist(mover, target)
					for(var/i = 0 to iter)
						step_away(mover, target)
						sleep(2)
			start_cooldown()
	return TRUE

/obj/item/mecha_equipment/gravcatapult/get_equip_info()
	. = "[..()] [mode == 1 ? "([locked || "Nothing"])" : null] \[<a href='byond://?src=\ref[src];mode=1'>S</a>|<a href='byond://?src=\ref[src];mode=2'>P</a>\]"

/obj/item/mecha_equipment/gravcatapult/handle_topic(mob/user, datum/topic_input/topic)
	. = ..()
	if(!.)
		return FALSE

	if(topic.has("mode"))
		mode = topic.get_num("mode")
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", get_equip_info())