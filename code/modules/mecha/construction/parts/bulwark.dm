// Bulwark
/obj/item/mecha_part/chassis/bulwark
	name = "\improper Bulwark chassis"

	construct_type = /datum/construction/mecha_chassis/ripley/bulwark
	target_icon = 'icons/obj/mecha/construction/ripley.dmi'

// Circuit Boards
/obj/item/circuitboard/mecha/bulwark/targeting
	name = "circuit board (\"Bulwark\" weapon control & targeting module)"
	icon_state = "mcontroller"
	matter_amounts = /datum/design/circuit/mecha/bulwark_targ::materials
	origin_tech = /datum/design/circuit/mecha/bulwark_targ::req_tech