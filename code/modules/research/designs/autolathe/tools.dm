// Basic Tools
/datum/design/autolathe/wrench
	name = "Wrench"
	req_tech = alist(/decl/tech/materials = 1, /decl/tech/engineering = 1)
	materials = alist(/decl/material/steel = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5)
	build_path = /obj/item/wrench

/datum/design/autolathe/screwdriver
	name = "Screwdriver"
	req_tech = alist(/decl/tech/materials = 1, /decl/tech/engineering = 1)
	materials = alist(/decl/material/steel = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5, /decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.25)
	build_path = /obj/item/screwdriver

/datum/design/autolathe/wirecutters
	name = "Wirecutters"
	req_tech = alist(/decl/tech/materials = 1, /decl/tech/engineering = 1)
	materials = alist(/decl/material/steel = QUARTER_SHEET_MATERIAL_AMOUNT * 0.65, /decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.15)
	build_path = /obj/item/wirecutters

/datum/design/autolathe/welding_torch
	name = "Welding Torch"
	req_tech = alist(/decl/tech/engineering = 1)
	materials = alist(/decl/material/steel = QUARTER_SHEET_MATERIAL_AMOUNT * 0.7, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.3)
	build_path = /obj/item/welding_torch

/datum/design/autolathe/industrial_welding_torch
	name = "Industrial Welding Torch"
	materials = alist(/decl/material/steel = QUARTER_SHEET_MATERIAL_AMOUNT * 0.7, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.6)
	build_path = /obj/item/welding_torch/industrial
	hidden = TRUE

/datum/design/autolathe/crowbar
	name = "Crowbar"
	req_tech = alist(/decl/tech/engineering = 1)
	materials = alist(/decl/material/steel = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/crowbar

/datum/design/autolathe/multitool
	name = "Multitool"
	req_tech = alist(/decl/tech/magnets = 1, /decl/tech/engineering = 1)
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/multitool

/datum/design/autolathe/t_scanner
	name = "T-Ray Scanner"
	req_tech = alist(/decl/tech/magnets = 1, /decl/tech/engineering = 1)
	materials = alist(/decl/material/plastic = 0.25 MATERIAL_SHEETS, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5)
	build_path = /obj/item/t_scanner

/datum/design/autolathe/flashlight
	name = "Flashlight"
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.5, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/flashlight

/datum/design/autolathe/extinguisher
	name = "Fire Extinguisher"
	materials = alist(/decl/material/steel = 0.4 MATERIAL_SHEETS, /decl/material/plastic = 0.1 MATERIAL_SHEETS)
	build_path = /obj/item/fire_extinguisher

/datum/design/autolathe/gas_analyser
	name = "Gas Analyser"
	req_tech = alist(/decl/tech/magnets = 1, /decl/tech/engineering = 1)
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.3, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.2)
	build_path = /obj/item/gas_analyser

// Miscellaneous
/datum/design/autolathe/kitchen_knife
	name = "Kitchen Knife"
	req_tech = alist(/decl/tech/materials = 1)
	materials = alist(/decl/material/steel = 6 MATERIAL_SHEETS)
	build_path = /obj/item/kitchenknife

/datum/design/autolathe/cleaver
	name = "Butcher's Cleaver"
	req_tech = alist(/decl/tech/materials = 1)
	materials = alist(/decl/material/steel = 8 MATERIAL_SHEETS)
	build_path = /obj/item/butch

/datum/design/autolathe/tape_recorder
	name = "Tape Recorder"
	materials = alist(/decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 0.6, /decl/material/glass = QUARTER_SHEET_MATERIAL_AMOUNT * 0.3)
	build_path = /obj/item/taperecorder

/datum/design/autolathe/bucket
	name = "Bucket"
	materials = alist(/decl/material/plastic = 0.5 MATERIAL_SHEETS)
	build_type = /obj/item/reagent_holder/glass/bucket

/datum/design/autolathe/rcd
	name = "Rapid Construction Device"
	materials = alist(/decl/material/steel = 25 MATERIAL_SHEETS)
	build_type = /obj/item/rcd
	hidden = TRUE