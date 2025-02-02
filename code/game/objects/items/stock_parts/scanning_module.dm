/*
 * Scanning Modules
 */
// Rating 1
/obj/item/stock_part/scanning_module
	name = "scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	matter_amounts = list(MATERIAL_METAL = 50, /decl/material/glass = 20)
	origin_tech = list(/decl/tech/magnets = 1)

// Rating 2
/obj/item/stock_part/scanning_module/adv
	name = "advanced scanning module"
	desc = "A compact, high resolution advanced scanning module used in the construction of certain devices."
	icon_state = "adv_scan_module"
	origin_tech = list(/decl/tech/magnets = 3)
	rating = 2

// Rating 3
/obj/item/stock_part/scanning_module/phasic
	name = "phasic scanning module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."
	icon_state = "phasic_scan_module"
	origin_tech = list(/decl/tech/magnets = 5)
	rating = 3

// Rating 4
/obj/item/stock_part/scanning_module/hyperphasic
	name = "hyper-phasic scanning module"
	desc = "A compact, high resolution hyper-phasic scanning module used in the construction of certain devices."
	icon_state = "hyper_phasic_scan_module"
	origin_tech = list(/decl/tech/magnets = 7)
	rating = 4