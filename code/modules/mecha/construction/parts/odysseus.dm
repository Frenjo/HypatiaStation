// Odysseus
/obj/item/mecha_part/chassis/odysseus
	name = "\improper Odysseus chassis"

/obj/item/mecha_part/chassis/odysseus/New()
	. = ..()
	construct = new /datum/construction/mecha/chassis/odysseus(src)

/obj/item/mecha_part/part/odysseus_head
	name = "\improper Odysseus head"
	icon_state = "odysseus_head"
	construction_time = 100
	construction_cost = list(/decl/material/steel = 2000, /decl/material/glass = 10000)
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/programming = 3)

/obj/item/mecha_part/part/odysseus_torso
	name = "\improper Odysseus torso"
	desc = "A torso part of Odysseus. Contains power unit, processing core and life support systems."
	icon_state = "odysseus_torso"
	origin_tech = list(
		/datum/tech/materials = 2, /datum/tech/biotech = 2, /datum/tech/engineering = 2,
		/datum/tech/programming = 2
	)
	construction_time = 180
	construction_cost = list(/decl/material/steel = 25000)

/obj/item/mecha_part/part/odysseus_left_arm
	name = "\improper Odysseus left arm"
	desc = "An Odysseus left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_l_arm"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	construction_time = 120
	construction_cost = list(/decl/material/steel = 10000)

/obj/item/mecha_part/part/odysseus_right_arm
	name = "\improper Odysseus right arm"
	desc = "An Odysseus right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_r_arm"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	construction_time = 120
	construction_cost = list(/decl/material/steel = 10000)

/obj/item/mecha_part/part/odysseus_left_leg
	name = "\improper Odysseus left leg"
	desc = "An Odysseus left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_l_leg"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	construction_time = 130
	construction_cost = list(/decl/material/steel = 15000)

/obj/item/mecha_part/part/odysseus_right_leg
	name = "\improper Odysseus right leg"
	desc = "A Odysseus right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_r_leg"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	construction_time = 130
	construction_cost = list(/decl/material/steel = 15000)

/*/obj/item/mecha_part/part/odysseus_armour
	name = "\improper Odysseus carapace"
	icon_state = "odysseus_armour"
	origin_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3)
	construction_time = 200
	construction_cost = list(/decl/material/steel = 15000)*/

// Circuit Boards
/obj/item/circuitboard/mecha/odysseus
	origin_tech = list(/datum/tech/programming = 3)

/obj/item/circuitboard/mecha/odysseus/main
	name = "circuit board (Odysseus Central Control module)"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/odysseus/peripherals
	name = "circuit board (Odysseus Peripherals Control module)"
	icon_state = "mcontroller"