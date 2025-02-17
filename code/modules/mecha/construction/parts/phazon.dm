// Phazon
/obj/item/mecha_part/chassis/phazon
	name = "\improper Phazon chassis"
	desc = "The chassis of a Phazon-type exosuit."

	matter_amounts = /datum/design/mechfab/part/phazon_chassis::materials
	origin_tech = /datum/design/mechfab/part/phazon_chassis::req_tech

	construct_type = /datum/construction/mecha_chassis/phazon
	target_icon = 'icons/obj/mecha/construction/phazon.dmi'

/obj/item/mecha_part/part/phazon
	icon = 'icons/obj/mecha/parts/phazon.dmi'

/obj/item/mecha_part/part/phazon/torso
	name = "\improper Phazon torso"
	desc = "The torso of a Phazon-type exosuit."
	icon_state = "phazon_harness"
	matter_amounts = /datum/design/mechfab/part/phazon_torso::materials
	origin_tech = /datum/design/mechfab/part/phazon_torso::req_tech

/obj/item/mecha_part/part/phazon/head
	name = "\improper Phazon head"
	icon_state = "phazon_head"
	desc = "The head of a Phazon-type exosuit. Its sensors are carefully calibrated to provide vision and data even when the exosuit is phasing."
	matter_amounts = /datum/design/mechfab/part/phazon_head::materials
	origin_tech = /datum/design/mechfab/part/phazon_head::req_tech

/obj/item/mecha_part/part/phazon/left_arm
	name = "\improper Phazon left arm"
	icon_state = "phazon_l_arm"
	desc = "The left arm of a Phazon-type exosuit. Several microtool arrays are located under the armour plating, which can be adjusted on the fly."
	matter_amounts = /datum/design/mechfab/part/phazon_left_arm::materials
	origin_tech = /datum/design/mechfab/part/phazon_left_arm::req_tech

/obj/item/mecha_part/part/phazon/right_arm
	name = "\improper Phazon right arm"
	icon_state = "phazon_r_arm"
	desc = "The right arm of a Phazon-type exosuit. Several microtool arrays are located under the armour plating, which can be adjusted on the fly."
	matter_amounts = /datum/design/mechfab/part/phazon_right_arm::materials
	origin_tech = /datum/design/mechfab/part/phazon_right_arm::req_tech

/obj/item/mecha_part/part/phazon/left_leg
	name = "\improper Phazon left leg"
	icon_state = "phazon_l_leg"
	desc = "The left leg of a Phazon-type exosuit. It contains one of the two unique phase drives required to allow the exosuit to phase through solid matter when engaged."
	matter_amounts = /datum/design/mechfab/part/phazon_left_leg::materials
	origin_tech = /datum/design/mechfab/part/phazon_left_leg::req_tech

/obj/item/mecha_part/part/phazon/right_leg
	name = "\improper Phazon right leg"
	icon_state = "phazon_r_leg"
	desc = "The right leg of a Phazon-type exosuit. It contains one of the two unique phase drives required to allow the exosuit to phase through solid matter when engaged."
	matter_amounts = /datum/design/mechfab/part/phazon_right_leg::materials
	origin_tech = /datum/design/mechfab/part/phazon_right_leg::req_tech

/obj/item/mecha_part/part/phazon/armour
	name = "\improper Phazon armour"
	desc = "The external armour plates of a Phazon-type exosuit. They are layered with plasma to protect the pilot from the stress of phasing and have unusual properties."
	icon_state = "phazon_armour"
	matter_amounts = /datum/design/mechfab/part/phazon_armour::materials
	origin_tech = /datum/design/mechfab/part/phazon_armour::req_tech

// Circuit Boards
/obj/item/circuitboard/mecha/phazon/main
	name = "circuit board (\"Phazon\" central control module)"
	matter_amounts = /datum/design/circuit/mecha/phazon_main::materials
	origin_tech = /datum/design/circuit/mecha/phazon_main::req_tech

/obj/item/circuitboard/mecha/phazon/peripherals
	name = "circuit board (\"Phazon\" peripherals control module)"
	icon_state = "mcontroller"
	matter_amounts = /datum/design/circuit/mecha/phazon_peri::materials
	origin_tech = /datum/design/circuit/mecha/phazon_peri::req_tech

/obj/item/circuitboard/mecha/phazon/targeting
	name = "circuit board (\"Phazon\" weapon control & targeting module)"
	icon_state = "mcontroller"
	matter_amounts = /datum/design/circuit/mecha/phazon_targ::materials
	origin_tech = /datum/design/circuit/mecha/phazon_targ::req_tech