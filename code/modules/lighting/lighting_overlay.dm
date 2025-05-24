GLOBAL_GLOBL_LIST_NEW(all_lighting_overlays) // Global list of lighting overlays.

/atom/movable/lighting_overlay
	name = ""
	icon = LIGHTING_ICON
	icon_state = "light1"
	plane = LIGHTING_PLANE
	anchored = TRUE
	mouse_opacity = FALSE
	invisibility = INVISIBILITY_LIGHTING
	color = LIGHTING_BASE_MATRIX
	blend_mode = BLEND_MULTIPLY

	atom_flags = ATOM_FLAG_UNSIMULATED

	var/lum_r = 0
	var/lum_g = 0
	var/lum_b = 0

	var/needs_update = FALSE

/atom/movable/lighting_overlay/New(atom/loc, no_update = FALSE)
	var/turf/T = loc // If this runtimes atleast we'll know what's creating overlays outside of turfs.
	if(!T.dynamic_lighting) // Only put lighting overlays on turfs with dynamic lighting enabled.
		qdel(src)
		return

	. = ..()
	verbs.Cut()
	GLOBL.all_lighting_overlays.Add(src)

	T.lighting_overlay = src
	T.luminosity = FALSE
	if(no_update)
		return
	update_overlay()

/atom/movable/lighting_overlay/Destroy()
	GLOBL.all_lighting_overlays.Remove(src)
	global.PClighting.lighting_update_overlays.Remove(src)
	global.PClighting.lighting_update_overlays_old.Remove(src)

	var/turf/T = loc
	if(istype(T))
		T.lighting_overlay = null
		T.luminosity = TRUE

	return ..()

// Lighting overlays should not be moving.
/atom/movable/lighting_overlay/Move()
	return
/atom/movable/lighting_overlay/forceMove(atom/destination)
	if(GC_DESTROYED(src))
		return ..() // Unless they're being deleted for some strange reason.
	return 0
// Lighting overlays should not get exploded either.
/atom/movable/lighting_overlay/ex_act()
	return

/atom/movable/lighting_overlay/proc/update_overlay()
	set waitfor = FALSE
	var/turf/T = loc
	if(!istype(T))
		if(isnotnull(loc))
			log_debug("A lighting overlay realised its loc was NOT a turf (actual loc: [loc][loc ? ", " + loc.type : "null"]) in update_overlay() and got qdel'ed!")
		else
			log_debug("A lighting overlay realised it was in nullspace in update_overlay() and got pooled!")
		qdel(src)
		return

	// To the future coder who sees this and thinks
	// "Why didn't he just use a loop?"
	// Well my man, it's because the loop performed like shit.
	// And there's no way to improve it because
	// without a loop you can make the list all at once which is the fastest you're gonna get.
	// Oh it's also shorter line wise.
	// Including with these comments.

	// See LIGHTING_CORNER_DIAGONAL in lighting_corner.dm for why these values are what they are.
	// No I seriously cannot think of a more efficient method, fuck off Comic.
	var/list/corners = T.corners
	var/static/datum/lighting_corner/dummy/dummy_lighting_corner = new /datum/lighting_corner/dummy()
	var/datum/lighting_corner/cr = corners[3] || dummy_lighting_corner
	var/datum/lighting_corner/cg = corners[2] || dummy_lighting_corner
	var/datum/lighting_corner/cb = corners[4] || dummy_lighting_corner
	var/datum/lighting_corner/ca = corners[1] || dummy_lighting_corner

	var/max = max(cr.cache_mx, cg.cache_mx, cb.cache_mx, ca.cache_mx)

	var/list/new_matrix = list(
		cr.cache_r, cr.cache_g, cr.cache_b, 0,
		cg.cache_r, cg.cache_g, cg.cache_b, 0,
		cb.cache_r, cb.cache_g, cb.cache_b, 0,
		ca.cache_r, ca.cache_g, ca.cache_b, 0,
		0, 0, 0, 1
	)
	var/lum = max > LIGHTING_SOFT_THRESHOLD

	if(lum)
		luminosity = TRUE
		animate(src, color = new_matrix, time = 5)
	else
		animate(src, color = new_matrix, time = 5)
		animate(luminosity = FALSE, time = 0)