///////////////////////////////////////
////////// PDA & Radio Stuff //////////
///////////////////////////////////////
/datum/design/binaryencrypt
	name = "Binary Encrpytion Key"
	desc = "An encyption key for a radio headset.  Contains cypherkeys."
	req_tech = list(/decl/tech/syndicate = 2)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 300, /decl/material/glass = 300)
	build_path = /obj/item/encryptionkey/binary

/datum/design/pda
	name = "PDA"
	desc = "A portable microcomputer by Thinktronic Systems, LTD. Functionality determined by a preprogrammed ROM cartridge."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/pda

/datum/design/cart_basic
	name = "Generic Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge

/datum/design/cart_engineering
	name = "Power-ON Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/engineering

/datum/design/cart_atmos
	name = "BreatheDeep Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/atmos

/datum/design/cart_medical
	name = "Med-U Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/medical

/datum/design/cart_chemistry
	name = "ChemWhiz Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/chemistry

/datum/design/cart_security
	name = "R.O.B.U.S.T. Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/security
	locked = 1

/datum/design/cart_janitor
	name = "CustodiPRO Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/janitor

/datum/design/cart_clown
	name = "Honkworks 5.0 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/clown

/datum/design/cart_mime
	name = "Gestur-O 1000 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/mime

/datum/design/cart_toxins
	name = "Signal Ace 2 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/signal/toxins

/datum/design/cart_quartermaster
	name = "Space Parts & Space Vendors Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/quartermaster
	locked = 1

/datum/design/cart_hop
	name = "Human Resources 9001 Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/hop
	locked = 1

/datum/design/cart_hos
	name = "R.O.B.U.S.T. DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/hos
	locked = 1

/datum/design/cart_ce
	name = "Power-On DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/ce
	locked = 1

/datum/design/cart_cmo
	name = "Med-U DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/cmo
	locked = 1

/datum/design/cart_rd
	name = "Signal Ace DELUXE Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/rd
	locked = 1

/datum/design/cart_captain
	name = "Value-PAK Cartridge"
	desc = "A data cartridge for portable microcomputers."
	req_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	build_type = DESIGN_TYPE_PROTOLATHE
	materials = list(MATERIAL_METAL = 50, /decl/material/glass = 50)
	build_path = /obj/item/cartridge/captain
	locked = 1