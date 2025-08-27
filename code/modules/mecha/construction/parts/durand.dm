// Durand
/obj/item/mecha_part/chassis/durand
	name = "\improper Durand chassis"

	matter_amounts = /datum/design/mechfab/part/durand_chassis::materials

	construct_type = /datum/component/construction/mecha_chassis/durand
	target_icon = 'icons/obj/mecha/construction/durand.dmi'

/obj/item/mecha_part/part/durand
	icon = 'icons/obj/mecha/parts/durand.dmi'

/obj/item/mecha_part/part/durand/torso
	name = "\improper Durand torso"
	icon_state = "harness"
	matter_amounts = /datum/design/mechfab/part/durand_torso::materials
	origin_tech = /datum/design/mechfab/part/durand_torso::req_tech

/obj/item/mecha_part/part/durand/head
	name = "\improper Durand head"
	icon_state = "head"
	matter_amounts = /datum/design/mechfab/part/durand_head::materials
	origin_tech = /datum/design/mechfab/part/durand_head::req_tech

/obj/item/mecha_part/part/durand/left_arm
	name = "\improper Durand left arm"
	icon_state = "l_arm"
	matter_amounts = /datum/design/mechfab/part/durand_left_arm::materials
	origin_tech = /datum/design/mechfab/part/durand_left_arm::req_tech

/obj/item/mecha_part/part/durand/right_arm
	name = "\improper Durand right arm"
	icon_state = "r_arm"
	matter_amounts = /datum/design/mechfab/part/durand_right_arm::materials
	origin_tech = /datum/design/mechfab/part/durand_right_arm::req_tech

/obj/item/mecha_part/part/durand/left_leg
	name = "\improper Durand left leg"
	icon_state = "l_leg"
	matter_amounts = /datum/design/mechfab/part/durand_left_leg::materials
	origin_tech = /datum/design/mechfab/part/durand_left_leg::req_tech

/obj/item/mecha_part/part/durand/right_leg
	name = "\improper Durand right leg"
	icon_state = "r_leg"
	matter_amounts = /datum/design/mechfab/part/durand_right_leg::materials
	origin_tech = /datum/design/mechfab/part/durand_right_leg::req_tech

/obj/item/mecha_part/part/durand/armour
	name = "\improper Durand armour plates"
	icon_state = "durand_armour"
	matter_amounts = /datum/design/mechfab/part/durand_armour::materials
	origin_tech = /datum/design/mechfab/part/durand_armour::req_tech

// Circuit Boards
/obj/item/circuitboard/mecha/durand
	matter_amounts = /datum/design/circuit/mecha/durand::materials
	origin_tech = /datum/design/circuit/mecha/durand::req_tech

/obj/item/circuitboard/mecha/durand/main
	name = "circuit board (\"Durand\" central control module)"

/obj/item/circuitboard/mecha/durand/peripherals
	name = "circuit board (\"Durand\" peripherals control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/durand/targeting
	name = "circuit board (\"Durand\" weapon control & targeting module)"
	icon_state = "mcontroller"
	matter_amounts = /datum/design/circuit/mecha/durand/targ::materials
	origin_tech = /datum/design/circuit/mecha/durand/targ::req_tech