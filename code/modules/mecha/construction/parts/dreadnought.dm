// Dreadnought
/obj/item/mecha_part/chassis/dreadnought
	name = "\improper Dreadnought chassis"

	construct_type = /datum/construction/mecha_chassis/ripley/dreadnought

// Circuit Boards
/obj/item/circuitboard/mecha/dreadnought
	origin_tech = list(/datum/tech/engineering = 3, /datum/tech/programming = 3)

/obj/item/circuitboard/mecha/dreadnought/main
	name = "circuit board (Dreadnought Central Control module)"

/obj/item/circuitboard/mecha/dreadnought/peripherals
	name = "circuit board (Dreadnought Peripherals Control module)"
	icon_state = "mcontroller"