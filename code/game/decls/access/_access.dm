/*
 * Datum-based access.
 *
 * Encapsulates access ID, name, region and type all in one place.
 */
/decl/access
	var/id = 0
	var/name = ""
	var/region = ACCESS_REGION_NONE
	var/access_type = ACCESS_TYPE_STATION

/*
 * Access Definition Defines
 *
 * These are just here to save a craptonne of duplicated lines.
 *
 * ACCESS_R (ACCESS_REGION) creates a /decl/access with an ACCESS_REGION_* specified.
 * ACCESS_T (ACCESS_TYPE) creates a /decl/access with an ACCESS_TYPE_* specified.
 *
 * Others should be declared manually in the usual way, the macros above just cover two very common standards.
 */
#define ACCESS_R(PATH, ID, NAME, REGION) \
/decl/access/##PATH \
{ \
	id = ID; \
	name = NAME; \
	region = REGION; \
}
#define ACCESS_T(PATH, ID, NAME, TYPE) \
/decl/access/##PATH \
{ \
	id = ID; \
	name = NAME; \
	access_type = TYPE; \
}

/*
 * Station Accesses
 */
ACCESS_R(security, ACCESS_SECURITY, "Security", ACCESS_REGION_SECURITY)
ACCESS_R(brig, ACCESS_BRIG, "Holding Cells", ACCESS_REGION_SECURITY)
// This is spelled the correct (British English) way.
ACCESS_R(armoury, ACCESS_ARMOURY, "Armoury", ACCESS_REGION_SECURITY)
ACCESS_R(forensics_lockers, ACCESS_FORENSICS_LOCKERS, "Forensics", ACCESS_REGION_SECURITY)
ACCESS_R(medical, ACCESS_MEDICAL, "Medical", ACCESS_REGION_MEDBAY)
ACCESS_R(morgue, ACCESS_MORGUE, "Morgue", ACCESS_REGION_MEDBAY)
ACCESS_R(tox, ACCESS_TOX, "R&D Lab", ACCESS_REGION_RESEARCH)
ACCESS_R(tox_storage, ACCESS_TOX_STORAGE, "Toxins Lab", ACCESS_REGION_RESEARCH)
ACCESS_R(genetics, ACCESS_GENETICS, "Genetics Lab", ACCESS_REGION_MEDBAY)
ACCESS_R(engine, ACCESS_ENGINE, "Engineering", ACCESS_REGION_ENGINEERING)
ACCESS_R(engine_equip, ACCESS_ENGINE_EQUIP, "Power Equipment", ACCESS_REGION_ENGINEERING)
ACCESS_R(maint_tunnels, ACCESS_MAINT_TUNNELS, "Maintenance", ACCESS_REGION_ENGINEERING)
ACCESS_R(external_airlocks, ACCESS_EXTERNAL_AIRLOCKS, "External Airlocks", ACCESS_REGION_ENGINEERING)
// This originally didn't have an access region, not sure if bug or feature.
ACCESS_R(emergency_storage, ACCESS_EMERGENCY_STORAGE, "Emergency Storage", ACCESS_REGION_ENGINEERING)
ACCESS_R(change_ids, ACCESS_CHANGE_IDS, "ID Computer", ACCESS_REGION_COMMAND)
ACCESS_R(ai_upload, ACCESS_AI_UPLOAD, "AI Upload", ACCESS_REGION_COMMAND)
ACCESS_R(teleporter, ACCESS_TELEPORTER, "Teleporter", ACCESS_REGION_COMMAND)
ACCESS_R(eva, ACCESS_EVA, "EVA", ACCESS_REGION_COMMAND)
ACCESS_R(bridge, ACCESS_BRIDGE, "Bridge", ACCESS_REGION_COMMAND)
ACCESS_R(captain, ACCESS_CAPTAIN, "Captain", ACCESS_REGION_COMMAND)
ACCESS_R(all_personal_lockers, ACCESS_ALL_PERSONAL_LOCKERS, "Personal Lockers", ACCESS_REGION_COMMAND)
ACCESS_R(chapel_office, ACCESS_CHAPEL_OFFICE, "Chapel Office", ACCESS_REGION_GENERAL)
ACCESS_R(tech_storage, ACCESS_TECH_STORAGE, "Technical Storage", ACCESS_REGION_ENGINEERING)
ACCESS_R(atmospherics, ACCESS_ATMOSPHERICS, "Atmospherics", ACCESS_REGION_ENGINEERING)
ACCESS_R(bar, ACCESS_BAR, "Bar", ACCESS_REGION_GENERAL)
ACCESS_R(janitor, ACCESS_JANITOR, "Custodial Closet", ACCESS_REGION_GENERAL)
ACCESS_R(crematorium, ACCESS_CREMATORIUM, "Crematorium", ACCESS_REGION_GENERAL)
ACCESS_R(kitchen, ACCESS_KITCHEN, "Kitchen", ACCESS_REGION_GENERAL)
ACCESS_R(robotics, ACCESS_ROBOTICS, "Robotics", ACCESS_REGION_RESEARCH)
ACCESS_R(rd, ACCESS_RD, "Research Director", ACCESS_REGION_RESEARCH)
ACCESS_R(cargo, ACCESS_CARGO, "Cargo Bay", ACCESS_REGION_SUPPLY)
ACCESS_R(construction, ACCESS_CONSTRUCTION, "Construction Areas", ACCESS_REGION_ENGINEERING)
ACCESS_R(chemistry, ACCESS_CHEMISTRY, "Chemistry Lab", ACCESS_REGION_MEDBAY)
// This originally didn't have an access region, not sure if bug or feature.
ACCESS_R(cargo_bot, ACCESS_CARGO_BOT, "Cargo Bot Delivery", ACCESS_REGION_SUPPLY)
ACCESS_R(hydroponics, ACCESS_HYDROPONICS, "Hydroponics", ACCESS_REGION_GENERAL)
ACCESS_T(manufacturing, ACCESS_MANUFACTURING, "Manufacturing", ACCESS_TYPE_NONE)
ACCESS_R(library, ACCESS_LIBRARY, "Library", ACCESS_REGION_GENERAL)
ACCESS_R(lawyer, ACCESS_LAWYER, "Law Office", ACCESS_REGION_GENERAL)
ACCESS_R(virology, ACCESS_VIROLOGY, "Virology", ACCESS_REGION_MEDBAY)
ACCESS_R(cmo, ACCESS_CMO, "Chief Medical Officer", ACCESS_REGION_MEDBAY)
ACCESS_R(qm, ACCESS_QM, "Quartermaster", ACCESS_REGION_SUPPLY)
ACCESS_R(court, ACCESS_COURT, "Courtroom", ACCESS_REGION_SECURITY)
ACCESS_R(clown, ACCESS_CLOWN, "HONK! Access", ACCESS_REGION_GENERAL)
ACCESS_R(mime, ACCESS_MIME, "Silent Access", ACCESS_REGION_GENERAL)
ACCESS_R(surgery, ACCESS_SURGERY, "Surgery", ACCESS_REGION_MEDBAY)
ACCESS_R(theatre, ACCESS_THEATRE, "Theatre", ACCESS_REGION_GENERAL)
ACCESS_R(research, ACCESS_RESEARCH, "Science", ACCESS_REGION_RESEARCH)
ACCESS_R(mining, ACCESS_MINING, "Mining", ACCESS_REGION_SUPPLY)
// Not in use.
ACCESS_T(mining_office, ACCESS_MINING_OFFICE, "Mining Office", ACCESS_TYPE_NONE)
ACCESS_R(mailsorting, ACCESS_MAILSORTING, "Cargo Office", ACCESS_REGION_SUPPLY)
// This originally didn't have an access region, not sure if bug or feature.
ACCESS_R(mint, ACCESS_MINT, "Mint", ACCESS_REGION_SUPPLY)
ACCESS_T(mint_vault, ACCESS_MINT_VAULT, "Mint Vault", ACCESS_TYPE_NONE)
ACCESS_R(heads_vault, ACCESS_HEADS_VAULT, "Main Vault", ACCESS_REGION_COMMAND)
ACCESS_R(mining_station, ACCESS_MINING_STATION, "Mining EVA", ACCESS_REGION_SUPPLY)
ACCESS_R(xenobiology, ACCESS_XENOBIOLOGY, "Xenobiology Lab", ACCESS_REGION_RESEARCH)
ACCESS_R(ce, ACCESS_CE, "Chief Engineer", ACCESS_REGION_ENGINEERING)
ACCESS_R(hop, ACCESS_HOP, "Head of Personnel", ACCESS_REGION_COMMAND)
ACCESS_R(hos, ACCESS_HOS, "Head of Security", ACCESS_REGION_SECURITY)
// Request console announcements
ACCESS_R(rc_announce, ACCESS_RC_ANNOUNCE, "RC Announcements", ACCESS_REGION_COMMAND)
// Used for events which require at least two people to confirm them.
ACCESS_R(keycard_auth, ACCESS_KEYCARD_AUTH, "Keycode Auth. Device", ACCESS_REGION_COMMAND)
// Has access to the entire telecoms satellite / machinery.
ACCESS_R(tcomsat, ACCESS_TCOMSAT, "Telecommunications", ACCESS_REGION_COMMAND)
ACCESS_R(gateway, ACCESS_GATEWAY, "Gateway", ACCESS_REGION_COMMAND)
// Security front doors
ACCESS_R(sec_doors, ACCESS_SEC_DOORS, "Brig", ACCESS_REGION_SECURITY)
// Psychiatrist's office
ACCESS_R(psychiatrist, ACCESS_PSYCHIATRIST, "Psychiatrist's Office", ACCESS_REGION_MEDBAY)
ACCESS_R(xenoarch, ACCESS_XENOARCH, "Xenoarchaeology", ACCESS_REGION_RESEARCH)

/*
 * CentCom Accesses
 *
 * Should leave plenty of room if we need to add more levels.
 * Mostly for admin fun times.
 */
// General facilities
ACCESS_T(cent_general, ACCESS_CENT_GENERAL, "Code Grey", ACCESS_TYPE_CENTCOM)
// Thunderdome
ACCESS_T(cent_thunder, ACCESS_CENT_THUNDER, "Code Yellow", ACCESS_TYPE_CENTCOM)
// Special Ops
ACCESS_T(cent_specops, ACCESS_CENT_SPECOPS, "Code Black", ACCESS_TYPE_CENTCOM)
// Medical/Research
ACCESS_T(cent_medical, ACCESS_CENT_MEDICAL, "Code White", ACCESS_TYPE_CENTCOM)
// Living quarters
ACCESS_T(cent_living, ACCESS_CENT_LIVING, "Code Green", ACCESS_TYPE_CENTCOM)
// Generic storage areas
ACCESS_T(cent_storage, ACCESS_CENT_STORAGE, "Code Orange", ACCESS_TYPE_CENTCOM)
// Teleporter
ACCESS_T(cent_teleporter, ACCESS_CENT_TELEPORTER, "Code Blue", ACCESS_TYPE_CENTCOM)
// Creed's office
ACCESS_T(cent_creed, ACCESS_CENT_CREED, "Code Silver", ACCESS_TYPE_CENTCOM)
// Captain's office/ID comp/AI
ACCESS_T(cent_captain, ACCESS_CENT_CAPTAIN, "Code Gold", ACCESS_TYPE_CENTCOM)

/*
 * Syndicate Accesses
 */
// General Syndicate Access
/decl/access/syndicate
	id = ACCESS_SYNDICATE
	access_type = ACCESS_TYPE_SYNDICATE

/*
 * Miscellaneous Accesses
 */
/decl/access/crate_cash
	id = ACCESS_CRATE_CASH
	access_type = ACCESS_TYPE_NONE

/*
 * Access Definition Undefines
 */
#undef ACCESS_R
#undef ACCESS_T