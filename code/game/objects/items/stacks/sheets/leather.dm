//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/sheet/xenochitin
	name = "alien chitin"
	desc = "A piece of the hide of a terrible creature."
	singular_name = "alien hide piece"
	icon = 'icons/mob/simple/alien.dmi'
	icon_state = "chitin"

/obj/item/xenos_claw
	name = "alien claw"
	desc = "The claw of a terrible creature."
	icon = 'icons/mob/simple/alien.dmi'
	icon_state = "claw"

/obj/item/weed_extract
	name = "weed extract"
	desc = "A piece of slimy, purplish weed."
	icon = 'icons/mob/simple/alien.dmi'
	icon_state = "weed_extract"

/obj/item/stack/sheet/leather
	name = "leather"
	singular_name = "leather piece"
	desc = "The by-product of mob grinding."
	icon_state = "leather"
	matter_amounts = alist(/decl/material/leather = MATERIAL_AMOUNT_PER_SHEET)
	origin_tech = alist(/decl/tech/materials = 2)
	material = /decl/material/leather