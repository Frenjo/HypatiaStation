////////////////////////////////////
////////// Mecha Circuits //////////
////////////////////////////////////
/datum/design/mecha_circuit
	build_type = DESIGN_TYPE_IMPRINTER
	materials = list(/decl/material/glass = MATERIAL_AMOUNT_PER_SHEET, "sacid" = 20)

// Ripley
/datum/design/mecha_circuit/ripley_main
	name = "Circuit Design (APLU \"Ripley\" Central Control module)"
	desc = "Allows for the construction of a \"Ripley\" Central Control module."
	req_tech = list(/datum/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/ripley/main

/datum/design/mecha_circuit/ripley_peri
	name = "Circuit Design (APLU \"Ripley\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Ripley\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals

// Dreadnought
/datum/design/mecha_circuit/dreadnought_main
	name = "Circuit Design (\"Dreadnought\" Central Control module)"
	desc = "Allows for the construction of a \"Dreadnought\" Central Control module."
	req_tech = list(/datum/tech/engineering = 3, /datum/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/dreadnought/main

/datum/design/mecha_circuit/dreadnought_peri
	name = "Circuit Design (\"Dreadnought\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Dreadnought\" Peripheral Control module."
	req_tech = list(/datum/tech/engineering = 3, /datum/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/dreadnought/peripherals

// Bulwark
/datum/design/mecha_circuit/bulwark_targ
	name = "Circuit Design (\"Bulwark\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Bulwark\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/combat = 2, /datum/tech/engineering = 3, /datum/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/bulwark/targeting

// Odysseus
/datum/design/mecha_circuit/odysseus_main
	name = "Circuit Design (\"Odysseus\" Central Control module)"
	desc = "Allows for the construction of a \"Odysseus\" Central Control module."
	req_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/odysseus/main

/datum/design/mecha_circuit/odysseus_peri
	name = "Circuit Design (\"Odysseus\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Odysseus\" Peripheral Control module."
	req_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals

// Gygax
/datum/design/mecha_circuit/gygax_main
	name = "Circuit Design (\"Gygax\" Central Control module)"
	desc = "Allows for the construction of a \"Gygax\" Central Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/main

/datum/design/mecha_circuit/gygax_peri
	name = "Circuit Design (\"Gygax\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Gygax\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals

/datum/design/mecha_circuit/gygax_targ
	name = "Circuit Design (\"Gygax\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Gygax\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/combat = 2, /datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting

// Serenity
/datum/design/mecha_circuit/serenity_medical
	name = "Circuit Design (\"Serenity\" Medical Control module)"
	desc = "Allows for the construction of a \"Serenity\" Medical Control module."
	req_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/serenity/medical

// Durand
/datum/design/mecha_circuit/durand_main
	name = "Circuit Design (\"Durand\" Central Control module)"
	desc = "Allows for the construction of a \"Durand\" Central Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/durand/main

/datum/design/mecha_circuit/durand_peri
	name = "Circuit Design (\"Durand\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Durand\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/durand/peripherals

/datum/design/mecha_circuit/durand_targ
	name = "Circuit Design (\"Durand\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Durand\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/combat = 4, /datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/durand/targeting

// Archambeau
/datum/design/mecha_circuit/archambeau_main
	name = "Circuit Design (\"Archambeau\" Central Control module)"
	desc = "Allows for the construction of an \"Archambeau\" Central Control module."
	req_tech = list(/datum/tech/materials = 7, /datum/tech/power_storage = 6, /datum/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/archambeau/main

/datum/design/mecha_circuit/archambeau_peri
	name = "Circuit Design (\"Archambeau\" Peripherals Control module)"
	desc = "Allows for the construction of an \"Archambeau\" Peripheral Control module."
	req_tech = list(/datum/tech/engineering = 6, /datum/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/archambeau/peripherals

/datum/design/mecha_circuit/archambeau_targ
	name = "Circuit Design (\"Archambeau\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Archambeau\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/combat = 4, /datum/tech/engineering = 6, /datum/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/archambeau/targeting

// Phazon
/datum/design/mecha_circuit/phazon_main
	name = "Circuit Design (\"Phazon\" Central Control module)"
	desc = "Allows for the construction of a \"Phazon\" Central Control module."
	req_tech = list(/datum/tech/materials = 7, /datum/tech/power_storage = 6, /datum/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/phazon/main

/datum/design/mecha_circuit/phazon_peri
	name = "Circuit Design (\"Phazon\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Phazon\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 5, /datum/tech/bluespace = 6)
	build_path = /obj/item/circuitboard/mecha/phazon/peripherals

/datum/design/mecha_circuit/phazon_targ
	name = "Circuit Design (\"Phazon\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Phazon\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/magnets = 6, /datum/tech/combat = 2, /datum/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/phazon/targeting

// H.O.N.K
/datum/design/mecha_circuit/honk_main
	name = "Circuit Design (\"H.O.N.K\" Central Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Central Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/honk/main

/datum/design/mecha_circuit/honk_peri
	name = "Circuit Design (\"H.O.N.K\" Peripherals Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/honk/peripherals

/datum/design/mecha_circuit/honk_targ
	name = "Circuit Design (\"H.O.N.K\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/honk/targeting

// Reticence
/datum/design/mecha_circuit/reticence_main
	name = "Circuit Design (\"Reticence\" Central Control module)"
	desc = "Allows for the construction of a \"Reticence\" Central Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/reticence/main

/datum/design/mecha_circuit/reticence_peri
	name = "Circuit Design (\"Reticence\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Reticence\" Peripheral Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/reticence/peripherals

/datum/design/mecha_circuit/reticence_targ
	name = "Circuit Design (\"Reticence\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Reticence\" Weapons & Targeting Control module."
	req_tech = list(/datum/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/reticence/targeting