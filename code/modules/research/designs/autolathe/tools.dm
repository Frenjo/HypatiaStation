// Basic Tools
/datum/design/autolathe/wrench
	name = "Wrench"
	req_tech = alist(/decl/tech/materials = 1, /decl/tech/engineering = 1)
	materials = alist(/decl/material/steel = 150)
	build_path = /obj/item/wrench

/datum/design/autolathe/screwdriver
	name = "Screwdriver"
	req_tech = alist(/decl/tech/materials = 1, /decl/tech/engineering = 1)
	materials = alist(/decl/material/steel = 75)
	build_path = /obj/item/screwdriver

/datum/design/autolathe/wirecutters
	name = "Wirecutters"
	req_tech = alist(/decl/tech/materials = 1, /decl/tech/engineering = 1)
	materials = alist(/decl/material/steel = 80)
	build_path = /obj/item/wirecutters

/datum/design/autolathe/welding_torch
	name = "Welding Torch"
	req_tech = alist(/decl/tech/engineering = 1)
	materials = alist(/decl/material/steel = (0.25 MATERIAL_SHEETS) * 0.7, /decl/material/glass = (0.25 MATERIAL_SHEETS) * 0.3)
	build_path = /obj/item/welding_torch

/datum/design/autolathe/industrial_welding_torch
	name = "Industrial Welding Torch"
	materials = alist(/decl/material/steel = (0.25 MATERIAL_SHEETS) * 0.7, /decl/material/glass = (0.25 MATERIAL_SHEETS) * 0.6)
	build_path = /obj/item/welding_torch/industrial
	hidden = TRUE

/datum/design/autolathe/crowbar
	name = "Crowbar"
	req_tech = alist(/decl/tech/engineering = 1)
	materials = alist(/decl/material/steel = 50)
	build_path = /obj/item/crowbar

/datum/design/autolathe/multitool
	name = "Multitool"
	req_tech = alist(/decl/tech/magnets = 1, /decl/tech/engineering = 1)
	materials = alist(/decl/material/plastic = 50, /decl/material/glass = 20)
	build_path = /obj/item/multitool

/datum/design/autolathe/t_scanner
	name = "T-Ray Scanner"
	req_tech = alist(/decl/tech/magnets = 1, /decl/tech/engineering = 1)
	materials = alist(/decl/material/plastic = 150, /decl/material/glass = 20)
	build_path = /obj/item/t_scanner

/datum/design/autolathe/flashlight
	name = "Flashlight"
	materials = alist(/decl/material/plastic = 50, /decl/material/glass = 20)
	build_path = /obj/item/flashlight

/datum/design/autolathe/extinguisher
	name = "Fire Extinguisher"
	materials = alist(/decl/material/steel = 90)
	build_path = /obj/item/fire_extinguisher

// Miscellaneous
/datum/design/autolathe/kitchen_knife
	name = "Kitchen Knife"
	req_tech = alist(/decl/tech/materials = 1)
	materials = alist(/decl/material/steel = 12000)
	build_path = /obj/item/kitchenknife

/datum/design/autolathe/tape_recorder
	name = "Tape Recorder"
	materials = alist(/decl/material/plastic = 60, /decl/material/glass = 30)
	build_path = /obj/item/taperecorder

/datum/design/autolathe/bucket
	name = "Bucket"
	materials = alist(/decl/material/plastic = 200)
	build_type = /obj/item/reagent_holder/glass/bucket

/datum/design/autolathe/rcd
	name = "Rapid Construction Device"
	materials = alist(/decl/material/steel = 50000)
	build_type = /obj/item/rcd
	hidden = TRUE