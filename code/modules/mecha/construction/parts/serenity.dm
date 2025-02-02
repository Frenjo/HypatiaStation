// Serenity
/obj/item/mecha_part/chassis/serenity
	name = "\improper Serenity chassis"

	construct_type = /datum/construction/mecha_chassis/gygax/serenity
	target_icon = 'icons/obj/mecha/construction/gygax.dmi'

/obj/item/mecha_part/part/gygax/armour/serenity
	name = "\improper Serenity carapace"
	desc = "The outer carapace of a Serenity-type exosuit."
	icon_state = "serenity_carapace"
	origin_tech = list(/decl/tech/materials = 4, /decl/tech/engineering = 4)

// Circuit Boards
/obj/item/circuitboard/mecha/serenity/medical
	name = "circuit board (Serenity Medical Control module)"
	icon_state = "mcontroller"
	origin_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 4)