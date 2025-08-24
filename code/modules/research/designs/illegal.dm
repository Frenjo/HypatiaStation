/datum/design/illegal
	build_type = DESIGN_TYPE_PROTOLATHE
	name_prefix = "Illegal Design"

/datum/design/illegal/binaryencrypt
	name = "Binary Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	req_tech = alist(/decl/tech/syndicate = 2)
	materials = alist(/decl/material/plastic = 0.3 MATERIAL_SHEETS, /decl/material/glass = 0.3 MATERIAL_SHEETS)
	build_path = /obj/item/encryptionkey/binary

/datum/design/illegal/chameleon
	name = "Chameleon Jumpsuit"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	req_tech = alist(/decl/tech/syndicate = 3)
	materials = alist(/decl/material/plastic = 0.5 MATERIAL_SHEETS)
	build_path = /obj/item/clothing/under/chameleon