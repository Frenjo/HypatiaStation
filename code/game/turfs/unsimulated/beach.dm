/turf/unsimulated/beach
	name = "beach"
	icon = 'icons/misc/beach.dmi'

/turf/unsimulated/beach/sand
	name = "sand"
	icon_state = "sand"

/turf/unsimulated/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/unsimulated/beach/water
	name = "water"
	icon_state = "water"

/turf/unsimulated/beach/water/New()
	. = ..()
	overlays.Add(image("icon" = 'icons/misc/beach.dmi', "icon_state" = "water2", "layer" = MOB_LAYER + 0.1))
