// Ripley
/obj/item/mecha_part/chassis/ripley
	name = "\improper Ripley chassis"

	matter_amounts = /datum/design/mechfab/part/ripley_chassis::materials

	construct_type = /datum/construction/mecha_chassis/ripley
	target_icon = 'icons/obj/mecha/construction/ripley.dmi'

/obj/item/mecha_part/part/ripley
	icon = 'icons/obj/mecha/parts/ripley.dmi'

/obj/item/mecha_part/part/ripley/torso
	name = "\improper Ripley torso"
	desc = "A torso part of Ripley APLU. Contains power unit, processing core and life support systems."
	icon_state = "ripley_harness"
	matter_amounts = /datum/design/mechfab/part/ripley_torso::materials
	origin_tech = alist(
		/decl/tech/materials = 2, /decl/tech/biotech = 2, /decl/tech/engineering = 2,
		/decl/tech/programming = 2
	)

/obj/item/mecha_part/part/ripley/left_arm
	name = "\improper Ripley left arm"
	desc = "A Ripley APLU left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_l_arm"
	matter_amounts = /datum/design/mechfab/part/ripley_left_arm::materials
	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)

/obj/item/mecha_part/part/ripley/right_arm
	name = "\improper Ripley right arm"
	desc = "A Ripley APLU right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_r_arm"
	matter_amounts = /datum/design/mechfab/part/ripley_right_arm::materials
	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)

/obj/item/mecha_part/part/ripley/left_leg
	name = "\improper Ripley left leg"
	desc = "A Ripley APLU left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_l_leg"
	matter_amounts = /datum/design/mechfab/part/ripley_left_leg::materials
	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)

/obj/item/mecha_part/part/ripley/right_leg
	name = "\improper Ripley right leg"
	desc = "A Ripley APLU right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_r_leg"
	matter_amounts = /datum/design/mechfab/part/ripley_right_leg::materials
	origin_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)

// Circuit Boards
/obj/item/circuitboard/mecha/ripley
	matter_amounts = /datum/design/circuit/mecha/ripley::materials
	origin_tech = /datum/design/circuit/mecha/ripley::req_tech

/obj/item/circuitboard/mecha/ripley/main
	name = "circuit board (APLU \"Ripley\" central control module)"

/obj/item/circuitboard/mecha/ripley/peripherals
	name = "circuit board (APLU \"Ripley\" peripherals control module)"
	icon_state = "mcontroller"