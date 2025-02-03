// Durand
/obj/item/mecha_part/chassis/durand
	name = "\improper Durand chassis"

	construct_type = /datum/construction/mecha_chassis/durand
	target_icon = 'icons/obj/mecha/construction/durand.dmi'

/obj/item/mecha_part/part/durand
	icon = 'icons/obj/mecha/parts/durand.dmi'

/obj/item/mecha_part/part/durand/torso
	name = "\improper Durand torso"
	icon_state = "durand_harness"
	origin_tech = list(
		/decl/tech/materials = 3, /decl/tech/biotech = 3, /decl/tech/engineering = 3,
		/decl/tech/programming = 2
	)

/obj/item/mecha_part/part/durand/head
	name = "\improper Durand head"
	icon_state = "durand_head"
	origin_tech = list(
		/decl/tech/materials = 3, /decl/tech/magnets = 3, /decl/tech/engineering = 3,
		/decl/tech/programming = 2
	)

/obj/item/mecha_part/part/durand/left_arm
	name = "\improper Durand left arm"
	icon_state = "durand_l_arm"
	origin_tech = list(/decl/tech/materials = 3, /decl/tech/engineering = 3, /decl/tech/programming = 2)

/obj/item/mecha_part/part/durand/right_arm
	name = "\improper Durand right arm"
	icon_state = "durand_r_arm"
	origin_tech = list(/decl/tech/materials = 3, /decl/tech/engineering = 3, /decl/tech/programming = 2)

/obj/item/mecha_part/part/durand/left_leg
	name = "\improper Durand left leg"
	icon_state = "durand_l_leg"
	origin_tech = list(/decl/tech/materials = 3, /decl/tech/engineering = 3, /decl/tech/programming = 2)

/obj/item/mecha_part/part/durand/right_leg
	name = "\improper Durand right leg"
	icon_state = "durand_r_leg"
	origin_tech = list(/decl/tech/materials = 3, /decl/tech/engineering = 3, /decl/tech/programming = 2)

/obj/item/mecha_part/part/durand/armour
	name = "\improper Durand armour plates"
	icon_state = "durand_armour"
	origin_tech = list(/decl/tech/materials = 5, /decl/tech/combat = 4, /decl/tech/engineering = 5)

// Circuit Boards
/obj/item/circuitboard/mecha/durand
	origin_tech = list(/decl/tech/programming = 4)

/obj/item/circuitboard/mecha/durand/main
	name = "circuit board (\"Durand\" central control module)"

/obj/item/circuitboard/mecha/durand/peripherals
	name = "circuit board (\"Durand\" peripherals control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/durand/targeting
	name = "circuit board (\"Durand\" weapon control & targeting module)"
	icon_state = "mcontroller"
	origin_tech = list(/decl/tech/combat = 4, /decl/tech/programming = 4)