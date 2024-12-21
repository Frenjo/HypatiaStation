////////////////////////////////////////////
////////// Miscellaneous Circuits //////////
////////////////////////////////////////////
/datum/design/destructive_analyser
	name = "Destructive Analyser Board"
	desc = "The circuit board for a destructive analyser."
	req_tech = list(/datum/tech/magnets = 2, /datum/tech/engineering = 2, /datum/tech/programming = 2)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/destructive_analyser

/datum/design/protolathe
	name = "Protolathe Board"
	desc = "The circuit board for a protolathe."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/programming = 2)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/protolathe

/datum/design/circuit_imprinter
	name = "Circuit Imprinter Board"
	desc = "The circuit board for a circuit imprinter."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/programming = 2)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/circuit_imprinter

/datum/design/autolathe
	name = "Autolathe Board"
	desc = "The circuit board for a autolathe."
	req_tech = list(/datum/tech/engineering = 2, /datum/tech/programming = 2)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/autolathe

/datum/design/rdservercontrol
	name = "R&D Server Control Console Board"
	desc = "The circuit board for a R&D Server Control Console"
	req_tech = list(/datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rdservercontrol

/datum/design/rdserver
	name = "R&D Server Board"
	desc = "The circuit board for an R&D Server"
	req_tech = list(/datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/rdserver

/datum/design/mechfab
	name = "Exosuit Fabricator Board"
	desc = "The circuit board for an Exosuit Fabricator"
	req_tech = list(/datum/tech/engineering = 3, /datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mechfab

/datum/design/robofab
	name = "Robotic Fabricator Board"
	desc = "The circuit board for a Robotic Fabricator"
	req_tech = list(/datum/tech/engineering = 3, /datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/robofab

////////////////////////////////////////
////////// Generator Circuits //////////
////////////////////////////////////////
/datum/design/pacman
	name = "PACMAN-type Generator Board"
	desc = "The circuit board that for a PACMAN-type portable generator."
	req_tech = list(/datum/tech/engineering = 3, /datum/tech/power_storage = 3, /datum/tech/programming = 3, /datum/tech/plasma = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	reliability_base = 79
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/pacman

/datum/design/superpacman
	name = "SUPERPACMAN-type Generator Board"
	desc = "The circuit board that for a SUPERPACMAN-type portable generator."
	req_tech = list(/datum/tech/engineering = 4, /datum/tech/power_storage = 4, /datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	reliability_base = 76
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/pacman/super

/datum/design/mrspacman
	name = "MRSPACMAN-type Generator Board"
	desc = "The circuit board that for a MRSPACMAN-type portable generator."
	req_tech = list(/datum/tech/engineering = 5, /datum/tech/power_storage = 5, /datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	reliability_base = 74
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/pacman/mrs

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
	materials = list(MATERIAL_METAL = 1000, /decl/material/glass = 500)
	reliability_base = 76
	build_path = /obj/item/mmi
	categories = list("Robot Internal Components")

/datum/design/mmi_radio
	name = "Radio-enabled Man-Machine Interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity. This one comes with a built-in radio."
	req_tech = list(/datum/tech/biotech = 4, /datum/tech/programming = 2)
	build_type = DESIGN_TYPE_PROTOLATHE | DESIGN_TYPE_ROBOFAB
	materials = list(MATERIAL_METAL = 1200, /decl/material/glass = 500)
	reliability_base = 74
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

/datum/design/synthetic_flash
	name = "Synthetic Flash"
	desc = "When a problem arises, SCIENCE is the solution."
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/combat = 2)
	build_type = DESIGN_TYPE_ROBOFAB
	materials = list(MATERIAL_METAL = 750, /decl/material/glass = 750)
	reliability_base = 76
	build_path = /obj/item/flash/synthetic
	categories = list("Robot Internal Components")

/datum/design/security_hud
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status."
	req_tech = list(/datum/tech/magnets = 3, /datum/tech/combat = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/clothing/glasses/hud/security
	locked = 1

/datum/design/borg_syndicate_module
	name = "Borg Illegal Weapons Upgrade"
	desc = "Allows for the construction of illegal upgrades for cyborgs"
	build_type = DESIGN_TYPE_ROBOFAB
	req_tech = list(/datum/tech/combat = 4, /datum/tech/syndicate = 3)
	build_path = /obj/item/borg/upgrade/syndicate
	categories = list("Robot Upgrade Modules")

/datum/design/chameleon
	name = "Chameleon Jumpsuit"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	req_tech = list(/datum/tech/syndicate = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 500)
	build_path = /obj/item/clothing/under/chameleon