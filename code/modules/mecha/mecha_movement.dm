//////////////////////////////////
////////  Movement procs  ////////
//////////////////////////////////

/obj/mecha/Move()
	. = ..()
	if(.)
		events.fireEvent("onMove", GET_TURF(src))

/obj/mecha/relaymove(mob/user, direction)
	if(user != occupant) //While not "realistic", this piece is player friendly.
		user.forceMove(GET_TURF(src))
		to_chat(user, SPAN_INFO("You climb out from \the [src]."))
		return FALSE
	if(connected_port)
		if(world.time - last_message > 20)
			occupant_message(SPAN_WARNING("Unable to move while connected to the air system port."))
			last_message = world.time
		return FALSE
	if(state)
		occupant_message(SPAN_WARNING("Maintenance protocols in effect."))
		return
	return domove(direction)

/obj/mecha/proc/domove(direction)
	return call((proc_res["dyndomove"] || src), "dyndomove")(direction)

/obj/mecha/proc/dyndomove(direction)
	if(!can_move)
		return 0
	if(pr_inertial_movement.active())
		return 0
	if(!has_charge(step_energy_drain))
		return 0
	var/move_result = 0
	if(hasInternalDamage(MECHA_INT_CONTROL_LOST))
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
		if(do_after(step_in))
			can_move = TRUE
		return 1
	return 0

/obj/mecha/proc/mechturn(direction)
	set_dir(direction)
	if(isnotnull(turn_sound))
		playsound(src, turn_sound, turn_sound_volume, 1)
	return 1

/obj/mecha/proc/mechstep(direction)
	. = step(src, direction)
	if(.)
		if(isnotnull(step_sound))
			playsound(src, step_sound, step_sound_volume, 1)

/obj/mecha/proc/mechsteprand()
	. = step_rand(src)
	if(.)
		if(isnotnull(step_sound))
			playsound(src, step_sound, step_sound_volume, 1)

/obj/mecha/Bump(atom/obstacle)
//	src.inertia_dir = null
	if(isobj(obstacle))
		var/obj/O = obstacle
		if(istype(O, /obj/effect/portal)) //derpfix
			anchored = FALSE
			O.Crossed(src)
			spawn(0)//countering portal teleport spawn(0), hurr
				src.anchored = TRUE
		else if(!O.anchored)
			step(obstacle, dir)
		else //I have no idea why I disabled this
			obstacle.Bumped(src)
	else if(ismob(obstacle))
		step(obstacle, dir)
	else
		obstacle.Bumped(src)