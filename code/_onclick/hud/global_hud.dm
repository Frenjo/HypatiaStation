/*
 * The global hud.
 *
 * Uses the same visual objects for all players.
 */
GLOBAL_GLOBL_NEW(global_hud, /datum/global_hud)

/datum/global_hud
	var/atom/movable/screen/druggy
	var/atom/movable/screen/blurry
	var/list/atom/movable/screen/vimpaired
	var/list/atom/movable/screen/darkMask

	/*
	 * Overlays for effects from various types of goggles.
	 */
	var/atom/movable/screen/nvg
	var/atom/movable/screen/science
	var/atom/movable/screen/thermal
	var/atom/movable/screen/meson

	/*
	 * Overlays for effects from different types of storm events.
	 */
	var/atom/movable/screen/rad_storm
	var/atom/movable/screen/ion_storm
	var/atom/movable/screen/electrical_storm

/*
 * Factory proc for fullscreen overlay objects.
 */
/datum/global_hud/proc/setup_overlay(icon_state)
	RETURN_TYPE(/atom/movable/screen)

	var/atom/movable/screen/screen = new /atom/movable/screen()
	screen.screen_loc = "1,1"
	screen.icon = 'icons/obj/hud_full.dmi'
	screen.icon_state = icon_state
	screen.plane = FULLSCREEN_PLANE
	screen.mouse_opacity = FALSE

	return screen

/*
 * Factory proc for fullscreen storm overlay objects.
 */
/datum/global_hud/proc/setup_storm_overlay(colour, icon_state = "mfoam")
	RETURN_TYPE(/atom/movable/screen)

	var/atom/movable/screen/screen = new /atom/movable/screen()
	screen.screen_loc = "WEST,SOUTH to EAST,NORTH"
	screen.icon = 'icons/effects/effects.dmi'
	screen.icon_state = icon_state
	screen.color = colour
	screen.alpha = 65
	screen.plane = FULLSCREEN_PLANE
	screen.blend_mode = BLEND_SUBTRACT
	screen.mouse_opacity = FALSE

	return screen

/datum/global_hud/New()
	. = ..()

	// 420erryday psychedellic colours screen overlay for when you are high.
	druggy = new /atom/movable/screen()
	druggy.screen_loc = "WEST,SOUTH to EAST,NORTH"
	druggy.icon_state = "druggy"
	druggy.plane = FULLSCREEN_PLANE
	druggy.mouse_opacity = FALSE

	// That white blurry effect you get when your eyes are damaged.
	blurry = new /atom/movable/screen()
	blurry.screen_loc = "WEST,SOUTH to EAST,NORTH"
	blurry.icon_state = "blurry"
	blurry.plane = FULLSCREEN_PLANE
	blurry.mouse_opacity = FALSE

	// Goggle effects.
	nvg = setup_overlay("nvg_hud")
	science = setup_overlay("science_hud")
	thermal = setup_overlay("thermal_hud")
	meson = setup_overlay("meson_hud")

	// Storm event effects.
	rad_storm = setup_storm_overlay("#0066ff")
	ion_storm = setup_storm_overlay("#ffdb60")
	electrical_storm = setup_storm_overlay("#00ffcc")

	// That nasty looking dither you get when you're short-sighted.
	vimpaired = newlist(/atom/movable/screen, /atom/movable/screen, /atom/movable/screen, /atom/movable/screen)
	vimpaired[1].screen_loc = "1,1 to 5,15"
	vimpaired[2].screen_loc = "5,1 to 10,5"
	vimpaired[3].screen_loc = "6,11 to 10,15"
	vimpaired[4].screen_loc = "11,1 to 15,15"

	// Welding mask overlay black/dither.
	darkMask = newlist(/atom/movable/screen, /atom/movable/screen, /atom/movable/screen, /atom/movable/screen, /atom/movable/screen, /atom/movable/screen, /atom/movable/screen, /atom/movable/screen)
	darkMask[1].screen_loc = "3,3 to 5,13"
	darkMask[2].screen_loc = "5,3 to 10,5"
	darkMask[3].screen_loc = "6,11 to 10,13"
	darkMask[4].screen_loc = "11,3 to 13,13"
	darkMask[5].screen_loc = "1,1 to 15,2"
	darkMask[6].screen_loc = "1,3 to 2,15"
	darkMask[7].screen_loc = "14,3 to 15,15"
	darkMask[8].screen_loc = "3,14 to 13,15"

	var/i
	for(i = 1, i <= 4, i++)
		vimpaired[i].icon_state = "dither50"
		vimpaired[i].plane = FULLSCREEN_PLANE
		vimpaired[i].mouse_opacity = FALSE

		darkMask[i].icon_state = "dither50"
		darkMask[i].plane = FULLSCREEN_PLANE
		darkMask[i].mouse_opacity = FALSE

	for(i = 5, i <= 8, i++)
		darkMask[i].icon_state = "black"
		darkMask[i].plane = FULLSCREEN_PLANE
		darkMask[i].mouse_opacity = FALSE