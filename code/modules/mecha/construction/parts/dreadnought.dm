// Dreadnought
/obj/item/mecha_part/chassis/dreadnought
	name = "\improper Dreadnought chassis"

/obj/item/mecha_part/chassis/dreadnought/New()
	. = ..()
	construct = new /datum/construction/mecha/chassis/dreadnought(src)

// Circuit Boards
/obj/item/circuitboard/mecha/dreadnought
	origin_tech = list(/datum/tech/engineering = 3, /datum/tech/programming = 3)

/obj/item/circuitboard/mecha/dreadnought/main
	name = "circuit board (Dreadnought Central Control module)"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/dreadnought/peripherals
	name = "circuit board (Dreadnought Peripherals Control module)"
	icon_state = "mcontroller"