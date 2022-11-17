GLOBAL_GLOBL_LIST_NEW(parallax_stars)
GLOBAL_GLOBL_LIST_NEW(parallax_bluespace_stars)

/proc/create_parallax()
	for(var/i = 0; i < PARALLAX_STAR_AMOUNT; i++)
		GLOBL.parallax_stars += new /obj/space_star()

	for(var/i = 0; i < PARALLAX_BLUESPACE_STAR_AMOUNT; i++)
		GLOBL.parallax_bluespace_stars += new /obj/space_star/bluespace()

/obj/parallax_master
	screen_loc = UI_SPACE_PARALLAX
	plane = SPACE_PARALLAX_PLANE
	blend_mode = BLEND_MULTIPLY
	appearance_flags = PLANE_MASTER
	mouse_opacity = 0
	simulated = FALSE

/obj/parallax_master/bluespace
	plane = SPACE_DUST_PLANE
	blend_mode = BLEND_ADD

/obj/space_parallax
	name = "space"
	icon = 'icons/mob/screen1_full.dmi'
	icon_state = "space_blank"
	screen_loc = UI_SPACE_PARALLAX
	plane = SPACE_PARALLAX_PLANE
	blend_mode = BLEND_ADD
	simulated = FALSE

/obj/space_star
	name = "star"
	icon = 'icons/turf/stars.dmi'
	icon_state = "star0"
	plane = SPACE_PARALLAX_PLANE
	blend_mode = BLEND_ADD
	appearance_flags = KEEP_APART
	simulated = FALSE

/obj/space_star/New()
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

/obj/space_star/bluespace
	icon_state = "bstar0"
	plane = SPACE_DUST_PLANE

/obj/space_star/bluespace/New()
	..()
	var/star_type = pick(prob(100); 0, prob(50); 1, prob(10); 2, prob(1); 3, prob(10); 4, prob(15); 5, prob(75); 6)
	icon_state = "bstar[star_type]"

/client
	var/obj/parallax_master/parallax_master
	var/obj/parallax_master/bluespace/bluespace_master
	var/obj/space_parallax/space_parallax

/client/proc/apply_parallax()
	// SPESS BACKGROUND
	if(!parallax_master && !bluespace_master && !space_parallax)
		parallax_master = new /obj/parallax_master()
		bluespace_master = new /obj/parallax_master/bluespace()
		space_parallax = new /obj/space_parallax()
	
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
		screen -= bluespace_master

/mob/Move()
	. = ..()
	if(. && client)
		var/area/new_area = get_area(src)
		client.set_parallax_space(new_area.parallax_type)

/mob/forceMove()
	. = ..()
	if(. && client)
		var/area/new_area = get_area(src)
		client.set_parallax_space(new_area.parallax_type)

/area
	var/parallax_type = PARALLAX_SPACE