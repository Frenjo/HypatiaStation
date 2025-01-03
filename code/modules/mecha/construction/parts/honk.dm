// H.O.N.K
/obj/item/mecha_part/chassis/honk
	name = "\improper H.O.N.K chassis"

	construct_type = /datum/construction/mecha_chassis/honk

/obj/item/mecha_part/part/honk_torso
	name = "\improper H.O.N.K torso"
	icon_state = "honk_harness"
	construction_time = 300
	construction_cost = list(/decl/material/steel = 35000, /decl/material/glass = 10000, /decl/material/bananium = 10000)

/obj/item/mecha_part/part/honk_head
	name = "\improper H.O.N.K head"
	icon_state = "honk_head"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 15000, /decl/material/glass = 5000, /decl/material/bananium = 5000)

/obj/item/mecha_part/part/honk_left_arm
	name = "\improper H.O.N.K left arm"
	icon_state = "honk_l_arm"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/bananium = 5000)

/obj/item/mecha_part/part/honk_right_arm
	name = "\improper H.O.N.K right arm"
	icon_state = "honk_r_arm"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/bananium = 5000)

/obj/item/mecha_part/part/honk_left_leg
	name = "\improper H.O.N.K left leg"
	icon_state = "honk_l_leg"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/bananium = 5000)

/obj/item/mecha_part/part/honk_right_leg
	name = "\improper H.O.N.K right leg"
	icon_state = "honk_r_leg"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/bananium = 5000)

// Circuit Boards
/obj/item/circuitboard/mecha/honk
	origin_tech = list(/datum/tech/programming = 4)

/obj/item/circuitboard/mecha/honk/main
	name = "circuit board (H.O.N.K Central Control module)"

/obj/item/circuitboard/mecha/honk/peripherals
	name = "circuit board (H.O.N.K Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/honk/targeting
	name = "circuit board (H.O.N.K Weapon Control and Targeting module)"
	icon_state = "mcontroller"