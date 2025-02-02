////////////////////////////////////////
////////// AI Module Circuits //////////
////////////////////////////////////////
/datum/design/circuit/safeguard_module
	name = "Module Design (Safeguard)"
	desc = "Allows for the construction of a Safeguard AI Module."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/safeguard

/datum/design/circuit/onehuman_module
	name = "Module Design (OneHuman)"
	desc = "Allows for the construction of a OneHuman AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 4)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/oneHuman

/datum/design/circuit/protectstation_module
	name = "Module Design (ProtectStation)"
	desc = "Allows for the construction of a ProtectStation AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/protectStation

/datum/design/circuit/notele_module
	name = "Module Design (TeleporterOffline Module)"
	desc = "Allows for the construction of a TeleporterOffline AI Module."
	req_tech = list(/decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/teleporterOffline

/datum/design/circuit/quarantine_module
	name = "Module Design (Quarantine)"
	desc = "Allows for the construction of a Quarantine AI Module."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/biotech = 2, /decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/quarantine

/datum/design/circuit/oxygen_module
	name = "Module Design (OxygenIsToxicToHumans)"
	desc = "Allows for the construction of a Safeguard AI Module."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/biotech = 2, /decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/oxygen

/datum/design/circuit/freeform_module
	name = "Module Design (Freeform)"
	desc = "Allows for the construction of a Freeform AI Module."
	req_tech = list(/decl/tech/materials = 4, /decl/tech/programming = 4)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/freeform

/datum/design/circuit/reset_module
	name = "Module Design (Reset)"
	desc = "Allows for the construction of a Reset AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/gold = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/reset

/datum/design/circuit/purge_module
	name = "Module Design (Purge)"
	desc = "Allows for the construction of a Purge AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 4)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/purge

/datum/design/circuit/freeformcore_module
	name = "Core Module Design (Freeform)"
	desc = "Allows for the construction of a Freeform AI Core Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 4)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/freeformcore

/datum/design/circuit/asimov
	name = "Core Module Design (Asimov)"
	desc = "Allows for the construction of a Asimov AI Core Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 3)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/asimov

/datum/design/circuit/paladin_module
	name = "Core Module Design (P.A.L.A.D.I.N.)"
	desc = "Allows for the construction of a P.A.L.A.D.I.N. AI Core Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 4)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/paladin

/datum/design/circuit/tyrant_module
	name = "Core Module Design (T.Y.R.A.N.T.)"
	desc = "Allows for the construction of a T.Y.R.A.N.T. AI Module."
	req_tech = list(/decl/tech/materials = 6, /decl/tech/programming = 4, /decl/tech/syndicate = 2)
	materials = list(/decl/material/glass = 2000, /decl/material/diamond = 100, "sacid" = 20)
	build_path = /obj/item/ai_module/tyrant