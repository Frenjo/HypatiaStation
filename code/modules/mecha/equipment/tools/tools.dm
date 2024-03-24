/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp
	name = "hydraulic clamp"
	icon_state = "mecha_clamp"
	equip_cooldown = 15
	energy_drain = 10

	var/dam_force = 20
	var/obj/mecha/working/ripley/cargo_holder

/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp/can_attach(obj/mecha/working/ripley/M as obj)
	if(..())
		if(istype(M))
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp/attach(obj/mecha/M as obj)
	..()
	cargo_holder = M
	return

/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp/action(atom/target)
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
			occupant_message(SPAN_WARNING("You squeeze [target] with [src.name]. Something cracks."))
			chassis.visible_message(SPAN_WARNING("[chassis] squeezes [target]."))
		else
			step_away(M, chassis)
			occupant_message("You push [target] out of the way.")
			chassis.visible_message("[chassis] pushes [target] out of the way.")
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
	return 1


/obj/item/mecha_parts/mecha_equipment/tool/drill
	name = "drill"
	desc = "This is the drill that'll pierce the heavens! (Can be attached to: Combat and Engineering Exosuits)"
	icon_state = "mecha_drill"
	equip_cooldown = 30
	energy_drain = 10
	force = 15

/obj/item/mecha_parts/mecha_equipment/tool/drill/action(atom/target)
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
			if(istype(target, /turf/simulated/wall/r_wall))
				occupant_message("<font color='red'>[target] is too durable to drill through.</font>")
			else if(istype(target, /turf/simulated/mineral))
				for(var/turf/simulated/mineral/M in range(chassis, 1))
					if(get_dir(chassis, M) & chassis.dir)
						M.get_drilled()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/ore/ore in range(chassis, 1))
							if(get_dir(chassis,ore)&chassis.dir)
								ore.Move(ore_box)
			else if(istype(target, /turf/simulated/floor/plating/airless/asteroid))
				for(var/turf/simulated/floor/plating/airless/asteroid/M in range(chassis, 1))
					if(get_dir(chassis, M) & chassis.dir)
						M.gets_dug()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/ore/ore in range(chassis, 1))
							if(get_dir(chassis, ore) & chassis.dir)
								ore.Move(ore_box)
			else if(target.loc == C)
				log_message("Drilled through [target]")
				target.ex_act(2)
	return 1

/obj/item/mecha_parts/mecha_equipment/tool/drill/can_attach(obj/mecha/M as obj)
	if(..())
		if(istype(M, /obj/mecha/working) || istype(M, /obj/mecha/combat))
			return 1
	return 0


/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill
	name = "diamond drill"
	desc = "This is an upgraded version of the drill that'll pierce the heavens! (Can be attached to: Combat and Engineering Exosuits)"
	icon_state = "mecha_diamond_drill"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_ENGINEERING = 3)
	construction_cost = list(MATERIAL_METAL = 10000, MATERIAL_DIAMOND = 6500)
	equip_cooldown = 20
	force = 15

/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill/action(atom/target)
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
			if(istype(target, /turf/simulated/wall/r_wall))
				if(do_after_cooldown(target))//To slow down how fast mechs can drill through the station
					log_message("Drilled through [target]")
					target.ex_act(3)
			else if(istype(target, /turf/simulated/mineral))
				for(var/turf/simulated/mineral/M in range(chassis, 1))
					if(get_dir(chassis, M) & chassis.dir)
						M.get_drilled()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/ore/ore in range(chassis, 1))
							if(get_dir(chassis, ore) & chassis.dir)
								ore.Move(ore_box)
			else if(istype(target,/turf/simulated/floor/plating/airless/asteroid))
				for(var/turf/simulated/floor/plating/airless/asteroid/M in range(target, 1))
					M.gets_dug()
				log_message("Drilled through [target]")
				if(locate(/obj/item/mecha_parts/mecha_equipment/tool/hydraulic_clamp) in chassis.equipment)
					var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in chassis:cargo
					if(ore_box)
						for(var/obj/item/ore/ore in range(target, 1))
							ore.Move(ore_box)
			else if(target.loc == C)
				log_message("Drilled through [target]")
				target.ex_act(2)
	return 1

/obj/item/mecha_parts/mecha_equipment/tool/drill/diamonddrill/can_attach(obj/mecha/M as obj)
	if(..())
		if(istype(M, /obj/mecha/working) || istype(M, /obj/mecha/combat))
			return 1
	return 0


/obj/item/mecha_parts/mecha_equipment/tool/extinguisher
	name = "extinguisher"
	desc = "Exosuit-mounted extinguisher (Can be attached to: Engineering exosuits)"
	icon_state = "mecha_exting"
	equip_cooldown = 5
	energy_drain = 0
	range = MELEE|RANGED

/obj/item/mecha_parts/mecha_equipment/tool/extinguisher/New()
	create_reagents(200)
	reagents.add_reagent("water", 200)
	. = ..()

/obj/item/mecha_parts/mecha_equipment/tool/extinguisher/action(atom/target) //copypasted from extinguisher. TODO: Rewrite from scratch.
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
			if(src.reagents.total_volume > 0)
				playsound(chassis, 'sound/effects/extinguish.ogg', 75, 1, -3)
				var/direction = get_dir(chassis,target)
				var/turf/T = get_turf(target)
				var/turf/T1 = get_step(T, turn(direction, 90))
				var/turf/T2 = get_step(T, turn(direction, -90))

				var/list/the_targets = list(T, T1, T2)
				spawn(0)
					for(var/a = 0, a < 5, a++)
						var/obj/effect/water/W = new /obj/effect/water(get_turf(chassis))
						if(!W)
							return
						var/turf/my_target = pick(the_targets)
						W.create_reagents(5)
						src.reagents.trans_to(W, 1)
						for(var/b = 0, b < 4, b++)
							if(!W)
								return
							step_towards(W, my_target)
							if(!W)
								return
							var/turf/W_turf = get_turf(W)
							W.reagents.reaction(W_turf)
							for(var/atom/atm in W_turf)
								W.reagents.reaction(atm)
							if(W.loc == my_target)
								break
							sleep(2)
	return 1

/obj/item/mecha_parts/mecha_equipment/tool/extinguisher/get_equip_info()
	return "[..()] \[[src.reagents.total_volume]\]"

/obj/item/mecha_parts/mecha_equipment/tool/extinguisher/on_reagent_change()
	return

/obj/item/mecha_parts/mecha_equipment/tool/extinguisher/can_attach(obj/mecha/working/M as obj)
	if(..())
		if(istype(M))
			return 1
	return 0


/obj/item/mecha_parts/mecha_equipment/tool/rcd
	name = "mounted RCD"
	desc = "An exosuit-mounted rapid-construction-device. (Can be attached to: Any exosuit)"
	icon_state = "mecha_rcd"
	origin_tech = list(
		RESEARCH_TECH_MATERIALS = 4, RESEARCH_TECH_BLUESPACE = 3, RESEARCH_TECH_MAGNETS = 4,
		RESEARCH_TECH_POWERSTORAGE = 4
	)
	equip_cooldown = 10
	energy_drain = 250
	range = MELEE|RANGED
	construction_time = 1200
	construction_cost = list(MATERIAL_METAL = 30000, MATERIAL_PLASMA = 25000, MATERIAL_SILVER = 20000, MATERIAL_GOLD = 20000)
	var/mode = 0 //0 - deconstruct, 1 - wall or floor, 2 - airlock.
	var/disabled = 0 //malf

/obj/item/mecha_parts/mecha_equipment/tool/rcd/action(atom/target)
	if(istype(target, /area/shuttle) || istype(target, /turf/space/transit))	//>implying these are ever made -Sieve
		disabled = 1
	else
		disabled = 0
	if(!isturf(target) && !istype(target, /obj/machinery/door/airlock))
		target = get_turf(target)
	if(!action_checks(target) || disabled || get_dist(chassis, target) > 3)
		return
	playsound(chassis, 'sound/machines/click.ogg', 50, 1)
	//meh
	switch(mode)
		if(0)
			if(istype(target, /turf/simulated/wall))
				occupant_message("Deconstructing [target]...")
				set_ready_state(0)
				if(do_after_cooldown(target))
					if(disabled)
						return
					chassis.spark_system.start()
					target:ChangeTurf(/turf/simulated/floor/plating)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.use_power(energy_drain)
			else if(istype(target, /turf/simulated/floor))
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
					target:ChangeTurf(/turf/simulated/floor/plating)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.spark_system.start()
					chassis.use_power(energy_drain * 2)
			else if(istype(target, /turf/simulated/floor))
				occupant_message("Building Wall...")
				set_ready_state(0)
				if(do_after_cooldown(target))
					if(disabled)
						return
					target:ChangeTurf(/turf/simulated/wall)
					playsound(target, 'sound/items/Deconstruct.ogg', 50, 1)
					chassis.spark_system.start()
					chassis.use_power(energy_drain * 2)
		if(2)
			if(istype(target, /turf/simulated/floor))
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

/obj/item/mecha_parts/mecha_equipment/tool/rcd/Topic(href,href_list)
	..()
	if(href_list["mode"])
		mode = text2num(href_list["mode"])
		switch(mode)
			if(0)
				occupant_message("Switched RCD to Deconstruct.")
			if(1)
				occupant_message("Switched RCD to Construct.")
			if(2)
				occupant_message("Switched RCD to Construct Airlock.")
	return

/obj/item/mecha_parts/mecha_equipment/tool/rcd/get_equip_info()
	return "[..()] \[<a href='?src=\ref[src];mode=0'>D</a>|<a href='?src=\ref[src];mode=1'>C</a>|<a href='?src=\ref[src];mode=2'>A</a>\]"


/obj/item/mecha_parts/mecha_equipment/teleporter
	name = "teleporter"
	desc = "An exosuit module that allows exosuits to teleport to any position in view."
	icon_state = "mecha_teleport"
	origin_tech = list(RESEARCH_TECH_BLUESPACE = 10)
	equip_cooldown = 150
	energy_drain = 1000
	range = RANGED

/obj/item/mecha_parts/mecha_equipment/teleporter/action(atom/target)
	if(!action_checks(target) || src.loc.z == 2)
		return
	var/turf/T = get_turf(target)
	if(T)
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_teleport(chassis, T, 4)
		do_after_cooldown()
	return


/obj/item/mecha_parts/mecha_equipment/wormhole_generator
	name = "wormhole generator"
	desc = "An exosuit module that allows generating of small quasi-stable wormholes."
	icon_state = "mecha_wholegen"
	origin_tech = list(RESEARCH_TECH_BLUESPACE = 3)
	equip_cooldown = 50
	energy_drain = 300
	range = RANGED

/obj/item/mecha_parts/mecha_equipment/wormhole_generator/action(atom/target)
	if(!action_checks(target) || src.loc.z == 2)
		return
	var/list/theareas = list()
	for(var/area/AR in orange(100, chassis))
		if(AR in theareas)
			continue
		theareas += AR
	if(!length(theareas))
		return
	var/area/thearea = pick(theareas)
	var/list/L = list()
	var/turf/pos = get_turf(src)
	for(var/turf/T in get_area_turfs(thearea.type))
		if(!T.density && pos.z == T.z)
			var/clear = 1
			for(var/obj/O in T)
				if(O.density)
					clear = 0
					break
			if(clear)
				L += T
	if(!length(L))
		return
	var/turf/target_turf = pick(L)
	if(!target_turf)
		return
	chassis.use_power(energy_drain)
	set_ready_state(0)
	var/obj/effect/portal/P = new /obj/effect/portal(get_turf(target))
	P.target = target_turf
	P.creator = null
	P.icon = 'icons/obj/objects.dmi'
	P.failchance = 0
	P.icon_state = "anom"
	P.name = "wormhole"
	do_after_cooldown()
	qdel(src)
	spawn(rand(150,300))
		qdel(P)
	return


/obj/item/mecha_parts/mecha_equipment/gravcatapult
	name = "gravitational catapult"
	desc = "An exosuit mounted Gravitational Catapult."
	icon_state = "mecha_teleport"
	origin_tech = list(RESEARCH_TECH_BLUESPACE = 2, RESEARCH_TECH_MAGNETS = 3)
	equip_cooldown = 10
	energy_drain = 100
	range = MELEE|RANGED
	var/atom/movable/locked
	var/mode = 1 //1 - gravsling 2 - gravpush

	var/last_fired = 0  //Concept stolen from guns.
	var/fire_delay = 10 //Used to prevent spam-brute against humans.

/obj/item/mecha_parts/mecha_equipment/gravcatapult/action(atom/movable/target)
	if(world.time >= last_fired + fire_delay)
		last_fired = world.time
	else
		if(world.time % 3)
			occupant_message(SPAN_WARNING("[src] is not ready to fire again!"))
		return 0

	switch(mode)
		if(1)
			if(!action_checks(target) && !locked)
				return
			if(!locked)
				if(!istype(target) || target.anchored)
					occupant_message("Unable to lock on [target].")
					return
				locked = target
				occupant_message("Locked on [target].")
				send_byjax(chassis.occupant, "exosuit.browser","\ref[src]",src.get_equip_info())
				return
			else if(target!=locked)
				if(locked in view(chassis))
					locked.throw_at(target, 14, 1.5)
					locked = null
					send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", src.get_equip_info())
					set_ready_state(0)
					chassis.use_power(energy_drain)
					do_after_cooldown()
				else
					locked = null
					occupant_message("Lock on [locked] disengaged.")
					send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", src.get_equip_info())
		if(2)
			if(!action_checks(target))
				return
			var/list/atoms = list()
			if(isturf(target))
				atoms = range(target, 3)
			else
				atoms = orange(target, 3)
			for(var/atom/movable/A in atoms)
				if(A.anchored) continue
				spawn(0)
					var/iter = 5 - get_dist(A, target)
					for(var/i = 0 to iter)
						step_away(A, target)
						sleep(2)
			set_ready_state(0)
			chassis.use_power(energy_drain)
			do_after_cooldown()
	return

/obj/item/mecha_parts/mecha_equipment/gravcatapult/get_equip_info()
	return "[..()] [mode == 1 ? "([locked || "Nothing"])" : null] \[<a href='?src=\ref[src];mode=1'>S</a>|<a href='?src=\ref[src];mode=2'>P</a>\]"

/obj/item/mecha_parts/mecha_equipment/gravcatapult/Topic(href, href_list)
	..()
	if(href_list["mode"])
		mode = text2num(href_list["mode"])
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", src.get_equip_info())
	return


/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster //what is that noise? A BAWWW from TK mutants.
	name = "armour booster module (close combat weaponry)"
	desc = "Boosts exosuit armour against armed melee attacks. Requires energy to operate."
	icon_state = "mecha_abooster_ccw"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 3)
	equip_cooldown = 10
	energy_drain = 50
	range = 0
	construction_cost = list(MATERIAL_METAL = 20000, MATERIAL_SILVER = 5000)

	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster/can_attach(obj/mecha/M as obj)
	if(..())
		if(!istype(M, /obj/mecha/combat/honker))
			if(!M.proc_res["dynattackby"])
				return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster/attach(obj/mecha/M as obj)
	..()
	chassis.proc_res["dynattackby"] = src
	return

/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster/detach()
	chassis.proc_res["dynattackby"] = null
	..()
	return

/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster/get_equip_info()
	if(!chassis)
		return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name]"

/obj/item/mecha_parts/mecha_equipment/anticcw_armor_booster/proc/dynattackby(obj/item/W as obj, mob/user as mob)
	if(!action_checks(user))
		return chassis.dynattackby(W,user)
	chassis.log_message("Attacked by [W]. Attacker - [user]")
	if(prob(chassis.deflect_chance * deflect_coeff))
		user << "\red The [W] bounces off [chassis] armor."
		chassis.log_append_to_last("Armor saved.")
	else
		chassis.occupant_message("<font color='red'><b>[user] hits [chassis] with [W].</b></font>")
		user.visible_message("<font color='red'><b>[user] hits [chassis] with [W].</b></font>", "<font color='red'><b>You hit [src] with [W].</b></font>")
		chassis.take_damage(round(W.force * damage_coeff), W.damtype)
		chassis.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))
	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()
	return


/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster
	name = "armour booster module (ranged weaponry)"
	desc = "Boosts exosuit armour against ranged attacks. Completely blocks taser shots. Requires energy to operate."
	icon_state = "mecha_abooster_proj"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 4)
	equip_cooldown = 10
	energy_drain = 50
	range = 0
	construction_cost = list(MATERIAL_METAL = 20000, MATERIAL_GOLD = 5000)

	var/deflect_coeff = 1.15
	var/damage_coeff = 0.8

/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster/can_attach(obj/mecha/M as obj)
	if(..())
		if(!istype(M, /obj/mecha/combat/honker))
			if(!M.proc_res["dynbulletdamage"] && !M.proc_res["dynhitby"])
				return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster/attach(obj/mecha/M as obj)
	..()
	chassis.proc_res["dynbulletdamage"] = src
	chassis.proc_res["dynhitby"] = src
	return

/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster/detach()
	chassis.proc_res["dynbulletdamage"] = null
	chassis.proc_res["dynhitby"] = null
	..()
	return

/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster/get_equip_info()
	if(!chassis)
		return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name]"

/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster/proc/dynbulletdamage(obj/item/projectile/Proj)
	if(!action_checks(src))
		return chassis.dynbulletdamage(Proj)
	if(prob(chassis.deflect_chance * deflect_coeff))
		chassis.occupant_message("\blue The armor deflects incoming projectile.")
		chassis.visible_message("The [chassis.name] armor deflects the projectile")
		chassis.log_append_to_last("Armor saved.")
	else
		chassis.take_damage(round(Proj.damage * src.damage_coeff), Proj.flag)
		chassis.check_for_internal_damage(list(MECHA_INT_FIRE, MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))
		Proj.on_hit(chassis)
	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()
	return

/obj/item/mecha_parts/mecha_equipment/antiproj_armor_booster/proc/dynhitby(atom/movable/A)
	if(!action_checks(A))
		return chassis.dynhitby(A)
	if(prob(chassis.deflect_chance * deflect_coeff) || isliving(A) || istype(A, /obj/item/mecha_parts/mecha_tracking))
		chassis.occupant_message("\blue The [A] bounces off the armor.")
		chassis.visible_message("The [A] bounces off the [chassis] armor")
		chassis.log_append_to_last("Armor saved.")
		if(isliving(A))
			var/mob/living/M = A
			M.take_organ_damage(10)
	else if(isobj(A))
		var/obj/O = A
		if(O.throwforce)
			chassis.take_damage(round(O.throwforce * damage_coeff))
			chassis.check_for_internal_damage(list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH, MECHA_INT_CONTROL_LOST))
	set_ready_state(0)
	chassis.use_power(energy_drain)
	do_after_cooldown()
	return


/obj/item/mecha_parts/mecha_equipment/repair_droid
	name = "repair droid"
	desc = "Automated repair droid. Scans exosuit for damage and repairs it. Can fix almost all types of external or internal damage."
	icon_state = "repair_droid"
	origin_tech = list(RESEARCH_TECH_MAGNETS = 3, RESEARCH_TECH_PROGRAMMING = 3)
	equip_cooldown = 20
	energy_drain = 100
	range = 0
	construction_cost = list(MATERIAL_METAL = 10000, MATERIAL_GOLD = 1000, MATERIAL_SILVER = 2000, MATERIAL_GLASS = 5000)

	var/health_boost = 2
	var/datum/global_iterator/pr_repair_droid
	var/icon/droid_overlay
	var/list/repairable_damage = list(MECHA_INT_TEMP_CONTROL, MECHA_INT_TANK_BREACH)

/obj/item/mecha_parts/mecha_equipment/repair_droid/New()
	..()
	pr_repair_droid = new /datum/global_iterator/mecha_repair_droid(list(src), 0)
	pr_repair_droid.set_delay(equip_cooldown)
	return

/obj/item/mecha_parts/mecha_equipment/repair_droid/attach(obj/mecha/M as obj)
	..()
	droid_overlay = new(src.icon, icon_state = "repair_droid")
	M.overlays += droid_overlay
	return

/obj/item/mecha_parts/mecha_equipment/repair_droid/destroy()
	chassis.overlays -= droid_overlay
	..()
	return

/obj/item/mecha_parts/mecha_equipment/repair_droid/detach()
	chassis.overlays -= droid_overlay
	pr_repair_droid.stop()
	..()
	return

/obj/item/mecha_parts/mecha_equipment/repair_droid/get_equip_info()
	if(!chassis)
		return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name] - <a href='?src=\ref[src];toggle_repairs=1'>[pr_repair_droid.active()?"Dea":"A"]ctivate</a>"


/obj/item/mecha_parts/mecha_equipment/repair_droid/Topic(href, href_list)
	..()
	if(href_list["toggle_repairs"])
		chassis.overlays -= droid_overlay
		if(pr_repair_droid.toggle())
			droid_overlay = new(src.icon, icon_state = "repair_droid_a")
			log_message("Activated.")
		else
			droid_overlay = new(src.icon, icon_state = "repair_droid")
			log_message("Deactivated.")
			set_ready_state(1)
		chassis.overlays += droid_overlay
		send_byjax(chassis.occupant, "exosuit.browser", "\ref[src]", src.get_equip_info())
	return

/datum/global_iterator/mecha_repair_droid/process(obj/item/mecha_parts/mecha_equipment/repair_droid/RD as obj)
	if(!RD.chassis)
		stop()
		RD.set_ready_state(1)
		return
	var/health_boost = RD.health_boost
	var/repaired = 0
	if(RD.chassis.hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
		health_boost *= -2
	else if(RD.chassis.hasInternalDamage() && prob(15))
		for(var/int_dam_flag in RD.repairable_damage)
			if(RD.chassis.hasInternalDamage(int_dam_flag))
				RD.chassis.clearInternalDamage(int_dam_flag)
				repaired = 1
				break
	if(health_boost<0 || RD.chassis.health < initial(RD.chassis.health))
		RD.chassis.health += min(health_boost, initial(RD.chassis.health) - RD.chassis.health)
		repaired = 1
	if(repaired)
		if(RD.chassis.use_power(RD.energy_drain))
			RD.set_ready_state(0)
		else
			stop()
			RD.set_ready_state(1)
			return
	else
		RD.set_ready_state(1)
	return


/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay
	name = "energy relay"
	desc = "Wirelessly drains energy from any available power channel in area. The performance index is quite low."
	icon_state = "tesla"
	origin_tech = list(RESEARCH_TECH_MAGNETS = 4, RESEARCH_TECH_SYNDICATE = 2)
	equip_cooldown = 10
	energy_drain = 0
	range = 0
	construction_cost = list(MATERIAL_METAL = 10000, MATERIAL_GOLD = 2000, MATERIAL_SILVER = 3000, MATERIAL_GLASS = 2000)

	var/datum/global_iterator/pr_energy_relay
	var/coeff = 100
	var/list/use_channels = list(EQUIP, ENVIRON, LIGHT)

/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/New()
	..()
	pr_energy_relay = new /datum/global_iterator/mecha_energy_relay(list(src), 0)
	pr_energy_relay.set_delay(equip_cooldown)
	return

/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/detach()
	pr_energy_relay.stop()
//	chassis.proc_res["dynusepower"] = null
	chassis.proc_res["dyngetcharge"] = null
	..()
	return

/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/attach(obj/mecha/M)
	..()
	chassis.proc_res["dyngetcharge"] = src
//	chassis.proc_res["dynusepower"] = src
	return

/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/can_attach(obj/mecha/M)
	if(..())
		if(!M.proc_res["dyngetcharge"])// && !M.proc_res["dynusepower"])
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/proc/dyngetcharge()
	if(equip_ready) //disabled
		return chassis.dyngetcharge()
	var/area/A = get_area(chassis)
	var/pow_chan = get_power_channel(A)
	var/charge = 0
	if(pow_chan)
		charge = 1000 //making magic
	else
		return chassis.dyngetcharge()
	return charge

/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/proc/get_power_channel(area/A)
	var/pow_chan
	if(A)
		for(var/c in use_channels)
			//if(A.master && A.master.powered(c))
			if(A.powered(c))
				pow_chan = c
				break
	return pow_chan

/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/Topic(href, href_list)
	..()
	if(href_list["toggle_relay"])
		if(pr_energy_relay.toggle())
			set_ready_state(0)
			log_message("Activated.")
		else
			set_ready_state(1)
			log_message("Deactivated.")
	return

/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/get_equip_info()
	if(!chassis)
		return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[src.name] - <a href='?src=\ref[src];toggle_relay=1'>[pr_energy_relay.active() ? "Dea" : "A"]ctivate</a>"

/*
/obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/proc/dynusepower(amount)
	if(!equip_ready) //enabled
		var/area/A = get_area(chassis)
		var/pow_chan = get_power_channel(A)
		if(pow_chan)
			A.master.use_power(amount * coeff, pow_chan)
			return 1
	return chassis.dynusepower(amount)
*/

/datum/global_iterator/mecha_energy_relay/process(obj/item/mecha_parts/mecha_equipment/tesla_energy_relay/ER)
	if(!ER.chassis || ER.chassis.hasInternalDamage(MECHA_INT_SHORT_CIRCUIT))
		stop()
		ER.set_ready_state(1)
		return
	var/cur_charge = ER.chassis.get_charge()
	if(isnull(cur_charge) || !ER.chassis.cell)
		stop()
		ER.set_ready_state(1)
		ER.occupant_message("No powercell detected.")
		return
	if(cur_charge < ER.chassis.cell.maxcharge)
		var/area/A = get_area(ER.chassis)
		if(A)
			var/pow_chan
			for(var/c in list(EQUIP, ENVIRON, LIGHT))
				//if(A.master.powered(c))
				if(A.powered(c))
					pow_chan = c
					break
			if(pow_chan)
				var/delta = min(12, ER.chassis.cell.maxcharge - cur_charge)
				ER.chassis.give_power(delta)
				//A.master.use_power(delta*ER.coeff, pow_chan)
				A.use_power(delta * ER.coeff, pow_chan)
	return


/obj/item/mecha_parts/mecha_equipment/generator
	name = "plasma converter"
	desc = "Generates power using solid plasma as fuel. Pollutes the environment."
	icon_state = "tesla"
	origin_tech = list(RESEARCH_TECH_PLASMATECH = 2, RESEARCH_TECH_POWERSTORAGE = 2, RESEARCH_TECH_ENGINEERING = 1)
	equip_cooldown = 10
	energy_drain = 0
	range = MELEE
	construction_cost = list(MATERIAL_METAL = 10000, MATERIAL_SILVER = 500, MATERIAL_GLASS = 1000)
	reliability = 1000

	var/datum/global_iterator/pr_mech_generator
	var/coeff = 100
	var/obj/item/stack/sheet/fuel
	var/max_fuel = 150000
	var/fuel_per_cycle_idle = 100
	var/fuel_per_cycle_active = 500
	var/power_per_cycle = 20

/obj/item/mecha_parts/mecha_equipment/generator/New()
	..()
	init()
	return

/obj/item/mecha_parts/mecha_equipment/generator/proc/init()
	fuel = new /obj/item/stack/sheet/mineral/plasma(src)
	fuel.amount = 0
	pr_mech_generator = new /datum/global_iterator/mecha_generator(list(src), 0)
	pr_mech_generator.set_delay(equip_cooldown)
	return

/obj/item/mecha_parts/mecha_equipment/generator/detach()
	pr_mech_generator.stop()
	..()
	return

/obj/item/mecha_parts/mecha_equipment/generator/Topic(href, href_list)
	..()
	if(href_list["toggle"])
		if(pr_mech_generator.toggle())
			set_ready_state(0)
			log_message("Activated.")
		else
			set_ready_state(1)
			log_message("Deactivated.")
	return

/obj/item/mecha_parts/mecha_equipment/generator/get_equip_info()
	var/output = ..()
	if(output)
		return "[output] \[[fuel]: [round(fuel.amount * fuel.perunit, 0.1)] cm<sup>3</sup>\] - <a href='?src=\ref[src];toggle=1'>[pr_mech_generator.active() ? "Dea" : "A"]ctivate</a>"
	return

/obj/item/mecha_parts/mecha_equipment/generator/action(target)
	if(chassis)
		var/result = load_fuel(target)
		var/message
		if(isnull(result))
			message = "<font color='red'>[fuel] traces in target minimal. [target] cannot be used as fuel.</font>"
		else if(!result)
			message = "Unit is full."
		else
			message = "[result] unit\s of [fuel] successfully loaded."
			send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
		occupant_message(message)
	return

/obj/item/mecha_parts/mecha_equipment/generator/proc/load_fuel(var/obj/item/stack/sheet/P)
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
	return

/obj/item/mecha_parts/mecha_equipment/generator/attackby(weapon,mob/user)
	var/result = load_fuel(weapon)
	if(isnull(result))
		user.visible_message("[user] tries to shove [weapon] into [src]. What a dumb-ass.", "<font color='red'>[fuel] traces minimal. [weapon] cannot be used as fuel.</font>")
	else if(!result)
		user << "Unit is full."
	else
		user.visible_message("[user] loads [src] with [fuel].", "[result] unit\s of [fuel] successfully loaded.")
	return

/obj/item/mecha_parts/mecha_equipment/generator/critfail()
	..()
	var/turf/simulated/T = get_turf(src)
	if(!T)
		return
	var/datum/gas_mixture/GM = new
	if(prob(10))
		T.assume_gas(/decl/xgm_gas/plasma, 100, 1500 + T0C)
		T.visible_message("The [src] suddenly disgorges a cloud of heated plasma.")
		destroy()
	else
		T.assume_gas(/decl/xgm_gas/plasma, 5, istype(T) ? T.air.temperature : T20C)
		T.visible_message("The [src] suddenly disgorges a cloud of plasma.")
	T.assume_air(GM)
	return

/datum/global_iterator/mecha_generator/process(obj/item/mecha_parts/mecha_equipment/generator/EG)
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


/obj/item/mecha_parts/mecha_equipment/generator/nuclear
	name = "\improper ExoNuclear reactor"
	desc = "Generates power using uranium. Pollutes the environment."
	icon_state = "tesla"
	origin_tech = list(RESEARCH_TECH_POWERSTORAGE = 3, RESEARCH_TECH_ENGINEERING = 3)
	construction_cost = list(MATERIAL_METAL = 10000, MATERIAL_SILVER = 500, MATERIAL_GLASS = 1000)
	max_fuel = 50000
	fuel_per_cycle_idle = 10
	fuel_per_cycle_active = 30
	power_per_cycle = 50
	reliability = 1000

	var/rad_per_cycle = 0.3

/obj/item/mecha_parts/mecha_equipment/generator/nuclear/init()
	fuel = new /obj/item/stack/sheet/mineral/uranium(src)
	fuel.amount = 0
	pr_mech_generator = new /datum/global_iterator/mecha_generator/nuclear(list(src), 0)
	pr_mech_generator.set_delay(equip_cooldown)
	return

/obj/item/mecha_parts/mecha_equipment/generator/nuclear/critfail()
	return

/datum/global_iterator/mecha_generator/nuclear/process(obj/item/mecha_parts/mecha_equipment/generator/nuclear/EG)
	if(..())
		for(var/mob/living/carbon/M in view(EG.chassis))
			if(ishuman(M))
				M.apply_effect((EG.rad_per_cycle * 3), IRRADIATE, 0)
			else
				M.radiation += EG.rad_per_cycle
	return 1



//This is pretty much just for the death-ripley so that it is harmless
/obj/item/mecha_parts/mecha_equipment/tool/safety_clamp
	name = "kill clamp"
	icon_state = "mecha_clamp"
	equip_cooldown = 15
	energy_drain = 0

	var/dam_force = 0
	var/obj/mecha/working/ripley/cargo_holder

/obj/item/mecha_parts/mecha_equipment/tool/safety_clamp/can_attach(obj/mecha/working/ripley/M as obj)
	if(..())
		if(istype(M))
			return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/tool/safety_clamp/attach(obj/mecha/M as obj)
	..()
	cargo_holder = M
	return

/obj/item/mecha_parts/mecha_equipment/tool/safety_clamp/action(atom/target)
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
			chassis.occupant_message("\red You obliterate [target] with [src.name], leaving blood and guts everywhere.")
			chassis.visible_message("\red [chassis] destroys [target] in an unholy fury.")
		if(chassis.occupant.a_intent == "disarm")
			chassis.occupant_message("\red You tear [target]'s limbs off with [src.name].")
			chassis.visible_message("\red [chassis] rips [target]'s arms off.")
		else
			step_away(M,chassis)
			chassis.occupant_message("You smash into [target], sending them flying.")
			chassis.visible_message("[chassis] tosses [target] like a piece of paper.")
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
	return 1

// Ported the passenger compartment from NSS Eternal along with the hoverpod. -Frenjo
/obj/item/mecha_parts/mecha_equipment/tool/passenger
	name = "passenger compartment"
	desc = "A mountable passenger compartment for exo-suits. Rather cramped."
	icon_state = "mecha_abooster_ccw"
	origin_tech = list(RESEARCH_TECH_ENGINEERING = 1, RESEARCH_TECH_BIOTECH = 1)
	energy_drain = 10
	range = MELEE
	construction_cost = list(MATERIAL_METAL = 5000, MATERIAL_GLASS = 5000)
	reliability = 1000
	equip_cooldown = 20
	salvageable = 0

	var/mob/living/carbon/occupant = null
	var/door_locked = 1

/obj/item/mecha_parts/mecha_equipment/tool/passenger/allow_drop()
	return 0

/obj/item/mecha_parts/mecha_equipment/tool/passenger/destroy()
	for(var/atom/movable/AM in src)
		AM.forceMove(get_turf(src))
	return ..()

/obj/item/mecha_parts/mecha_equipment/tool/passenger/Exit(atom/movable/O)
	return 0

/obj/item/mecha_parts/mecha_equipment/tool/passenger/proc/move_inside(mob/user)
	if(chassis)
		chassis.visible_message("\blue [user] starts to climb into [chassis].")

	if(do_after(user, 40, needhand = 0))
		if(!src.occupant)
			user.forceMove(src)
			occupant = user
			log_message("[user] boarded.")
			occupant_message("[user] boarded.")
		else if(src.occupant != user)
			user << "\red [src.occupant] was faster. Try better next time, loser."
	else
		user << "You stop entering the exosuit."

/obj/item/mecha_parts/mecha_equipment/tool/passenger/verb/eject()
	set name = "Eject"
	set category = "Exosuit Interface"
	set src = usr.loc
	set popup_menu = 0

	if(usr != occupant)
		return
	occupant << "You climb out from \the [src]."
	go_out()
	occupant_message("[occupant] disembarked.")
	log_message("[occupant] disembarked.")
	add_fingerprint(usr)

/obj/item/mecha_parts/mecha_equipment/tool/passenger/proc/go_out()
	if(!occupant)
		return
	occupant.forceMove(get_turf(src))
	occupant.reset_view()
	/*
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	*/
	occupant = null
	return

/obj/item/mecha_parts/mecha_equipment/tool/passenger/attach()
	..()
	if(chassis)
		chassis.verbs |= /obj/mecha/proc/move_inside_passenger

/obj/item/mecha_parts/mecha_equipment/tool/passenger/detach()
	if(occupant)
		occupant_message("Unable to detach [src] - equipment occupied.")
		return

	var/obj/mecha/M = chassis
	..()
	if(M && !(locate(/obj/item/mecha_parts/mecha_equipment/tool/passenger) in M))
		M.verbs -= /obj/mecha/proc/move_inside_passenger

/obj/item/mecha_parts/mecha_equipment/tool/passenger/get_equip_info()
	return "[..()] <br />[occupant? "\[Occupant: [occupant]\]|" : ""]Exterior Hatch: <a href='?src=\ref[src];toggle_lock=1'>Toggle Lock</a>"

/obj/item/mecha_parts/mecha_equipment/tool/passenger/Topic(href,href_list)
	..()
	if(href_list["toggle_lock"])
		door_locked = !door_locked
		occupant_message("Passenger compartment hatch [door_locked? "locked" : "unlocked"].")
		if(chassis)
			chassis.visible_message("The hatch on \the [chassis] [door_locked? "locks" : "unlocks"].", "You hear something latching.")


#define LOCKED 1
#define OCCUPIED 2

/obj/mecha/proc/move_inside_passenger()
	set category = PANEL_OBJECT
	set name = "Enter Passenger Compartment"
	set src in oview(1)

	//check that usr can climb in
	if(usr.stat || !ishuman(usr))
		return

	if(!usr.Adjacent(src))
		return

	if(!isturf(usr.loc))
		usr << "\red You can't reach the passenger compartment from here."
		return

	if(iscarbon(usr))
		var/mob/living/carbon/C = usr
		if(C.handcuffed)
			usr << "\red Kinda hard to climb in while handcuffed don't you think?"
			return

	for(var/mob/living/carbon/slime/M in range(1, usr))
		if(M.Victim == usr)
			usr << "\red You're too busy getting your life sucked out of you."
			return

	//search for a valid passenger compartment
	var/feedback = 0 //for nicer user feedback
	for(var/obj/item/mecha_parts/mecha_equipment/tool/passenger/P in src)
		if(P.occupant)
			feedback |= OCCUPIED
			continue
		if(P.door_locked)
			feedback |= LOCKED
			continue

		//found a boardable compartment
		P.move_inside(usr)
		return

	//didn't find anything
	switch(feedback)
		if(OCCUPIED)
			usr << "\red The passenger compartment is already occupied!"
		if(LOCKED)
			usr << "\red The passenger compartment hatch is locked!"
		if(OCCUPIED|LOCKED)
			usr << "\red All of the passenger compartments are already occupied or locked!"
		if(0)
			usr << "\red \The [src] doesn't have a passenger compartment."

#undef LOCKED
#undef OCCUPIED
// END PORT -Frenjo

/obj/item/paintkit //Please don't use this for anything, it's a base type for custom mech paintjobs.
	name = "mecha customisation kit"
	desc = "A generic kit containing all the needed tools and parts to turn a mech into another mech."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "royce_kit"

	var/new_name = "mech"		//What is the variant called?
	var/new_desc = "A mech."	//How is the new mech described?
	var/new_icon = "ripley"		//What base icon will the new mech use?
	var/removable = null		//Can the kit be removed?
	var/list/allowed_types = list() //Types of mech that the kit will work on.