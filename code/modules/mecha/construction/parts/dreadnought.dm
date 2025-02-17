// Dreadnought
/obj/item/mecha_part/chassis/dreadnought
	name = "\improper Dreadnought chassis"

	construct_type = /datum/construction/mecha_chassis/ripley/dreadnought
	target_icon = 'icons/obj/mecha/construction/ripley.dmi'

// Circuit Boards
/obj/item/circuitboard/mecha/dreadnought
	matter_amounts = /datum/design/circuit/mecha/dreadnought::materials
	origin_tech = /datum/design/circuit/mecha/dreadnought::req_tech

/obj/item/circuitboard/mecha/dreadnought/main
	name = "circuit board (\"Dreadnought\" central control module)"

/obj/item/circuitboard/mecha/dreadnought/peripherals
	name = "circuit board (\"Dreadnought\" peripherals control module)"
	icon_state = "mcontroller"