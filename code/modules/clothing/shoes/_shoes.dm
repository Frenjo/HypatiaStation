/*
 * Shoes
 */
/obj/item/clothing/shoes
	name = "shoes"
	icon = 'icons/obj/items/clothing/shoes.dmi'
	desc = "Comfortable-looking shoes."
	gender = PLURAL //Carn: for grammarically correct text-parsing

	siemens_coefficient = 0.9
	body_parts_covered = FEET
	slot_flags = SLOT_FEET

	permeability_coefficient = 0.50
	slowdown = SHOES_SLOWDOWN
	species_restricted = list("exclude", SPECIES_SOGHUN, SPECIES_TAJARAN)

	var/chained = 0