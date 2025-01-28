// Durand
/obj/item/mecha_part/chassis/durand
	name = "\improper Durand chassis"

	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 8)
	construct_type = /datum/construction/mecha_chassis/durand
	target_icon = 'icons/obj/mecha/construction/durand.dmi'

/obj/item/mecha_part/part/durand
	icon = 'icons/obj/mecha/parts/durand.dmi'

/obj/item/mecha_part/part/durand/torso
	name = "\improper Durand torso"
	icon_state = "durand_harness"
	origin_tech = list(
		/datum/tech/materials = 3, /datum/tech/biotech = 3, /datum/tech/engineering = 3,
		/datum/tech/programming = 2
	)
	construction_time = 300
	construction_cost = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 17, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 10,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 5
	)

/obj/item/mecha_part/part/durand/head
	name = "\improper Durand head"
	icon_state = "durand_head"
	origin_tech = list(
		/datum/tech/materials = 3, /datum/tech/magnets = 3, /datum/tech/engineering = 3,
		/datum/tech/programming = 2
	)
	construction_time = 200
	construction_cost = list(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 8, MATERIAL_AMOUNT_PER_SHEET * 5,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2
	)

/obj/item/mecha_part/part/durand/left_arm
	name = "\improper Durand left arm"
	icon_state = "durand_l_arm"
	origin_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2)

/obj/item/mecha_part/part/durand/right_arm
	name = "\improper Durand right arm"
	icon_state = "durand_r_arm"
	origin_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2)

/obj/item/mecha_part/part/durand/left_leg
	name = "\improper Durand left leg"
	icon_state = "durand_l_leg"
	origin_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 12, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2)

/obj/item/mecha_part/part/durand/right_leg
	name = "\improper Durand right leg"
	icon_state = "durand_r_leg"
	origin_tech = list(/datum/tech/materials = 3, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	construction_time = 200
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 12, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2)

/obj/item/mecha_part/part/durand/armour
	name = "\improper Durand armour plates"
	icon_state = "durand_armour"
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/combat = 4, /datum/tech/engineering = 5)
	construction_time = 600
	construction_cost = list(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 15, /decl/material/uranium = MATERIAL_AMOUNT_PER_SHEET * 5)

// Circuit Boards
/obj/item/circuitboard/mecha/durand
	origin_tech = list(/datum/tech/programming = 4)

/obj/item/circuitboard/mecha/durand/main
	name = "circuit board (Durand Central Control module)"

/obj/item/circuitboard/mecha/durand/peripherals
	name = "circuit board (Durand Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/durand/targeting
	name = "circuit board (Durand Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	origin_tech = list(/datum/tech/combat = 4, /datum/tech/programming = 4)