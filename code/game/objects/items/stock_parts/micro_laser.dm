/*
 * Micro-Lasers
 */
// Rating 1
/obj/item/stock_part/micro_laser
	name = "micro-laser"
	desc = "A tiny laser used in certain devices."
	icon_state = "micro_laser"
	matter_amounts = /datum/design/stock_part/basic_micro_laser::materials
	origin_tech = /datum/design/stock_part/basic_micro_laser::req_tech

// Rating 2
/obj/item/stock_part/micro_laser/high
	name = "high-power micro-laser"
	icon_state = "high_micro_laser"
	matter_amounts = /datum/design/stock_part/high_micro_laser::materials
	origin_tech = /datum/design/stock_part/high_micro_laser::req_tech
	rating = 2

// Rating 3
/obj/item/stock_part/micro_laser/ultra
	name = "ultra-high-power micro-laser"
	icon_state = "ultra_high_micro_laser"
	matter_amounts = /datum/design/stock_part/ultra_micro_laser::materials
	origin_tech = /datum/design/stock_part/ultra_micro_laser::req_tech
	rating = 3

// Rating 4
/obj/item/stock_part/micro_laser/hyperultra
	name = "hyper-ultra-high-power micro-laser"
	icon_state = "hyper_ultra_high_micro_laser"
	matter_amounts = /datum/design/stock_part/hyper_ultra_micro_laser::materials
	origin_tech = /datum/design/stock_part/hyper_ultra_micro_laser::req_tech
	rating = 4