// Archambeau
/obj/item/mecha_part/chassis/archambeau
	name = "\improper Archambeau chassis"
	desc = "The chassis of an Archambeau-type exosuit."

	origin_tech = list(/decl/tech/materials = 7, /decl/tech/combat = 4, /decl/tech/engineering = 6)
	construct_type = /datum/construction/mecha_chassis/durand/archambeau
	target_icon = 'icons/obj/mecha/construction/durand.dmi'

/obj/item/mecha_part/part/durand/armour/archambeau
	name = "\improper Archambeau armour plates"
	icon_state = "archambeau_armour"
	origin_tech = list(/decl/tech/materials = 7, /decl/tech/combat = 4, /decl/tech/engineering = 6)

// Circuit Boards
/obj/item/circuitboard/mecha/archambeau/main
	name = "circuit board (Archambeau Central Control module)"
	origin_tech = list(/decl/tech/materials = 7, /decl/tech/power_storage = 6, /decl/tech/programming = 5)

/obj/item/circuitboard/mecha/archambeau/peripherals
	name = "circuit board (Archambeau Peripherals Control module)"
	icon_state = "mcontroller"
	origin_tech = list(/decl/tech/engineering = 6, /decl/tech/programming = 5)

/obj/item/circuitboard/mecha/archambeau/targeting
	name = "circuit board (Archambeau Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	origin_tech = list(/decl/tech/combat = 4, /decl/tech/engineering = 6, /decl/tech/programming = 5)