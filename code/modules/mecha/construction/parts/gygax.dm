// Gygax
/obj/item/mecha_part/chassis/gygax
	name = "\improper Gygax chassis"

	construction_cost = list(/decl/material/steel = 25000)
	construct_type = /datum/construction/mecha_chassis/gygax

/obj/item/mecha_part/part/gygax_torso
	name = "\improper Gygax torso"
	desc = "The torso of a Gygax. Contains a power unit, processing core and life support systems. Has an additional equipment slot."
	icon_state = "gygax_harness"
	origin_tech = list(
		/datum/tech/materials = 2, /datum/tech/biotech = 3, /datum/tech/engineering = 3,
		/datum/tech/programming = 2
	)
	construction_time = 300
	construction_cost = list(/decl/material/steel = 50000, /decl/material/glass = 20000)

/obj/item/mecha_part/part/gygax_head
	name = "\improper Gygax head"
	desc = "A Gygax head. Houses advanced surveilance and targeting sensors."
	icon_state = "gygax_head"
	origin_tech = list(
		/datum/tech/materials = 2, /datum/tech/magnets = 3, /datum/tech/engineering = 3,
		/datum/tech/programming = 2
	)
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/glass = 10000)

/obj/item/mecha_part/part/gygax_left_arm
	name = "\improper Gygax left arm"
	desc = "A Gygax left arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_l_arm"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	construction_time = 200
	construction_cost = list(/decl/material/steel = 30000)

/obj/item/mecha_part/part/gygax_right_arm
	name = "\improper Gygax right arm"
	desc = "A Gygax right arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_r_arm"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	construction_time = 200
	construction_cost = list(/decl/material/steel = 30000)

/obj/item/mecha_part/part/gygax_left_leg
	name = "\improper Gygax left leg"
	icon_state = "gygax_l_leg"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	construction_time = 200
	construction_cost = list(/decl/material/steel = 35000)

/obj/item/mecha_part/part/gygax_right_leg
	name = "\improper Gygax right leg"
	icon_state = "gygax_r_leg"
	origin_tech = list(/datum/tech/materials = 2, /datum/tech/engineering = 3, /datum/tech/programming = 2)
	construction_time = 200
	construction_cost = list(/decl/material/steel = 35000)

/obj/item/mecha_part/part/gygax_armour
	name = "\improper Gygax armour plates"
	icon_state = "gygax_armour"
	origin_tech = list(/datum/tech/materials = 6, /datum/tech/combat = 4, /datum/tech/engineering = 5)
	construction_time = 600
	construction_cost = list(/decl/material/steel = 50000, /decl/material/diamond = 10000)

// Circuit Boards
/obj/item/circuitboard/mecha/gygax
	origin_tech = list(/datum/tech/programming = 4)

/obj/item/circuitboard/mecha/gygax/main
	name = "circuit board (Gygax Central Control module)"

/obj/item/circuitboard/mecha/gygax/peripherals
	name = "circuit board (Gygax Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/circuitboard/mecha/gygax/targeting
	name = "circuit board (Gygax Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	origin_tech = list(/datum/tech/combat = 2, /datum/tech/programming = 4)