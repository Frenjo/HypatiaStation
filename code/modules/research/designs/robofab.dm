/datum/design/robofab
	build_type = DESIGN_TYPE_ROBOFAB

// Robot
/datum/design/robofab/robot
	name_prefix = "Robot Part Design"

/datum/design/robofab/robot/chassis
	name = "Endoskeleton"
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 25)
	build_time = 50 SECONDS
	build_path = /obj/item/robot_part/chassis
	categories = list("Robot")

/datum/design/robofab/robot/torso
	name = "Torso"
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 20)
	build_time = 35 SECONDS
	build_path = /obj/item/robot_part/torso
	categories = list("Robot")

/datum/design/robofab/robot/head
	name = "Head"
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 12.5)
	build_time = 35 SECONDS
	build_path = /obj/item/robot_part/head
	categories = list("Robot")

/datum/design/robofab/robot/left_arm
	name = "Left Arm"
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 9)
	build_time = 20 SECONDS
	build_path = /obj/item/robot_part/l_arm
	categories = list("Robot")

/datum/design/robofab/robot/right_arm
	name = "Right Arm"
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 9)
	build_time = 20 SECONDS
	build_path = /obj/item/robot_part/r_arm
	categories = list("Robot")

/datum/design/robofab/robot/left_leg
	name = "Left Leg"
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 7.5)
	build_time = 20 SECONDS
	build_path = /obj/item/robot_part/l_leg
	categories = list("Robot")

/datum/design/robofab/robot/right_leg
	name = "Right Leg"
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 7.5)
	build_time = 20 SECONDS
	build_path = /obj/item/robot_part/r_leg
	categories = list("Robot")

// Robot Internal Components
/datum/design/robofab/robot_component
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 2.5)
	build_time = 20 SECONDS
	categories = list("Robot Internal Components")
	name_prefix = "Robot Component Design"

/datum/design/robofab/robot_component/binary_comm_device
	name = "Binary Communication Device"
	build_path = /obj/item/robot_part/component/binary_communication_device

/datum/design/robofab/robot_component/actuator
	name = "Actuator"
	build_path = /obj/item/robot_part/component/actuator

/datum/design/robofab/robot_component/armour
	name = "Armour"
	build_path = /obj/item/robot_part/component/armour

/datum/design/robofab/robot_component/camera
	name = "Camera"
	build_path = /obj/item/robot_part/component/camera

/datum/design/robofab/robot_component/diagnosis_unit
	name = "Diagnosis Unit"
	build_path = /obj/item/robot_part/component/diagnosis_unit

/datum/design/robofab/robot_component/radio
	name = "Radio"
	build_path = /obj/item/robot_part/component/radio

/datum/design/robofab/synthetic_flash
	name = "Synthetic Flash"
	desc = "When a problem arises, SCIENCE is the solution."
	req_tech = alist(/decl/tech/magnets = 3, /decl/tech/combat = 2)
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
	name = "Model Reset Module"
	desc = "Allows for the construction of robot model reset modules."
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5)
	build_path = /obj/item/robot_upgrade/reset

/datum/design/robofab/robot_upgrade/rename
	name = "Reclassification Module"
	desc = "Allows for the construction of robot reclassification modules."
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 11)
	build_path = /obj/item/robot_upgrade/rename

/datum/design/robofab/robot_upgrade/restart
	name = "Emergency Restart Module"
	desc = "Allows for the construction of robot emergency restart modules."
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 18, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3)
	build_path = /obj/item/robot_upgrade/restart

/datum/design/robofab/robot_upgrade/vtec
	name = "VTEC Module"
	desc = "Allows for the construction of robot VTEC modules."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/engineering = 3)
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 24, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3,
		/decl/material/gold = MATERIAL_AMOUNT_PER_SHEET * 3
	)
	build_path = /obj/item/robot_upgrade/vtec

/datum/design/robofab/robot_upgrade/expander
	name = "Expander Module"
	desc = "Allows for the construction of robot expander modules."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 3)
	// This is the total amount of steel it costs to build a whole other robot endoskeleton.
	materials = alist(/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 90.5)
	build_path = /obj/item/robot_upgrade/expander

/datum/design/robofab/robot_upgrade/taser_cooler
	name = "Security Rapid Taser Cooling Module"
	desc = "Allows for the construction of rapid taser cooling modules for security robots."
	req_tech = alist(/decl/tech/combat = 2, /decl/tech/engineering = 3)
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 24, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 3,
		/decl/material/gold = MATERIAL_AMOUNT_PER_SHEET, /decl/material/diamond = MATERIAL_AMOUNT_PER_SHEET
	)
	build_path = /obj/item/robot_upgrade/tasercooler

/datum/design/robofab/robot_upgrade/jetpack
	name = "Miner Jetpack Module"
	desc = "Allows for the construction of jetpack modules for miner robots."
	req_tech = alist(/decl/tech/materials = 2, /decl/tech/engineering = 2)
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/uranium = MATERIAL_AMOUNT_PER_SHEET * 10,
		/decl/material/plasma = MATERIAL_AMOUNT_PER_SHEET * 8
	)
	build_path = /obj/item/robot_upgrade/jetpack

/datum/design/robofab/robot_upgrade/holding_satchel
	name = "Miner Holding Satchel Module"
	desc = "Allows for the construction of holding satchel modules for miner robots."
	req_tech = /datum/design/bluespace/mining_satchel_holding::req_tech
	materials = /datum/design/bluespace/mining_satchel_holding::materials
	reliability_base = /datum/design/bluespace/mining_satchel_holding::reliability_base
	build_path = /obj/item/robot_upgrade/holding_satchel

/datum/design/robofab/robot_upgrade/scrambled
	name = "Scrambled Equipment Module"
	desc = "Allows for the construction of illegal upgrades for robots."
	req_tech = alist(/decl/tech/combat = 4, /decl/tech/syndicate = 3)
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET * 8,
		/decl/material/diamond = MATERIAL_AMOUNT_PER_SHEET * 5
	)
	build_path = /obj/item/robot_upgrade/scrambled

/datum/design/robofab/robot_upgrade/flashproof
	name = "Flash Suppression Module"
	desc = "Allows for the construction of robot flash-suppression modules."
	req_tech = alist(/decl/tech/combat = 4, /decl/tech/syndicate = 3)
	materials = alist(
		/decl/material/steel = MATERIAL_AMOUNT_PER_SHEET * 5, /decl/material/glass = MATERIAL_AMOUNT_PER_SHEET,
		/decl/material/silver = MATERIAL_AMOUNT_PER_SHEET * 2, /decl/material/gold = MATERIAL_AMOUNT_PER_SHEET,
		/decl/material/diamond = MATERIAL_AMOUNT_PER_SHEET * 3
	)
	build_path = /obj/item/robot_upgrade/flashproof