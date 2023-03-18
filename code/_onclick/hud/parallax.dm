GLOBAL_GLOBL_LIST_NEW(parallax_stars)
GLOBAL_GLOBL_LIST_NEW(parallax_bluespace_stars)

/proc/create_parallax()
	for(var/i = 0; i < PARALLAX_STAR_AMOUNT; i++)
		GLOBL.parallax_stars.Add(new /atom/movable/space_star())

	for(var/i = 0; i < PARALLAX_BLUESPACE_STAR_AMOUNT; i++)
		GLOBL.parallax_bluespace_stars.Add(new /atom/movable/space_star/bluespace())

/atom/movable/parallax_master
	screen_loc = UI_SPACE_PARALLAX
	plane = SPACE_PARALLAX_PLANE
	blend_mode = BLEND_MULTIPLY
	appearance_flags = PLANE_MASTER
	mouse_opacity = FALSE
	simulated = FALSE

/atom/movable/parallax_master/bluespace
	plane = SPACE_DUST_PLANE
	blend_mode = BLEND_ADD

/atom/movable/space_parallax
	name = "space"
	icon = 'icons/mob/screen/screen1_full.dmi'
	icon_state = "space_blank"
	screen_loc = UI_SPACE_PARALLAX
	plane = SPACE_PARALLAX_PLANE
	blend_mode = BLEND_ADD
	simulated = FALSE

/atom/movable/space_star
	name = "star"
	icon = 'icons/turf/stars.dmi'
	icon_state = "star0"
	plane = SPACE_PARALLAX_PLANE
	blend_mode = BLEND_ADD
	appearance_flags = KEEP_APART
	simulated = FALSE

/atom/movable/space_star/New()
	// At a close look, only 2 tiles contain red stars(9,10), 3 contain blue(6,7,8), and 5 have white(1,2,3,4,5).
	// Let's try to keep that consistent by probability.
	// There's also a slightly higher chance for non-animated white stars(4,5) to break up the twinkle a bit.
	// Single stars(6,7,8,9,10) or small clusters(4,5) have a generally higher probability, whereas larger clusters(1,2,3) are generally more rare.
	// Along with the default single white star(0) if nothing else is chosen just to fill space.
	var/star_type = pick( \
		100; 0, \
		28; 1, \
		28; 2, \
		28; 3, \
		34; 4, \
		34; 5, \
		27; 6, \
		27; 7, \
		27; 8, \
		24; 9, \
		24; 10 \
	)
	icon_state = "astar[star_type]"
	pixel_x = rand(-50, 530)
	pixel_y = rand(-50, 530)

/atom/movable/space_star/bluespace
	icon_state = "bstar0"
	plane = SPACE_DUST_PLANE

/atom/movable/space_star/bluespace/New()
	. = ..()
	// These probabilities are mostly kept consistent to Halworsen's original implementation.
	var/star_type = pick( \
		100; 0, \
		50; 1, \
		10; 2, \
		1; 3, \
		10; 4, \
		15; 5, \
		75; 6 \
	)
	icon_state = "bstar[star_type]"

/client
	var/atom/movable/parallax_master/parallax_master
	var/atom/movable/parallax_master/bluespace/bluespace_master
	var/atom/movable/space_parallax/space_parallax

/client/proc/apply_parallax()
	// SPESS BACKGROUND
	if(isnull(parallax_master))
		parallax_master = new /atom/movable/parallax_master()
	if(isnull(bluespace_master))
		bluespace_master = new /atom/movable/parallax_master/bluespace()
	if(isnull(space_parallax))
		space_parallax = new /atom/movable/space_parallax()

	space_parallax.overlays |= GLOBL.parallax_stars
	screen |= list(parallax_master, space_parallax)

/client/proc/set_parallax_space(parallax_type)
	var/is_bluespace = (parallax_type == PARALLAX_BLUESPACE)
	space_parallax.icon_state = is_bluespace ? "bluespace" : "space_blank"
	space_parallax.overlays.Cut()

	if(is_bluespace)
		space_parallax.overlays |= GLOBL.parallax_bluespace_stars
		screen |= bluespace_master
	else
		space_parallax.overlays |= GLOBL.parallax_stars
		screen.Remove(bluespace_master)

/mob/Move()
	. = ..()
	if(. && !isnull(client))
		var/area/new_area = get_area(src)
		client.set_parallax_space(new_area.parallax_type)

/mob/forceMove()
	. = ..()
	if(. && !isnull(client))
		var/area/new_area = get_area(src)
		client.set_parallax_space(new_area.parallax_type)

/area
	var/parallax_type = PARALLAX_SPACE