/*
 * Beach
 */
/turf/open/floor/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'

/turf/open/floor/beach/sand
	name = "sand"
	icon_state = "sand"

/turf/open/floor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/open/floor/beach/water
	name = "water"
	icon_state = "water"

/turf/open/floor/beach/water/New()
	. = ..()
	var/image/water = image(icon = 'icons/misc/beach.dmi', icon_state = "water5")
	water.plane = DEFAULT_PLANE
	water.layer = MOB_LAYER + 0.1
	overlays.Add(water)