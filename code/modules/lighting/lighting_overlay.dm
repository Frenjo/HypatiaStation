GLOBAL_GLOBL_LIST_NEW(all_lighting_overlays) // Global list of lighting overlays.

/atom/movable/lighting_overlay
	name = ""
	mouse_opacity = FALSE
	simulated = FALSE
	anchored = TRUE
	icon = LIGHTING_ICON
	plane = LIGHTING_PLANE
	invisibility = INVISIBILITY_LIGHTING
	color = LIGHTING_BASE_MATRIX
	icon_state = "light1"
	blend_mode = BLEND_MULTIPLY

	var/lum_r = 0
	var/lum_g = 0
	var/lum_b = 0

	var/needs_update = FALSE

/atom/movable/lighting_overlay/New(atom/loc, no_update = FALSE)
	. = ..()
	verbs.Cut()
	GLOBL.all_lighting_overlays.Add(src)

	var/turf/T = loc //If this runtimes atleast we'll know what's creating overlays outside of turfs.
	T.lighting_overlay = src
	T.luminosity = FALSE
	if(no_update)
		return
	update_overlay()

/atom/movable/lighting_overlay/Destroy()
	GLOBL.all_lighting_overlays.Remove(src)
	GLOBL.lighting_update_overlays.Remove(src)
	GLOBL.lighting_update_overlays_old.Remove(src)

	var/turf/T = loc
	if(istype(T))
		T.lighting_overlay = null
		T.luminosity = TRUE

	return ..()

/atom/movable/lighting_overlay/proc/update_overlay()
	set waitfor = FALSE
	var/turf/T = loc

	if(!istype(T))
		if(!isnull(loc))
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
	var/datum/lighting_corner/cr = T.corners[3] || global.dummy_lighting_corner
	var/datum/lighting_corner/cg = T.corners[2] || global.dummy_lighting_corner
	var/datum/lighting_corner/cb = T.corners[4] || global.dummy_lighting_corner
	var/datum/lighting_corner/ca = T.corners[1] || global.dummy_lighting_corner

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