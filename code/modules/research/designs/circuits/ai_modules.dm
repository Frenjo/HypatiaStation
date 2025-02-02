////////////////////////////////////////
////////// AI Module Circuits //////////
////////////////////////////////////////
/datum/design/circuit/ai_module
	name_prefix = "AI Module Design"

/datum/design/circuit/ai_module/safeguard
	name = "Safeguard"
	desc = "Allows for the construction of a Safeguard AI Module."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/safeguard

/datum/design/circuit/ai_module/onehuman
	name = "OneHuman"
	desc = "Allows for the construction of a OneHuman AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 4)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/oneHuman

/datum/design/circuit/ai_module/protectstation
	name = "ProtectStation"
	desc = "Allows for the construction of a ProtectStation AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/protectStation

/datum/design/circuit/ai_module/notele
	name = "TeleporterOffline"
	desc = "Allows for the construction of a TeleporterOffline AI Module."
	req_tech = list(/decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/teleporterOffline

/datum/design/circuit/ai_module/quarantine
	name = "Quarantine"
	desc = "Allows for the construction of a Quarantine AI Module."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/biotech = 2, /decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/quarantine

/datum/design/circuit/ai_module/oxygen
	name = "OxygenIsToxicToHumans"
	desc = "Allows for the construction of an OxygenIsToxicToHumans AI Module."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/biotech = 2, /decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/oxygen

/datum/design/circuit/ai_module/freeform
	name = "Freeform"
	desc = "Allows for the construction of a Freeform AI Module."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/programming = 4)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/freeform

/datum/design/circuit/ai_module/reset
	name = "Reset"
	desc = "Allows for the construction of a Reset AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/reset

/datum/design/circuit/ai_module/purge
	name = "Purge"
	desc = "Allows for the construction of a Purge AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 4)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/purge

/datum/design/circuit/core_ai_module
	name_prefix = "Core AI Module Design"

/datum/design/circuit/core_ai_module/freeform
	name = "Freeform"
	desc = "Allows for the construction of a Freeform Core AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 4)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/freeformcore

/datum/design/circuit/core_ai_module/asimov
	name = "Asimov"
	desc = "Allows for the construction of a Asimov Core AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/asimov

/datum/design/circuit/core_ai_module/paladin
	name = "P.A.L.A.D.I.N."
	desc = "Allows for the construction of a P.A.L.A.D.I.N. Core AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 4)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/paladin

/datum/design/circuit/core_ai_module/tyrant
	name = "T.Y.R.A.N.T."
	desc = "Allows for the construction of a T.Y.R.A.N.T. Core AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 4, /decl/tech/syndicate = 2)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/tyrant