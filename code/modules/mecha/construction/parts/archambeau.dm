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
	name = "circuit board (\"Archambeau\" central control module)"
	matter_amounts = /datum/design/circuit/mecha/archambeau_main::materials
	origin_tech = /datum/design/circuit/mecha/archambeau_main::req_tech

/obj/item/circuitboard/mecha/archambeau/peripherals
	name = "circuit board (\"Archambeau\" peripherals control module)"
	icon_state = "mcontroller"
	matter_amounts = /datum/design/circuit/mecha/archambeau_peri::materials
	origin_tech = /datum/design/circuit/mecha/archambeau_peri::req_tech

/obj/item/circuitboard/mecha/archambeau/targeting
	name = "circuit board (\"Archambeau\" weapon control & targeting module)"
	icon_state = "mcontroller"
	matter_amounts = /datum/design/circuit/mecha/archambeau_targ::materials
	origin_tech = /datum/design/circuit/mecha/archambeau_targ::req_tech