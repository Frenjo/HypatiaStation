/*
 * Matter Bins
 */
// Rating 1
/obj/item/stock_part/matter_bin
	name = "matter bin"
	desc = "A container for holding compressed matter awaiting re-construction."
	icon_state = "matter_bin"
	matter_amounts = /datum/design/stock_part/basic_matter_bin::materials
	origin_tech = /datum/design/stock_part/basic_matter_bin::req_tech

// Rating 2
/obj/item/stock_part/matter_bin/adv
	name = "advanced matter bin"
	icon_state = "advanced_matter_bin"
	matter_amounts = /datum/design/stock_part/adv_matter_bin::materials
	origin_tech = /datum/design/stock_part/adv_matter_bin::req_tech
	rating = 2

// Rating 3
/obj/item/stock_part/matter_bin/super
	name = "super matter bin"
	icon_state = "super_matter_bin"
	matter_amounts = /datum/design/stock_part/super_matter_bin::materials
	origin_tech = /datum/design/stock_part/super_matter_bin::req_tech
	rating = 3

// Rating 4
/obj/item/stock_part/matter_bin/hyper
	name = "hyper matter bin"
	icon_state = "hyper_matter_bin"
	matter_amounts = /datum/design/stock_part/hyper_matter_bin::materials
	origin_tech = /datum/design/stock_part/hyper_matter_bin::req_tech
	rating = 4