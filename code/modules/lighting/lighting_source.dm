// This is where the fun begins.
// These are the main datums that emit light.

/datum/light_source
	var/atom/top_atom		// The atom we're emitting light from(for example a mob if we're from a flashlight that's being held).
	var/atom/source_atom	// The atom that we belong to.

	var/turf/source_turf	// The turf under the above.
	var/light_power			// Intensity of the emitter light.
	var/light_range			// The range of the emitted light.
	var/light_color			// The colour of the light, string, decomposed by parse_light_color()

	// Variables for keeping track of the colour.
	var/lum_r
	var/lum_g
	var/lum_b

	// The lumcount values used to apply the light.
	var/tmp/applied_lum_r
	var/tmp/applied_lum_g
	var/tmp/applied_lum_b

	var/list/datum/lighting_corner/effect_str	// List used to store how much we're affecting corners.
	var/list/turf/affecting_turfs

	var/applied = FALSE // Whether we have applied our light yet or not.

	var/vis_update		// Whether we should smartly recalculate visibility. and then only update tiles that became(in)visible to us.
	var/needs_update	// Whether we are queued for an update.
	var/destroyed		// Whether we are destroyed and need to stop emitting light.
	var/force_update

/datum/light_source/New(atom/owner, atom/top)
	source_atom = owner // Set our new owner.
	LAZYADD(source_atom.light_sources, src) // Add us to the lights of our owner.
	top_atom = top
	if(top_atom != source_atom)
		LAZYADD(top_atom.light_sources, src)

	source_turf = top_atom
	light_power = source_atom.light_power
	light_range = source_atom.light_range
	light_color = source_atom.light_color

	parse_light_color()

	effect_str = list()
	affecting_turfs = list()

	update()

	return ..()

// Kill ourselves.
/datum/light_source/proc/destroy()
	destroyed = TRUE
	force_update()
	if(isnotnull(source_atom))
		source_atom.light_sources.Remove(src)

	if(isnotnull(top_atom))
		top_atom.light_sources.Remove(src)

// Call it dirty, I don't care.
// This is here so there's no performance loss on non-instant updates from the fact that the engine can also do instant updates.
#define EFFECT_UPDATE	\
	if(!needs_update)		\
	{						\
		global.PClighting.lighting_update_lights.Add(src);	\
		needs_update = TRUE;	\
	}

// This proc will cause the light source to update the top atom, and add itself to the update queue.
/datum/light_source/proc/update(atom/new_top_atom)
	// This top atom is different.
	if(isnotnull(new_top_atom) && new_top_atom != top_atom)
		if(top_atom != source_atom) // Remove ourselves from the light sources of that top atom.
			top_atom.light_sources.Remove(src)

		top_atom = new_top_atom

		if(top_atom != source_atom)
			LAZYADD(top_atom.light_sources, src) // Add ourselves to the light sources of our new top atom.

	EFFECT_UPDATE

// Will force an update without checking if it's actually needed.
/datum/light_source/proc/force_update()
	force_update = TRUE

	EFFECT_UPDATE

// Will cause the light source to recalculate turfs that were removed or added to visibility only.
/datum/light_source/proc/vis_update()
	vis_update = TRUE

	EFFECT_UPDATE

// Will check if we actually need to update, and update any variables that may need to be updated.
/datum/light_source/proc/check()
	if(isnull(source_atom) || !light_range || !light_power)
		destroy()
		return TRUE

	if(isnull(top_atom))
		top_atom = source_atom
		. = TRUE

	if(isturf(top_atom))
		if(source_turf != top_atom)
			source_turf = top_atom
			. = TRUE
	else if(top_atom.loc != source_turf)
		source_turf = top_atom.loc
		. = TRUE

	if(source_atom.light_power != light_power)
		light_power = source_atom.light_power
		. = TRUE

	if(source_atom.light_range != light_range)
		light_range = source_atom.light_range
		. = TRUE

	if(light_range && light_power && !applied)
		. = TRUE

	if(source_atom.light_color != light_color)
		light_color = source_atom.light_color
		parse_light_color()
		. = TRUE

// Decompile the hexadecimal colour into lumcounts of each perspective.
/datum/light_source/proc/parse_light_color()
	if(light_color)
		var/list/colour_list = rgb2num(light_color)
		lum_r = colour_list[1] / 255
		lum_g = colour_list[2] / 255
		lum_b = colour_list[3] / 255
	else
		lum_r = 1
		lum_g = 1
		lum_b = 1

// Macro that applies light to a new corner.
// It is a macro in the interest of speed, yet not having to copy paste it.
// If you're wondering what's with the backslashes, the backslashes cause BYOND to not automatically end the line.
// As such this all gets counted as a single line.
// The braces and semicolons are there to be able to do this on a single line.

#define APPLY_CORNER(C)					\
	. = LUM_FALLOFF(C, source_turf);	\
										\
	. *= light_power / 2;				\
										\
	effect_str[C] = .;					\
										\
	C.update_lumcount					\
	(									\
		. * applied_lum_r,				\
		. * applied_lum_g,				\
		. * applied_lum_b				\
	);

// I don't need to explain what this does, do I?
#define REMOVE_CORNER(C)				\
	. = -effect_str[C];					\
	C.update_lumcount					\
	(									\
		. * applied_lum_r,				\
		. * applied_lum_g,				\
		. * applied_lum_b				\
	);

// This is the define used to calculate falloff.
#define LUM_FALLOFF(C, T) (1 - CLAMP01(sqrt((C.x - T.x) ** 2 +(C.y - T.y) ** 2 + LIGHTING_HEIGHT) / max(1, light_range)))

/datum/light_source/proc/apply_lum()
	var/static/update_gen = 1
	applied = TRUE

	// Keep track of the last applied lum values so that the lighting can be reversed
	applied_lum_r = lum_r
	applied_lum_g = lum_g
	applied_lum_b = lum_b

	FOR_DVIEW(var/turf/T, light_range, source_turf, INVISIBILITY_LIGHTING)
		if(!T.lighting_corners_initialised)
			T.generate_missing_corners()

		for_no_type_check(var/datum/lighting_corner/C, T.get_corners())
			if(C.update_gen == update_gen)
				continue

			C.update_gen = update_gen
			C.affecting.Add(src)

			if(!C.active)
				effect_str[C] = 0
				continue

			APPLY_CORNER(C)

		LAZYADD(T.affecting_lights, src)
		affecting_turfs.Add(T)
	END_FOR_DVIEW

	update_gen++

/datum/light_source/proc/remove_lum()
	applied = FALSE

	for_no_type_check(var/turf/T, affecting_turfs)
		if(isnull(T.affecting_lights))
			T.affecting_lights = list()
		else
			T.affecting_lights.Remove(src)

	affecting_turfs.Cut()

	for_no_type_check(var/datum/lighting_corner/C, effect_str)
		REMOVE_CORNER(C)

		C.affecting.Remove(src)

	effect_str.Cut()

/datum/light_source/proc/recalc_corner(datum/lighting_corner/C)
	if(effect_str.Find(C)) // Already have one.
		REMOVE_CORNER(C)

	APPLY_CORNER(C)

/datum/light_source/proc/smart_vis_update()
	var/list/datum/lighting_corner/corners = list()
	var/list/turf/turfs = list()
	FOR_DVIEW(var/turf/T, light_range, source_turf, 0)
		if(!T.lighting_corners_initialised)
			T.generate_missing_corners()
		corners |= T.get_corners()
		turfs.Add(T)
	END_FOR_DVIEW

	var/list/turf/L = turfs - affecting_turfs // New turfs, add us to the affecting lights of them.
	affecting_turfs.Add(L)
	for_no_type_check(var/turf/T, L)
		if(isnull(T.affecting_lights))
			T.affecting_lights = list(src)
		else
			T.affecting_lights.Add(src)

	L = affecting_turfs - turfs // Now-gone turfs, remove us from the affecting lights.
	affecting_turfs.Remove(L)
	for_no_type_check(var/turf/T, L)
		T.affecting_lights.Remove(src)

	for_no_type_check(var/datum/lighting_corner/C, corners - effect_str) // New corners
		if(isnull(C))
			corners.Remove(C)
			continue
		C.affecting.Add(src)
		if(!C.active)
			effect_str[C] = 0
			continue

		APPLY_CORNER(C)

	for_no_type_check(var/datum/lighting_corner/C, effect_str - corners) // Old, now gone, corners.
		REMOVE_CORNER(C)
		C.affecting.Remove(src)
		effect_str.Remove(C)

#undef EFFECT_UPDATE
#undef LUM_FALLOFF
#undef REMOVE_CORNER
#undef APPLY_CORNER