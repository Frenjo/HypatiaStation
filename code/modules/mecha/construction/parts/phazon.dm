// Phazon
/obj/item/mecha_part/chassis/phazon
	name = "\improper Phazon chassis"
	origin_tech = list(/datum/tech/materials = 7)

/obj/item/mecha_part/chassis/phazon/New()
	. = ..()
	construct = new /datum/construction/mecha/chassis/phazon(src)

/obj/item/mecha_part/part/phazon_torso
	name = "\improper Phazon torso"
	icon_state = "phazon_harness"
	construction_time = 300
	construction_cost = list(/decl/material/steel = 35000, /decl/material/glass = 10000, /decl/material/plasma = 20000)
	origin_tech = list(
		/datum/tech/materials = 7, /datum/tech/power_storage = 6, /datum/tech/programming = 5,
		/datum/tech/bluespace = 6
	)

/obj/item/mecha_part/part/phazon_head
	name = "\improper Phazon head"
	icon_state = "phazon_head"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 15000, /decl/material/glass = 5000, /decl/material/plasma = 10000)
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 6, /datum/tech/programming = 4)

/obj/item/mecha_part/part/phazon_left_arm
	name = "\improper Phazon left arm"
	icon_state = "phazon_l_arm"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/plasma = 10000)
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 2, /datum/tech/bluespace = 2)

/obj/item/mecha_part/part/phazon_right_arm
	name = "\improper Phazon right arm"
	icon_state = "phazon_r_arm"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/plasma = 10000)
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 2, /datum/tech/bluespace = 2)

/obj/item/mecha_part/part/phazon_left_leg
	name = "\improper Phazon left leg"
	icon_state = "phazon_l_leg"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/plasma = 10000)
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 3, /datum/tech/bluespace = 3)

/obj/item/mecha_part/part/phazon_right_leg
	name = "\improper Phazon right leg"
	icon_state = "phazon_r_leg"
	construction_time = 200
	construction_cost = list(/decl/material/steel = 20000, /decl/material/plasma = 10000)
	origin_tech = list(/datum/tech/materials = 5, /datum/tech/magnets = 3, /datum/tech/bluespace = 3)