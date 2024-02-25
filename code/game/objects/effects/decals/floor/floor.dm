/obj/effect/decal/floor
	name = "floor decal"
	icon = 'icons/turf/floor_decals.dmi'
	layer = TURF_LAYER

/obj/effect/decal/floor/initialise()
	. = ..()
	loc.overlays.Add(image(icon, loc, icon_state, layer, dir))
	qdel(src)

// Chapel floor pattern
/obj/effect/decal/floor/chapel
	name = "chapel"

/obj/effect/decal/floor/chapel/red
	name = "chapel red"
	icon_state = "chapel_red"

/obj/effect/decal/floor/chapel/yellow
	name = "chapel yellow"
	icon_state = "chapel_yellow"

// Solar
/obj/effect/decal/floor/solar_panel
	name = "solar panel"
	icon_state = "solarpanel"