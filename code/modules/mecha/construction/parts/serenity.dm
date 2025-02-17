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
	name = "circuit board (\"Serenity\" medical control module)"
	icon_state = "mcontroller"
	matter_amounts = /datum/design/circuit/mecha/serenity_medical::materials
	origin_tech = /datum/design/circuit/mecha/serenity_medical::req_tech