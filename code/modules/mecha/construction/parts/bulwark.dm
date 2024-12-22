// Bulwark
/obj/item/mecha_part/chassis/bulwark
	name = "\improper Bulwark chassis"

/obj/item/mecha_part/chassis/bulwark/New()
	. = ..()
	construct = new /datum/construction/mecha/chassis/bulwark(src)

// Circuit Boards
/obj/item/circuitboard/mecha/bulwark/targeting
	name = "circuit board (Bulwark Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	origin_tech = list(/datum/tech/combat = 2, /datum/tech/engineering = 3, /datum/tech/programming = 3)