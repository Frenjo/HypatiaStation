/*
 * Manipulators
 */
// Rating 1
/obj/item/stock_part/manipulator
	name = "micro-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "micro_mani"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1, RESEARCH_TECH_PROGRAMMING = 1)
	matter_amounts = list(MATERIAL_METAL = 30)

// Rating 2
/obj/item/stock_part/manipulator/nano
	name = "nano-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "nano_mani"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_PROGRAMMING = 2)
	rating = 2

// Rating 3
/obj/item/stock_part/manipulator/pico
	name = "pico-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "pico_mani"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_PROGRAMMING = 2)
	rating = 3

// Rating 4
/obj/item/stock_part/manipulator/femto
	name = "femto-manipulator"
	desc = "A tiny little manipulator used in the construction of certain devices."
	icon_state = "femto_mani"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 7, RESEARCH_TECH_PROGRAMMING = 2)
	rating = 4