// Hydraulic Clamp
/obj/item/mecha_part/equipment/tool/hydraulic_clamp
	name = "hydraulic clamp"
	desc = "An exosuit-mounted hydraulic clamp with cargo loading capability. (Can be attached to: Working Exosuits)"
	icon_state = "clamp"
	equip_cooldown = 1.5 SECONDS
	energy_drain = 10

	var/dam_force = 20
	var/obj/mecha/working/cargo_holder

	var/is_safety_clamp = FALSE

/obj/item/mecha_part/equipment/tool/hydraulic_clamp/attach(obj/mecha/working/M)
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
				occupant_message(SPAN_INFO("You lift \the [target] and start to load it into the cargo compartment."))
				chassis.visible_message(SPAN_INFO("[chassis] lifts \the [target] and starts to load it into the cargo compartment."))
				set_ready_state(0)
				chassis.use_power(energy_drain)
				O.anchored = TRUE
				var/T = chassis.loc
				if(do_after_cooldown(target))
					if(T == chassis.loc && src == chassis.selected)
						cargo_holder.cargo += O
						O.forceMove(chassis)
						O.anchored = FALSE
						occupant_message(SPAN_INFO_B("[target] succesfully loaded."))
						log_message("Loaded [O]. Cargo compartment capacity: [cargo_holder.cargo_capacity - length(cargo_holder.cargo)]")
					else
						occupant_message(SPAN_INFO("You must hold still while handling objects."))
						O.anchored = initial(O.anchored)
			else
				occupant_message(SPAN_WARNING("Not enough room in cargo compartment."))
		else
			occupant_message(SPAN_WARNING("[target] is firmly secured."))

	else if(isliving(target))
		var/mob/living/M = target
		if(M.stat > 1)
			return
		var/pilot_message = null
		var/radial_message = null
		if(chassis.occupant.a_intent == "hurt")
			if(!is_safety_clamp)
				M.take_overall_damage(dam_force)
				M.adjustOxyLoss(round(dam_force / 2))
				M.updatehealth()
				pilot_message = SPAN_WARNING("You squeeze [target] with [name]. Something cracks.")
				radial_message = SPAN_WARNING("[chassis] squeezes [target].")
			else
				pilot_message = SPAN_DANGER("You obliterate [target] with [name], leaving blood and guts everywhere!")
				radial_message = SPAN_DANGER("[chassis] destroys [target] in an unholy fury!")
		else if(chassis.occupant.a_intent == "disarm" && is_safety_clamp)
			pilot_message = SPAN_DANGER("You tear [target]'s limbs off with [name]!")
			radial_message = SPAN_DANGER("[chassis] rips [target]'s arms off!")
		else
			step_away(M, chassis)
			if(!is_safety_clamp)
				pilot_message = SPAN_INFO("You push [target] out of the way.")
				radial_message = SPAN_INFO("[chassis] pushes [target] out of the way.")
			else
				pilot_message = SPAN_WARNING("You smash into [target], sending them flying!")
				radial_message = SPAN_WARNING("[chassis] tosses [target] like a piece of paper!")
		chassis.occupant_message(pilot_message)
		chassis.visible_message(radial_message)
		set_ready_state(0)
		chassis.use_power(energy_drain)
		do_after_cooldown()
	return 1

// Safety Clamp (Kill Clamp)
// This is pretty much just for the death-ripley so that it is harmless.
/obj/item/mecha_part/equipment/tool/hydraulic_clamp/safety
	name = "kill clamp"
	desc = "An exosuit-mounted hydraulic clamp with KILL CAPABILITY. (Can be attached to: Working Exosuits)"
	energy_drain = 0

	is_safety_clamp = TRUE

// Extinguisher
/obj/item/mecha_part/equipment/tool/extinguisher
	name = "extinguisher"
	desc = "An exosuit-mounted fire extinguisher. (Can be attached to: Working Exosuits)"
	icon_state = "exting"
	equip_cooldown = 0.5 SECONDS
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
			occupant_message(SPAN_INFO("Extinguisher refilled."))
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
	. = "[..()] \[[reagents.total_volume]\]"

/obj/item/mecha_part/equipment/tool/extinguisher/on_reagent_change()
	return