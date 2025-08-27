// Gygax
/obj/item/mecha_part/chassis/gygax
	name = "\improper Gygax chassis"

	matter_amounts = /datum/design/mechfab/part/gygax_chassis::materials

	construct_type = /datum/component/construction/mecha_chassis/gygax
	target_icon = 'icons/obj/mecha/construction/gygax.dmi'

/obj/item/mecha_part/part/gygax
	icon = 'icons/obj/mecha/parts/gygax.dmi'

/obj/item/mecha_part/part/gygax/torso
	name = "\improper Gygax torso"
	desc = "The torso of a Gygax. Contains a power unit, processing core and life support systems. Has an additional equipment slot."
	icon_state = "harness"
	matter_amounts = /datum/design/mechfab/part/gygax_torso::materials
	origin_tech = /datum/design/mechfab/part/gygax_torso::req_tech

/obj/item/mecha_part/part/gygax/head
	name = "\improper Gygax head"
	desc = "A Gygax head. Houses advanced surveilance and targeting sensors."
	icon_state = "head"
	matter_amounts = /datum/design/mechfab/part/gygax_head::materials
	origin_tech = /datum/design/mechfab/part/gygax_head::req_tech

/obj/item/mecha_part/part/gygax/left_arm
	name = "\improper Gygax left arm"
	desc = "A Gygax left arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "l_arm"
	matter_amounts = /datum/design/mechfab/part/gygax_left_arm::materials
	origin_tech = /datum/design/mechfab/part/gygax_left_arm::req_tech

/obj/item/mecha_part/part/gygax/right_arm
	name = "\improper Gygax right arm"
	desc = "A Gygax right arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "r_arm"
	matter_amounts = /datum/design/mechfab/part/gygax_right_arm::materials
	origin_tech = /datum/design/mechfab/part/gygax_right_arm::req_tech

/obj/item/mecha_part/part/gygax/left_leg
	name = "\improper Gygax left leg"
	icon_state = "l_leg"
	matter_amounts = /datum/design/mechfab/part/gygax_left_leg::materials
	origin_tech = /datum/design/mechfab/part/gygax_left_leg::req_tech

/obj/item/mecha_part/part/gygax/right_leg
	name = "\improper Gygax right leg"
	icon_state = "r_leg"
	matter_amounts = /datum/design/mechfab/part/gygax_right_leg::materials
	origin_tech = /datum/design/mechfab/part/gygax_right_leg::req_tech

/obj/item/mecha_part/part/gygax/armour
	name = "\improper Gygax armour plates"
	icon_state = "gygax_armour"
	matter_amounts = /datum/design/mechfab/part/gygax_armour::materials
	origin_tech = /datum/design/mechfab/part/gygax_armour::req_tech

// Circuit Boards
/obj/item/circuitboard/mecha/gygax
	matter_amounts = /datum/design/circuit/mecha/gygax::materials
	origin_tech = /datum/design/circuit/mecha/gygax::req_tech

/obj/item/circuitboard/mecha/gygax/main
	name = "circuit board (\"Gygax\" central control module)"

/obj/item/circuitboard/mecha/gygax/peripherals
	name = "circuit board (\"Gygax\" peripherals control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/gygax/targeting
	name = "circuit board (\"Gygax\" weapon control & targeting module)"
	icon_state = "mcontroller"
	matter_amounts = /datum/design/circuit/mecha/gygax/targ::materials
	origin_tech = /datum/design/circuit/mecha/gygax/targ::req_tech