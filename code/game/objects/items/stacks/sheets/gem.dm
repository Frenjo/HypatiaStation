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