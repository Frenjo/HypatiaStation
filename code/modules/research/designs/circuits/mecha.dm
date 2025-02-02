////////////////////////////////////
////////// Mecha Circuits //////////
////////////////////////////////////
// Ripley
/datum/design/circuit/mecha/ripley_main
	name = "Circuit Design (APLU \"Ripley\" Central Control module)"
	desc = "Allows for the construction of a \"Ripley\" Central Control module."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/ripley/main

/datum/design/circuit/mecha/ripley_peri
	name = "Circuit Design (APLU \"Ripley\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Ripley\" Peripheral Control module."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals

// Dreadnought
/datum/design/circuit/mecha/dreadnought_main
	name = "Circuit Design (\"Dreadnought\" Central Control module)"
	desc = "Allows for the construction of a \"Dreadnought\" Central Control module."
	req_tech = list(/decl/tech/engineering = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/dreadnought/main

/datum/design/circuit/mecha/dreadnought_peri
	name = "Circuit Design (\"Dreadnought\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Dreadnought\" Peripheral Control module."
	req_tech = list(/decl/tech/engineering = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/dreadnought/peripherals

// Bulwark
/datum/design/circuit/mecha/bulwark_targ
	name = "Circuit Design (\"Bulwark\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Bulwark\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/combat = 2, /decl/tech/engineering = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/bulwark/targeting

// Odysseus
/datum/design/circuit/mecha/odysseus_main
	name = "Circuit Design (\"Odysseus\" Central Control module)"
	desc = "Allows for the construction of a \"Odysseus\" Central Control module."
	req_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/odysseus/main

/datum/design/circuit/mecha/odysseus_peri
	name = "Circuit Design (\"Odysseus\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Odysseus\" Peripheral Control module."
	req_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals

// Gygax
/datum/design/circuit/mecha/gygax_main
	name = "Circuit Design (\"Gygax\" Central Control module)"
	desc = "Allows for the construction of a \"Gygax\" Central Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/main

/datum/design/circuit/mecha/gygax_peri
	name = "Circuit Design (\"Gygax\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Gygax\" Peripheral Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals

/datum/design/circuit/mecha/gygax_targ
	name = "Circuit Design (\"Gygax\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Gygax\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/combat = 2, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting

// Serenity
/datum/design/circuit/mecha/serenity_medical
	name = "Circuit Design (\"Serenity\" Medical Control module)"
	desc = "Allows for the construction of a \"Serenity\" Medical Control module."
	req_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/serenity/medical

// Durand
/datum/design/circuit/mecha/durand_main
	name = "Circuit Design (\"Durand\" Central Control module)"
	desc = "Allows for the construction of a \"Durand\" Central Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/durand/main

/datum/design/circuit/mecha/durand_peri
	name = "Circuit Design (\"Durand\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Durand\" Peripheral Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/durand/peripherals

/datum/design/circuit/mecha/durand_targ
	name = "Circuit Design (\"Durand\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Durand\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/combat = 4, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/durand/targeting

// Archambeau
/datum/design/circuit/mecha/archambeau_main
	name = "Circuit Design (\"Archambeau\" Central Control module)"
	desc = "Allows for the construction of an \"Archambeau\" Central Control module."
	req_tech = list(/decl/tech/materials = 7, /decl/tech/power_storage = 6, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/archambeau/main

/datum/design/circuit/mecha/archambeau_peri
	name = "Circuit Design (\"Archambeau\" Peripherals Control module)"
	desc = "Allows for the construction of an \"Archambeau\" Peripheral Control module."
	req_tech = list(/decl/tech/engineering = 6, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/archambeau/peripherals

/datum/design/circuit/mecha/archambeau_targ
	name = "Circuit Design (\"Archambeau\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Archambeau\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/combat = 4, /decl/tech/engineering = 6, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/archambeau/targeting

// Phazon
/datum/design/circuit/mecha/phazon_main
	name = "Circuit Design (\"Phazon\" Central Control module)"
	desc = "Allows for the construction of a \"Phazon\" Central Control module."
	req_tech = list(/decl/tech/materials = 7, /decl/tech/power_storage = 6, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/phazon/main

/datum/design/circuit/mecha/phazon_peri
	name = "Circuit Design (\"Phazon\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Phazon\" Peripheral Control module."
	req_tech = list(/decl/tech/programming = 5, /decl/tech/bluespace = 6)
	build_path = /obj/item/circuitboard/mecha/phazon/peripherals

/datum/design/circuit/mecha/phazon_targ
	name = "Circuit Design (\"Phazon\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Phazon\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/magnets = 6, /decl/tech/combat = 2, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/phazon/targeting

// H.O.N.K
/datum/design/circuit/mecha/honk_main
	name = "Circuit Design (\"H.O.N.K\" Central Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Central Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/honk/main

/datum/design/circuit/mecha/honk_peri
	name = "Circuit Design (\"H.O.N.K\" Peripherals Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Peripheral Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/honk/peripherals

/datum/design/circuit/mecha/honk_targ
	name = "Circuit Design (\"H.O.N.K\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"H.O.N.K\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/honk/targeting

// Reticence
/datum/design/circuit/mecha/reticence_main
	name = "Circuit Design (\"Reticence\" Central Control module)"
	desc = "Allows for the construction of a \"Reticence\" Central Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/reticence/main

/datum/design/circuit/mecha/reticence_peri
	name = "Circuit Design (\"Reticence\" Peripherals Control module)"
	desc = "Allows for the construction of a \"Reticence\" Peripheral Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/reticence/peripherals

/datum/design/circuit/mecha/reticence_targ
	name = "Circuit Design (\"Reticence\" Weapons & Targeting Control module)"
	desc = "Allows for the construction of a \"Reticence\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/reticence/targeting