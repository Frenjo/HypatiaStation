GLOBAL_GLOBL_LIST_NEW(atom/movable/space_star/space/parallax_stars)
GLOBAL_GLOBL_LIST_NEW(atom/movable/space_star/bluespace/parallax_bluespace_stars)

/proc/create_parallax()
	for(var/i = 0; i < PARALLAX_STAR_AMOUNT; i++)
		GLOBL.parallax_stars.Add(new /atom/movable/space_star/space())

	for(var/i = 0; i < PARALLAX_BLUESPACE_STAR_AMOUNT; i++)
		GLOBL.parallax_bluespace_stars.Add(new /atom/movable/space_star/bluespace())

/atom/movable/parallax_master
	screen_loc = UI_SPACE_PARALLAX
	appearance_flags = PLANE_MASTER
	mouse_opacity = FALSE
	atom_flags = ATOM_FLAG_UNSIMULATED

/atom/movable/parallax_master/space
	plane = SPACE_PARALLAX_PLANE
	blend_mode = BLEND_MULTIPLY

/atom/movable/parallax_master/bluespace
	plane = SPACE_DUST_PLANE
	blend_mode = BLEND_ADD

/atom/movable/space_parallax
	name = "space"
	icon = 'icons/hud/screen1_full.dmi'
	icon_state = "space_blank"
	screen_loc = UI_SPACE_PARALLAX
	plane = SPACE_PARALLAX_PLANE
	blend_mode = BLEND_ADD
	atom_flags = ATOM_FLAG_UNSIMULATED

	var/parallax_type = PARALLAX_SPACE

/atom/movable/space_star
	name = "star"
	icon = 'icons/turf/stars.dmi'
	blend_mode = BLEND_ADD
	appearance_flags = KEEP_APART
	atom_flags = ATOM_FLAG_UNSIMULATED

/atom/movable/space_star/New()
	. = ..()
	pixel_x = rand(-50, 530)
	pixel_y = rand(-50, 530)

/atom/movable/space_star/space
	icon_state = "star0"
	plane = SPACE_PARALLAX_PLANE

/atom/movable/space_star/space/New()
	. = ..()
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
	var/atom/movable/parallax_master/space/space_master
	var/atom/movable/parallax_master/bluespace/bluespace_master
	var/atom/movable/space_parallax/space_parallax

/client/proc/apply_parallax()
	// SPESS BACKGROUND
	if(isnull(space_master))
		space_master = new /atom/movable/parallax_master/space()
	if(isnull(bluespace_master))
		bluespace_master = new /atom/movable/parallax_master/bluespace()
	if(isnull(space_parallax))
		space_parallax = new /atom/movable/space_parallax()
	else
		space_parallax.cut_overlays()

	space_parallax.add_overlay(GLOBL.parallax_stars)
	screen |= list(space_master, space_parallax)

/client/proc/set_parallax_space(parallax_type)
	if(space_parallax.parallax_type == parallax_type)
		return

	space_parallax.parallax_type = parallax_type

	var/is_bluespace = (parallax_type == PARALLAX_BLUESPACE)
	space_parallax.icon_state = is_bluespace ? "bluespace" : "space_blank"
	space_parallax.cut_overlays()

	if(is_bluespace)
		space_parallax.add_overlay(GLOBL.parallax_bluespace_stars)
		screen |= bluespace_master
	else
		space_parallax.add_overlay(GLOBL.parallax_stars)
		screen.Remove(bluespace_master)

/mob/Move()
	. = ..()
	if(. && isnotnull(client))
		var/area/new_area = GET_AREA(src)
		client.set_parallax_space(new_area.parallax_type)

/mob/forceMove()
	. = ..()
	if(. && isnotnull(client))
		var/area/new_area = GET_AREA(src)
		client.set_parallax_space(new_area.parallax_type)

/area
	var/parallax_type = PARALLAX_SPACE