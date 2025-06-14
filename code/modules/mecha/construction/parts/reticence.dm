/obj/item/mecha_part/chassis/reticence
	name = "\improper Reticence chassis"

	matter_amounts = /datum/design/mechfab/part/reticence_chassis::materials

	construct_type = /datum/construction/mecha_chassis/reticence

/obj/item/mecha_part/part/reticence
	icon = 'icons/obj/mecha/parts/reticence.dmi'

/obj/item/mecha_part/part/reticence/torso
	name = "\improper Reticence torso"
	icon_state = "harness"

	matter_amounts = /datum/design/mechfab/part/reticence_torso::materials

/obj/item/mecha_part/part/reticence/head
	name = "\improper Reticence head"
	icon_state = "head"

	matter_amounts = /datum/design/mechfab/part/reticence_head::materials

/obj/item/mecha_part/part/reticence/left_arm
	name = "\improper Reticence left arm"
	icon_state = "l_arm"

	matter_amounts = /datum/design/mechfab/part/reticence_left_arm::materials

/obj/item/mecha_part/part/reticence/right_arm
	name = "\improper Reticence right arm"
	icon_state = "r_arm"

	matter_amounts = /datum/design/mechfab/part/reticence_right_arm::materials

/obj/item/mecha_part/part/reticence/left_leg
	name = "\improper Reticence left leg"
	icon_state = "l_leg"

	matter_amounts = /datum/design/mechfab/part/reticence_left_leg::materials

/obj/item/mecha_part/part/reticence/right_leg
	name = "\improper Reticence right leg"
	icon_state = "r_leg"

	matter_amounts = /datum/design/mechfab/part/reticence_right_leg::materials

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