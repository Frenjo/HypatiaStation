/*
 * Stock Part
 */
// Sprited/added unique icons for upgraded capacitors and scanning modules, along with rating 4 parts. -Frenjo
/obj/item/stock_part
	name = "stock part"
	desc = "What?"
	gender = PLURAL
	icon = 'icons/obj/stock_parts.dmi'
	w_class = 2

	var/rating = 1

/obj/item/stock_part/New()
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

/obj/item/stock_part/console_screen
	name = "console screen"
	desc = "Used in the construction of computers and other devices with an interactive console."
	icon_state = "screen"
	matter_amounts = list(MATERIAL_GLASS = 200)
	origin_tech = list(/datum/tech/materials = 1)