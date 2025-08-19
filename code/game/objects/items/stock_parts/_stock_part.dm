/*
 * Stock Part
 */
/obj/item/stock_part
	name = "stock part"
	desc = "What?"
	gender = PLURAL
	icon = 'icons/obj/stock_parts.dmi'
	w_class = WEIGHT_CLASS_SMALL

	var/rating = 1

/obj/item/stock_part/New()
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

/obj/item/stock_part/console_screen
	name = "console screen"
	desc = "Used in the construction of computers and other devices with an interactive console."
	icon_state = "screen"
	matter_amounts = /datum/design/stock_part/console_screen::materials
	origin_tech = /datum/design/stock_part/console_screen::req_tech