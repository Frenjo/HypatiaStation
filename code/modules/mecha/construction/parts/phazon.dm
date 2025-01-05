// Phazon
/obj/item/mecha_part/chassis/phazon
	name = "\improper Phazon chassis"
	desc = "The chassis of a Phazon-type exosuit."

	origin_tech = list(/datum/tech/materials = 7)
	construct_type = /datum/construction/mecha_chassis/phazon

/obj/item/mecha_part/part/phazon_torso
	name = "\improper Phazon torso"
	desc = "The torso of a Phazon-type exosuit."
	icon_state = "phazon_harness"
	construction_time = 300
	construction_cost = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 5,
		/decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 10
	)
	origin_tech = list(
		/datum/tech/materials = 7, /datum/tech/power_storage = 6, /datum/tech/programming = 5,
		/datum/tech/bluespace = 6
	)

/obj/item/mecha_part/part/phazon_head
	name = "\improper Phazon head"
	icon_state = "phazon_head"
	desc = "The head of a Phazon-type exosuit. Its sensors are carefully calibrated to provide vision and data even when the exosuit is phasing."
	construction_time = 200
	construction_cost = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3,
		/decl/material/plasma = 10000
	)
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 6, /datum/tech/programming = 4)

/obj/item/mecha_part/part/phazon_left_arm
	name = "\improper Phazon left arm"
	icon_state = "phazon_l_arm"
	desc = "The left arm of a Phazon-type exosuit. Several microtool arrays are located under the armour plating, which can be adjusted on the fly."
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 5)
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 2, /datum/tech/bluespace = 2)

/obj/item/mecha_part/part/phazon_right_arm
	name = "\improper Phazon right arm"
	icon_state = "phazon_r_arm"
	desc = "The right arm of a Phazon-type exosuit. Several microtool arrays are located under the armour plating, which can be adjusted on the fly."
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 5)
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 2, /datum/tech/bluespace = 2)

/obj/item/mecha_part/part/phazon_left_leg
	name = "\improper Phazon left leg"
	icon_state = "phazon_l_leg"
	desc = "The left leg of a Phazon-type exosuit. It contains one of the two unique phase drives required to allow the exosuit to phase through solid matter when engaged."
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 5)
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 3, /datum/tech/bluespace = 3)

/obj/item/mecha_part/part/phazon_right_leg
	name = "\improper Phazon right leg"
	icon_state = "phazon_r_leg"
	desc = "The right leg of a Phazon-type exosuit. It contains one of the two unique phase drives required to allow the exosuit to phase through solid matter when engaged."
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 5)
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 3, /datum/tech/bluespace = 3)

/obj/item/mecha_part/part/phazon_armour
	name = "\improper Phazon armour"
	desc = "The external armour plates of a Phazon-type exosuit. They are layered with plasma to protect the pilot from the stress of phasing and have unusual properties."
	icon_state = "phazon_armour"
	construction_time = 300
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 14, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 9)
	origin_tech = list(/datum/tech/materials = 7, /datum/tech/magnets = 6, /datum/tech/bluespace = 6)

// Circuit Boards
/obj/item/circuitboard/mecha/phazon/main
	name = "circuit board (Phazon Central Control module)"
	origin_tech = list(/datum/tech/materials = 7, /datum/tech/power_storage = 6, /datum/tech/programming = 5)

/obj/item/circuitboard/mecha/phazon/peripherals
	name = "circuit board (Phazon Peripherals Control module)"
	icon_state = "mcontroller"
	origin_tech = list(/datum/tech/programming = 5, /datum/tech/bluespace = 6)

/obj/item/circuitboard/mecha/phazon/targeting
	name = "circuit board (Phazon Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	origin_tech = list(/datum/tech/magnets = 6, /datum/tech/combat = 2, /datum/tech/programming = 5)