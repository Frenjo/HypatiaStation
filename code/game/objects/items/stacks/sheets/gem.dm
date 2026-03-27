// Diamond
/obj/item/stack/sheet/diamond
	name = "diamond"
	icon_state = "diamond"
	matter_amounts = alist(/decl/material/diamond = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 6)
	material = /decl/material/diamond

/obj/item/stack/sheet/diamond/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

// Plasma
/obj/item/stack/sheet/plasma
	name = "solid plasma"
	icon_state = "plasma"
	matter_amounts = alist(/decl/material/plasma = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/plasma = 2)
	material = /decl/material/plasma

/obj/item/stack/sheet/plasma/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

// Valhollide
/obj/item/stack/sheet/valhollide
	name = "valhollide"
	icon_state = "valhollide"
	matter_amounts = alist(/decl/material/valhollide = 1 MATERIAL_SHEET)
	origin_tech = alist(
		/decl/tech/materials = 7, /decl/tech/plasma = 5, /decl/tech/bluespace = 5
	)
	material = /decl/material/valhollide

// Verdantium
/obj/item/stack/sheet/verdantium
	name = "verdantium"
	icon_state = "verdantium"
	matter_amounts = alist(/decl/material/verdantium = 1 MATERIAL_SHEET)
	origin_tech = alist(
		/decl/tech/materials = 6, /decl/tech/biotech = 4, /decl/tech/power_storage = 5
	)
	material = /decl/material/verdantium

// Morphium
/obj/item/stack/sheet/morphium
	name = "morphium"
	icon_state = "morphium"
	matter_amounts = alist(/decl/material/morphium = 1 MATERIAL_SHEET)
	origin_tech = alist(
		/decl/tech/materials = 7, /decl/tech/plasma = 4, /decl/tech/bluespace = 4,
		/decl/tech/syndicate = 1, /decl/tech/arcane = 1
	)
	material = /decl/material/morphium