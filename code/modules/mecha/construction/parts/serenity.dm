// Serenity
/obj/item/mecha_part/chassis/serenity
	name = "\improper Serenity chassis"

	construct_type = /datum/construction/mecha_chassis/gygax/serenity

/obj/item/mecha_part/part/serenity_carapace
	name = "\improper Serenity carapace"
	desc = "The outer carapace of a Serenity-type exosuit."
	icon_state = "serenity_carapace"
	origin_tech = list(/datum/tech/materials = 4, /datum/tech/engineering = 4)
	construction_time = 400
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 3)

// Circuit Boards
/obj/item/circuitboard/mecha/serenity/medical
	name = "circuit board (Serenity Medical Control module)"
	icon_state = "mcontroller"
	origin_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 4)