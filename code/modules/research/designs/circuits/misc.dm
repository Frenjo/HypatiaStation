////////////////////////////////////////////
////////// Miscellaneous Circuits //////////
////////////////////////////////////////////
/datum/design/circuit/destructive_analyser
	name = "Destructive Analyser Board"
	desc = "The circuit board for a destructive analyser."
	req_tech = list(/decl/tech/magnets = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/destructive_analyser

/datum/design/circuit/protolathe
	name = "Protolathe Board"
	desc = "The circuit board for a protolathe."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/protolathe

/datum/design/circuit/circuit_imprinter
	name = "Circuit Imprinter Board"
	desc = "The circuit board for a circuit imprinter."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/circuit_imprinter

/datum/design/circuit/autolathe
	name = "Autolathe Board"
	desc = "The circuit board for a autolathe."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/programming = 2)
	build_path = /obj/item/circuitboard/autolathe

/datum/design/circuit/rdservercontrol
	name = "R&D Server Control Console Board"
	desc = "The circuit board for a R&D Server Control Console"
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/rdservercontrol

/datum/design/circuit/rdserver
	name = "R&D Server Board"
	desc = "The circuit board for an R&D Server"
	req_tech = list(/decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/rdserver

/datum/design/circuit/mechfab
	name = "Exosuit Fabricator Board"
	desc = "The circuit board for an Exosuit Fabricator"
	req_tech = list(/decl/tech/engineering = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/mechfab

/datum/design/circuit/robofab
	name = "Robotic Fabricator Board"
	desc = "The circuit board for a Robotic Fabricator"
	req_tech = list(/decl/tech/engineering = 3, /decl/tech/programming = 3)
	build_path = /obj/item/circuitboard/robofab

////////////////////////////////////////
////////// Generator Circuits //////////
////////////////////////////////////////
/datum/design/circuit/pacman
	name = "PACMAN-type Generator Board"
	desc = "The circuit board for a PACMAN-type portable generator."
	req_tech = list(/decl/tech/engineering = 3, /decl/tech/power_storage = 3, /decl/tech/programming = 3, /decl/tech/plasma = 3)
	reliability_base = 79
	build_path = /obj/item/circuitboard/pacman

/datum/design/circuit/superpacman
	name = "SUPERPACMAN-type Generator Board"
	desc = "The circuit board for a SUPERPACMAN-type portable generator."
	req_tech = list(/decl/tech/engineering = 4, /decl/tech/power_storage = 4, /decl/tech/programming = 3)
	reliability_base = 76
	build_path = /obj/item/circuitboard/pacman/super

/datum/design/circuit/mrspacman
	name = "MRSPACMAN-type Generator Board"
	desc = "The circuit board for a MRSPACMAN-type portable generator."
	req_tech = list(/decl/tech/engineering = 5, /decl/tech/power_storage = 5, /decl/tech/programming = 3)
	reliability_base = 74
	build_path = /obj/item/circuitboard/pacman/mrs

////////////////////////////////////////////
////////// Power Storage Circuits //////////
////////////////////////////////////////////
/datum/design/circuit/cell_rack
	name = "CRES Board"
	desc = "The circuit board for a Cell Rack Energy Storage unit."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_path = /obj/item/circuitboard/cell_rack