// H.O.N.K
/obj/item/mecha_part/chassis/honk
	name = "\improper H.O.N.K chassis"

	matter_amounts = /datum/design/mechfab/part/honk_chassis::materials

	construct_type = /datum/construction/mecha_chassis/honk

/obj/item/mecha_part/part/honk
	icon = 'icons/obj/mecha/parts/honk.dmi'

/obj/item/mecha_part/part/honk/torso
	name = "\improper H.O.N.K torso"
	icon_state = "honk_harness"

	matter_amounts = /datum/design/mechfab/part/honk_torso::materials

/obj/item/mecha_part/part/honk/head
	name = "\improper H.O.N.K head"
	icon_state = "honk_head"

	matter_amounts = /datum/design/mechfab/part/honk_head::materials

/obj/item/mecha_part/part/honk/left_arm
	name = "\improper H.O.N.K left arm"
	icon_state = "honk_l_arm"

	matter_amounts = /datum/design/mechfab/part/honk_left_arm::materials

/obj/item/mecha_part/part/honk/right_arm
	name = "\improper H.O.N.K right arm"
	icon_state = "honk_r_arm"

	matter_amounts = /datum/design/mechfab/part/honk_right_arm::materials

/obj/item/mecha_part/part/honk/left_leg
	name = "\improper H.O.N.K left leg"
	icon_state = "honk_l_leg"

	matter_amounts = /datum/design/mechfab/part/honk_left_leg::materials

/obj/item/mecha_part/part/honk/right_leg
	name = "\improper H.O.N.K right leg"
	icon_state = "honk_r_leg"

	matter_amounts = /datum/design/mechfab/part/honk_right_leg::materials

// Circuit Boards
/obj/item/circuitboard/mecha/honk
	matter_amounts = /datum/design/circuit/mecha/honk::materials
	origin_tech = /datum/design/circuit/mecha/honk::req_tech

/obj/item/circuitboard/mecha/honk/main
	name = "circuit board (\"H.O.N.K\" central control module)"

/obj/item/circuitboard/mecha/honk/peripherals
	name = "circuit board (\"H.O.N.K\" peripherals control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/honk/targeting
	name = "circuit board (\"H.O.N.K\" weapon control & targeting module)"
	icon_state = "mcontroller"