/obj/item/mecha_part/chassis/reticence
	name = "\improper Reticence chassis"

	construct_type = /datum/construction/mecha_chassis/reticence

/obj/item/mecha_part/part/reticence
	icon = 'icons/obj/mecha/parts/reticence.dmi'

/obj/item/mecha_part/part/reticence/torso
	name = "\improper Reticence torso"
	icon_state = "reticence_harness"

/obj/item/mecha_part/part/reticence/head
	name = "\improper Reticence head"
	icon_state = "reticence_head"

/obj/item/mecha_part/part/reticence/left_arm
	name = "\improper Reticence left arm"
	icon_state = "reticence_l_arm"

/obj/item/mecha_part/part/reticence/right_arm
	name = "\improper Reticence right arm"
	icon_state = "reticence_r_arm"

/obj/item/mecha_part/part/reticence/left_leg
	name = "\improper Reticence left leg"
	icon_state = "reticence_l_leg"

/obj/item/mecha_part/part/reticence/right_leg
	name = "\improper Reticence right leg"
	icon_state = "reticence_r_leg"

// Circuit Boards
/obj/item/circuitboard/mecha/reticence
	matter_amounts = /datum/design/circuit/mecha/reticence::materials
	origin_tech = /datum/design/circuit/mecha/reticence::req_tech

/obj/item/circuitboard/mecha/reticence/main
	name = "circuit board (\"Reticence\" central control module)"

/obj/item/circuitboard/mecha/reticence/peripherals
	name = "circuit board (\"Reticence\" peripherals control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/reticence/targeting
	name = "circuit board (\"Reticence\" weapon control & targeting module)"
	icon_state = "mcontroller"