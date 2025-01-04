/obj/item/mecha_part/chassis/reticence
	name = "\improper Reticence chassis"

	construct_type = /datum/construction/mecha_chassis/reticence

/obj/item/mecha_part/part/reticence_torso
	name = "\improper Reticence torso"
	icon_state = "reticence_harness"
	construction_time = 300
	construction_cost = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11, /decl/material/glass = 10000, /decl/material/bananium = 10000
	) // Bananium is a placeholder for tranquilite.

/obj/item/mecha_part/part/reticence_head
	name = "\improper Reticence head"
	icon_state = "reticence_head"
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/glass = 5000, /decl/material/bananium = 5000)

/obj/item/mecha_part/part/reticence_left_arm
	name = "\improper Reticence left arm"
	icon_state = "reticence_l_arm"
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/bananium = 5000)

/obj/item/mecha_part/part/reticence_right_arm
	name = "\improper Reticence right arm"
	icon_state = "reticence_r_arm"
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/bananium = 5000)

/obj/item/mecha_part/part/reticence_left_leg
	name = "\improper Reticence left leg"
	icon_state = "reticence_l_leg"
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/bananium = 5000)

/obj/item/mecha_part/part/reticence_right_leg
	name = "\improper Reticence right leg"
	icon_state = "reticence_r_leg"
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 6, /decl/material/bananium = 5000)

// Circuit Boards
/obj/item/circuitboard/mecha/reticence
	origin_tech = list(/datum/tech/programming = 4)

/obj/item/circuitboard/mecha/reticence/main
	name = "circuit board (Reticence Central Control module)"

/obj/item/circuitboard/mecha/reticence/peripherals
	name = "circuit board (Reticence Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/reticence/targeting
	name = "circuit board (Reticence Weapon Control and Targeting module)"
	icon_state = "mcontroller"