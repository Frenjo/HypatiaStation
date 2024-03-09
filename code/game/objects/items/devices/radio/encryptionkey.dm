/obj/item/encryptionkey
	name = "standard radio encryption key"
	desc = "An encyption key for a radio headset. Has no special codes in it. WHY DOES IT EXIST? ASK NANOTRASEN."
	icon = 'icons/obj/items/devices/radio.dmi'
	icon_state = "cypherkey"
	item_state = ""

	var/translate_binary = 0
	var/translate_hive = 0
	var/syndie = 0
	var/list/channels = list()

/obj/item/encryptionkey/attackby(obj/item/W as obj, mob/user as mob)

// Syndicate
/obj/item/encryptionkey/syndicate
	icon_state = "cypherkey"
	channels = list(CHANNEL_SYNDICATE = 1)
	origin_tech = list(RESEARCH_TECH_SYNDICATE = 3)
	syndie = 1 //Signifies that it de-crypts Syndicate transmissions

// Binary
/obj/item/encryptionkey/binary
	icon_state = "cypherkey"
	translate_binary = 1
	origin_tech = list(RESEARCH_TECH_SYNDICATE = 3)

// Security
/obj/item/encryptionkey/sec
	name = "security radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "sec_cypherkey"
	channels = list(CHANNEL_SECURITY = 1)

// Security Paramedic (MedSec)
/obj/item/encryptionkey/sec_para
	name = "security paramedic radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "sec_cypherkey"
	channels = list(CHANNEL_MEDICAL = 1, CHANNEL_SECURITY = 1)

// Engineering
/obj/item/encryptionkey/engi
	name = "engineering radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "eng_cypherkey"
	channels = list(CHANNEL_ENGINEERING = 1)

// Roboticist (EngSci)
/obj/item/encryptionkey/robo
	name = "robotics radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "rob_cypherkey"
	channels = list(CHANNEL_SCIENCE = 1, CHANNEL_ENGINEERING = 1)

// Medical
/obj/item/encryptionkey/med
	name = "medical radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "med_cypherkey"
	channels = list(CHANNEL_MEDICAL = 1)

// MedSci
/obj/item/encryptionkey/medsci
	name = "medical research radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "medsci_cypherkey"
	channels = list(CHANNEL_SCIENCE = 1, CHANNEL_MEDICAL = 1)

// Science
/obj/item/encryptionkey/sci
	name = "science radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "sci_cypherkey"
	channels = list(CHANNEL_SCIENCE = 1)

// Xenoarch (MinSci)
/obj/item/encryptionkey/xenoarch
	name = "xenoarchaeology radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "sci_cypherkey"
	channels = list(CHANNEL_SCIENCE = 1, CHANNEL_MINING = 1)

// Command
/obj/item/encryptionkey/com
	name = "command radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "com_cypherkey"
	channels = list(CHANNEL_COMMAND = 1)

/obj/item/encryptionkey/heads/captain
	name = "captain radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "cap_cypherkey"
	channels = list(
		CHANNEL_COMMAND = 1, CHANNEL_SECURITY = 1, CHANNEL_SUPPLY = 0,
		CHANNEL_SERVICE = 0, CHANNEL_SCIENCE = 0, CHANNEL_MEDICAL = 0,
		CHANNEL_ENGINEERING = 0, CHANNEL_MINING = 0
	)

/obj/item/encryptionkey/heads/rd
	name = "research director radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "rd_cypherkey"
	channels = list(CHANNEL_SCIENCE = 1, CHANNEL_COMMAND = 1)

/obj/item/encryptionkey/heads/hos
	name = "head of security radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "hos_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_SECURITY = 1)

/obj/item/encryptionkey/heads/ce
	name = "chief engineer radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "ce_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_ENGINEERING = 1)

/obj/item/encryptionkey/heads/cmo
	name = "chief medical officer radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "cmo_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_MEDICAL = 1)

/obj/item/encryptionkey/heads/hop
	name = "head of personnel radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "hop_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_SERVICE = 1, CHANNEL_SUPPLY = 0, CHANNEL_MINING = 0)

// Mining
/obj/item/encryptionkey/mining_foreman
	name = "mining foreman radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "mine_cypherkey"
	channels = list(CHANNEL_SUPPLY = 1, CHANNEL_MINING = 1)

/obj/item/encryptionkey/mining
	name = "mining radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "mine_cypherkey"
	channels = list(CHANNEL_MINING = 1)

// Cargo
/obj/item/encryptionkey/qm
	name = "quartermaster radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "qm_cypherkey"
	channels = list(CHANNEL_SUPPLY = 1, CHANNEL_MINING = 1)

/obj/item/encryptionkey/cargo
	name = "supply radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "cargo_cypherkey"
	channels = list(CHANNEL_SUPPLY = 1)

// Service
/obj/item/encryptionkey/service
	name = "service radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "cypherkey"
	channels = list(CHANNEL_SERVICE = 1)

// Response Team
/obj/item/encryptionkey/ert
	name = "\improper NanoTrasen ERT radio encryption key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	channels = list(
		CHANNEL_RESPONSETEAM = 1, CHANNEL_SUPPLY = 1, CHANNEL_SERVICE = 1,
		CHANNEL_SCIENCE = 1, CHANNEL_COMMAND = 1, CHANNEL_MEDICAL = 1,
		CHANNEL_ENGINEERING = 1, CHANNEL_SECURITY = 1, CHANNEL_MINING = 1
	)