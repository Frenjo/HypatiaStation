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

/*
 * Access Definition Defines
 *
 * These are just here to save a craptonne of duplicated lines.
 *
 * ACCESS_R (ACCESS_REGION) creates a /datum/access with an ACCESS_REGION_* specified.
 * ACCESS_T (ACCESS_TYPE) creates a /datum/access with an ACCESS_TYPE_* specified.
 *
 * Others should be declared manually in the usual way, the macros above just cover two very common standards.
 */
#define ACCESS_R(PATH, ID, NAME, REGION) \
/datum/access/##PATH \
{ \
	id = ID; \
	name = NAME; \
	region = REGION; \
}
#define ACCESS_T(PATH, ID, NAME, TYPE) \
/datum/access/##PATH \
{ \
	id = ID; \
	name = NAME; \
	access_type = TYPE; \
}

/*
 * Station Accesses
 */
#define ACCESS_SECURITY 1
ACCESS_R(security, ACCESS_SECURITY, "Security", ACCESS_REGION_SECURITY)

#define ACCESS_BRIG 2
ACCESS_R(brig, ACCESS_BRIG, "Holding Cells", ACCESS_REGION_SECURITY)

// This is spelled the correct (British English) way.
#define ACCESS_ARMOURY 3
ACCESS_R(armoury, ACCESS_ARMOURY, "Armoury", ACCESS_REGION_SECURITY)

#define ACCESS_FORENSICS_LOCKERS 4
ACCESS_R(forensics_lockers, ACCESS_FORENSICS_LOCKERS, "Forensics", ACCESS_REGION_SECURITY)

#define ACCESS_MEDICAL 5
ACCESS_R(medical, ACCESS_MEDICAL, "Medical", ACCESS_REGION_MEDBAY)

#define ACCESS_MORGUE 6
ACCESS_R(morgue, ACCESS_MORGUE, "Morgue", ACCESS_REGION_MEDBAY)

#define ACCESS_TOX 7
ACCESS_R(tox, ACCESS_TOX, "R&D Lab", ACCESS_REGION_RESEARCH)

#define ACCESS_TOX_STORAGE 8
ACCESS_R(tox_storage, ACCESS_TOX_STORAGE, "Toxins Lab", ACCESS_REGION_RESEARCH)

#define ACCESS_GENETICS 9
ACCESS_R(genetics, ACCESS_GENETICS, "Genetics Lab", ACCESS_REGION_MEDBAY)

#define ACCESS_ENGINE 10
ACCESS_R(engine, ACCESS_ENGINE, "Engineering", ACCESS_REGION_ENGINEERING)

#define ACCESS_ENGINE_EQUIP 11
ACCESS_R(engine_equip, ACCESS_ENGINE_EQUIP, "Power Equipment", ACCESS_REGION_ENGINEERING)

#define ACCESS_MAINT_TUNNELS 12
ACCESS_R(maint_tunnels, ACCESS_MAINT_TUNNELS, "Maintenance", ACCESS_REGION_ENGINEERING)

#define ACCESS_EXTERNAL_AIRLOCKS 13
ACCESS_R(external_airlocks, ACCESS_EXTERNAL_AIRLOCKS, "External Airlocks", ACCESS_REGION_ENGINEERING)

// This originally didn't have an access region, not sure if bug or feature.
#define ACCESS_EMERGENCY_STORAGE 14
ACCESS_R(emergency_storage, ACCESS_EMERGENCY_STORAGE, "Emergency Storage", ACCESS_REGION_ENGINEERING)

#define ACCESS_CHANGE_IDS 15
ACCESS_R(change_ids, ACCESS_CHANGE_IDS, "ID Computer", ACCESS_REGION_COMMAND)

#define ACCESS_AI_UPLOAD 16
ACCESS_R(ai_upload, ACCESS_AI_UPLOAD, "AI Upload", ACCESS_REGION_COMMAND)

#define ACCESS_TELEPORTER 17
ACCESS_R(teleporter, ACCESS_TELEPORTER, "Teleporter", ACCESS_REGION_COMMAND)

#define ACCESS_EVA 18
ACCESS_R(eva, ACCESS_EVA, "EVA", ACCESS_REGION_COMMAND)

#define ACCESS_BRIDGE 19
ACCESS_R(bridge, ACCESS_BRIDGE, "Bridge", ACCESS_REGION_COMMAND)

#define ACCESS_CAPTAIN 20
ACCESS_R(captain, ACCESS_CAPTAIN, "Captain", ACCESS_REGION_COMMAND)

#define ACCESS_ALL_PERSONAL_LOCKERS 21
ACCESS_R(all_personal_lockers, ACCESS_ALL_PERSONAL_LOCKERS, "Personal Lockers", ACCESS_REGION_COMMAND)

#define ACCESS_CHAPEL_OFFICE 22
ACCESS_R(chapel_office, ACCESS_CHAPEL_OFFICE, "Chapel Office", ACCESS_REGION_GENERAL)

#define ACCESS_TECH_STORAGE 23
ACCESS_R(tech_storage, ACCESS_TECH_STORAGE, "Technical Storage", ACCESS_REGION_ENGINEERING)

#define ACCESS_ATMOSPHERICS 24
ACCESS_R(atmospherics, ACCESS_ATMOSPHERICS, "Atmospherics", ACCESS_REGION_ENGINEERING)

#define ACCESS_BAR 25
ACCESS_R(bar, ACCESS_BAR, "Bar", ACCESS_REGION_GENERAL)

#define ACCESS_JANITOR 26
ACCESS_R(janitor, ACCESS_JANITOR, "Custodial Closet", ACCESS_REGION_GENERAL)

#define ACCESS_CREMATORIUM 27
ACCESS_R(crematorium, ACCESS_CREMATORIUM, "Crematorium", ACCESS_REGION_GENERAL)

#define ACCESS_KITCHEN 28
ACCESS_R(kitchen, ACCESS_KITCHEN, "Kitchen", ACCESS_REGION_GENERAL)

#define ACCESS_ROBOTICS 29
ACCESS_R(robotics, ACCESS_ROBOTICS, "Robotics", ACCESS_REGION_RESEARCH)

#define ACCESS_RD 30
ACCESS_R(rd, ACCESS_RD, "Research Director", ACCESS_REGION_RESEARCH)

#define ACCESS_CARGO 31
ACCESS_R(cargo, ACCESS_CARGO, "Cargo Bay", ACCESS_REGION_SUPPLY)

#define ACCESS_CONSTRUCTION 32
ACCESS_R(construction, ACCESS_CONSTRUCTION, "Construction Areas", ACCESS_REGION_ENGINEERING)

#define ACCESS_CHEMISTRY 33
ACCESS_R(chemistry, ACCESS_CHEMISTRY, "Chemistry Lab", ACCESS_REGION_MEDBAY)

// This originally didn't have an access region, not sure if bug or feature.
#define ACCESS_CARGO_BOT 34
ACCESS_R(cargo_bot, ACCESS_CARGO_BOT, "Cargo Bot Delivery", ACCESS_REGION_SUPPLY)

#define ACCESS_HYDROPONICS 35
ACCESS_R(hydroponics, ACCESS_HYDROPONICS, "Hydroponics", ACCESS_REGION_GENERAL)

#define ACCESS_MANUFACTURING 36
ACCESS_T(manufacturing, ACCESS_MANUFACTURING, "Manufacturing", ACCESS_TYPE_NONE)

#define ACCESS_LIBRARY 37
ACCESS_R(library, ACCESS_LIBRARY, "Library", ACCESS_REGION_GENERAL)

#define ACCESS_LAWYER 38
ACCESS_R(lawyer, ACCESS_LAWYER, "Law Office", ACCESS_REGION_GENERAL)

#define ACCESS_VIROLOGY 39
ACCESS_R(virology, ACCESS_VIROLOGY, "Virology", ACCESS_REGION_MEDBAY)

#define ACCESS_CMO 40
ACCESS_R(cmo, ACCESS_CMO, "Chief Medical Officer", ACCESS_REGION_MEDBAY)

#define ACCESS_QM 41
ACCESS_R(qm, ACCESS_QM, "Quartermaster", ACCESS_REGION_SUPPLY)

#define ACCESS_COURT 42
ACCESS_R(court, ACCESS_COURT, "Courtroom", ACCESS_REGION_SECURITY)

#define ACCESS_CLOWN 43
ACCESS_R(clown, ACCESS_CLOWN, "HONK! Access", ACCESS_REGION_GENERAL)

#define ACCESS_MIME 44
ACCESS_R(mime, ACCESS_MIME, "Silent Access", ACCESS_REGION_GENERAL)

#define ACCESS_SURGERY 45
ACCESS_R(surgery, ACCESS_SURGERY, "Surgery", ACCESS_REGION_MEDBAY)

#define ACCESS_THEATRE 46
ACCESS_R(theatre, ACCESS_THEATRE, "Theatre", ACCESS_REGION_GENERAL)

#define ACCESS_RESEARCH 47
ACCESS_R(research, ACCESS_RESEARCH, "Science", ACCESS_REGION_RESEARCH)

#define ACCESS_MINING 48
ACCESS_R(mining, ACCESS_MINING, "Mining", ACCESS_REGION_SUPPLY)

// Not in use.
#define ACCESS_MINING_OFFICE 49
ACCESS_T(mining_office, ACCESS_MINING_OFFICE, "Mining Office", ACCESS_TYPE_NONE)

#define ACCESS_MAILSORTING 50
ACCESS_R(mailsorting, ACCESS_MAILSORTING, "Cargo Office", ACCESS_REGION_SUPPLY)

// This originally didn't have an access region, not sure if bug or feature.
#define ACCESS_MINT 51
ACCESS_R(mint, ACCESS_MINT, "Mint", ACCESS_REGION_SUPPLY)

#define ACCESS_MINT_VAULT 52
ACCESS_T(mint_vault, ACCESS_MINT_VAULT, "Mint Vault", ACCESS_TYPE_NONE)

#define ACCESS_HEADS_VAULT 53
ACCESS_R(heads_vault, ACCESS_HEADS_VAULT, "Main Vault", ACCESS_REGION_COMMAND)

#define ACCESS_MINING_STATION 54
ACCESS_R(mining_station, ACCESS_MINING_STATION, "Mining EVA", ACCESS_REGION_SUPPLY)

#define ACCESS_XENOBIOLOGY 55
ACCESS_R(xenobiology, ACCESS_XENOBIOLOGY, "Xenobiology Lab", ACCESS_REGION_RESEARCH)

#define ACCESS_CE 56
ACCESS_R(ce, ACCESS_CE, "Chief Engineer", ACCESS_REGION_ENGINEERING)

#define ACCESS_HOP 57
ACCESS_R(hop, ACCESS_HOP, "Head of Personnel", ACCESS_REGION_COMMAND)

#define ACCESS_HOS 58
ACCESS_R(hos, ACCESS_HOS, "Head of Security", ACCESS_REGION_SECURITY)

// Request console announcements.
#define ACCESS_RC_ANNOUNCE 59
ACCESS_R(rc_announce, ACCESS_RC_ANNOUNCE, "RC Announcements", ACCESS_REGION_COMMAND)

// Used for events which require at least two people to confirm them.
#define ACCESS_KEYCARD_AUTH 60
ACCESS_R(keycard_auth, ACCESS_KEYCARD_AUTH, "Keycode Auth. Device", ACCESS_REGION_COMMAND)

// Has access to the entire telecoms satellite / machinery.
#define ACCESS_TCOMSAT 61
ACCESS_R(tcomsat, ACCESS_TCOMSAT, "Telecommunications", ACCESS_REGION_COMMAND)

#define ACCESS_GATEWAY 62
ACCESS_R(gateway, ACCESS_GATEWAY, "Gateway", ACCESS_REGION_COMMAND)

// Security front doors.
#define ACCESS_SEC_DOORS 63
ACCESS_R(sec_doors, ACCESS_SEC_DOORS, "Brig", ACCESS_REGION_SECURITY)

// Psychiatrist's office.
#define ACCESS_PSYCHIATRIST 64
ACCESS_R(psychiatrist, ACCESS_PSYCHIATRIST, "Psychiatrist's Office", ACCESS_REGION_MEDBAY)

#define ACCESS_XENOARCH 65
ACCESS_R(xenoarch, ACCESS_XENOARCH, "Xenoarchaeology", ACCESS_REGION_RESEARCH)

/*
 * CentCom Accesses
 *
 * Should leave plenty of room if we need to add more levels.
 * Mostly for admin fun times.
 */
// General facilities.
#define ACCESS_CENT_GENERAL 101
ACCESS_T(cent_general, ACCESS_CENT_GENERAL, "Code Grey", ACCESS_TYPE_CENTCOM)

// Thunderdome.
#define ACCESS_CENT_THUNDER 102
ACCESS_T(cent_thunder, ACCESS_CENT_THUNDER, "Code Yellow", ACCESS_TYPE_CENTCOM)

// Special Ops.
#define ACCESS_CENT_SPECOPS 103
ACCESS_T(cent_specops, ACCESS_CENT_SPECOPS, "Code Black", ACCESS_TYPE_CENTCOM)

// Medical/Research.
#define ACCESS_CENT_MEDICAL 104
ACCESS_T(cent_medical, ACCESS_CENT_MEDICAL, "Code White", ACCESS_TYPE_CENTCOM)

// Living quarters.
#define ACCESS_CENT_LIVING 105
ACCESS_T(cent_living, ACCESS_CENT_LIVING, "Code Green", ACCESS_TYPE_CENTCOM)

// Generic storage areas.
#define ACCESS_CENT_STORAGE 106
ACCESS_T(cent_storage, ACCESS_CENT_STORAGE, "Code Orange", ACCESS_TYPE_CENTCOM)

// Teleporter.
#define ACCESS_CENT_TELEPORTER 107
ACCESS_T(cent_teleporter, ACCESS_CENT_TELEPORTER, "Code Blue", ACCESS_TYPE_CENTCOM)

// Creed's office.
#define ACCESS_CENT_CREED 108
ACCESS_T(cent_creed, ACCESS_CENT_CREED, "Code Silver", ACCESS_TYPE_CENTCOM)

// Captain's office/ID comp/AI.
#define ACCESS_CENT_CAPTAIN 109
ACCESS_T(cent_captain, ACCESS_CENT_CAPTAIN, "Code Gold", ACCESS_TYPE_CENTCOM)

/*
 * Syndicate Accesses
 */
// General Syndicate Access.
#define ACCESS_SYNDICATE 150
/datum/access/syndicate
	id = ACCESS_SYNDICATE
	access_type = ACCESS_TYPE_SYNDICATE

/*
 * Miscellaneous Accesses
 */
#define ACCESS_CRATE_CASH 200
/datum/access/crate_cash
	id = ACCESS_CRATE_CASH
	access_type = ACCESS_TYPE_NONE

/*
 * Access Definition Undefines
 */
#undef ACCESS_R
#undef ACCESS_T