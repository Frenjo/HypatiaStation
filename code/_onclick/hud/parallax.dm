/obj/screen/parallax_master
	screen_loc = UI_SPACE_PARALLAX
	plane = SPACE_PARALLAX_PLANE
	blend_mode = BLEND_MULTIPLY
	appearance_flags = PLANE_MASTER
	mouse_opacity = 0

/obj/screen/space_parallax
	icon = 'icons/mob/screen1_full.dmi'
	icon_state = "space"
	name = "space"
	screen_loc = UI_SPACE_PARALLAX
	plane = SPACE_PARALLAX_PLANE
	blend_mode = BLEND_ADD

/obj/screen/space_star
	icon = 'icons/turf/stars.dmi'
	icon_state = "star0"
	name = "star"
	plane = SPACE_PARALLAX_PLANE
	blend_mode = BLEND_ADD
	appearance_flags = KEEP_APART

/obj/screen/space_star/New()
	//var/star_type = pick( prob(100); 0, prob(10); 1, prob(1); 2 )
	// At a close look, only 2 tiles contain red stars(9,10), lots more contain blue(6,7,8), and white are everywhere(1,2,3,4,5).
	// Let's try to keep that consistent by probability.
	// There's also a slightly higher chance for non-animated white stars(3,4) to break up the twinkle a bit.
	// Along with the default single white star(0) if nothing else is chosen just to fill space.
	var/star_type = pick(prob(100); 0, prob(38); 1, prob(38); 2, prob(38); 3, prob(40); 4, prob(40); 5, prob(30); 6, prob(25); 7, prob(25); 8, prob(15); 9, prob(14); 10)
	//icon_state = "star[star_type]"
	icon_state = "astar[star_type]"
	//screen_loc = "[rand( 1, 15 )]:[rand( -16, 16 )],[rand( 1, 15 )]:[rand( -16, 16 )]"
	pixel_x = rand(-50, 530)
	pixel_y = rand(-50, 530)

/obj/screen/space_star/bluespace
	icon_state = "bstar0"
	plane = SPACE_DUST_PLANE

/obj/screen/space_star/bluespace/New()
	..()
	var/star_type = pick(prob(100); 0, prob(50); 1, prob(10); 2, prob(1); 3, prob(10); 4, prob(15); 5, prob(75); 6)
	icon_state = "bstar[star_type]"

/datum/hud/proc/create_parallax()
	// SPESS BACKGROUND
	mymob.parallax_master = new /obj/screen/parallax_master()
	mymob.space_parallax = new /obj/screen/space_parallax()
	mymob.space_parallax.overlays |= global_hud.parallax_stars

	mymob.client.screen |= mymob.parallax_master
	mymob.client.screen |= mymob.space_parallax

/datum/hud/proc/toggle_parallax_space()
	var/space_mode = mymob.space_parallax.icon_state == "space" ? 1 : 0
	mymob.space_parallax.icon_state = "[space_mode ? "bluespace" : "space"]"
	mymob.space_parallax.overlays.Cut()

	if(space_mode)
		mymob.space_parallax.overlays |= global_hud.parallax_bluespace_stars
	else
		mymob.space_parallax.overlays |= global_hud.parallax_stars