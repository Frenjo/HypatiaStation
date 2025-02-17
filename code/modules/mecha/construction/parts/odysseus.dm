// Odysseus
/obj/item/mecha_part/chassis/odysseus
	name = "\improper Odysseus chassis"

	construct_type = /datum/construction/mecha_chassis/odysseus
	target_icon = 'icons/obj/mecha/construction/odysseus.dmi'

/obj/item/mecha_part/part/odysseus
	icon = 'icons/obj/mecha/parts/odysseus.dmi'

/obj/item/mecha_part/part/odysseus/torso
	name = "\improper Odysseus torso"
	desc = "The torso of an Odysseus-type exosuit. It contains the power unit, processing core and life support systems."
	icon_state = "odysseus_torso"
	origin_tech = list(
		/decl/tech/materials = 2, /decl/tech/biotech = 2, /decl/tech/engineering = 2,
		/decl/tech/programming = 2
	)

/obj/item/mecha_part/part/odysseus/head
	name = "\improper Odysseus head"
	desc = "The head of an Odysseus-type exosuit."
	icon_state = "odysseus_head"
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/programming = 3)

/obj/item/mecha_part/part/odysseus/left_arm
	name = "\improper Odysseus left arm"
	desc = "The left arm of an Odysseus-type exosuit. The data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_l_arm"
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)

/obj/item/mecha_part/part/odysseus/right_arm
	name = "\improper Odysseus right arm"
	desc = "The right arm of an Odysseus-type exosuit. The data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_r_arm"
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)

/obj/item/mecha_part/part/odysseus/left_leg
	name = "\improper Odysseus left leg"
	desc = "The left leg of an Odysseus-type exosuit. It contains somewhat complex servodrives and balance systems."
	icon_state = "odysseus_l_leg"
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)

/obj/item/mecha_part/part/odysseus/right_leg
	name = "\improper Odysseus right leg"
	desc = "The right leg of an Odysseus-type exosuit. It contains somewhat complex servodrives and balance systems."
	icon_state = "odysseus_r_leg"
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)

/obj/item/mecha_part/part/odysseus/carapace
	name = "\improper Odysseus carapace"
	desc = "The outer carapace of an Odysseus-type exosuit."
	icon_state = "odysseus_carapace"
	origin_tech = list(/decl/tech/materials = 3, /decl/tech/engineering = 3)

// Circuit Boards
/obj/item/circuitboard/mecha/odysseus
	matter_amounts = /datum/design/circuit/mecha/odysseus::materials
	origin_tech = /datum/design/circuit/mecha/odysseus::req_tech

/obj/item/circuitboard/mecha/odysseus/main
	name = "circuit board (\"Odysseus\" central control module)"

/obj/item/circuitboard/mecha/odysseus/peripherals
	name = "circuit board (\"Odysseus\" peripherals control module)"
	icon_state = "mcontroller"