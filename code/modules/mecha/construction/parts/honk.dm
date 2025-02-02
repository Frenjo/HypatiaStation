// H.O.N.K
/obj/item/mecha_part/chassis/honk
	name = "\improper H.O.N.K chassis"

	construct_type = /datum/construction/mecha_chassis/honk

/obj/item/mecha_part/part/honk
	icon = 'icons/obj/mecha/parts/honk.dmi'

/obj/item/mecha_part/part/honk/torso
	name = "\improper H.O.N.K torso"
	icon_state = "honk_harness"

/obj/item/mecha_part/part/honk/head
	name = "\improper H.O.N.K head"
	icon_state = "honk_head"

/obj/item/mecha_part/part/honk/left_arm
	name = "\improper H.O.N.K left arm"
	icon_state = "honk_l_arm"

/obj/item/mecha_part/part/honk/right_arm
	name = "\improper H.O.N.K right arm"
	icon_state = "honk_r_arm"

/obj/item/mecha_part/part/honk/left_leg
	name = "\improper H.O.N.K left leg"
	icon_state = "honk_l_leg"

/obj/item/mecha_part/part/honk/right_leg
	name = "\improper H.O.N.K right leg"
	icon_state = "honk_r_leg"

// Circuit Boards
/obj/item/circuitboard/mecha/honk
	origin_tech = list(/decl/tech/programming = 4)

/obj/item/circuitboard/mecha/honk/main
	name = "circuit board (H.O.N.K Central Control module)"

/obj/item/circuitboard/mecha/honk/peripherals
	name = "circuit board (H.O.N.K Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/honk/targeting
	name = "circuit board (H.O.N.K Weapon Control and Targeting module)"
	icon_state = "mcontroller"