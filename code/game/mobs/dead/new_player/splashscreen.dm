GLOBAL_GLOBL_TYPED_NEW(splashscreen, /obj/effect/splashscreen)

/obj/effect/splashscreen
	name = "Space Station 13"
	icon = 'icons/hud/splashscreen.dmi'
	icon_state = "title"
	plane = FULLSCREEN_PLANE
	screen_loc = "WEST,SOUTH"

// Don't do anything because we're a damn splash screen.
/obj/effect/splashscreen/New()
	SHOULD_CALL_PARENT(FALSE)