////////////////////////////////
////////// Data Disks //////////
////////////////////////////////
/datum/design/design_disk
	name = "Disk Design (Design Data)"
	desc = "Produce additional disks for storing device designs."
	req_tech = alist(/decl/tech/programming = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = alist(/decl/material/iron = QUARTER_SHEET_MATERIAL_AMOUNT * 3, /decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/disk/design

/datum/design/tech_disk
	name = "Disk Design (Technology Data)"
	desc = "Produce additional disks for storing technology data."
	req_tech = alist(/decl/tech/programming = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = alist(/decl/material/iron = QUARTER_SHEET_MATERIAL_AMOUNT * 3, /decl/material/plastic = QUARTER_SHEET_MATERIAL_AMOUNT * 3)
	build_path = /obj/item/disk/tech

////////////////////////////////////////////////
////////// Non-Circuit Computer Stuff //////////
////////////////////////////////////////////////
/datum/design/intellicard
	name = "AI Design (Intellicard AI Transportation System)"
	desc = "Allows for the construction of an intellicard."
	req_tech = alist(/decl/tech/materials = 4, /decl/tech/programming = 4)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = alist(/decl/material/glass = 0.5 MATERIAL_SHEETS, /decl/material/gold = HALF_SHEET_MATERIAL_AMOUNT * 0.25)
	build_path = /obj/item/aicard

/datum/design/paicard
	name = "AI Design (Personal Artificial Intelligence Card)"
	desc = "Allows for the construction of a pAI Card"
	req_tech = alist(/decl/tech/programming = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = alist(/decl/material/plastic = 0.25 MATERIAL_SHEETS, /decl/material/glass = 0.25 MATERIAL_SHEETS)
	build_path = /obj/item/paicard

/datum/design/posibrain
	name = "AI Design (Positronic Brain)"
	desc = "Allows for the construction of a positronic brain"
	req_tech = alist(/decl/tech/materials = 6, /decl/tech/engineering = 4, /decl/tech/programming = 4, /decl/tech/bluespace = 2)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_ROBOFAB
	materials = alist(
		/decl/material/steel = 1 MATERIAL_SHEET, /decl/material/glass = 0.5 MATERIAL_SHEETS, /decl/material/silver = 0.5 MATERIAL_SHEETS,
		/decl/material/gold = 0.25 MATERIAL_SHEETS, /decl/material/diamond = 0.1 MATERIAL_SHEETS, /decl/material/plasma = 0.25 MATERIAL_SHEETS
	)
	build_time = 7.5 SECONDS
	build_path = /obj/item/mmi/posibrain
	categories = list("Robot Internal Components")

/////////////////////////////////////////
////////// Miscellaneous Items //////////
/////////////////////////////////////////
/datum/design/light_replacer
	name = "Custodial Design (Light Replacer)"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	req_tech = alist(/decl/tech/materials = 3, /decl/tech/magnets = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = alist(
		/decl/material/steel = 0.75 MATERIAL_SHEETS, /decl/material/glass = 1.5 MATERIAL_SHEETS,
		/decl/material/silver = QUARTER_SHEET_MATERIAL_AMOUNT * 1.5
	)
	build_path = /obj/item/lightreplacer

/datum/design/security_hud
	name = "Security Design (Security HUD)"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status."
	req_tech = alist(/decl/tech/magnets = 3, /decl/tech/combat = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = alist(/decl/material/plastic = 0.5 MATERIAL_SHEETS, /decl/material/glass = 0.5 MATERIAL_SHEETS)
	build_path = /obj/item/clothing/glasses/hud/security
	locked = 1

/datum/design/experimental_welder
	name = "Tool Design (Experimental Welding Torch)"
	desc = "An advanced welding torch design that regenerates its internal fuel reserve over time."
	req_tech = alist(/decl/tech/engineering = 4, /decl/tech/plasma = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = alist(
		/decl/material/steel = QUARTER_SHEET_MATERIAL_AMOUNT * 0.7, /decl/material/glass = HALF_SHEET_MATERIAL_AMOUNT * 1.2,
		/decl/material/plasma = HALF_SHEET_MATERIAL_AMOUNT * 1.5, /decl/material/uranium = HALF_SHEET_MATERIAL_AMOUNT * 1.5
	)
	build_path = /obj/item/welding_torch/experimental