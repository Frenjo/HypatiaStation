/*
 * Plastic
 */
/obj/item/stack/sheet/plastic
	name = "plastic"
	icon_state = "plastic"
	singular_name = "plastic sheet"
	matter_amounts = alist(/decl/material/plastic = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 3)
	material = /decl/material/plastic

/obj/item/stack/sheet/plastic/cyborg
	name = "plastic sheets"

/obj/item/stack/sheet/plastic/New(loc, amount = null)
	pixel_x = rand(0, 4) - 4
	pixel_y = rand(0, 4) - 4
	. = ..()

/*
 * Cardboard
 */
/obj/item/stack/sheet/cardboard	//BubbleWrap
	name = "cardboard"
	desc = "Large sheets of card, like boxes folded flat."
	singular_name = "cardboard sheet"
	icon_state = "card"
	matter_amounts = alist(/decl/material/cardboard = 1 MATERIAL_SHEET)
	origin_tech = alist(/decl/tech/materials = 1)
	material = /decl/material/cardboard