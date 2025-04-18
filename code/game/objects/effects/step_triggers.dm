/* Simple object type, calls a proc when "stepped" on by something */
/obj/effect/step_trigger
	invisibility = INVISIBILITY_MAXIMUM // nope cant see this shit
	anchored = TRUE

	var/affect_ghosts = FALSE
	var/stopper = TRUE // stops throwers

/obj/effect/step_trigger/proc/Trigger(atom/movable/A)
	return 0

/obj/effect/step_trigger/Crossed(atom/movable/AM)
	..()
	if(!AM)
		return
	if(isghost(AM) && !affect_ghosts)
		return
	Trigger(AM)


/* Tosses things in a certain direction */
/obj/effect/step_trigger/thrower
	var/direction = SOUTH	// the direction of throw
	var/tiles = 3			// if 0: forever until atom hits a stopper
	var/immobilize = TRUE	// if TRUE: prevents mobs from moving while they're being flung
	var/speed = 1			// delay of movement
	var/facedir = FALSE		// if TRUE: atom faces the direction of movement
	var/nostop = FALSE		// if TRUE: will only be stopped by teleporters
	var/list/affecting = list()

/obj/effect/step_trigger/thrower/Trigger(atom/A)
	if(!A || !ismovable(A))
		return

	var/atom/movable/AM = A
	var/curtiles = 0
	var/stopthrow = 0
	for(var/obj/effect/step_trigger/thrower/T in orange(2, src))
		if(AM in T.affecting)
			return

	if(ismob(AM))
		var/mob/M = AM
		if(immobilize)
			M.canmove = FALSE

	affecting.Add(AM)
	while(AM && !stopthrow)
		if(tiles)
			if(curtiles >= tiles)
				break
		if(AM.z != src.z)
			break

		curtiles++

		sleep(speed)

		// Calculate if we should stop the process
		if(!nostop)
			for(var/obj/effect/step_trigger/T in get_step(AM, direction))
				if(T.stopper && T != src)
					stopthrow = 1
		else
			for(var/obj/effect/step_trigger/teleporter/T in get_step(AM, direction))
				if(T.stopper)
					stopthrow = 1

		if(AM)
			var/predir = AM.dir
			step(AM, direction)
			if(!facedir)
				AM.set_dir(predir)

	affecting.Remove(AM)

	if(ismob(AM))
		var/mob/M = AM
		if(immobilize)
			M.canmove = TRUE


/* Stops things thrown by a thrower, doesn't do anything */
/obj/effect/step_trigger/stopper


/* Instant teleporter */
/obj/effect/step_trigger/teleporter
	var/teleport_x = 0	// teleportation coordinates (if one is null, then no teleport!)
	var/teleport_y = 0
	var/teleport_z = 0

/obj/effect/step_trigger/teleporter/Trigger(atom/movable/A)
	if(teleport_x && teleport_y && teleport_z)
		A.x = teleport_x
		A.y = teleport_y
		A.z = teleport_z


/* Random teleporter, teleports atoms to locations ranging from teleport_x - teleport_x_offset, etc */
/obj/effect/step_trigger/teleporter/random
	var/teleport_x_offset = 0
	var/teleport_y_offset = 0
	var/teleport_z_offset = 0

/obj/effect/step_trigger/teleporter/random/Trigger(atom/movable/A)
	if(teleport_x && teleport_y && teleport_z)
		if(teleport_x_offset && teleport_y_offset && teleport_z_offset)
			A.x = rand(teleport_x, teleport_x_offset)
			A.y = rand(teleport_y, teleport_y_offset)
			A.z = rand(teleport_z, teleport_z_offset)