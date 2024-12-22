////////////////////////////////////
////////// Mecha Circuits //////////
////////////////////////////////////
// Ripley
/datum/design/ripley_main
	name = "Circuit Design (APLU \"Ripley\" Central Control module)"
	desc = "Allows for the construction of a \"Ripley\" Central Control module."
	req_tech = list(/datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/ripley/main

/datum/design/ripley_peri
	name = "Circuit Design (APLU \"Ripley\" Peripherals Control module)"
	desc = "Allows for the construction of a  \"Ripley\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals

// Dreadnought
/datum/design/dreadnought_main
	name = "Circuit Design (\"Dreadnought\" Central Control module)"
	desc = "Allows for the construction of a \"Dreadnought\" Central Control module."
	req_tech = list(/datum/tech/engineering = 3, /datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/dreadnought/main

/datum/design/dreadnought_peri
	name = "Circuit Design (\"Dreadnought\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Dreadnought\" Peripheral Control module."
	req_tech = list(/datum/tech/engineering = 3, /datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/dreadnought/peripherals

// Bulwark
/datum/design/bulwark_targ
	name = "Circuit Design (\"Bulwark\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Bulwark\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/combat = 2, /datum/tech/engineering = 3, /datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/bulwark/targeting

// Odysseus
/datum/design/odysseus_main
	name = "Circuit Design (\"Odysseus\" Central Control module)"
	desc = "Allows for the construction of a \"Odysseus\" Central Control module."
	req_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/odysseus/main

/datum/design/odysseus_peri
	name = "Circuit Design (\"Odysseus\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Odysseus\" Peripheral Control module."
	req_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals

// Serenity
/datum/design/serenity_medical
	name = "Circuit Design (\"Serenity\" Medical Control module)"
	desc = "Allows for the construction of a \"Serenity\" Medical Control module."
	req_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 4)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/serenity/medical

// Gygax
/datum/design/gygax_main
	name = "Circuit Design (\"Gygax\" Central Control module)"
	desc = "Allows for the construction of a \"Gygax\" Central Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/gygax/main

/datum/design/gygax_peri
	name = "Circuit Design (\"Gygax\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Gygax\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals

/datum/design/gygax_targ
	name = "Circuit Design (\"Gygax\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Gygax\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/combat = 2, /datum/tech/programming = 4)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting

// Durand
/datum/design/durand_main
	name = "Circuit Design (\"Durand\" Central Control module)"
	desc = "Allows for the construction of a \"Durand\" Central Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/durand/main

/datum/design/durand_peri
	name = "Circuit Design (\"Durand\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Durand\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/durand/peripherals

/datum/design/durand_targ
	name = "Circuit Design (\"Durand\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Durand\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/combat = 4, /datum/tech/programming = 4)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/durand/targeting

// Phazon
/datum/design/phazon_main
	name = "Circuit Design (\"Phazon\" Central Control module)"
	desc = "Allows for the construction of a \"Phazon\" Central Control module."
	req_tech = list(/datum/tech/materials = 7, /datum/tech/power_storage = 6, /datum/tech/programming = 5)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 1000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/phazon/main

/datum/design/phazon_peri
	name = "Circuit Design (\"Phazon\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Phazon\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 5, /datum/tech/bluespace = 6)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 1000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/phazon/peripherals

/datum/design/phazon_targ
	name = "Circuit Design (\"Phazon\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Phazon\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/magnets = 6, /datum/tech/combat = 2, /datum/tech/programming = 5)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 1000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/phazon/targeting

// Honk
/datum/design/honk_main
	name = "Circuit Design (\"H.O.N.K\" Central Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Central Control module."
	req_tech = list(/datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/honk/main

/datum/design/honk_peri
	name = "Circuit Design (\"H.O.N.K\" Peripherals Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/honk/peripherals

/datum/design/honk_targ
	name = "Circuit Design (\"H.O.N.K\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/programming = 3)
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = 2000, "sacid" = 20)
	build_path = /obj/item/circuitboard/mecha/honk/targeting