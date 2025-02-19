/datum/design/illegal
	build_type = DESIGN_TYPE_PROTOLATHE
	name_prefix = "Illegal Design"

/datum/design/illegal/binaryencrypt
	name = "Binary Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	req_tech = list(/decl/tech/syndicate = 2)
	materials = list(/decl/material/plastic = 300, /decl/material/glass = 300)
	build_path = /obj/item/encryptionkey/binary

/datum/design/illegal/chameleon
	name = "Chameleon Jumpsuit"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	req_tech = list(/decl/tech/syndicate = 3)
	materials = list(/decl/material/plastic = 500)
	build_path = /obj/item/clothing/under/chameleon