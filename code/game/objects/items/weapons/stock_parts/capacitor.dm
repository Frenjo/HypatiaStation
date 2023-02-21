// Rating 1
/obj/item/weapon/stock_part/capacitor
	name = "capacitor"
	desc = "A basic capacitor used in the construction of a variety of devices."
	icon_state = "capacitor"
	origin_tech = list(RESEARCH_TECH_POWERSTORAGE = 1)
	matter_amounts = list(MATERIAL_METAL = 50, MATERIAL_GLASS = 50)

// Rating 2
/obj/item/weapon/stock_part/capacitor/adv
	name = "advanced capacitor"
	desc = "An advanced capacitor used in the construction of a variety of devices."
	icon_state = "adv_capacitor"
	origin_tech = list(RESEARCH_TECH_POWERSTORAGE = 3)
	rating = 2

// Rating 3
/obj/item/weapon/stock_part/capacitor/super
	name = "super capacitor"
	desc = "A super-high capacity capacitor used in the construction of a variety of devices."
	icon_state = "super_capacitor"
	origin_tech = list(RESEARCH_TECH_POWERSTORAGE = 5, RESEARCH_TECH_MATERIALS = 4)
	rating = 3

// Rating 4
/obj/item/weapon/stock_part/capacitor/hyper
	name = "hyper capacitor"
	desc = "A hyper-high capacity capacitor used in the construction of a variety of devices."
	icon_state = "hyper_capacitor"
	origin_tech = list(RESEARCH_TECH_POWERSTORAGE = 7, RESEARCH_TECH_MATERIALS = 4)
	rating = 4