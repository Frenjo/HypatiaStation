// Imperion
/obj/item/mecha_part/chassis/imperion
	name = "\improper Imperion chassis"
	desc = "The chassis of an Imperion-type exosuit."

	matter_amounts = /datum/design/mechfab/part/imperion_chassis::materials
	origin_tech = /datum/design/mechfab/part/imperion_chassis::req_tech

	construct_type = /datum/component/construction/mecha_chassis/imperion
	target_icon = 'icons/obj/mecha/construction/imperion.dmi'

/obj/item/mecha_part/part/imperion
	icon = 'icons/obj/mecha/parts/phazon.dmi'

/obj/item/mecha_part/part/imperion/torso
	name = "\improper Imperion torso"
	desc = "The torso of an Imperion-type exosuit."
	icon_state = "harness"
	matter_amounts = /datum/design/mechfab/part/imperion_torso::materials
	origin_tech = /datum/design/mechfab/part/imperion_torso::req_tech

/obj/item/mecha_part/part/imperion/head
	name = "\improper Imperion head"
	desc = "The head of an Imperion-type exosuit."
	icon_state = "head"
	matter_amounts = /datum/design/mechfab/part/imperion_head::materials
	origin_tech = /datum/design/mechfab/part/imperion_head::req_tech

/obj/item/mecha_part/part/imperion/left_arm
	name = "\improper Imperion left arm"
	desc = "The left arm of an Imperion-type exosuit."
	icon_state = "l_arm"
	matter_amounts = /datum/design/mechfab/part/imperion_left_arm::materials
	origin_tech = /datum/design/mechfab/part/imperion_left_arm::req_tech

/obj/item/mecha_part/part/imperion/right_arm
	name = "\improper Imperion right arm"
	desc = "The right arm of an Imperion-type exosuit."
	icon_state = "r_arm"
	matter_amounts = /datum/design/mechfab/part/imperion_right_arm::materials
	origin_tech = /datum/design/mechfab/part/imperion_right_arm::req_tech

/obj/item/mecha_part/part/imperion/left_leg
	name = "\improper Imperion left leg"
	desc = "The left leg of an Imperion-type exosuit."
	icon_state = "l_leg"
	matter_amounts = /datum/design/mechfab/part/imperion_left_leg::materials
	origin_tech = /datum/design/mechfab/part/imperion_left_leg::req_tech

/obj/item/mecha_part/part/imperion/right_leg
	name = "\improper Imperion right leg"
	desc = "The right leg of an Imperion-type exosuit."
	icon_state = "r_leg"
	matter_amounts = /datum/design/mechfab/part/imperion_right_leg::materials
	origin_tech = /datum/design/mechfab/part/imperion_right_leg::req_tech

/obj/item/mecha_part/part/imperion/armour
	name = "\improper Imperion armour"
	desc = "The external armour plates of an Imperion-type exosuit."
	icon_state = "imperion_armour"
	matter_amounts = /datum/design/mechfab/part/imperion_armour::materials
	origin_tech = /datum/design/mechfab/part/imperion_armour::req_tech

// This is only here as a placeholder.
// How the FUCK do we not have this item already???
/obj/item/heart
	name = "heart"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "heart-off"