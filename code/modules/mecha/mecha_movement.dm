//////////////////////////////////
////////  Movement procs  ////////
//////////////////////////////////

/obj/mecha/relaymove(mob/user, direction)
	if(user != occupant)
		return FALSE
	return do_move(direction)

/obj/mecha/proc/do_move(direction)
	if(!COOLDOWN_FINISHED(src, cooldown_mecha_move))
		return FALSE
	COOLDOWN_START(src, cooldown_mecha_move, move_delay)

	if(pr_inertial_movement.active())
		return FALSE
	if(!has_charge(step_energy_drain))
		return FALSE
	if(isnotnull(connected_port))
		if(COOLDOWN_FINISHED(src, cooldown_mecha_message))
			occupant_message(SPAN_WARNING("Unable to move while connected to the air system port."))
			COOLDOWN_START(src, cooldown_mecha_message, MECHA_MESSAGE_COOLDOWN)
		return FALSE
	if(state)
		occupant_message(SPAN_WARNING("Maintenance protocols in effect."))
		return FALSE

	var/move_result = FALSE
	if(internal_damage & MECHA_INT_CONTROL_LOST)
		move_result = mechsteprand()
	else if(dir != direction)
		move_result = mechturn(direction)
	else
		move_result	= mechstep(direction)
	if(!move_result)
		return FALSE

	use_power(step_energy_drain)
	if(isspace(loc) && !check_for_support())
		pr_inertial_movement.start(list(src, direction))
		log_message("Movement control lost. Inertial movement started.")
	return TRUE

/obj/mecha/proc/handle_equipment_movement()
	for_no_type_check(var/obj/item/mecha_equipment/equip, equipment)
		if(equip.chassis == src) // Sanity.
			equip.handle_movement_action()

/obj/mecha/proc/mechturn(direction)
	. = set_dir(direction)
	if(.)
		play_turn_sound()

/obj/mecha/proc/play_turn_sound()
	if(isnull(turn_sound))
		return
	playsound(src, turn_sound, turn_sound_volume, 1)

/obj/mecha/proc/mechstep(direction)
	. = step(src, direction)
	if(.)
		play_step_sound()
		handle_equipment_movement()

/obj/mecha/proc/mechsteprand()
	. = step_rand(src)
	if(.)
		play_step_sound()
		handle_equipment_movement()

/obj/mecha/proc/play_step_sound()
	if(isnull(step_sound))
		return
	playsound(src, step_sound, step_sound_volume, 1)

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