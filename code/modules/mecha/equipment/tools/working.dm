// Hydraulic Clamp
/obj/item/mecha_equipment/tool/hydraulic_clamp
	name = "mounted hydraulic clamp"
	desc = "An exosuit-mounted hydraulic clamp with cargo loading capability."
	icon_state = "clamp"

	matter_amounts = /datum/design/mechfab/equipment/working/hydraulic_clamp::materials
	origin_tech = /datum/design/mechfab/equipment/working/hydraulic_clamp::req_tech

	equip_cooldown = 1.5 SECONDS
	energy_drain = 10
	equip_range = MECHA_EQUIP_MELEE

	var/dam_force = 20
	var/obj/mecha/working/cargo_holder = null

	var/is_safety_clamp = FALSE

/obj/item/mecha_equipment/tool/hydraulic_clamp/attach(obj/mecha/M)
	. = ..()
	if(istype(M, /obj/mecha/working)) // If it's not a working mech with cargo capacity, then it still gets squeeze functionality.
		cargo_holder = M

/obj/item/mecha_equipment/tool/hydraulic_clamp/action(atom/target)
	if(!..())
		return FALSE
	if(isnull(chassis))
		return FALSE
	if(istype(target, /obj/structure/stool))
		return FALSE
	for(var/mob/living/M in target.contents)
		return FALSE

	if(isobj(target) && isnotnull(cargo_holder))
		var/obj/O = target
		if(!O.anchored)
			if(length(cargo_holder.cargo) < cargo_holder.cargo_capacity)
				occupant_message(SPAN_INFO("You lift \the [target] and start to load it into the cargo compartment."))
				chassis.visible_message(SPAN_INFO("[chassis] lifts \the [target] and starts to load it into the cargo compartment."))
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
						return FALSE
				else
					return FALSE
			else
				occupant_message(SPAN_WARNING("Not enough room in cargo compartment."))
				return FALSE
		else
			occupant_message(SPAN_WARNING("[target] is firmly secured."))
			return FALSE

	else if(isliving(target))
		var/mob/living/M = target
		if(M.stat > 1)
			return FALSE
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
		start_cooldown()
	return TRUE

/obj/item/mecha_equipment/tool/hydraulic_clamp/handle_movement_action()
	if(isnull(cargo_holder))
		return FALSE
	var/obj/structure/ore_box/box = locate(/obj/structure/ore_box) in cargo_holder.cargo
	if(isnull(box))
		return FALSE
	for(var/obj/item/ore/ore in range(cargo_holder, 1))
		if((get_dir(cargo_holder, ore) & cargo_holder.dir) || ore.loc == cargo_holder.loc) // If we can reach it and it's in front of us, grab it.
			ore.forceMove(box)
	return TRUE

// Safety Clamp (Kill Clamp)
// This is pretty much just for the death-ripley so that it is harmless.
/obj/item/mecha_equipment/tool/hydraulic_clamp/safety
	name = "mounted kill clamp"
	desc = "An exosuit-mounted hydraulic clamp with KILL CAPABILITY."

	energy_drain = 0

	is_safety_clamp = TRUE

// Rescue Jaw
// A special variant of the hydraulic clamp for medical exosuits, it doesn't have cargo loading functionality.
/obj/item/mecha_equipment/tool/hydraulic_clamp/rescue
	name = "mounted rescue jaw"
	desc = "An exosuit-mounted jaws of life used to extricate casualties from dangerous areas."
	icon_state = "rescue_jaw"

	mecha_types = MECHA_TYPE_MEDICAL

	energy_drain = 5 // Half the energy drain of the regular clamp.

	dam_force = 10 // Half as forceful as the regular clamp.

	attaches_to_string = "any <em><i>medical</i></em> exosuit except the <em><i>Rescue Ranger</i></em>"

// Extinguisher
/obj/item/mecha_equipment/tool/extinguisher
	name = "mounted extinguisher"
	desc = "An exosuit-mounted fire extinguisher."
	icon_state = "exting"

	equip_cooldown = 0.5 SECONDS
	energy_drain = 0
	equip_range = MECHA_EQUIP_MELEE | MECHA_EQUIP_RANGED

/obj/item/mecha_equipment/tool/extinguisher/initialise()
	. = ..()
	create_reagents(200)
	reagents.add_reagent("water", 200)

/obj/item/mecha_equipment/tool/extinguisher/action(atom/target) //copypasted from extinguisher. TODO: Rewrite from scratch.
	if(!..() || get_dist(chassis, target) > 3)
		return FALSE
	if(get_dist(chassis, target) > 2)
		return FALSE
	if(do_after_cooldown(target))
		if(istype(target, /obj/structure/reagent_dispensers/watertank) && get_dist(chassis, target) <= 1)
			var/obj/o = target
			o.reagents.trans_to(src, 200)
			occupant_message(SPAN_INFO("Extinguisher refilled."))
			playsound(chassis, 'sound/effects/refill.ogg', 50, 1, -6)

		else if(reagents.total_volume > 0)
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
						return FALSE
					var/turf/my_target = pick(the_targets)
					W.create_reagents(5)
					reagents.trans_to(W, 1)
					for(var/b = 0, b < 4, b++)
						if(isnull(W))
							return FALSE
						step_towards(W, my_target)
						if(isnull(W))
							return FALSE
						var/turf/W_turf = GET_TURF(W)
						W.reagents.reaction(W_turf)
						for_no_type_check(var/atom/movable/mover, W_turf)
							W.reagents.reaction(mover)
						if(W.loc == my_target)
							break
						sleep(2)
	return TRUE

/obj/item/mecha_equipment/tool/extinguisher/get_equip_info()
	. = "[..()] \[[reagents.total_volume]\]"

/obj/item/mecha_equipment/tool/extinguisher/on_reagent_change()
	return