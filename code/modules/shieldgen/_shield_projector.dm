// This actually creates the shields. It's an item so that it can be carried, but it could also be placed inside a stationary object if desired.
// It should work inside the contents of any mob.
/obj/item/shield_projector
	name = "combat shield projector"
	desc = "A miniturized and compact shield projector. This type has been optimized to diffuse lasers or block high velocity projectiles from the outside, \
	but allow those projectiles to leave the shield from the inside. Blocking too many damaging projectiles will cause the shield to fail."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "jammer0"

	var/active = FALSE	// If it's on.
	var/shield_health = 400	// How much damage the shield blocks before breaking. This is a shared health pool for all shields attached to this projector.
	var/max_shield_health = 400	// Ditto. This is fairly high, but shields are really big, you can't miss them, and laser carbines pump out so much hurt.
	var/shield_regen_amount = 20	// How much to recharge every process(), after the delay.
	var/shield_regen_delay = 5 SECONDS	// If the shield takes damage, it won't recharge for this long.
	var/last_damaged_time = null	// world.time when the shields took damage, used for the delay.
	var/list/obj/effect/directional_shield/active_shields = list()	// Shields that are active and deployed.
	var/always_on = FALSE	// If true, will always try to reactivate if disabled for whatever reason, ideal if AI mobs are holding this.

	var/high_colour = "#0099FF"	// Colour the shield will be when at max health.  A light blue.
	var/low_colour = "#FF0000"		// Colour the shield will drift towards as health is lowered.  Deep red.

/obj/item/shield_projector/New()
	. = ..()
	GLOBL.processing_objects.Add(src)
	if(always_on)
		create_shields()

/obj/item/shield_projector/Destroy()
	destroy_shields()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/item/shield_projector/proc/create_shield(newloc, new_dir)
	var/obj/effect/directional_shield/S = new /obj/effect/directional_shield(newloc, src)
	S.dir = new_dir
	active_shields.Add(S)

/obj/item/shield_projector/proc/create_shields() // Override this for a specific shape. Be sure to call ..() for the checks, however.
	if(active) // Already made.
		return FALSE
	if(shield_health <= 0)
		return FALSE
	active = TRUE
	icon_state = "jammer1"
	return TRUE

/obj/item/shield_projector/proc/destroy_shields()
	for_no_type_check(var/obj/effect/directional_shield/S, active_shields)
		active_shields -= S
		qdel(S)
	active = FALSE
	icon_state = "jammer0"

/obj/item/shield_projector/proc/update_shield_positions()
	for_no_type_check(var/obj/effect/directional_shield/S, active_shields)
		S.relocate()

/obj/item/shield_projector/proc/adjust_health(amount)
	shield_health = clamp(shield_health + amount, 0, max_shield_health)
	if(amount < 0)
		if(shield_health <= 0)
			destroy_shields()
			var/turf/T = GET_TURF(src)
			T.visible_message(SPAN_DANGER("\The [src] overloads and the shield vanishes!"))
			playsound(GET_TURF(src), 'sound/machines/defibrillator/failed.ogg', 75, 0)
		else
			if(shield_health < max_shield_health / 4) // Play a more urgent sounding beep if it's at 25% health.
				playsound(GET_TURF(src), 'sound/machines/defibrillator/success.ogg', 75, 0)
			else
				playsound(GET_TURF(src), 'sound/machines/defibrillator/safety_on.ogg', 75, 0)
		last_damaged_time = world.time
	update_shield_colours()

// Makes shields become gradually more red as the projector's health decreases.
/obj/item/shield_projector/proc/update_shield_colours()
	// This is done at the projector instead of the shields themselves to avoid needing to calculate this more than once every update.
	var/lerp_weight = shield_health / max_shield_health
	var/list/low_colour_list = GETHEXCOLOURS(low_colour)
	var/low_r = low_colour_list[1]
	var/low_g = low_colour_list[2]
	var/low_b = low_colour_list[3]
	var/list/high_colour_list = GETHEXCOLOURS(high_colour)
	var/high_r = high_colour_list[1]
	var/high_g = high_colour_list[2]
	var/high_b = high_colour_list[3]
	var/new_r = Interpolate(low_r, high_r, weight = lerp_weight)
	var/new_g = Interpolate(low_g, high_g, weight = lerp_weight)
	var/new_b = Interpolate(low_b, high_b, weight = lerp_weight)
	var/new_colour = rgb(new_r, new_g, new_b)
	// Now deploy the new colour to all the shields.
	for_no_type_check(var/obj/effect/directional_shield/S, active_shields)
		S.update_colour(new_colour)

/obj/item/shield_projector/attack_self(mob/living/user)
	if(active)
		if(always_on)
			to_chat(user, SPAN_WARNING("You can't seem to deactivate \the [src]."))
			return
		destroy_shields()
	else
		set_dir(user.dir) // Needed for linear shields.
		create_shields()
	visible_message(SPAN_NOTICE("\The [user] [!active ? "de":""]activates \the [src]."))

/obj/item/shield_projector/process()
	if(shield_health < max_shield_health && ((last_damaged_time + shield_regen_delay) < world.time))
		adjust_health(shield_regen_amount)
		if(always_on && !active) // Make shields as soon as possible if this is set.
			create_shields()
		if(shield_health == max_shield_health)
			playsound(GET_TURF(src), 'sound/machines/defibrillator/ready.ogg', 75, 0)
		else
			playsound(GET_TURF(src), 'sound/machines/defibrillator/safety_off.ogg', 75, 0)

/obj/item/shield_projector/examine(mob/user)
	..()
	if(get_dist(src, user) <= 1)
		to_chat(user, "\The [src]'s shield matrix is at [round( (shield_health / max_shield_health) * 100, 0.01)]% strength.")

/obj/item/shield_projector/emp_act(severity)
	adjust_health(-max_shield_health / severity) // A strong EMP will kill the shield instantly, but weaker ones won't on the first hit.

/obj/item/shield_projector/Move(newloc, direct)
	. = ..(newloc, direct)
	update_shield_positions()

/obj/item/shield_projector/on_loc_moved(newloc, direct)
	update_shield_positions()

// Subtypes
/obj/item/shield_projector/rectangle
	name = "rectangular combat shield projector"
	desc = "This creates a shield in a rectangular shape, which allows projectiles to leave from inside but blocks projectiles from outside. \
	Everything else can pass through the shield freely, including other people and thrown objects. The shield also cannot block certain effects which \
	take place over an area, such as flashbangs or explosions."

	var/size_x = 3	// How big the rectangle will be, in tiles from the center.
	var/size_y = 3	// Ditto.

// Horrible implementation below.
/obj/item/shield_projector/rectangle/create_shields()
	if(!..())
		return FALSE

	// Make a rectangle in a really terrible way.
	var/x_dist = size_x
	var/y_dist = size_y

	var/turf/T = GET_TURF(src)
	if(isnull(T))
		return FALSE
	// Top left corner.
	var/turf/T1 = locate(T.x - x_dist, T.y + y_dist, T.z)
	// Bottom right corner.
	var/turf/T2 = locate(T.x + x_dist, T.y - y_dist, T.z)
	if(isnull(T1) || isnull(T2)) // If we're on the edge of the map then don't bother.
		return FALSE

	// Build half of the corners first, as they are 'anchors' for the rest of the code below.
	create_shield(T1, NORTHWEST)
	create_shield(T2, SOUTHEAST)

	// Build the edges.
	// First start with the north side.
	var/current_x = T1.x + 1 // Start next to the top left corner.
	var/current_y = T1.y
	var/length = (x_dist * 2) - 1
	for(var/i = 1 to length)
		create_shield(locate(current_x, current_y, T.z), NORTH)
		current_x++

	// Make the top right corner.
	create_shield(locate(current_x, current_y, T.z), NORTHEAST)

	// Now for the west edge.
	current_x = T1.x
	current_y = T1.y - 1
	length = (y_dist * 2) - 1
	for(var/i = 1 to length)
		create_shield(locate(current_x, current_y, T.z), WEST)
		current_y--

	// Make the bottom left corner.
	create_shield(locate(current_x, current_y, T.z), SOUTHWEST)

	// Switch to the second corner, and make the east edge.
	current_x = T2.x
	current_y = T2.y + 1
	length = (y_dist * 2) - 1
	for(var/i = 1 to length)
		create_shield(locate(current_x, current_y, T.z), EAST)
		current_y++

	// There are no more corners to create, so we can just go build the south edge now.
	current_x = T2.x - 1
	current_y = T2.y
	length = (x_dist * 2) - 1
	for(var/i = 1 to length)
		create_shield(locate(current_x, current_y, T.z), SOUTH)
		current_x--
	// Finally done.
	update_shield_colours()
	return TRUE

// Weaker and smaller variant.
/obj/item/shield_projector/rectangle/weak
	shield_health = 200 // Half as strong as the default.
	max_shield_health = 200
	size_x = 2
	size_y = 2

// A shortcut for admins to spawn in to put into simple animals or other things where it needs to reactivate automatically.
/obj/item/shield_projector/rectangle/automatic
	always_on = TRUE

/obj/item/shield_projector/rectangle/automatic/weak
	shield_health = 200 // Half as strong as the default.
	max_shield_health = 200
	size_x = 2
	size_y = 2

// Variant for Exosuit design.
/obj/item/shield_projector/rectangle/weak/exosuit
	name = "omnidirectional exosuit shield projector"
	size_x = 1
	size_y = 1

	var/obj/mecha/my_mecha = null
	var/obj/item/mecha_part/equipment/shield_droid/my_tool = null

/obj/item/shield_projector/rectangle/weak/exosuit/process()
	. = ..()
	if((isnotnull(my_tool) && loc != my_tool) && (isnotnull(my_mecha) && loc != my_mecha))
		forceMove(my_tool)
	if(active)
		my_tool.set_ready_state(0)
		if(my_mecha.has_charge(2000)) // Stops at 2000 charge.
			my_mecha.use_power(my_tool.energy_drain)
		else
			destroy_shields()
			my_tool.set_ready_state(1)
			my_tool.log_message("Power lost.")
	else
		my_tool.set_ready_state(1)

/obj/item/shield_projector/rectangle/weak/exosuit/attack_self(mob/living/user)
	if(active)
		if(always_on)
			to_chat(user, SPAN_WARNING("You can't seem to deactivate \the [src]."))
			return

		destroy_shields()
	else
		if(ismecha(user.loc))
			set_dir(user.loc.dir)
		else
			set_dir(user.dir)
		create_shields()
	visible_message(SPAN_NOTICE("\The [user] [!active ? "de":""]activates \the [src]."))

/obj/item/shield_projector/rectangle/weak/exosuit/adjust_health(amount)
	. = ..()
	my_mecha.use_power(my_tool.energy_drain)
	if(!active && shield_health < shield_regen_amount)
		my_tool.log_message("Shield overloaded.")
		my_mecha.use_power(my_tool.energy_drain * 4)

/obj/item/shield_projector/line
	name = "linear combat shield projector"
	desc = "This creates a shield in a straight line perpendicular to the direction where the user was facing when it was activated. \
	The shield allows projectiles to leave from inside but blocks projectiles from outside. Everything else can pass through the shield freely, \
	including other people and thrown objects. The shield also cannot block certain effects which take place over an area, such as flashbangs or explosions."

	var/line_length = 5			// How long the line is.  Recommended to be an odd number.
	var/offset_from_center = 2	// How far from the projector will the line's center be.

/obj/item/shield_projector/line/create_shields()
	if(!..())
		return FALSE

	var/turf/T = GET_TURF(src) // This is another 'anchor', or will be once we move away from the projector.
	for(var/i = 1 to offset_from_center)
		T = get_step(T, dir)
	if(isnull(T)) // We went off the map or something.
		return
	// We're at the right spot now.  Build the center piece.
	create_shield(T, dir)

	var/length_to_build = round( (line_length - 1) / 2)
	var/turf/temp_T = T

	// First loop, we build the left (from a north perspective) side of the line.
	for(var/i = 1 to length_to_build)
		temp_T = get_step(temp_T, turn(dir, 90) )
		if(isnull(temp_T))
			break
		create_shield(temp_T, i == length_to_build ? turn(dir, 45) : dir)

	temp_T = T

	// Second loop, we build the right side.
	for(var/i = 1 to length_to_build)
		temp_T = get_step(temp_T, turn(dir, -90))
		if(isnull(temp_T))
			break
		create_shield(temp_T, i == length_to_build ? turn(dir, -45) : dir)
	// Finished.
	update_shield_colours()
	return TRUE

// Variant for Exosuit design.
/obj/item/shield_projector/line/exosuit
	name = "linear exosuit shield projector"
	offset_from_center = 1 // Snug against the exosuit.
	max_shield_health = 200 // Half as strong as the default.

	var/obj/mecha/my_mecha = null
	var/obj/item/mecha_part/equipment/shield_droid/my_tool = null

/obj/item/shield_projector/line/exosuit/process()
	. = ..()
	if((isnotnull(my_tool) && loc != my_tool) && (isnotnull(my_mecha) && loc != my_mecha))
		forceMove(my_tool)
	if(active)
		my_tool.set_ready_state(0)
		if(my_mecha.has_charge(2000)) // Stops at 2000 charge.
			my_mecha.use_power(my_tool.energy_drain)
		else
			destroy_shields()
			my_tool.set_ready_state(1)
			my_tool.log_message("Power lost.")
	else
		my_tool.set_ready_state(1)

/obj/item/shield_projector/line/exosuit/attack_self(mob/living/user)
	if(active)
		if(always_on)
			to_chat(user, SPAN_WARNING("You can't seem to deactivate \the [src]."))
			return

		destroy_shields()
	else
		if(ismecha(user.loc))
			set_dir(user.loc.dir)
		else
			set_dir(user.dir)
		create_shields()
	visible_message(SPAN_NOTICE("\The [user] [!active ? "de":""]activates \the [src]."))

/obj/item/shield_projector/line/exosuit/adjust_health(amount)
	. = ..()
	my_mecha.use_power(my_tool.energy_drain)
	if(!active && shield_health < shield_regen_amount)
		my_tool.log_message("Shield overloaded.")
		my_mecha.use_power(my_tool.energy_drain * 4)