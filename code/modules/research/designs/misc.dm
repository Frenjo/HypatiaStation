////////////////////////////////
////////// Data Disks //////////
////////////////////////////////
/datum/design/design_disk
	name = "Disk Design (Design Data)"
	desc = "Produce additional disks for storing device designs."
	req_tech = list(/decl/tech/programming = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 10)
	build_path = /obj/item/disk/design

/datum/design/tech_disk
	name = "Disk Design (Technology Data)"
	desc = "Produce additional disks for storing technology data."
	req_tech = list(/decl/tech/programming = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 10)
	build_path = /obj/item/disk/tech

////////////////////////////////////////////////
////////// Non-Circuit Computer Stuff //////////
////////////////////////////////////////////////
/datum/design/intellicard
	name = "AI Design (Intellicard AI Transportation System)"
	desc = "Allows for the construction of an intellicard."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/programming = 4)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(/decl/material/glass = 1000, /decl/material/gold = 200)
	build_path = /obj/item/aicard

/datum/design/paicard
	name = "AI Design (Personal Artificial Intelligence Card)"
	desc = "Allows for the construction of a pAI Card"
	req_tech = list(/decl/tech/programming = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(/decl/material/glass = 500, MATERIAL_METAL = 500)
	build_path = /obj/item/paicard

/datum/design/posibrain
	name = "AI Design (Positronic Brain)"
	desc = "Allows for the construction of a positronic brain"
	req_tech = list(/decl/tech/materials = 6, /decl/tech/engineering = 4, /decl/tech/programming = 4, /decl/tech/bluespace = 2)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_ROBOFAB
	materials = list(
		/decl/material/steel = 2000, /decl/material/glass = 1000, /decl/material/silver = 1000,
		/decl/material/gold = 500, /decl/material/diamond = 100, /decl/material/plasma = 500
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
	req_tech = list(/decl/tech/materials = 3, /decl/tech/magnets = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 1500, /decl/material/glass = 3000, /decl/material/silver = 150)
	build_path = /obj/item/lightreplacer

/datum/design/security_hud
	name = "Security Design (Security HUD)"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status."
	req_tech = list(/decl/tech/magnets = 3, /decl/tech/combat = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/clothing/glasses/hud/security
	locked = 1