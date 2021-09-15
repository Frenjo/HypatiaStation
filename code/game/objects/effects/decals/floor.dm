/obj/effect/decal/floor
	name = "floor decal"
	icon = 'icons/turf/floor_decals.dmi'
	layer = TURF_LAYER

/obj/effect/decal/floor/initialize()
	. = ..()
	loc.set_dir(src.dir)
	loc.overlays += src
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

// Siding
/obj/effect/decal/floor/siding
	name = "siding"

// Black siding - IE Hydroponics siding.
/obj/effect/decal/floor/siding/black
	icon_state = "siding_full"

/obj/effect/decal/floor/siding/black/border
	icon_state = "siding_border"

/obj/effect/decal/floor/siding/black/tri_border
	icon_state = "siding_tri_border"

/obj/effect/decal/floor/siding/black/corner
	icon_state = "siding_corner"

// Wood siding
/obj/effect/decal/floor/siding/wood
	name = "wood siding"
	icon_state = "siding_wood_full"

/obj/effect/decal/floor/siding/wood/border
	icon_state = "siding_wood_border"

/obj/effect/decal/floor/siding/wood/double_border
	icon_state = "siding_wood_double_border"

/obj/effect/decal/floor/siding/wood/tri_border
	icon_state = "siding_wood_tri_border"

// Floor signs
/obj/effect/decal/floor/sign
	name = "sign"

/obj/effect/decal/floor/sign/a1
	name = "a1 sign"
	icon_state = "sign_a1"

/obj/effect/decal/floor/sign/a2
	name = "a2 sign"
	icon_state = "sign_a2"

/obj/effect/decal/floor/sign/di
	name = "di sign"
	icon_state = "sign_di"

/obj/effect/decal/floor/sign/sa
	name = "sa sign"
	icon_state = "sign_sa"

/obj/effect/decal/floor/sign/sb
	name = "sb sign"
	icon_state = "sign_sb"

/obj/effect/decal/floor/sign/sc
	name = "sc sign"
	icon_state = "sign_sc"

/obj/effect/decal/floor/sign/w
	name = "w sign"
	icon_state = "sign_w"

/obj/effect/decal/floor/sign/v
	name = "v sign"
	icon_state = "sign_v"

/obj/effect/decal/floor/sign/psy
	name = "psy sign"
	icon_state = "sign_psy"

/obj/effect/decal/floor/sign/ex
	name = "ex sign"
	icon_state = "sign_ex"

/obj/effect/decal/floor/sign/m
	name = "m sign"
	icon_state = "sign_m"

/obj/effect/decal/floor/sign/cmo
	name = "cmo sign"
	icon_state = "sign_cmo"

// Solar
/obj/effect/decal/floor/solar_panel
	name = "solar panel"
	icon_state = "solarpanel"

// Industrial markings
/obj/effect/decal/floor/industrial
	name = "industrial floor decal"

/obj/effect/decal/floor/industrial/delivery
	name = "delivery marking"
	icon_state = "delivery"

/obj/effect/decal/floor/industrial/bot
	name = "bot marking"
	icon_state = "bot"

/obj/effect/decal/floor/industrial/loadingarea
	name = "loading area"
	icon_state = "loadingarea"

// Warning stripes
/obj/effect/decal/floor/industrial/warning
	name = "warning stripes"

/obj/effect/decal/floor/industrial/warning/border
	icon_state = "warning_border"

/obj/effect/decal/floor/industrial/warning/tri_border
	icon_state = "warning_tri_border"

/obj/effect/decal/floor/industrial/warning/corner
	icon_state = "warning_corner"