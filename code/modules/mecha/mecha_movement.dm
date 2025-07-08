//////////////////////////////////
////////  Movement procs  ////////
//////////////////////////////////

/obj/mecha/relaymove(mob/user, direction)
	if(user != occupant) //While not "realistic", this piece is player friendly.
		user.forceMove(GET_TURF(src))
		to_chat(user, SPAN_INFO("You climb out from \the [src]."))
		return FALSE
	if(isnotnull(connected_port))
		if(world.time - last_message > 20)
			occupant_message(SPAN_WARNING("Unable to move while connected to the air system port."))
			last_message = world.time
		return FALSE
	if(state)
		occupant_message(SPAN_WARNING("Maintenance protocols in effect."))
		return FALSE
	return do_move(direction)

/obj/mecha/proc/do_move(direction)
	if(!can_move)
		return FALSE
	if(pr_inertial_movement.active())
		return FALSE
	if(!has_charge(step_energy_drain))
		return FALSE
	var/move_result = 0
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		move_result = mechsteprand()
	else if(src.dir != direction)
		move_result = mechturn(direction)
	else
		move_result	= mechstep(direction)
	if(move_result)
		can_move = FALSE
		use_power(step_energy_drain)
		if(isspace(loc))
			if(!check_for_support())
				pr_inertial_movement.start(list(src, direction))
				log_message("Movement control lost. Inertial movement started.")
		if(do_after(occupant, step_in, src, FALSE, FALSE))
			can_move = TRUE
		return TRUE
	return FALSE

/obj/mecha/proc/handle_equipment_movement()
	for_no_type_check(var/obj/item/mecha_equipment/equip, equipment)
		if(equip.chassis == src) // Sanity.
			equip.handle_movement_action()

/obj/mecha/proc/mechturn(direction)
	. = set_dir(direction)
	if(. && isnotnull(turn_sound))
		playsound(src, turn_sound, turn_sound_volume, 1)

/obj/mecha/proc/mechstep(direction)
	. = step(src, direction)
	if(. && isnotnull(step_sound))
		playsound(src, step_sound, step_sound_volume, 1)
		handle_equipment_movement()

/obj/mecha/proc/mechsteprand()
	. = step_rand(src)
	if(. && isnotnull(step_sound))
		playsound(src, step_sound, step_sound_volume, 1)
		handle_equipment_movement()

/obj/mecha/Bump(atom/obstacle)
//	src.inertia_dir = null
	if(isobj(obstacle))
		var/obj/O = obstacle
		if(istype(O, /obj/effect/portal)) //derpfix
			anchored = FALSE
			O.Crossed(src)
			spawn(0)//countering portal teleport spawn(0), hurr
				anchored = TRUE
		else if(!O.anchored)
			step(obstacle, dir)
		else //I have no idea why I disabled this
			obstacle.Bumped(src)
	else if(ismob(obstacle))
		step(obstacle, dir)
	else
		obstacle.Bumped(src)