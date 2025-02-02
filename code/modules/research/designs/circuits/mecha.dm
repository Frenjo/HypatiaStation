////////////////////////////////////
////////// Mecha Circuits //////////
////////////////////////////////////
/datum/design/circuit/mecha
	name_prefix = "Exosuit Circuit Design"

// Ripley
/datum/design/circuit/mecha/ripley_main
	name = "APLU \"Ripley\" Central Control module"
	desc = "Allows for the construction of a \"Ripley\" Central Control module."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/ripley/main

/datum/design/circuit/mecha/ripley_peri
	name = "APLU \"Ripley\" Peripherals Control module"
	desc = "Allows for the construction of a \"Ripley\" Peripheral Control module."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals

// Dreadnought
/datum/design/circuit/mecha/dreadnought_main
	name = "\"Dreadnought\" Central Control module"
	desc = "Allows for the construction of a \"Dreadnought\" Central Control module."
	req_tech = list(/decl/tech/engineering = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/dreadnought/main

/datum/design/circuit/mecha/dreadnought_peri
	name = "\"Dreadnought\" Peripherals Control module"
	desc = "Allows for the construction of a \"Dreadnought\" Peripheral Control module."
	req_tech = list(/decl/tech/engineering = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/dreadnought/peripherals

// Bulwark
/datum/design/circuit/mecha/bulwark_targ
	name = "\"Bulwark\" Weapons & Targeting Control module"
	desc = "Allows for the construction of a \"Bulwark\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/combat = 2, /decl/tech/engineering = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/bulwark/targeting

// Odysseus
/datum/design/circuit/mecha/odysseus_main
	name = "\"Odysseus\" Central Control module"
	desc = "Allows for the construction of a \"Odysseus\" Central Control module."
	req_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/odysseus/main

/datum/design/circuit/mecha/odysseus_peri
	name = "\"Odysseus\" Peripherals Control module"
	desc = "Allows for the construction of a \"Odysseus\" Peripheral Control module."
	req_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals

// Gygax
/datum/design/circuit/mecha/gygax_main
	name = "\"Gygax\" Central Control module"
	desc = "Allows for the construction of a \"Gygax\" Central Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/main

/datum/design/circuit/mecha/gygax_peri
	name = "\"Gygax\" Peripherals Control module"
	desc = "Allows for the construction of a \"Gygax\" Peripheral Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals

/datum/design/circuit/mecha/gygax_targ
	name = "\"Gygax\" Weapons & Targeting Control module"
	desc = "Allows for the construction of a \"Gygax\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/combat = 2, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting

// Serenity
/datum/design/circuit/mecha/serenity_medical
	name = "\"Serenity\" Medical Control module"
	desc = "Allows for the construction of a \"Serenity\" Medical Control module."
	req_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/serenity/medical

// Durand
/datum/design/circuit/mecha/durand_main
	name = "\"Durand\" Central Control module"
	desc = "Allows for the construction of a \"Durand\" Central Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/durand/main

/datum/design/circuit/mecha/durand_peri
	name = "\"Durand\" Peripherals Control module"
	desc = "Allows for the construction of a \"Durand\" Peripheral Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/durand/peripherals

/datum/design/circuit/mecha/durand_targ
	name = "\"Durand\" Weapons & Targeting Control module"
	desc = "Allows for the construction of a \"Durand\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/combat = 4, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/durand/targeting

// Archambeau
/datum/design/circuit/mecha/archambeau_main
	name = "\"Archambeau\" Central Control module"
	desc = "Allows for the construction of an \"Archambeau\" Central Control module."
	req_tech = list(/decl/tech/materials = 7, /decl/tech/power_storage = 6, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/archambeau/main

/datum/design/circuit/mecha/archambeau_peri
	name = "\"Archambeau\" Peripherals Control module"
	desc = "Allows for the construction of an \"Archambeau\" Peripheral Control module."
	req_tech = list(/decl/tech/engineering = 6, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/archambeau/peripherals

/datum/design/circuit/mecha/archambeau_targ
	name = "\"Archambeau\" Weapons & Targeting Control module"
	desc = "Allows for the construction of a \"Archambeau\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/combat = 4, /decl/tech/engineering = 6, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/archambeau/targeting

// Phazon
/datum/design/circuit/mecha/phazon_main
	name = "\"Phazon\" Central Control module"
	desc = "Allows for the construction of a \"Phazon\" Central Control module."
	req_tech = list(/decl/tech/materials = 7, /decl/tech/power_storage = 6, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/phazon/main

/datum/design/circuit/mecha/phazon_peri
	name = "\"Phazon\" Peripherals Control module"
	desc = "Allows for the construction of a \"Phazon\" Peripheral Control module."
	req_tech = list(/decl/tech/programming = 5, /decl/tech/bluespace = 6)
	build_path = /obj/item/circuitboard/mecha/phazon/peripherals

/datum/design/circuit/mecha/phazon_targ
	name = "\"Phazon\" Weapons & Targeting Control module"
	desc = "Allows for the construction of a \"Phazon\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/magnets = 6, /decl/tech/combat = 2, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/phazon/targeting

// H.O.N.K
/datum/design/circuit/mecha/honk_main
	name = "\"H.O.N.K\" Central Control module"
	desc = "Allows for the construction of a \"H.O.N.K\" Central Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/honk/main

/datum/design/circuit/mecha/honk_peri
	name = "\"H.O.N.K\" Peripherals Control module"
	desc = "Allows for the construction of a \"H.O.N.K\" Peripheral Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/honk/peripherals

/datum/design/circuit/mecha/honk_targ
	name = "\"H.O.N.K\" Weapons & Targeting Control module"
	desc = "Allows for the construction of a \"H.O.N.K\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/honk/targeting

// Reticence
/datum/design/circuit/mecha/reticence_main
	name = "\"Reticence\" Central Control module"
	desc = "Allows for the construction of a \"Reticence\" Central Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/reticence/main

/datum/design/circuit/mecha/reticence_peri
	name = "\"Reticence\" Peripherals Control module"
	desc = "Allows for the construction of a \"Reticence\" Peripheral Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/reticence/peripherals

/datum/design/circuit/mecha/reticence_targ
	name = "\"Reticence\" Weapons & Targeting Control module"
	desc = "Allows for the construction of a \"Reticence\" Weapons & Targeting Control module."
	req_tech = list(/decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/reticence/targeting