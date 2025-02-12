// Basic Tools
/datum/design/autolathe/wrench
	name = "Wrench"
	materials = list(/decl/material/steel = 150)
	build_path = /obj/item/wrench

/datum/design/autolathe/screwdriver
	name = "Screwdriver"
	materials = list(/decl/material/steel = 75)
	build_path = /obj/item/screwdriver

/datum/design/autolathe/wirecutters
	name = "Wirecutters"
	materials = list(/decl/material/steel = 80)
	build_path = /obj/item/wirecutters

/datum/design/autolathe/welding_tool
	name = "Welding Tool"
	materials = list(/decl/material/steel = 70, /decl/material/glass = 30)
	build_path = /obj/item/weldingtool

/datum/design/autolathe/industrial_welding_tool
	name = "Industrial Welding Tool"
	materials = list(/decl/material/steel = 70, /decl/material/glass = 60)
	build_path = /obj/item/weldingtool/largetank
	hidden = TRUE

/datum/design/autolathe/crowbar
	name = "Crowbar"
	materials = list(/decl/material/steel = 50)
	build_path = /obj/item/crowbar

/datum/design/autolathe/multitool
	name = "Multitool"
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20)
	build_path = /obj/item/multitool

/datum/design/autolathe/t_scanner
	name = "T-Ray Scanner"
	materials = list(MATERIAL_METAL = 150)
	build_path = /obj/item/t_scanner

/datum/design/autolathe/flashlight
	name = "Flashlight"
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 20)
	build_path = /obj/item/flashlight

/datum/design/autolathe/extinguisher
	name = "Fire Extinguisher"
	materials = list(/decl/material/steel = 90)
	build_path = /obj/item/extinguisher

// Miscellaneous
/datum/design/autolathe/kitchen_knife
	name = "Kitchen Knife"
	materials = list(/decl/material/steel = 12000)
	build_path = /obj/item/kitchenknife

/datum/design/autolathe/tape_recorder
	name = "Tape Recorder"
	materials = list(MATERIAL_METAL = 60, /decl/material/glass = 30)
	build_path = /obj/item/taperecorder

/datum/design/autolathe/bucket
	name = "Bucket"
	materials = list(MATERIAL_METAL = 200)
	build_type = /obj/item/reagent_holder/glass/bucket

/datum/design/autolathe/rcd
	name = "Rapid Construction Device"
	materials = list(MATERIAL_METAL = 50000)
	build_type = /obj/item/rcd
	hidden = TRUE