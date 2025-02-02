// Gygax
/obj/item/mecha_part/chassis/gygax
	name = "\improper Gygax chassis"

	construct_type = /datum/construction/mecha_chassis/gygax
	target_icon = 'icons/obj/mecha/construction/gygax.dmi'

/obj/item/mecha_part/part/gygax
	icon = 'icons/obj/mecha/parts/gygax.dmi'

/obj/item/mecha_part/part/gygax/torso
	name = "\improper Gygax torso"
	desc = "The torso of a Gygax. Contains a power unit, processing core and life support systems. Has an additional equipment slot."
	icon_state = "gygax_harness"
	origin_tech = list(
		/decl/tech/materials = 2, /decl/tech/biotech = 3, /decl/tech/engineering = 3,
		/decl/tech/programming = 2
	)

/obj/item/mecha_part/part/gygax/head
	name = "\improper Gygax head"
	desc = "A Gygax head. Houses advanced surveilance and targeting sensors."
	icon_state = "gygax_head"
	origin_tech = list(
		/decl/tech/materials = 2, /decl/tech/magnets = 3, /decl/tech/engineering = 3,
		/decl/tech/programming = 2
	)

/obj/item/mecha_part/part/gygax/left_arm
	name = "\improper Gygax left arm"
	desc = "A Gygax left arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_l_arm"
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/engineering = 3, /decl/tech/programming = 2)

/obj/item/mecha_part/part/gygax/right_arm
	name = "\improper Gygax right arm"
	desc = "A Gygax right arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_r_arm"
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/engineering = 3, /decl/tech/programming = 2)

/obj/item/mecha_part/part/gygax/left_leg
	name = "\improper Gygax left leg"
	icon_state = "gygax_l_leg"
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/engineering = 3, /decl/tech/programming = 2)

/obj/item/mecha_part/part/gygax/right_leg
	name = "\improper Gygax right leg"
	icon_state = "gygax_r_leg"
	origin_tech = list(/decl/tech/materials = 2, /decl/tech/engineering = 3, /decl/tech/programming = 2)

/obj/item/mecha_part/part/gygax/armour
	name = "\improper Gygax armour plates"
	icon_state = "gygax_armour"
	origin_tech = list(/decl/tech/materials = 6, /decl/tech/combat = 4, /decl/tech/engineering = 5)

// Circuit Boards
/obj/item/circuitboard/mecha/gygax
	origin_tech = list(/decl/tech/programming = 4)

/obj/item/circuitboard/mecha/gygax/main
	name = "circuit board (Gygax Central Control module)"

/obj/item/circuitboard/mecha/gygax/peripherals
	name = "circuit board (Gygax Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/gygax/targeting
	name = "circuit board (Gygax Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	origin_tech = list(/decl/tech/combat = 2, /decl/tech/programming = 4)