// Archambeau
/obj/item/mecha_part/chassis/archambeau
	name = "\improper Archambeau chassis"
	desc = "The chassis of an Archambeau-type exosuit."

	origin_tech = list(/datum/tech/materials = 7, /datum/tech/combat = 4, /datum/tech/engineering = 6)
	construct_type = /datum/construction/mecha_chassis/durand/archambeau

/obj/item/mecha_part/part/archambeau_armour
	name = "\improper Archambeau armour plates"
	icon_state = "archambeau_armour"
	origin_tech = list(/datum/tech/materials = 7, /datum/tech/combat = 4, /datum/tech/engineering = 6)
	construction_time = 600
	construction_cost = list(/decl/material/steel = 50000, /decl/material/uranium = 30000, /decl/material/plasma = 30000)

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