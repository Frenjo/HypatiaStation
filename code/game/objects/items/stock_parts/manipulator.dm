/*
 * Manipulators
 */
// Rating 1
/obj/item/stock_part/manipulator
	name = "micro-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "micro_mani"
	matter_amounts = /datum/design/stock_part/micro_mani::materials
	origin_tech = /datum/design/stock_part/micro_mani::req_tech

// Rating 2
/obj/item/stock_part/manipulator/nano
	name = "nano-manipulator"
	icon_state = "nano_mani"
	matter_amounts = /datum/design/stock_part/nano_mani::materials
	origin_tech = /datum/design/stock_part/nano_mani::req_tech
	rating = 2

// Rating 3
/obj/item/stock_part/manipulator/pico
	name = "pico-manipulator"
	icon_state = "pico_mani"
	matter_amounts = /datum/design/stock_part/pico_mani::materials
	origin_tech = /datum/design/stock_part/pico_mani::req_tech
	rating = 3

// Rating 4
/obj/item/stock_part/manipulator/femto
	name = "femto-manipulator"
	icon_state = "femto_mani"
	matter_amounts = /datum/design/stock_part/femto_mani::materials
	origin_tech = /datum/design/stock_part/femto_mani::req_tech
	rating = 4