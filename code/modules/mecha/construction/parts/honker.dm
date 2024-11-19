// HONK (Honker)
/obj/item/mecha_part/chassis/honker
	name = "\improper H.O.N.K chassis"

/obj/item/mecha_part/chassis/honker/New()
	. = ..()
	construct = new /datum/construction/mecha/chassis/honker(src)

/obj/item/mecha_part/part/honker_torso
	name = "\improper H.O.N.K torso"
	icon_state = "honker_harness"
	construction_time = 300
	construction_cost = list(/decl/material/steel = 35000, /decl/material/glass = 10000, /decl/material/bananium = 10000)

/obj/item/mecha_part/part/honker_head
	name = "\improper H.O.N.K head"
	icon_state = "honker_head"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 15000, /decl/material/glass = 5000, /decl/material/bananium = 5000)

/obj/item/mecha_part/part/honker_left_arm
	name = "\improper H.O.N.K left arm"
	icon_state = "honker_l_arm"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/bananium = 5000)

/obj/item/mecha_part/part/honker_right_arm
	name = "\improper H.O.N.K right arm"
	icon_state = "honker_r_arm"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/bananium = 5000)

/obj/item/mecha_part/part/honker_left_leg
	name = "\improper H.O.N.K left leg"
	icon_state = "honker_l_leg"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/bananium = 5000)

/obj/item/mecha_part/part/honker_right_leg
	name = "\improper H.O.N.K right leg"
	icon_state = "honker_r_leg"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/bananium = 5000)

// Circuit Boards
/obj/item/circuitboard/mecha/honker
	origin_tech = list(/datum/tech/programming = 4)

/obj/item/circuitboard/mecha/honker/main
	name = "circuit board (H.O.N.K Central Control module)"
	icon_state = "mainboard"

/obj/item/circuitboard/mecha/honker/peripherals
	name = "circuit board (H.O.N.K Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/honker/targeting
	name = "circuit board (H.O.N.K Weapon Control and Targeting module)"
	icon_state = "mcontroller"