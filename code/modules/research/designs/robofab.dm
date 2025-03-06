/datum/design/robofab
	build_type = DESIGN_TYPE_ROBOFAB

// Robot
/datum/design/robofab/robot
	name_prefix = "Robot Part Design"

/datum/design/robofab/robot/suit
	materials = alist(/decl/material/steel = 50000)
	build_time = 50 SECONDS
	build_path = /obj/item/robot_parts/robot_suit
	categories = list("Robot")

/datum/design/robofab/robot/chest
	materials = alist(/decl/material/steel = 40000)
	build_time = 35 SECONDS
	build_path = /obj/item/robot_parts/chest
	categories = list("Robot")

/datum/design/robofab/robot/head
	materials = alist(/decl/material/steel = 25000)
	build_time = 35 SECONDS
	build_path = /obj/item/robot_parts/head
	categories = list("Robot")

/datum/design/robofab/robot/left_arm
	materials = alist(/decl/material/steel = 18000)
	build_time = 20 SECONDS
	build_path = /obj/item/robot_parts/l_arm
	categories = list("Robot")

/datum/design/robofab/robot/right_arm
	materials = alist(/decl/material/steel = 18000)
	build_time = 20 SECONDS
	build_path = /obj/item/robot_parts/r_arm
	categories = list("Robot")

/datum/design/robofab/robot/left_leg
	materials = alist(/decl/material/steel = 15000)
	build_time = 20 SECONDS
	build_path = /obj/item/robot_parts/l_leg
	categories = list("Robot")

/datum/design/robofab/robot/right_leg
	materials = alist(/decl/material/steel = 15000)
	build_time = 20 SECONDS
	build_path = /obj/item/robot_parts/r_leg
	categories = list("Robot")

// Robot Internal Components
/datum/design/robofab/robot_component
	materials = alist(/decl/material/steel = 5000)
	build_time = 20 SECONDS
	categories = list("Robot Internal Components")
	name_prefix = "Robot Component Design"

/datum/design/robofab/robot_component/binary_comm_device
	build_path = /obj/item/robot_parts/robot_component/binary_communication_device

/datum/design/robofab/robot_component/actuator
	build_path = /obj/item/robot_parts/robot_component/actuator

/datum/design/robofab/robot_component/armour
	build_path = /obj/item/robot_parts/robot_component/armour

/datum/design/robofab/robot_component/camera
	build_path = /obj/item/robot_parts/robot_component/camera

/datum/design/robofab/robot_component/diagnosis_unit
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit

/datum/design/robofab/robot_component/radio
	build_path = /obj/item/robot_parts/robot_component/radio

/datum/design/robofab/synthetic_flash
	name = "Synthetic Flash"
	desc = "When a problem arises, SCIENCE is the solution."
	req_tech = list(/decl/tech/magnets = 3, /decl/tech/combat = 2)
	reliability_base = 76
	materials = alist(/decl/material/plastic = 750, /decl/material/glass = 750)
	build_time = 10 SECONDS
	build_path = /obj/item/flash/synthetic
	categories = list("Robot Internal Components")
	name_prefix = "Robot Component Design"

// Robot Upgrade Modules
/datum/design/robofab/robot_upgrade
	build_time = 12 SECONDS
	categories = list("Robot Upgrade Modules")
	name_prefix = "Robot Upgrade Design"

/datum/design/robofab/robot_upgrade/reset
	materials = alist(/decl/material/steel = 10000)
	build_path = /obj/item/borg/upgrade/reset

/datum/design/robofab/robot_upgrade/rename
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11)
	build_path = /obj/item/borg/upgrade/rename

/datum/design/robofab/robot_upgrade/restart
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 18, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_path = /obj/item/borg/upgrade/restart

/datum/design/robofab/robot_upgrade/vtec
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 24, /decl/material/glass = 6000, /decl/material/gold = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_path = /obj/item/borg/upgrade/vtec

/datum/design/robofab/robot_upgrade/taser_cooler
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 24, /decl/material/glass = 6000,
		/decl/material/gold = 2000, /decl/material/diamond = MATERIAL_AMOUNT_PER_SHEET
	)
	build_path = /obj/item/borg/upgrade/tasercooler

/datum/design/robofab/robot_upgrade/jetpack
	materials = alist(/decl/material/steel = 10000, /decl/material/uranium = 20000, /decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 8)
	build_path = /obj/item/borg/upgrade/jetpack

/datum/design/robofab/robot_upgrade/syndicate
	name = "Scrambled Equipment"
	desc = "Allows for the construction of illegal upgrades for robots."
	req_tech = list(/decl/tech/combat = 4, /decl/tech/syndicate = 3)
	materials = alist(/decl/material/steel = 10000, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 8, /decl/material/diamond = 10000)
	build_path = /obj/item/borg/upgrade/syndicate

/*
/datum/design/robofab/robot_upgrade/flashproof
	materials = alist(
		/decl/material/steel = 10000, /decl/material/glass = 2000, /decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2,
		/decl/material/gold = 2000, /decl/material/diamond = MATERIAL_AMOUNT_PER_SHEET * 3
	)
	build_path = /obj/item/borg/upgrade/flashproof
*/