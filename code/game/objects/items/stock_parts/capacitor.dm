/*
 * Capacitors
 */
// Rating 1
/obj/item/stock_part/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor"
	matter_amounts = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	origin_tech = list(/datum/tech/power_storage = 1)

// Rating 2
/obj/item/stock_part/capacitor/adv
	name = "advanced capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	icon_state = "adv_capacitor"
	origin_tech = list(/datum/tech/power_storage = 3)
	rating = 2

// Rating 3
/obj/item/stock_part/capacitor/super
	name = "super capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	icon_state = "super_capacitor"
	origin_tech = list(/datum/tech/materials = 4, /datum/tech/power_storage = 5)
	rating = 3

// Rating 4
/obj/item/stock_part/capacitor/hyper
	name = "hyper capacitor"
	desc = "A hyper-capacity capacitor used in the construction of a variety of devices."
	icon_state = "hyper_capacitor"
	origin_tech = list(/datum/tech/materials = 4, /datum/tech/power_storage = 7)
	rating = 4