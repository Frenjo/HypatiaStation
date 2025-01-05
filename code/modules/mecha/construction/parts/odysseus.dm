// Odysseus
/obj/item/mecha_part/chassis/odysseus
	name = "\improper Odysseus chassis"

	construct_type = /datum/construction/mecha_chassis/odysseus

/obj/item/mecha_part/part/odysseus_torso
	name = "\improper Odysseus torso"
	desc = "The torso of an Odysseus-type exosuit. It contains the power unit, processing core and life support systems."
	icon_state = "odysseus_torso"
	origin_tech = list(
		/datum/tech/materials = 2, /datum/tech/biotech = 2, /datum/tech/engineering = 2,
		/datum/tech/programming = 2
	)
	construction_time = 180
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 8)

/obj/item/mecha_part/part/odysseus_head
	name = "\improper Odysseus head"
	desc = "The head of an Odysseus-type exosuit."
	icon_state = "odysseus_head"
	construction_time = 100
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 3, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 5)
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/programming = 3)

/obj/item/mecha_part/part/odysseus_left_arm
	name = "\improper Odysseus left arm"
	desc = "The left arm of an Odysseus-type exosuit. The data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_l_arm"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	construction_time = 120
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 3)

/obj/item/mecha_part/part/odysseus_right_arm
	name = "\improper Odysseus right arm"
	desc = "The right arm of an Odysseus-type exosuit. The data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_r_arm"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	construction_time = 120
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 3)

/obj/item/mecha_part/part/odysseus_left_leg
	name = "\improper Odysseus left leg"
	desc = "The left leg of an Odysseus-type exosuit. It contains somewhat complex servodrives and balance systems."
	icon_state = "odysseus_l_leg"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	construction_time = 130
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5)

/obj/item/mecha_part/part/odysseus_right_leg
	name = "\improper Odysseus right leg"
	desc = "The right leg of an Odysseus-type exosuit. It contains somewhat complex servodrives and balance systems."
	icon_state = "odysseus_r_leg"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	construction_time = 130
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5)

/obj/item/mecha_part/part/odysseus_carapace
	name = "\improper Odysseus carapace"
	desc = "The outer carapace of an Odysseus-type exosuit."
	icon_state = "odysseus_carapace"
	origin_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3)
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 3)

// Circuit Boards
/obj/item/circuitboard/mecha/odysseus
	origin_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 3)

/obj/item/circuitboard/mecha/odysseus/main
	name = "circuit board (Odysseus Central Control module)"

/obj/item/circuitboard/mecha/odysseus/peripherals
	name = "circuit board (Odysseus Peripherals Control module)"
	icon_state = "mcontroller"