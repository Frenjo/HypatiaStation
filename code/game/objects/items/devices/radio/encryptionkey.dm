/obj/item/encryptionkey
	name = "Standard Encryption Key"
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
	name = "Security Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "sec_cypherkey"
	channels = list(CHANNEL_SECURITY = 1)

// Security Paramedic (MedSec)
/obj/item/encryptionkey/sec_para
	name = "Security Paramedic Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "sec_cypherkey"
	channels = list(CHANNEL_MEDICAL = 1, CHANNEL_SECURITY = 1)

// Engineering
/obj/item/encryptionkey/engi
	name = "Engineering Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "eng_cypherkey"
	channels = list(CHANNEL_ENGINEERING = 1)

// Roboticist (EngSci)
/obj/item/encryptionkey/robo
	name = "Robotics Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "rob_cypherkey"
	channels = list(CHANNEL_SCIENCE = 1, CHANNEL_ENGINEERING = 1)

// Medical
/obj/item/encryptionkey/med
	name = "Medical Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "med_cypherkey"
	channels = list(CHANNEL_MEDICAL = 1)

// MedSci
/obj/item/encryptionkey/medsci
	name = "Medical Research Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "medsci_cypherkey"
	channels = list(CHANNEL_SCIENCE = 1, CHANNEL_MEDICAL = 1)

// Science
/obj/item/encryptionkey/sci
	name = "Science Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "sci_cypherkey"
	channels = list(CHANNEL_SCIENCE = 1)

// Xenoarch (MinSci)
/obj/item/encryptionkey/xenoarch
	name = "Xenoarchaeology Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "sci_cypherkey"
	channels = list(CHANNEL_SCIENCE = 1, CHANNEL_MINING = 1)

// Command
/obj/item/encryptionkey/com
	name = "Command Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "com_cypherkey"
	channels = list(CHANNEL_COMMAND = 1)

/obj/item/encryptionkey/heads/captain
	name = "Captain's Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "cap_cypherkey"
	channels = list(
		CHANNEL_COMMAND = 1, CHANNEL_SECURITY = 1, CHANNEL_SUPPLY = 0,
		CHANNEL_SERVICE = 0, CHANNEL_SCIENCE = 0, CHANNEL_MEDICAL = 0,
		CHANNEL_ENGINEERING = 0, CHANNEL_MINING = 0
	)

/obj/item/encryptionkey/heads/rd
	name = "Research Director's Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "rd_cypherkey"
	channels = list(CHANNEL_SCIENCE = 1, CHANNEL_COMMAND = 1)

/obj/item/encryptionkey/heads/hos
	name = "Head of Security's Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "hos_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_SECURITY = 1)

/obj/item/encryptionkey/heads/ce
	name = "Chief Engineer's Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "ce_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_ENGINEERING = 1)

/obj/item/encryptionkey/heads/cmo
	name = "Chief Medical Officer's Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "cmo_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_MEDICAL = 1)

/obj/item/encryptionkey/heads/hop
	name = "Head of Personnel's Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "hop_cypherkey"
	channels = list(CHANNEL_COMMAND = 1, CHANNEL_SERVICE = 1, CHANNEL_SUPPLY = 0, CHANNEL_MINING = 0)

// Mining
/obj/item/encryptionkey/mining_foreman
	name = "Mining Foreman's Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "mine_cypherkey"
	channels = list(CHANNEL_SUPPLY = 1, CHANNEL_MINING = 1)

/obj/item/encryptionkey/mining
	name = "Mining Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "mine_cypherkey"
	channels = list(CHANNEL_MINING = 1)

// Cargo
/obj/item/encryptionkey/qm
	name = "Quartermaster's Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "qm_cypherkey"
	channels = list(CHANNEL_SUPPLY = 1, CHANNEL_MINING = 1)

/obj/item/encryptionkey/cargo
	name = "Supply Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "cargo_cypherkey"
	channels = list(CHANNEL_SUPPLY = 1)

// Service
/obj/item/encryptionkey/service
	name = "Service Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	icon_state = "cypherkey"
	channels = list(CHANNEL_SERVICE = 1)

// Response Team
/obj/item/encryptionkey/ert
	name = "NanoTrasen ERT Radio Encryption Key"
	desc = "An encyption key for a radio headset. Contains cypherkeys."
	channels = list(
		CHANNEL_RESPONSETEAM = 1, CHANNEL_SUPPLY = 1, CHANNEL_SERVICE = 1,
		CHANNEL_SCIENCE = 1, CHANNEL_COMMAND = 1, CHANNEL_MEDICAL = 1,
		CHANNEL_ENGINEERING = 1, CHANNEL_SECURITY = 1, CHANNEL_MINING = 1
	)