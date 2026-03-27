// Brigand
/obj/item/mecha_part/chassis/brigand
	name = "\improper Brigand chassis"
	desc = "The chassis of a Brigand-type exosuit."

	matter_amounts = /datum/design/mechfab/part/brigand_chassis::materials
	origin_tech = /datum/design/mechfab/part/brigand_chassis::req_tech

	construct_type = /datum/component/construction/mecha_chassis/durand/brigand
	target_icon = 'icons/obj/mecha/construction/durand.dmi'

/obj/item/mecha_part/part/durand/armour/brigand
	name = "\improper Brigand armour plates"
	icon_state = "brigand_armour"
	matter_amounts = /datum/design/mechfab/part/brigand_armour::materials
	origin_tech = /datum/design/mechfab/part/brigand_armour::req_tech

// Circuit Boards
/obj/item/circuitboard/mecha/brigand/main
	name = "circuit board (\"Brigand\" central control module)"
	matter_amounts = /datum/design/circuit/mecha/brigand_main::materials
	origin_tech = /datum/design/circuit/mecha/brigand_main::req_tech

/obj/item/circuitboard/mecha/brigand/peripherals
	name = "circuit board (\"Brigand\" peripherals control module)"
	icon_state = "mcontroller"
	matter_amounts = /datum/design/circuit/mecha/brigand_peri::materials
	origin_tech = /datum/design/circuit/mecha/brigand_peri::req_tech

/obj/item/circuitboard/mecha/brigand/targeting
	name = "circuit board (\"Brigand\" weapon control & targeting module)"
	icon_state = "mcontroller"
	matter_amounts = /datum/design/circuit/mecha/brigand_targ::materials
	origin_tech = /datum/design/circuit/mecha/brigand_targ::req_tech