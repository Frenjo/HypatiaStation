// Iron
/obj/item/stack/sheet/iron
	name = "iron"
	desc = "Sheets made from iron. They have been dubbed iron sheets."
	singular_name = "iron sheet"
	icon_state = "iron"

	matter_amounts = alist(/decl/material/iron = 1 MATERIAL_SHEET)
	throwforce = 13
	obj_flags = OBJ_FLAG_CONDUCT
	origin_tech = alist(/decl/tech/materials = 1)
	material = /decl/material/iron

// Steel
/obj/item/stack/sheet/steel
	name = "steel"
	desc = "Sheets made from an alloy of iron and carbon. They have been dubbed steel sheets."
	singular_name = "steel sheet"
	icon_state = "steel"
	matter_amounts = alist(/decl/material/steel = 1 MATERIAL_SHEET)
	throwforce = 14
	obj_flags = OBJ_FLAG_CONDUCT
	origin_tech = alist(/decl/tech/materials = 1)
	material = /decl/material/steel

/obj/item/stack/sheet/steel/cyborg
	matter_amounts = null

// Plasteel
/obj/item/stack/sheet/plasteel
	name = "plasteel"
	singular_name = "plasteel sheet"
	desc = "Sheets made from an alloy of iron, carbon and plasma."
	icon_state = "plasteel"
	item_state = "sheet-metal"
	matter_amounts = alist(/decl/material/steel = 1 MATERIAL_SHEET, /decl/material/plasma = 1 MATERIAL_SHEET)
	throwforce = 15
	obj_flags = OBJ_FLAG_CONDUCT
	origin_tech = alist(/decl/tech/materials = 2)
	material = /decl/material/plasteel

// Silver
/obj/item/stack/sheet/silver
	name = "silver"
	icon_state = "silver"
	matter_amounts = alist(/decl/material/silver = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 3)
	material = /decl/material/silver

/obj/item/stack/sheet/silver/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

// Gold
/obj/item/stack/sheet/gold
	name = "gold"
	icon_state = "gold"
	matter_amounts = alist(/decl/material/gold = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 4)
	material = /decl/material/gold

/obj/item/stack/sheet/gold/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

// Uranium
/obj/item/stack/sheet/uranium
	name = "uranium"
	icon_state = "uranium"
	matter_amounts = alist(/decl/material/uranium = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 5)
	material = /decl/material/uranium

/obj/item/stack/sheet/uranium/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

// Enriched Uranium
/obj/item/stack/sheet/enruranium
	name = "enriched uranium"
	icon_state = "enruranium"
	matter_amounts = alist(/decl/material/uranium = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 5)
	material = /decl/material/enriched_uranium

// Bananium
/obj/item/stack/sheet/bananium
	name = "bananium"
	icon_state = "bananium"
	matter_amounts = alist(/decl/material/bananium = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 4)
	material = /decl/material/bananium

/obj/item/stack/sheet/bananium/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

// Tranquilite
/obj/item/stack/sheet/tranquilite
	name = "tranquilite"
	icon_state = "tranquilite"
	matter_amounts = alist(/decl/material/tranquilite = 1 MATERIAL_SHEET)
	origin_tech = alist (/decl/tech/materials = 4)
	material = /decl/material/tranquilite

/obj/item/stack/sheet/tranquilite/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

// Adamantine
/obj/item/stack/sheet/adamantine
	name = "adamantine"
	icon_state = "adamantine"
	matter_amounts = alist(/decl/material/adamantine = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 4)
	material = /decl/material/adamantine

// Mythril
/obj/item/stack/sheet/mythril
	name = "mythril"
	icon_state = "mythril"
	matter_amounts = alist(/decl/material/mythril = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 4)
	material = /decl/material/mythril

// Durasteel
/obj/item/stack/sheet/durasteel
	name = "durasteel"
	icon_state = "durasteel"
	matter_amounts = alist(/decl/material/plasteel = 1 MATERIAL_SHEET, /decl/material/diamond = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 8)
	material = /decl/material/durasteel

// Imperium
/obj/item/stack/sheet/imperium
	name = "imperium alloy"
	icon_state = "imperium"
	blend_mode = BLEND_OVERLAY

	matter_amounts = alist(/decl/material/durasteel = 1 MATERIAL_SHEET, /decl/material/morphium = 1 MATERIAL_SHEET)
	origin_tech = alist(
		/decl/tech/materials = 8, /decl/tech/plasma = 4, /decl/tech/bluespace = 5,
		/decl/tech/syndicate = 1, /decl/tech/arcane = 1
	)
	material = /decl/material/imperium

/obj/item/stack/sheet/imperium/initialise()
	. = ..()
	start_hue_rotation()

/obj/item/stack/sheet/imperium/proc/start_hue_rotation()
	animate(src, color = color_matrix_rotate_hue(1), loop = -1, time = 0.25 SECONDS) // Start the loop.
	var/step_precision = 18 // Larger is more precise rotations.
	for(var/current_step in 1 to step_precision - 1) // We do the -1 here because 360 == 0 when it comes to angles.
		animate(
			color = color_matrix_rotate_hue(current_step * 360 / step_precision),
			loop = -1,
			time = 0.25 SECONDS
		)