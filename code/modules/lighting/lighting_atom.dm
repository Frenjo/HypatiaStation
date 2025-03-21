/atom
	var/light_power = 1 // intensity of the light
	var/light_range = 0 // range in tiles of the light
	var/light_color		// Hexadecimal RGB string representing the colour of the light

	var/datum/light_source/light
	var/list/datum/light_source/light_sources

// Nonsensical value for l_color default, so we can detect if it gets set to null.
#define NONSENSICAL_VALUE -99999
/atom/proc/set_light(l_range, l_power, l_color = NONSENSICAL_VALUE)
	if(isnotnull(l_power))
		light_power = l_power

	if(isnotnull(l_range))
		light_range = l_range

	if(l_color != NONSENSICAL_VALUE)
		light_color = l_color

	update_light()
#undef NONSENSICAL_VALUE

/atom/proc/update_light()
	if(!light_power || !light_range)
		if(isnotnull(light))
			light.destroy()
			light = null
		return

	. = ismovable(loc) ? loc : src

	if(isnotnull(light))
		light.update(.)
	else
		light = new /datum/light_source(src, .)

/atom/New()
	. = ..()
	if(light_power && light_range)
		update_light()

	if(opacity && isturf(loc))
		var/turf/T = loc
		T.has_opaque_atom = TRUE // No need to recalculate it in this case, it's guranteed to be on afterwards anyways.

/atom/Destroy()
	if(isnotnull(light))
		light.destroy()
		light = null
	return ..()

/atom/Entered(atom/movable/mover, atom/old_loc)
	. = ..()
	if(isnotnull(mover) && old_loc != src)
		for_no_type_check(var/datum/light_source/L, mover.light_sources)
			L.source_atom.update_light()

/atom/movable/Destroy()
	var/turf/T = loc
	if(opacity && istype(T))
		T.reconsider_lights()
	return ..()

/atom/proc/set_opacity(new_opacity)
	if(new_opacity == opacity)
		return

	opacity = new_opacity
	var/turf/T = loc
	if(!isturf(T))
		return

	if(new_opacity == TRUE)
		T.has_opaque_atom = TRUE
		T.reconsider_lights()
	else
		var/old_has_opaque_atom = T.has_opaque_atom
		T.recalc_atom_opacity()
		if(old_has_opaque_atom != T.has_opaque_atom)
			T.reconsider_lights()

/obj/item/equipped()
	. = ..()
	update_light()

/obj/item/pickup()
	. = ..()
	update_light()

/obj/item/dropped()
	. = ..()
	update_light()