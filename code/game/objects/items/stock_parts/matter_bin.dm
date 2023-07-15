/*
 * Matter Bins
 */
// Rating 1
/obj/item/stock_part/matter_bin
	name = "matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "matter_bin"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 1)
	matter_amounts = list(MATERIAL_METAL = 80)

// Rating 2
/obj/item/stock_part/matter_bin/adv
	name = "advanced matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "advanced_matter_bin"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 3)
	rating = 2

// Rating 3
/obj/item/stock_part/matter_bin/super
	name = "super matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "super_matter_bin"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 5)
	rating = 3

// Rating 4
/obj/item/stock_part/matter_bin/hyper
	name = "hyper matter bin"
	desc = "A container for hold compressed matter awaiting re-construction."
	icon_state = "hyper_matter_bin"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 7)
	rating = 4