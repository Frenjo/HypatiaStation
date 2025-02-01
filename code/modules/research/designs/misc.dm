////////////////////////////////
////////// Data Disks //////////
////////////////////////////////
/datum/design/design_disk
	name = "Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	req_tech = list(/datum/tech/programming = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 10)
	build_path = /obj/item/disk/design

/datum/design/tech_disk
	name = "Technology Data Storage Disk"
	desc = "Produce additional disks for storing technology data."
	req_tech = list(/datum/tech/programming = 1)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_AUTOLATHE
	materials = list(MATERIAL_METAL = 30, /decl/material/glass = 10)
	build_path = /obj/item/disk/tech

////////////////////////////////////////////////
////////// Non-Circuit Computer Stuff //////////
////////////////////////////////////////////////
/datum/design/intellicard
	name = "Intellicard AI Transportation System"
	desc = "Allows for the construction of an intellicard."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/programming = 4)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(/decl/material/glass = 1000, /decl/material/gold = 200)
	build_path = /obj/item/aicard

/datum/design/paicard
	name = "Personal Artificial Intelligence Card"
	desc = "Allows for the construction of a pAI Card"
	req_tech = list(/datum/tech/programming = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(/decl/material/glass = 500, MATERIAL_METAL = 500)
	build_path = /obj/item/paicard

/datum/design/mmi
	name = "Man-Machine Interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity."
	req_tech = list(/datum/tech/biotech = 3, /datum/tech/programming = 2)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_ROBOFAB
	reliability_base = 76
	materials = list(MATERIAL_METAL = 1000, /decl/material/glass = 500)
	build_time = 7.5 SECONDS
	build_path = /obj/item/mmi
	categories = list("Robot Internal Components")

/datum/design/mmi_radio
	name = "Radio-enabled Man-Machine Interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."
	req_tech = list(/datum/tech/biotech = 4, /datum/tech/programming = 2)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_ROBOFAB
	reliability_base = 74
	materials = list(MATERIAL_METAL = 1200, /decl/material/glass = 500)
	build_time = 7.5 SECONDS
	build_path = /obj/item/mmi/radio_enabled
	categories = list("Robot Internal Components")

/datum/design/posibrain
	name = "Positronic Brain"
	desc = "Allows for the construction of a positronic brain"
	req_tech = list(/datum/tech/materials = 6, /datum/tech/engineering = 4, /datum/tech/programming = 4, /datum/tech/bluespace = 2)

	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_ROBOFAB
	materials = list(
		MATERIAL_METAL = 2000, /decl/material/glass = 1000, /decl/material/silver = 1000,
		/decl/material/gold = 500, /decl/material/diamond = 100, /decl/material/plasma = 500
	)
	build_time = 7.5 SECONDS
	build_path = /obj/item/mmi/posibrain
	categories = list("Robot Internal Components")

/////////////////////////////////////////
////////// Miscellaneous Items //////////
/////////////////////////////////////////
/datum/design/light_replacer
	name = "Light Replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	req_tech = list(/datum/tech/materials = 4, /datum/tech/magnets = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 1500, /decl/material/glass = 3000, /decl/material/silver = 150)
	build_path = /obj/item/lightreplacer

/datum/design/security_hud
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status."
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/combat = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/clothing/glasses/hud/security
	locked = 1

/datum/design/chameleon
	name = "Chameleon Jumpsuit"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	req_tech = list(/datum/tech/syndicate = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 500)
	build_path = /obj/item/clothing/under/chameleon