/*
 * Datum-based access.
 *
 * Encapsulates access ID, name, region and type all in one place.
 */
/datum/access
	var/id = 0
	var/name = ""
	var/region = ACCESS_REGION_NONE
	var/access_type = ACCESS_TYPE_STATION

// TODO: Maybe condense all of these down with a multi-line macro?
/*
 * Station Accesses
 */
#define ACCESS_SECURITY 1
/datum/access/security
	id = ACCESS_SECURITY
	name = "Security"
	region = ACCESS_REGION_SECURITY

#define ACCESS_BRIG 2
/datum/access/brig
	id = ACCESS_BRIG
	name = "Holding Cells"
	region = ACCESS_REGION_SECURITY

// This is spelled the correct (British English) way.
#define ACCESS_ARMOURY 3
/datum/access/armoury
	id = ACCESS_ARMOURY
	name = "Armoury"
	region = ACCESS_REGION_SECURITY

#define ACCESS_FORENSICS_LOCKERS 4
/datum/access/forensics_lockers
	id = ACCESS_FORENSICS_LOCKERS
	name = "Forensics"
	region = ACCESS_REGION_SECURITY

#define ACCESS_MEDICAL 5
/datum/access/medical
	id = ACCESS_MEDICAL
	name = "Medical"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_MORGUE 6
/datum/access/morgue
	id = ACCESS_MORGUE
	name = "Morgue"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_TOX 7
/datum/access/tox
	id = ACCESS_TOX
	name = "R&D Lab"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_TOX_STORAGE 8
/datum/access/tox_storage
	id = ACCESS_TOX_STORAGE
	name = "Toxins Lab"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_GENETICS 9
/datum/access/genetics
	id = ACCESS_GENETICS
	name = "Genetics Lab"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_ENGINE 10
/datum/access/engine
	id = ACCESS_ENGINE
	name = "Engineering"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_ENGINE_EQUIP 11
/datum/access/engine_equip
	id = ACCESS_ENGINE_EQUIP
	name = "Power Equipment"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_MAINT_TUNNELS 12
/datum/access/maint_tunnels
	id = ACCESS_MAINT_TUNNELS
	name = "Maintenance"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_EXTERNAL_AIRLOCKS 13
/datum/access/external_airlocks
	id = ACCESS_EXTERNAL_AIRLOCKS
	name = "External Airlocks"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_EMERGENCY_STORAGE 14
/datum/access/emergency_storage
	id = ACCESS_EMERGENCY_STORAGE
	name = "Emergency Storage"
	region = ACCESS_REGION_ENGINEERING // This originally didn't have an access region, not sure if bug or feature.

#define ACCESS_CHANGE_IDS 15
/datum/access/change_ids
	id = ACCESS_CHANGE_IDS
	name = "ID Computer"
	region = ACCESS_REGION_COMMAND

#define ACCESS_AI_UPLOAD 16
/datum/access/ai_upload
	id = ACCESS_AI_UPLOAD
	name = "AI Upload"
	region = ACCESS_REGION_COMMAND

#define ACCESS_TELEPORTER 17
/datum/access/teleporter
	id = ACCESS_TELEPORTER
	name = "Teleporter"
	region = ACCESS_REGION_COMMAND

#define ACCESS_EVA 18
/datum/access/eva
	id = ACCESS_EVA
	name = "EVA"
	region = ACCESS_REGION_COMMAND

#define ACCESS_BRIDGE 19
/datum/access/bridge
	id = ACCESS_BRIDGE
	name = "Bridge"
	region = ACCESS_REGION_COMMAND

#define ACCESS_CAPTAIN 20
/datum/access/captain
	id = ACCESS_CAPTAIN
	name = "Captain"
	region = ACCESS_REGION_COMMAND

#define ACCESS_ALL_PERSONAL_LOCKERS 21
/datum/access/all_personal_lockers
	id = ACCESS_ALL_PERSONAL_LOCKERS
	name = "Personal Lockers"
	region = ACCESS_REGION_COMMAND

#define ACCESS_CHAPEL_OFFICE 22
/datum/access/chapel_office
	id = ACCESS_CHAPEL_OFFICE
	name = "Chapel Office"
	region = ACCESS_REGION_GENERAL

#define ACCESS_TECH_STORAGE 23
/datum/access/tech_storage
	id = ACCESS_TECH_STORAGE
	name = "Technical Storage"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_ATMOSPHERICS 24
/datum/access/atmospherics
	id = ACCESS_ATMOSPHERICS
	name = "Atmospherics"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_BAR 25
/datum/access/bar
	id = ACCESS_BAR
	name = "Bar"
	region = ACCESS_REGION_GENERAL

#define ACCESS_JANITOR 26
/datum/access/janitor
	id = ACCESS_JANITOR
	name = "Custodial Closet"
	region = ACCESS_REGION_GENERAL

#define ACCESS_CREMATORIUM 27
/datum/access/crematorium
	id = ACCESS_CREMATORIUM
	name = "Crematorium"
	region = ACCESS_REGION_GENERAL

#define ACCESS_KITCHEN 28
/datum/access/kitchen
	id = ACCESS_KITCHEN
	name = "Kitchen"
	region = ACCESS_REGION_GENERAL

#define ACCESS_ROBOTICS 29
/datum/access/robotics
	id = ACCESS_ROBOTICS
	name = "Robotics"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_RD 30
/datum/access/rd
	id = ACCESS_RD
	name = "Research Director"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_CARGO 31
/datum/access/cargo
	id = ACCESS_CARGO
	name = "Cargo Bay"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_CONSTRUCTION 32
/datum/access/construction
	id = ACCESS_CONSTRUCTION
	name = "Construction Areas"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_CHEMISTRY 33
/datum/access/Chemistry
	id = ACCESS_CHEMISTRY
	name = "Chemistry Lab"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_CARGO_BOT 34
/datum/access/cargo_bot
	id = ACCESS_CARGO_BOT
	name = "Cargo Bot Delivery"
	region = ACCESS_REGION_SUPPLY // This originally didn't have an access region, not sure if bug or feature.

#define ACCESS_HYDROPONICS 35
/datum/access/hydroponics
	id = ACCESS_HYDROPONICS
	name = "Hydroponics"
	region = ACCESS_REGION_GENERAL

#define ACCESS_MANUFACTURING 36
/datum/access/manufacturing
	id = ACCESS_MANUFACTURING
	name = "Manufacturing"
	access_type = ACCESS_TYPE_NONE

#define ACCESS_LIBRARY 37
/datum/access/library
	id = ACCESS_LIBRARY
	name = "Library"
	region = ACCESS_REGION_GENERAL

#define ACCESS_LAWYER 38
/datum/access/lawyer
	id = ACCESS_LAWYER
	name = "Law Office"
	region = ACCESS_REGION_GENERAL

#define ACCESS_VIROLOGY 39
/datum/access/virology
	id = ACCESS_VIROLOGY
	name = "Virology"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_CMO 40
/datum/access/cmo
	id = ACCESS_CMO
	name = "Chief Medical Officer"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_QM 41
/datum/access/qm
	id = ACCESS_QM
	name = "Quartermaster"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_COURT 42
/datum/access/court
	id = ACCESS_COURT
	name = "Courtroom"
	region = ACCESS_REGION_SECURITY

#define ACCESS_CLOWN 43
/datum/access/clown
	id = ACCESS_CLOWN
	name = "HONK! Access"
	region = ACCESS_REGION_GENERAL

#define ACCESS_MIME 44
/datum/access/mime
	id = ACCESS_MIME
	name = "Silent Access"
	region = ACCESS_REGION_GENERAL

#define ACCESS_SURGERY 45
/datum/access/surgery
	id = ACCESS_SURGERY
	name = "Surgery"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_THEATRE 46
/datum/access/theatre
	id = ACCESS_THEATRE
	name = "Theatre"
	region = ACCESS_REGION_GENERAL

#define ACCESS_RESEARCH 47
/datum/access/research
	id = ACCESS_RESEARCH
	name = "Science"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_MINING 48
/datum/access/mining
	id = ACCESS_MINING
	name = "Mining"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_MINING_OFFICE 49
/datum/access/mining_office
	id = ACCESS_MINING_OFFICE
	name = "Mining Office"
	access_type = ACCESS_TYPE_NONE // Not in use.

#define ACCESS_MAILSORTING 50
/datum/access/mailsorting
	id = ACCESS_MAILSORTING
	name = "Cargo Office"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_MINT 51
/datum/access/mint
	id = ACCESS_MINT
	name = "Mint"
	region = ACCESS_REGION_SUPPLY // This originally didn't have an access region, not sure if bug or feature.

#define ACCESS_MINT_VAULT 52
/datum/access/mint_vault
	id = ACCESS_MINT_VAULT
	name = "Mint Vault"
	access_type = ACCESS_TYPE_NONE

#define ACCESS_HEADS_VAULT 53
/datum/access/heads_vault
	id = ACCESS_HEADS_VAULT
	name = "Main Vault"
	region = ACCESS_REGION_COMMAND

#define ACCESS_MINING_STATION 54
/datum/access/mining_station
	id = ACCESS_MINING_STATION
	name = "Mining EVA"
	region = ACCESS_REGION_SUPPLY

#define ACCESS_XENOBIOLOGY 55
/datum/access/xenobiology
	id = ACCESS_XENOBIOLOGY
	name = "Xenobiology Lab"
	region = ACCESS_REGION_RESEARCH

#define ACCESS_CE 56
/datum/access/ce
	id = ACCESS_CE
	name = "Chief Engineer"
	region = ACCESS_REGION_ENGINEERING

#define ACCESS_HOP 57
/datum/access/hop
	id = ACCESS_HOP
	name = "Head of Personnel"
	region = ACCESS_REGION_COMMAND

#define ACCESS_HOS 58
/datum/access/hos
	id = ACCESS_HOS
	name = "Head of Security"
	region = ACCESS_REGION_SECURITY

#define ACCESS_RC_ANNOUNCE 59
/datum/access/rc_announce // Request console announcements.
	id = ACCESS_RC_ANNOUNCE
	name = "RC Announcements"
	region = ACCESS_REGION_COMMAND

#define ACCESS_KEYCARD_AUTH 60
/datum/access/keycard_auth // Used for events which require at least two people to confirm them.
	id = ACCESS_KEYCARD_AUTH
	name = "Keycode Auth. Device"
	region = ACCESS_REGION_COMMAND

#define ACCESS_TCOMSAT 61
/datum/access/tcomsat // Has access to the entire telecoms satellite / machinery.
	id = ACCESS_TCOMSAT
	name = "Telecommunications"
	region = ACCESS_REGION_COMMAND

#define ACCESS_GATEWAY 62
/datum/access/gateway
	id = ACCESS_GATEWAY
	name = "Gateway"
	region = ACCESS_REGION_COMMAND

#define ACCESS_SEC_DOORS 63
/datum/access/sec_doors // Security front doors.
	id = ACCESS_SEC_DOORS
	name = "Brig"
	region = ACCESS_REGION_SECURITY

#define ACCESS_PSYCHIATRIST 64
/datum/access/psychiatrist // Psychiatrist's office.
	id = ACCESS_PSYCHIATRIST
	name = "Psychiatrist's Office"
	region = ACCESS_REGION_MEDBAY

#define ACCESS_XENOARCH 65
/datum/access/xenoarch
	id = ACCESS_XENOARCH
	name = "Xenoarchaeology"
	region = ACCESS_XENOARCH

/*
 * CentCom Accesses
 *
 * Should leave plenty of room if we need to add more levels.
 * Mostly for admin fun times.
 */
#define ACCESS_CENT_GENERAL 101 // General facilities.
/datum/access/cent_general
	id = ACCESS_CENT_GENERAL
	name = "Code Grey"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_THUNDER 102 // Thunderdome.
/datum/access/cent_thunder
	id = ACCESS_CENT_THUNDER
	name = "Code Yellow"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_SPECOPS 103 // Special Ops.
/datum/access/cent_specops
	id = ACCESS_CENT_SPECOPS
	name = "Code Black"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_MEDICAL 104 // Medical/Research
/datum/access/cent_medical
	id = ACCESS_CENT_MEDICAL
	name = "Code White"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_LIVING 105 // Living quarters.
/datum/access/cent_living
	id = ACCESS_CENT_LIVING
	name = "Code Green"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_STORAGE 106 // Generic storage areas.
/datum/access/cent_storage
	id = ACCESS_CENT_STORAGE
	name = "Code Orange"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_TELEPORTER 107 // Teleporter.
/datum/access/cent_teleporter
	id = ACCESS_CENT_TELEPORTER
	name = "Code Blue"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_CREED 108 // Creed's office.
/datum/access/cent_creed
	id = ACCESS_CENT_CREED
	name = "Code Silver"
	access_type = ACCESS_TYPE_CENTCOM

#define ACCESS_CENT_CAPTAIN 109 // Captain's office/ID comp/AI.
/datum/access/cent_captain
	id = ACCESS_CENT_CAPTAIN
	name = "Code Gold"
	access_type = ACCESS_TYPE_CENTCOM

/*
 * Syndicate Accesses
 */
#define ACCESS_SYNDICATE 150
/datum/access/syndicate // General Syndicate Access.
	id = ACCESS_SYNDICATE
	access_type = ACCESS_TYPE_SYNDICATE

/*
 * Miscellaneous Accesses
 */
#define ACCESS_CRATE_CASH 200
/datum/access/crate_cash
	id = ACCESS_CRATE_CASH
	access_type = ACCESS_TYPE_NONE