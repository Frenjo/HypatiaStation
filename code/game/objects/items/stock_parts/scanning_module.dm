/*
 * Scanning Modules
 */
// Rating 1
/obj/item/stock_part/scanning_module
	name = "scanning module"
	desc = "A compact, high resolution scanning module used in the construction of certain devices."
	icon_state = "scan_module"
	matter_amounts = /datum/design/stock_part/basic_scanning_module::materials
	origin_tech = /datum/design/stock_part/basic_scanning_module::req_tech

// Rating 2
/obj/item/stock_part/scanning_module/adv
	name = "advanced scanning module"
	desc = "A compact, high resolution advanced scanning module used in the construction of certain devices."
	icon_state = "adv_scan_module"
	matter_amounts = /datum/design/stock_part/adv_scanning_module::materials
	origin_tech = /datum/design/stock_part/adv_scanning_module::req_tech
	rating = 2

// Rating 3
/obj/item/stock_part/scanning_module/phasic
	name = "phasic scanning module"
	desc = "A compact, high resolution phasic scanning module used in the construction of certain devices."
	icon_state = "phasic_scan_module"
	matter_amounts = /datum/design/stock_part/phasic_scanning_module::materials
	origin_tech = /datum/design/stock_part/phasic_scanning_module::req_tech
	rating = 3

// Rating 4
/obj/item/stock_part/scanning_module/hyperphasic
	name = "hyper-phasic scanning module"
	desc = "A compact, high resolution hyper-phasic scanning module used in the construction of certain devices."
	icon_state = "hyper_phasic_scan_module"
	matter_amounts = /datum/design/stock_part/hyperphasic_scanning_module::materials
	origin_tech = /datum/design/stock_part/hyperphasic_scanning_module::req_tech
	rating = 4