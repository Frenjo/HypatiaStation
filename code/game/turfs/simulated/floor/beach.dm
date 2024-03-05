/*
 * Beach
 */
/turf/simulated/floor/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'

/turf/simulated/floor/beach/sand
	name = "sand"
	icon_state = "sand"

/turf/simulated/floor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/simulated/floor/beach/water
	name = "water"
	icon_state = "water"

/turf/simulated/floor/beach/water/New()
	. = ..()
	var/image/water = image(icon = 'icons/misc/beach.dmi', icon_state = "water5")
	water.plane = DEFAULT_PLANE
	water.layer = MOB_LAYER + 0.1
	overlays.Add(water)