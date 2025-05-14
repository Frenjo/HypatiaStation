// This is the actual shield. The projector is a different item.
/obj/effect/directional_shield
	name = "directional combat shield"
	desc = "A wide shield, which has the property to block incoming projectiles but allow outgoing projectiles to pass it. \
	Slower moving objects are not blocked, so people can walk in and out of the barrier, and things can be thrown into and out of it."
	icon = 'icons/effects/effects.dmi'
	icon_state = "directional_shield"

	density = FALSE // People can move pass these shields.
	opacity = FALSE
	anchored = TRUE
	plane = UNLIT_EFFECTS_PLANE
	mouse_opacity = FALSE

	var/obj/item/shield_projector/projector = null // The thing creating the shield.
	var/x_offset = 0 // Offset from the 'center' of where the projector is, so that if it moves, the shield can recalc its position.
	var/y_offset = 0 // Ditto.

/obj/effect/directional_shield/New(newloc, new_projector)
	. = ..(newloc)
	if(new_projector)
		projector = new_projector
		var/turf/us = GET_TURF(src)
		var/turf/them = GET_TURF(projector)
		if(isnotnull(them))
			x_offset = us.x - them.x
			y_offset = us.y - them.y
	else
		update_colour()

/obj/effect/directional_shield/Destroy()
	if(isnotnull(projector))
		projector.active_shields.Remove(src)
		projector = null
	return ..()

/obj/effect/directional_shield/proc/relocate()
	if(isnull(projector))
		return // Nothing to follow.
	var/turf/T = GET_TURF(projector)
	if(isnull(T))
		return
	var/turf/new_pos = locate(T.x + x_offset, T.y + y_offset, T.z)
	if(new_pos)
		forceMove(new_pos)
	else
		qdel(src)

/obj/effect/directional_shield/proc/update_colour(new_colour)
	if(!projector)
		color = "#0099FF"
	else
		animate(src, 5, color = new_colour)

/obj/effect/directional_shield/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || (height == 0))
		return TRUE
	else if(istype(mover, /obj/item/projectile))
		var/obj/item/projectile/P = mover
		var/bad_arc = reverse_direction(dir) // Arc of directions from which we cannot block.
		if(check_shield_arc(src, bad_arc, P)) // This is actually for mobs but it will work for our purposes as well.
			return FALSE
		else
			return TRUE
	return TRUE

/obj/effect/directional_shield/bullet_act(obj/item/projectile/P)
	adjust_health(-P.damage)
	P.on_hit()
	playsound(GET_TURF(src), 'sound/effects/EMPulse.ogg', 75, 1)

// All the shields tied to their projector are one 'unit', and don't have individualized health values like most other shields.
/obj/effect/directional_shield/proc/adjust_health(amount)
	projector?.adjust_health(amount) // Projector will kill the shield if needed.
	// If the shield lacks a projector, then it was probably spawned in by an admin for bus, so it's indestructable.