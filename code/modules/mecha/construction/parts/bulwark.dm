// Bulwark
/obj/item/mecha_part/chassis/bulwark
	name = "\improper Bulwark chassis"

	matter_amounts = /datum/design/mechfab/part/bulwark_chassis::materials

	construct_type = /datum/component/construction/mecha_chassis/ripley/bulwark
	target_icon = 'icons/obj/mecha/construction/ripley.dmi'

// Circuit Boards
/obj/item/circuitboard/mecha/bulwark/targeting
	name = "circuit board (\"Bulwark\" weapon control & targeting module)"
	icon_state = "mcontroller"
	matter_amounts = /datum/design/circuit/mecha/bulwark_targ::materials
	origin_tech = /datum/design/circuit/mecha/bulwark_targ::req_tech