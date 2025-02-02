////////////////////////////////////////////
////////// Miscellaneous Circuits //////////
////////////////////////////////////////////
/datum/design/circuit/destructive_analyser
	name = "Destructive Analyser"
	desc = "Allows for the construction of circuit boards used to build a destructive analyser."
	req_tech = list(/decl/tech/magnets = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/destructive_analyser

/datum/design/circuit/protolathe
	name = "Protolathe"
	desc = "Allows for the construction of circuit boards used to build a protolathe."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/protolathe

/datum/design/circuit/circuit_imprinter
	name = "Circuit Imprinter"
	desc = "Allows for the construction of circuit boards used to build a circuit imprinter."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/circuit_imprinter

/datum/design/circuit/autolathe
	name = "Autolathe"
	desc = "Allows for the construction of circuit boards used to build an autolathe."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/autolathe

/datum/design/circuit/rdservercontrol
	name = "R&D Server Control Console"
	desc = "Allows for the construction of circuit boards used to build an R&D server control console."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/rdservercontrol

/datum/design/circuit/rdserver
	name = "R&D Server"
	desc = "Allows for the construction of circuit boards used to build an R&D server."
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/rdserver

/datum/design/circuit/mechfab
	name = "Exosuit Fabricator"
	desc = "Allows for the construction of circuit boards used to build an exosuit fabricator."
	req_tech = list(/decl/tech/engineering = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mechfab

/datum/design/circuit/robofab
	name = "Robotic Fabricator"
	desc = "Allows for the construction of circuit boards used to build a robotic fabricator."
	req_tech = list(/decl/tech/engineering = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/robofab

////////////////////////////////////////
////////// Generator Circuits //////////
////////////////////////////////////////
/datum/design/circuit/pacman
	name = "PACMAN-type Generator"
	desc = "Allows for the construction of circuit boards used to build a PACMAN-type portable generator."
	req_tech = list(/decl/tech/engineering = 3, /decl/tech/power_storage = 3, /decl/tech/programming = 3, /decl/tech/plasma = 3)
	reliability_base = 79
	build_path = /obj/item/circuitboard/pacman

/datum/design/circuit/superpacman
	name = "SUPERPACMAN-type Generator"
	desc = "Allows for the construction of circuit boards used to build a SUPERPACMAN-type portable generator."
	req_tech = list(/decl/tech/engineering = 4, /decl/tech/power_storage = 4, /decl/tech/programming = 3)
	reliability_base = 76
	build_path = /obj/item/circuitboard/pacman/super

/datum/design/circuit/mrspacman
	name = "MRSPACMAN-type Generator"
	desc = "Allows for the construction of circuit boards used to build a MRSPACMAN-type portable generator."
	req_tech = list(/decl/tech/engineering = 5, /decl/tech/power_storage = 5, /decl/tech/programming = 3)
	reliability_base = 74
	build_path = /obj/item/circuitboard/pacman/mrs

////////////////////////////////////////////
////////// Power Storage Circuits //////////
////////////////////////////////////////////
/datum/design/circuit/cell_rack
	name = "CRES"
	desc = "Allows for the construction of circuit boards used to build a cell rack energy storage unit."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_path = /obj/item/circuitboard/cell_rack