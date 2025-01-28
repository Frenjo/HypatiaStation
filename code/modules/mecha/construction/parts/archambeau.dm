// Archambeau
/obj/item/mecha_part/chassis/archambeau
	name = "\improper Archambeau chassis"
	desc = "The chassis of an Archambeau-type exosuit."

	origin_tech = list(/datum/tech/materials = 7, /datum/tech/combat = 4, /datum/tech/engineering = 6)
	construct_type = /datum/construction/mecha_chassis/durand/archambeau
	target_icon = 'icons/obj/mecha/construction/durand.dmi'

/obj/item/mecha_part/part/durand/armour/archambeau
	name = "\improper Archambeau armour plates"
	icon_state = "archambeau_armour"
	origin_tech = list(/datum/tech/materials = 7, /datum/tech/combat = 4, /datum/tech/engineering = 6)
	construction_time = 600
	construction_cost = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 15, /decl/material/uranium = MATERIAL_AMOUNT_PER_SHEET * 9,
		/decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 9
	)

// Circuit Boards
/obj/item/circuitboard/mecha/archambeau/main
	name = "circuit board (Archambeau Central Control module)"
	origin_tech = list(/datum/tech/materials = 7, /datum/tech/power_storage = 6, /datum/tech/programming = 5)

/obj/item/circuitboard/mecha/archambeau/peripherals
	name = "circuit board (Archambeau Peripherals Control module)"
	icon_state = "mcontroller"
	origin_tech = list(/datum/tech/engineering = 6, /datum/tech/programming = 5)

/obj/item/circuitboard/mecha/archambeau/targeting
	name = "circuit board (Archambeau Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	origin_tech = list(/datum/tech/combat = 4, /datum/tech/engineering = 6, /datum/tech/programming = 5)