/turf
	luminosity = TRUE

	var/dynamic_lighting = TRUE

	var/tmp/lighting_corners_initialised = FALSE

	var/tmp/list/datum/light_source/affecting_lights		// List of light sources affecting this turf.
	var/tmp/atom/movable/lighting_overlay/lighting_overlay	// Our lighting overlay.
	var/tmp/list/datum/lighting_corner/corners
	var/tmp/has_opaque_atom = FALSE // Not to be confused with opacity, this will be TRUE if there's any opaque atom on the tile.

/turf/New()
	. = ..()

	if(dynamic_lighting)
		luminosity = FALSE

	if(opacity)
		has_opaque_atom = TRUE

// Causes any affecting light sources to be queued for a visibility update, for example a door got opened.
/turf/proc/reconsider_lights()
	for(var/datum/light_source/L in affecting_lights)
		L.vis_update()

/turf/proc/lighting_clear_overlay()
	if(isnotnull(lighting_overlay))
		qdel(lighting_overlay)

	for(var/datum/lighting_corner/C in corners)
		C.update_active()

// Builds a lighting overlay for us, but only if our area is dynamic.
/turf/proc/lighting_build_overlay()
	if(isnotnull(lighting_overlay))
		return

	var/area/A = loc
	if(A.dynamic_lighting)
		if(!lighting_corners_initialised)
			generate_missing_corners()

		new /atom/movable/lighting_overlay(src)

		for(var/datum/lighting_corner/C in corners)
			if(!C.active) // We would activate the corner, calculate the lighting for it.
				for(var/L in C.affecting)
					var/datum/light_source/S = L
					S.recalc_corner(C)

				C.active = TRUE

// Used to get a scaled lumcount.
/turf/proc/get_lumcount(minlum = 0, maxlum = 1)
	if(isnull(lighting_overlay))
		return 1

	var/total_lums = 0
	for(var/datum/lighting_corner/L in corners)
		total_lums += max(L.lum_r, L.lum_g, L.lum_b)

	total_lums /= 4 // 4 corners, max channel selected, return the average

	total_lums = (total_lums - minlum) / (maxlum - minlum)

	return CLAMP01(total_lums)

// Can't think of a good name, this proc will recalculate the has_opaque_atom variable.
/turf/proc/recalc_atom_opacity()
	has_opaque_atom = FALSE
	for(var/atom/A in contents + src) // Loop through every movable atom on our tile PLUS ourselves (we matter too...)
		if(A.opacity)
			has_opaque_atom = TRUE

// If an opaque movable atom moves around we need to potentially update visibility.
/turf/Entered(atom/movable/mover, atom/OldLoc)
	. = ..()

	if(mover?.opacity)
		has_opaque_atom = TRUE // Make sure to do this before reconsider_lights(), incase we're on instant updates. Guaranteed to be on in this case.
		reconsider_lights()

/turf/Exited(atom/movable/mover, atom/newloc)
	. = ..()

	if(mover?.opacity)
		recalc_atom_opacity() // Make sure to do this before reconsider_lights(), incase we're on instant updates.
		reconsider_lights()

/turf/proc/get_corners()
	if(has_opaque_atom)
		return null // Since this proc gets used in a for loop, null won't be looped though.

	return corners

/turf/proc/generate_missing_corners()
	lighting_corners_initialised = TRUE
	if(isnull(corners))
		corners = list(null, null, null, null)

	for(var/i = 1 to 4)
		if(isnotnull(corners[i])) // Already have a corner on this direction.
			continue

		corners[i] = new /datum/lighting_corner(src, global.lighting_corner_diagonal[i])