// Rating 1
/obj/item/stock_part/micro_laser
	name = "micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"
	origin_tech = list(RESEARCH_TECH_MAGNETS = 1)
	matter_amounts = list(MATERIAL_METAL = 10, MATERIAL_GLASS = 20)

// Rating 2
/obj/item/stock_part/micro_laser/high
	name = "high-power micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "high_micro_laser"
	origin_tech = list(RESEARCH_TECH_MAGNETS = 3)
	rating = 2

// Rating 3
/obj/item/stock_part/micro_laser/ultra
	name = "ultra-high-power micro-laser"
	icon_state = "ultra_high_micro_laser"
	desc = "A tiny laser used in certain devices."
	origin_tech = list(RESEARCH_TECH_MAGNETS = 5)
	rating = 3

// Rating 4
/obj/item/stock_part/micro_laser/hyperultra
	name = "hyper-ultra-high-power micro-laser"
	icon_state = "hyper_ultra_high_micro_laser"
	desc = "A tiny laser used in certain devices."
	origin_tech = list(RESEARCH_TECH_MAGNETS = 7)
	rating = 4