/*
 * Sandstone
 */
/obj/item/stack/sheet/sandstone
	name = "sandstone brick"
	desc = "This appears to be a combination of both sand and stone."
	singular_name = "sandstone brick"
	icon_state = "sandstone"
	throw_speed = 4
	throw_range = 5
	matter_amounts = alist(/decl/material/sandstone = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 1)
	material = /decl/material/sandstone

/obj/item/stack/sheet/sandstone/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()