////////////////////////////////////
////////// Mecha Circuits //////////
////////////////////////////////////
/datum/design/circuit/mecha
	name_prefix = "Exosuit Circuit Design"

// Ripley
/datum/design/circuit/mecha/ripley
	req_tech = alist(/decl/tech/programming = 3)

/datum/design/circuit/mecha/ripley/main
	name = "APLU \"Ripley\" Central Control module"
	desc = "Allows for the construction of a \"Ripley\" Central Control module."
	build_path = /obj/item/circuitboard/mecha/ripley/main

/datum/design/circuit/mecha/ripley/peri
	name = "APLU \"Ripley\" Peripherals Control module"
	desc = "Allows for the construction of a \"Ripley\" Peripheral Control module."
	build_path = /obj/item/circuitboard/mecha/ripley/peripherals

// Dreadnought
/datum/design/circuit/mecha/dreadnought
	req_tech = alist(/decl/tech/engineering = 3, /decl/tech/programming = 3)

/datum/design/circuit/mecha/dreadnought/main
	name = "\"Dreadnought\" Central Control module"
	desc = "Allows for the construction of a \"Dreadnought\" Central Control module."
	build_path = /obj/item/circuitboard/mecha/dreadnought/main

/datum/design/circuit/mecha/dreadnought/peri
	name = "\"Dreadnought\" Peripherals Control module"
	desc = "Allows for the construction of a \"Dreadnought\" Peripheral Control module."
	build_path = /obj/item/circuitboard/mecha/dreadnought/peripherals

// Bulwark
/datum/design/circuit/mecha/bulwark_targ
	name = "\"Bulwark\" Weapon Control & Targeting module"
	desc = "Allows for the construction of a \"Bulwark\" Weapon Control & Targeting module."
	req_tech = alist(/decl/tech/combat = 2, /decl/tech/engineering = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mecha/bulwark/targeting

// Odysseus
/datum/design/circuit/mecha/odysseus
	req_tech = alist(/decl/tech/biotech = 2, /decl/tech/programming = 3)

/datum/design/circuit/mecha/odysseus/main
	name = "\"Odysseus\" Central Control module"
	desc = "Allows for the construction of an \"Odysseus\" Central Control module."
	build_path = /obj/item/circuitboard/mecha/odysseus/main

/datum/design/circuit/mecha/odysseus/peri
	name = "\"Odysseus\" Peripherals Control module"
	desc = "Allows for the construction of an \"Odysseus\" Peripheral Control module."
	build_path = /obj/item/circuitboard/mecha/odysseus/peripherals

// Gygax
/datum/design/circuit/mecha/gygax
	req_tech = alist(/decl/tech/programming = 4)

/datum/design/circuit/mecha/gygax/main
	name = "\"Gygax\" Central Control module"
	desc = "Allows for the construction of a \"Gygax\" Central Control module."
	build_path = /obj/item/circuitboard/mecha/gygax/main

/datum/design/circuit/mecha/gygax/peri
	name = "\"Gygax\" Peripherals Control module"
	desc = "Allows for the construction of a \"Gygax\" Peripheral Control module."
	build_path = /obj/item/circuitboard/mecha/gygax/peripherals

/datum/design/circuit/mecha/gygax/targ
	name = "\"Gygax\" Weapon Control & Targeting module"
	desc = "Allows for the construction of a \"Gygax\" Weapon Control & Targeting module."
	req_tech = alist(/decl/tech/combat = 2, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/gygax/targeting

// Serenity
/datum/design/circuit/mecha/serenity_medical
	name = "\"Serenity\" Medical Control module"
	desc = "Allows for the construction of a \"Serenity\" Medical Control module."
	req_tech = alist(/decl/tech/biotech = 2, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/serenity/medical

// Durand
/datum/design/circuit/mecha/durand
	req_tech = alist(/decl/tech/programming = 4)

/datum/design/circuit/mecha/durand/main
	name = "\"Durand\" Central Control module"
	desc = "Allows for the construction of a \"Durand\" Central Control module."
	build_path = /obj/item/circuitboard/mecha/durand/main

/datum/design/circuit/mecha/durand/peri
	name = "\"Durand\" Peripherals Control module"
	desc = "Allows for the construction of a \"Durand\" Peripheral Control module."
	build_path = /obj/item/circuitboard/mecha/durand/peripherals

/datum/design/circuit/mecha/durand/targ
	name = "\"Durand\" Weapon Control & Targeting module"
	desc = "Allows for the construction of a \"Durand\" Weapon Control & Targeting module."
	req_tech = alist(/decl/tech/combat = 4, /decl/tech/programming = 4)
	build_path = /obj/item/circuitboard/mecha/durand/targeting

// Archambeau
/datum/design/circuit/mecha/archambeau_main
	name = "\"Archambeau\" Central Control module"
	desc = "Allows for the construction of an \"Archambeau\" Central Control module."
	req_tech = alist(/decl/tech/materials = 7, /decl/tech/power_storage = 6, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/archambeau/main

/datum/design/circuit/mecha/archambeau_peri
	name = "\"Archambeau\" Peripherals Control module"
	desc = "Allows for the construction of an \"Archambeau\" Peripheral Control module."
	req_tech = alist(/decl/tech/engineering = 6, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/archambeau/peripherals

/datum/design/circuit/mecha/archambeau_targ
	name = "\"Archambeau\" Weapon Control & Targeting module"
	desc = "Allows for the construction of an \"Archambeau\" Weapon Control & Targeting module."
	req_tech = alist(/decl/tech/combat = 4, /decl/tech/engineering = 6, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/archambeau/targeting

// Phazon
/datum/design/circuit/mecha/phazon_main
	name = "\"Phazon\" Central Control module"
	desc = "Allows for the construction of a \"Phazon\" Central Control module."
	req_tech = alist(/decl/tech/materials = 7, /decl/tech/power_storage = 6, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/phazon/main

/datum/design/circuit/mecha/phazon_peri
	name = "\"Phazon\" Peripherals Control module"
	desc = "Allows for the construction of a \"Phazon\" Peripheral Control module."
	req_tech = alist(/decl/tech/programming = 5, /decl/tech/bluespace = 6)
	build_path = /obj/item/circuitboard/mecha/phazon/peripherals

/datum/design/circuit/mecha/phazon_targ
	name = "\"Phazon\" Weapon Control & Targeting module"
	desc = "Allows for the construction of a \"Phazon\" Weapon Control & Targeting module."
	req_tech = alist(/decl/tech/magnets = 6, /decl/tech/combat = 2, /decl/tech/programming = 5)
	build_path = /obj/item/circuitboard/mecha/phazon/targeting

// H.O.N.K
/datum/design/circuit/mecha/honk
	req_tech = alist(/decl/tech/programming = 4)

/datum/design/circuit/mecha/honk/main
	name = "\"H.O.N.K\" Central Control module"
	desc = "Allows for the construction of a \"H.O.N.K\" Central Control module."
	build_path = /obj/item/circuitboard/mecha/honk/main

/datum/design/circuit/mecha/honk/peri
	name = "\"H.O.N.K\" Peripherals Control module"
	desc = "Allows for the construction of a \"H.O.N.K\" Peripheral Control module."
	build_path = /obj/item/circuitboard/mecha/honk/peripherals

/datum/design/circuit/mecha/honk/targ
	name = "\"H.O.N.K\" Weapon Control & Targeting module"
	desc = "Allows for the construction of a \"H.O.N.K\" Weapon Control & Targeting module."
	build_path = /obj/item/circuitboard/mecha/honk/targeting

// Reticence
/datum/design/circuit/mecha/reticence
	req_tech = alist(/decl/tech/programming = 4)

/datum/design/circuit/mecha/reticence/main
	name = "\"Reticence\" Central Control module"
	desc = "Allows for the construction of a \"Reticence\" Central Control module."
	build_path = /obj/item/circuitboard/mecha/reticence/main

/datum/design/circuit/mecha/reticence/peri
	name = "\"Reticence\" Peripherals Control module"
	desc = "Allows for the construction of a \"Reticence\" Peripheral Control module."
	build_path = /obj/item/circuitboard/mecha/reticence/peripherals

/datum/design/circuit/mecha/reticence/targ
	name = "\"Reticence\" Weapon Control & Targeting module"
	desc = "Allows for the construction of a \"Reticence\" Weapon Control & Targeting module."
	build_path = /obj/item/circuitboard/mecha/reticence/targeting