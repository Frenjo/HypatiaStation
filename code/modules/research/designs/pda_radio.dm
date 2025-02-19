///////////////////////////////
////////// PDA Stuff //////////
///////////////////////////////
/datum/design/pda
	name = "Microcomputer Design (PDA)"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(/decl/material/plastic = 50, /decl/material/glass = 50)
	build_path = /obj/item/pda

/datum/design/pda_cartridge
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(/decl/material/plastic = 50, /decl/material/glass = 50)
	name_prefix = "Microcomputer Design"

/datum/design/pda_cartridge/basic
	name = "Generic Cartridge"
	build_path = /obj/item/cartridge

/datum/design/pda_cartridge/engineering
	name = "Power-ON Cartridge"
	build_path = /obj/item/cartridge/engineering

/datum/design/pda_cartridge/atmos
	name = "BreatheDeep Cartridge"
	build_path = /obj/item/cartridge/atmos

/datum/design/pda_cartridge/medical
	name = "Med-U Cartridge"
	build_path = /obj/item/cartridge/medical

/datum/design/pda_cartridge/chemistry
	name = "ChemWhiz Cartridge"
	build_path = /obj/item/cartridge/chemistry

/datum/design/pda_cartridge/security
	name = "R.O.B.U.S.T. Cartridge"
	build_path = /obj/item/cartridge/security
	locked = 1

/datum/design/pda_cartridge/janitor
	name = "CustodiPRO Cartridge"
	build_path = /obj/item/cartridge/janitor

/datum/design/pda_cartridge/clown
	name = "Honkworks 5.0 Cartridge"
	build_path = /obj/item/cartridge/clown

/datum/design/pda_cartridge/mime
	name = "Gestur-O 1000 Cartridge"
	build_path = /obj/item/cartridge/mime

/datum/design/pda_cartridge/toxins
	name = "Signal Ace 2 Cartridge"
	build_path = /obj/item/cartridge/signal/toxins

/datum/design/pda_cartridge/quartermaster
	name = "Space Parts & Space Vendors Cartridge"
	build_path = /obj/item/cartridge/quartermaster
	locked = 1

/datum/design/pda_cartridge/hop
	name = "Human Resources 9001 Cartridge"
	build_path = /obj/item/cartridge/hop
	locked = 1

/datum/design/pda_cartridge/hos
	name = "R.O.B.U.S.T. DELUXE Cartridge"
	build_path = /obj/item/cartridge/hos
	locked = 1

/datum/design/pda_cartridge/ce
	name = "Power-On DELUXE Cartridge"
	build_path = /obj/item/cartridge/ce
	locked = 1

/datum/design/pda_cartridge/cmo
	name = "Med-U DELUXE Cartridge"
	build_path = /obj/item/cartridge/cmo
	locked = 1

/datum/design/pda_cartridge/rd
	name = "Signal Ace DELUXE Cartridge"
	build_path = /obj/item/cartridge/rd
	locked = 1

/datum/design/pda_cartridge/captain
	name = "Value-PAK Cartridge"
	build_path = /obj/item/cartridge/captain
	locked = 1