/*
 * Manipulators
 */
// Rating 1
/obj/item/stock_part/manipulator
	name = "micro-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "micro_mani"
	matter_amounts = list(MATERIAL_METAL = 30)
	origin_tech = list(/datum/tech/materials = 1, /datum/tech/programming = 1)

// Rating 2
/obj/item/stock_part/manipulator/nano
	name = "nano-manipulator"
	icon_state = "nano_mani"
	origin_tech = list(/datum/tech/materials = 3, /datum/tech/programming = 2)
	rating = 2

// Rating 3
/obj/item/stock_part/manipulator/pico
	name = "pico-manipulator"
	icon_state = "pico_mani"
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/programming = 2)
	rating = 3

// Rating 4
/obj/item/stock_part/manipulator/femto
	name = "femto-manipulator"
	icon_state = "femto_mani"
	origin_tech = list(/datum/tech/materials = 7, /datum/tech/programming = 2)
	rating = 4