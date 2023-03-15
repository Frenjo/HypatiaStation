/////////////////////////
////// Mecha Parts //////
/////////////////////////

/obj/item/mecha_parts
	name = "mecha part"
	icon = 'icons/mecha/mech_construct.dmi'
	icon_state = "blank"
	w_class = 5
	flags = CONDUCT
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_MATERIAL = 2)
	var/construction_time = 100
	var/list/construction_cost = list(MATERIAL_METAL = 20000, MATERIAL_GLASS = 5000)


/obj/item/mecha_parts/chassis
	name = "Mecha Chassis"
	icon_state = "backbone"
	var/datum/construction/construct
	construction_cost = list(MATERIAL_METAL = 20000)
	flags = CONDUCT

/obj/item/mecha_parts/chassis/attackby(obj/item/W as obj, mob/user as mob)
	if(!construct || !construct.action(W, user))
		..()
	return

/obj/item/mecha_parts/chassis/attack_hand()
	return

/////////// Ripley
/obj/item/mecha_parts/chassis/ripley
	name = "Ripley Chassis"

/obj/item/mecha_parts/chassis/ripley/New()
	..()
	construct = new /datum/construction/mecha/ripley_chassis(src)

/obj/item/mecha_parts/part/ripley_torso
	name = "Ripley Torso"
	desc = "A torso part of Ripley APLU. Contains power unit, processing core and life support systems."
	icon_state = "ripley_harness"
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_BIOTECH = 2,
		RESEARCH_TECH_ENGINEERING = 2
	)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 40000, MATERIAL_GLASS = 15000)

/obj/item/mecha_parts/part/ripley_left_arm
	name = "Ripley Left Arm"
	desc = "A Ripley APLU left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_l_arm"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_ENGINEERING = 2)
	construction_time = 150
	construction_cost = list(MATERIAL_METAL = 25000)

/obj/item/mecha_parts/part/ripley_right_arm
	name = "Ripley Right Arm"
	desc = "A Ripley APLU right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_r_arm"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_ENGINEERING = 2)
	construction_time = 150
	construction_cost = list(MATERIAL_METAL = 25000)

/obj/item/mecha_parts/part/ripley_left_leg
	name = "Ripley Left Leg"
	desc = "A Ripley APLU left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_l_leg"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_ENGINEERING = 2)
	construction_time = 150
	construction_cost = list(MATERIAL_METAL = 30000)

/obj/item/mecha_parts/part/ripley_right_leg
	name = "Ripley Right Leg"
	desc = "A Ripley APLU right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_r_leg"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_ENGINEERING = 2)
	construction_time = 150
	construction_cost = list(MATERIAL_METAL = 30000)


///////// Gygax
/obj/item/mecha_parts/chassis/gygax
	name = "Gygax Chassis"
	construction_cost = list(MATERIAL_METAL = 25000)

/obj/item/mecha_parts/chassis/gygax/New()
	..()
	construct = new /datum/construction/mecha/gygax_chassis(src)

/obj/item/mecha_parts/part/gygax_torso
	name = "Gygax Torso"
	desc = "A torso part of Gygax. Contains power unit, processing core and life support systems. Has an additional equipment slot."
	icon_state = "gygax_harness"
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_BIOTECH = 3,
		RESEARCH_TECH_ENGINEERING = 3
	)
	construction_time = 300
	construction_cost = list(MATERIAL_METAL = 50000, MATERIAL_GLASS = 20000)

/obj/item/mecha_parts/part/gygax_head
	name = "Gygax Head"
	desc = "A Gygax head. Houses advanced surveilance and targeting sensors."
	icon_state = "gygax_head"
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_MAGNETS = 3,
		RESEARCH_TECH_ENGINEERING = 3
	)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 20000, MATERIAL_GLASS = 10000)

/obj/item/mecha_parts/part/gygax_left_arm
	name = "Gygax Left Arm"
	desc = "A Gygax left arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_l_arm"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_ENGINEERING = 3)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 30000)

/obj/item/mecha_parts/part/gygax_right_arm
	name = "Gygax Right Arm"
	desc = "A Gygax right arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_r_arm"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_ENGINEERING = 3)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 30000)

/obj/item/mecha_parts/part/gygax_left_leg
	name = "Gygax Left Leg"
	icon_state = "gygax_l_leg"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_ENGINEERING = 3)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 35000)

/obj/item/mecha_parts/part/gygax_right_leg
	name = "Gygax Right Leg"
	icon_state = "gygax_r_leg"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_ENGINEERING = 3)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 35000)

/obj/item/mecha_parts/part/gygax_armour
	name = "Gygax Armour Plates"
	icon_state = "gygax_armour"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 6, RESEARCH_TECH_COMBAT = 4, RESEARCH_TECH_ENGINEERING = 5)
	construction_time = 600
	construction_cost = list(MATERIAL_METAL = 50000, MATERIAL_DIAMOND = 10000)


//////////// Durand
/obj/item/mecha_parts/chassis/durand
	name = "Durand Chassis"
	construction_cost = list(MATERIAL_METAL = 25000)

/obj/item/mecha_parts/chassis/durand/New()
	..()
	construct = new /datum/construction/mecha/durand_chassis(src)

/obj/item/mecha_parts/part/durand_torso
	name = "Durand Torso"
	icon_state = "durand_harness"
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_BIOTECH = 3,
		RESEARCH_TECH_ENGINEERING = 3
	)
	construction_time = 300
	construction_cost = list(MATERIAL_METAL = 55000, MATERIAL_GLASS = 20000, MATERIAL_SILVER = 10000)

/obj/item/mecha_parts/part/durand_head
	name = "Durand Head"
	icon_state = "durand_head"
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_MAGNETS = 3,
		RESEARCH_TECH_ENGINEERING = 3
	)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 25000, MATERIAL_GLASS = 10000, MATERIAL_SILVER = 3000)

/obj/item/mecha_parts/part/durand_left_arm
	name = "Durand Left Arm"
	icon_state = "durand_l_arm"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_ENGINEERING = 3)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 35000, MATERIAL_SILVER = 3000)

/obj/item/mecha_parts/part/durand_right_arm
	name = "Durand Right Arm"
	icon_state = "durand_r_arm"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_ENGINEERING = 3)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 35000, MATERIAL_SILVER = 3000)

/obj/item/mecha_parts/part/durand_left_leg
	name = "Durand Left Leg"
	icon_state = "durand_l_leg"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_ENGINEERING = 3)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 40000, MATERIAL_SILVER = 3000)

/obj/item/mecha_parts/part/durand_right_leg
	name = "Durand Right Leg"
	icon_state = "durand_r_leg"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_ENGINEERING = 3)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 40000, MATERIAL_SILVER = 3000)

/obj/item/mecha_parts/part/durand_armour
	name = "Durand Armour Plates"
	icon_state = "durand_armour"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_COMBAT = 4, RESEARCH_TECH_ENGINEERING = 5)
	construction_time = 600
	construction_cost = list(MATERIAL_METAL = 50000, MATERIAL_URANIUM = 10000)


////////// Firefighter
/obj/item/mecha_parts/chassis/firefighter
	name = "Firefighter Chassis"

/obj/item/mecha_parts/chassis/firefighter/New()
	..()
	construct = new /datum/construction/mecha/firefighter_chassis(src)
/*
/obj/item/mecha_parts/part/firefighter_torso
	name="Ripley-on-Fire Torso"
	icon_state = "ripley_harness"

/obj/item/mecha_parts/part/firefighter_left_arm
	name="Ripley-on-Fire Left Arm"
	icon_state = "ripley_l_arm"

/obj/item/mecha_parts/part/firefighter_right_arm
	name="Ripley-on-Fire Right Arm"
	icon_state = "ripley_r_arm"

/obj/item/mecha_parts/part/firefighter_left_leg
	name="Ripley-on-Fire Left Leg"
	icon_state = "ripley_l_leg"

/obj/item/mecha_parts/part/firefighter_right_leg
	name="Ripley-on-Fire Right Leg"
	icon_state = "ripley_r_leg"
*/

////////// HONK
/obj/item/mecha_parts/chassis/honker
	name = "H.O.N.K Chassis"

/obj/item/mecha_parts/chassis/honker/New()
	..()
	construct = new /datum/construction/mecha/honker_chassis(src)

/obj/item/mecha_parts/part/honker_torso
	name = "H.O.N.K Torso"
	icon_state = "honker_harness"
	construction_time = 300
	construction_cost = list(MATERIAL_METAL = 35000, MATERIAL_GLASS = 10000, MATERIAL_BANANIUM = 10000)

/obj/item/mecha_parts/part/honker_head
	name = "H.O.N.K Head"
	icon_state = "honker_head"
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 15000, MATERIAL_GLASS = 5000, MATERIAL_BANANIUM = 5000)

/obj/item/mecha_parts/part/honker_left_arm
	name = "H.O.N.K Left Arm"
	icon_state = "honker_l_arm"
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 20000, MATERIAL_BANANIUM = 5000)

/obj/item/mecha_parts/part/honker_right_arm
	name = "H.O.N.K Right Arm"
	icon_state = "honker_r_arm"
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 20000, MATERIAL_BANANIUM = 5000)

/obj/item/mecha_parts/part/honker_left_leg
	name = "H.O.N.K Left Leg"
	icon_state = "honker_l_leg"
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 20000, MATERIAL_BANANIUM = 5000)

/obj/item/mecha_parts/part/honker_right_leg
	name = "H.O.N.K Right Leg"
	icon_state = "honker_r_leg"
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 20000, MATERIAL_BANANIUM = 5000)


////////// Phazon
/obj/item/mecha_parts/chassis/phazon
	name = "Phazon Chassis"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 7)

/obj/item/mecha_parts/chassis/phazon/New()
	..()
	construct = new /datum/construction/mecha/phazon_chassis(src)

/obj/item/mecha_parts/part/phazon_torso
	name = "Phazon Torso"
	icon_state = "phazon_harness"
	construction_time = 300
	construction_cost = list(MATERIAL_METAL = 35000, MATERIAL_GLASS = 10000, MATERIAL_PLASMA = 20000)
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 5, RESEARCH_TECH_MATERIALS = 7, RESEARCH_TECH_BLUESPACE = 6,
		RESEARCH_TECH_POWERSTORAGE = 6
	)

/obj/item/mecha_parts/part/phazon_head
	name = "Phazon Head"
	icon_state = "phazon_head"
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 15000, MATERIAL_GLASS = 5000, MATERIAL_PLASMA = 10000)
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_MAGNETS = 6)

/obj/item/mecha_parts/part/phazon_left_arm
	name = "Phazon Left Arm"
	icon_state = "phazon_l_arm"
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 20000, MATERIAL_PLASMA = 10000)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_BLUESPACE = 2, RESEARCH_TECH_MAGNETS = 2)

/obj/item/mecha_parts/part/phazon_right_arm
	name = "Phazon Right Arm"
	icon_state = "phazon_r_arm"
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 20000, MATERIAL_PLASMA = 10000)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_BLUESPACE = 2, RESEARCH_TECH_MAGNETS = 2)

/obj/item/mecha_parts/part/phazon_left_leg
	name = "Phazon Left Leg"
	icon_state = "phazon_l_leg"
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 20000, MATERIAL_PLASMA = 10000)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_BLUESPACE = 3, RESEARCH_TECH_MAGNETS = 3)

/obj/item/mecha_parts/part/phazon_right_leg
	name = "Phazon Right Leg"
	icon_state = "phazon_r_leg"
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 20000, MATERIAL_PLASMA = 10000)
	origin_tech = list(RESEARCH_TECH_MATERIALS = 5, RESEARCH_TECH_BLUESPACE = 3, RESEARCH_TECH_MAGNETS = 3)


///////// Odysseus
/obj/item/mecha_parts/chassis/odysseus
	name = "Odysseus Chassis"

/obj/item/mecha_parts/chassis/odysseus/New()
	..()
	construct = new /datum/construction/mecha/odysseus_chassis(src)

/obj/item/mecha_parts/part/odysseus_head
	name = "Odysseus Head"
	icon_state = "odysseus_head"
	construction_time = 100
	construction_cost = list(MATERIAL_METAL = 2000, MATERIAL_GLASS = 10000)
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_MATERIALS = 2)

/obj/item/mecha_parts/part/odysseus_torso
	name = "Odysseus Torso"
	desc = "A torso part of Odysseus. Contains power unit, processing core and life support systems."
	icon_state = "odysseus_torso"
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_BIOTECH = 2,
		RESEARCH_TECH_ENGINEERING = 2
	)
	construction_time = 180
	construction_cost = list(MATERIAL_METAL = 25000)

/obj/item/mecha_parts/part/odysseus_left_arm
	name = "Odysseus Left Arm"
	desc = "An Odysseus left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_l_arm"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_ENGINEERING = 2)
	construction_time = 120
	construction_cost = list(MATERIAL_METAL = 10000)

/obj/item/mecha_parts/part/odysseus_right_arm
	name = "Odysseus Right Arm"
	desc = "An Odysseus right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_r_arm"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_ENGINEERING = 2)
	construction_time = 120
	construction_cost = list(MATERIAL_METAL = 10000)

/obj/item/mecha_parts/part/odysseus_left_leg
	name = "Odysseus Left Leg"
	desc = "An Odysseus left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_l_leg"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_ENGINEERING = 2)
	construction_time = 130
	construction_cost = list(MATERIAL_METAL = 15000)

/obj/item/mecha_parts/part/odysseus_right_leg
	name = "Odysseus Right Leg"
	desc = "A Odysseus right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_r_leg"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_MATERIALS = 2, RESEARCH_TECH_ENGINEERING = 2)
	construction_time = 130
	construction_cost = list(MATERIAL_METAL = 15000)

/*/obj/item/mecha_parts/part/odysseus_armour
	name="Odysseus Carapace"
	icon_state = "odysseus_armour"
	origin_tech = list(RESEARCH_TECH_MATERIALS = 3, RESEARCH_TECH_ENGINEERING = 3)
	construction_time = 200
	construction_cost = list(MATERIAL_METAL = 15000)*/


///////// Circuitboards
/obj/item/weapon/circuitboard/mecha
	name = "circuit board (Exosuit)"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	item_state = "electronic"
	board_type = "other"
	flags = CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15

// Ripley
/obj/item/weapon/circuitboard/mecha/ripley
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)

/obj/item/weapon/circuitboard/mecha/ripley/peripherals
	name = "circuit board (Ripley Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/ripley/main
	name = "circuit board (Ripley Central Control module)"
	icon_state = "mainboard"

// Gygax
/obj/item/weapon/circuitboard/mecha/gygax
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4)

/obj/item/weapon/circuitboard/mecha/gygax/peripherals
	name = "circuit board (Gygax Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/gygax/targeting
	name = "circuit board (Gygax Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_COMBAT = 4)

/obj/item/weapon/circuitboard/mecha/gygax/main
	name = "circuit board (Gygax Central Control module)"
	icon_state = "mainboard"

// Durand
/obj/item/weapon/circuitboard/mecha/durand
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4)

/obj/item/weapon/circuitboard/mecha/durand/peripherals
	name = "circuit board (Durand Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/durand/targeting
	name = "circuit board (Durand Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_COMBAT = 4)

/obj/item/weapon/circuitboard/mecha/durand/main
	name = "circuit board (Durand Central Control module)"
	icon_state = "mainboard"

// Honker
/obj/item/weapon/circuitboard/mecha/honker
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4)

/obj/item/weapon/circuitboard/mecha/honker/peripherals
	name = "circuit board (H.O.N.K Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/honker/targeting
	name = "circuit board (H.O.N.K Weapon Control and Targeting module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/honker/main
	name = "circuit board (H.O.N.K Central Control module)"
	icon_state = "mainboard"

// Odysseus
/obj/item/weapon/circuitboard/mecha/odysseus
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)

/obj/item/weapon/circuitboard/mecha/odysseus/peripherals
	name = "circuit board (Odysseus Peripherals Control module)"
	icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/odysseus/main
	name = "circuit board (Odysseus Central Control module)"
	icon_state = "mainboard"