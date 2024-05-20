/*
 * Micro-Lasers
 */
// Rating 1
/obj/item/stock_part/micro_laser
	name = "micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"
	matter_amounts = list(MATERIAL_METAL = 10, MATERIAL_GLASS = 20)
	origin_tech = list(/datum/tech/magnets = 1)

// Rating 2
/obj/item/stock_part/micro_laser/high
	name = "high-power micro-laser"
	icon_state = "high_micro_laser"
	origin_tech = list(/datum/tech/magnets = 3)
	rating = 2

// Rating 3
/obj/item/stock_part/micro_laser/ultra
	name = "ultra-high-power micro-laser"
	icon_state = "ultra_high_micro_laser"
	origin_tech = list(/datum/tech/magnets = 5)
	rating = 3

// Rating 4
/obj/item/stock_part/micro_laser/hyperultra
	name = "hyper-ultra-high-power micro-laser"
	icon_state = "hyper_ultra_high_micro_laser"
	origin_tech = list(/datum/tech/magnets = 7)
	rating = 4