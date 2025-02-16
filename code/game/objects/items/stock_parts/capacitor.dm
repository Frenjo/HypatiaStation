/*
 * Capacitors
 */
// Rating 1
/obj/item/stock_part/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor"
	matter_amounts = /datum/design/stock_part/basic_capacitor::materials
	origin_tech = /datum/design/stock_part/basic_capacitor::req_tech

// Rating 2
/obj/item/stock_part/capacitor/adv
	name = "advanced capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	icon_state = "adv_capacitor"
	matter_amounts = /datum/design/stock_part/adv_capacitor::materials
	origin_tech = /datum/design/stock_part/adv_capacitor::req_tech
	rating = 2

// Rating 3
/obj/item/stock_part/capacitor/super
	name = "super capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	icon_state = "super_capacitor"
	matter_amounts = /datum/design/stock_part/super_capacitor::materials
	origin_tech = /datum/design/stock_part/super_capacitor::req_tech
	rating = 3

// Rating 4
/obj/item/stock_part/capacitor/hyper
	name = "hyper capacitor"
	desc = "A hyper-capacity capacitor used in the construction of a variety of devices."
	icon_state = "hyper_capacitor"
	matter_amounts = /datum/design/stock_part/hyper_capacitor::materials
	origin_tech = /datum/design/stock_part/hyper_capacitor::req_tech
	rating = 4