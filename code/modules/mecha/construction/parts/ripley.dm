// Ripley
/obj/item/mecha_part/chassis/ripley
	name = "\improper Ripley chassis"

/obj/item/mecha_part/chassis/ripley/New()
	. = ..()
	construct = new /datum/construction/mecha/chassis/ripley(src)

/obj/item/mecha_part/part/ripley_torso
	name = "\improper Ripley torso"
	desc = "A torso part of Ripley APLU. Contains power unit, processing core and life support systems."
	icon_state = "ripley_harness"
	origin_tech = list(
		/datum/tech/materials = 2, /datum/tech/biotech = 2, /datum/tech/engineering = 2,
		/datum/tech/programming = 2
	)
	construction_time = 200
	construction_cost = list(/decl/material/steel = 40000, /decl/material/glass = 15000)

/obj/item/mecha_part/part/ripley_left_arm
	name = "\improper Ripley left arm"
	desc = "A Ripley APLU left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_l_arm"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	construction_time = 150
	construction_cost = list(/decl/material/steel = 25000)

/obj/item/mecha_part/part/ripley_right_arm
	name = "\improper Ripley right arm"
	desc = "A Ripley APLU right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_r_arm"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	construction_time = 150
	construction_cost = list(/decl/material/steel = 25000)

/obj/item/mecha_part/part/ripley_left_leg
	name = "\improper Ripley left leg"
	desc = "A Ripley APLU left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_l_leg"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	construction_time = 150
	construction_cost = list(/decl/material/steel = 30000)

/obj/item/mecha_part/part/ripley_right_leg
	name = "\improper Ripley right leg"
	desc = "A Ripley APLU right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_r_leg"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	construction_time = 150
	construction_cost = list(/decl/material/steel = 30000)

// Circuit Boards
/obj/item/circuitboard/mecha/ripley
	origin_tech = list(/datum/tech/programming = 3)

/obj/item/circuitboard/mecha/ripley/main
	name = "circuit board (Ripley Central Control module)"

/obj/item/circuitboard/mecha/ripley/peripherals
	name = "circuit board (Ripley Peripherals Control module)"
	icon_state = "mcontroller"