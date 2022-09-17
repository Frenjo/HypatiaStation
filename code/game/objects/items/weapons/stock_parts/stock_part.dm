///////////////////////////////// Stock Parts /////////////////////////////////
// Sprited/added unique icons for upgraded capacitors and scanning modules, along with rating 4 parts. -Frenjo
/obj/item/weapon/stock_part
	name = "stock part"
	desc = "What?"
	gender = PLURAL
	icon = 'icons/obj/stock_parts.dmi'
	w_class = 2.0

	var/rating = 1

/obj/item/weapon/stock_part/New()
	src.pixel_x = rand(-5.0, 5)
	src.pixel_y = rand(-5.0, 5)
	..()

/obj/item/weapon/stock_part/console_screen
	name = "console screen"
	desc = "Used in the construction of computers and other devices with a interactive console."
	icon_state = "screen"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1)
	g_amt = 200