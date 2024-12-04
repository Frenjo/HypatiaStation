#define ACCESS_REGION_NONE			-1
#define ACCESS_REGION_ALL			0
#define ACCESS_REGION_SECURITY		1
#define ACCESS_REGION_MEDBAY		2
#define ACCESS_REGION_RESEARCH		3
#define ACCESS_REGION_ENGINEERING	4
#define ACCESS_REGION_COMMAND		5
#define ACCESS_REGION_GENERAL		6
#define ACCESS_REGION_SUPPLY		7

#define ACCESS_TYPE_NONE		BITFLAG(0)
#define ACCESS_TYPE_STATION		BITFLAG(1)
#define ACCESS_TYPE_CENTCOM		BITFLAG(2)
#define ACCESS_TYPE_SYNDICATE	BITFLAG(3)
#define ACCESS_TYPE_ALL (ACCESS_TYPE_NONE | ACCESS_TYPE_STATION | ACCESS_TYPE_CENTCOM | ACCESS_TYPE_SYNDICATE)

/*
 * Station Accesses
 */
#define ACCESS_SECURITY 1
#define ACCESS_BRIG 2
// This is spelled the correct (British English) way.
#define ACCESS_ARMOURY 3
#define ACCESS_FORENSICS_LOCKERS 4
#define ACCESS_MEDICAL 5
#define ACCESS_MORGUE 6
#define ACCESS_TOX 7
#define ACCESS_TOX_STORAGE 8
#define ACCESS_GENETICS 9
#define ACCESS_ENGINE 10
#define ACCESS_ENGINE_EQUIP 11
#define ACCESS_MAINT_TUNNELS 12
#define ACCESS_EXTERNAL_AIRLOCKS 13
#define ACCESS_EMERGENCY_STORAGE 14
#define ACCESS_CHANGE_IDS 15
#define ACCESS_AI_UPLOAD 16
#define ACCESS_TELEPORTER 17
#define ACCESS_EVA 18
#define ACCESS_BRIDGE 19
#define ACCESS_CAPTAIN 20
#define ACCESS_ALL_PERSONAL_LOCKERS 21
#define ACCESS_CHAPEL_OFFICE 22
#define ACCESS_TECH_STORAGE 23
#define ACCESS_ATMOSPHERICS 24
#define ACCESS_BAR 25
#define ACCESS_JANITOR 26
#define ACCESS_CREMATORIUM 27
#define ACCESS_KITCHEN 28
#define ACCESS_ROBOTICS 29
#define ACCESS_RD 30
#define ACCESS_CARGO 31
#define ACCESS_CONSTRUCTION 32
#define ACCESS_CHEMISTRY 33
#define ACCESS_CARGO_BOT 34
#define ACCESS_HYDROPONICS 35
#define ACCESS_MANUFACTURING 36
#define ACCESS_LIBRARY 37
#define ACCESS_LAWYER 38
#define ACCESS_VIROLOGY 39
#define ACCESS_CMO 40
#define ACCESS_QM 41
#define ACCESS_COURT 42
#define ACCESS_CLOWN 43
#define ACCESS_MIME 44
#define ACCESS_SURGERY 45
#define ACCESS_THEATRE 46
#define ACCESS_RESEARCH 47
#define ACCESS_MINING 48
// Not in use.
#define ACCESS_MINING_OFFICE 49
#define ACCESS_MAILSORTING 50
// This originally didn't have an access region, not sure if bug or feature.
#define ACCESS_MINT 51
#define ACCESS_MINT_VAULT 52
#define ACCESS_HEADS_VAULT 53
#define ACCESS_MINING_STATION 54
#define ACCESS_XENOBIOLOGY 55
#define ACCESS_CE 56
#define ACCESS_HOP 57
#define ACCESS_HOS 58
// Request console announcements.
#define ACCESS_RC_ANNOUNCE 59
// Used for events which require at least two people to confirm them.
#define ACCESS_KEYCARD_AUTH 60
// Has access to the entire telecoms satellite / machinery.
#define ACCESS_TCOMSAT 61
#define ACCESS_GATEWAY 62
// Security front doors.
#define ACCESS_SEC_DOORS 63
// Psychiatrist's office.
#define ACCESS_PSYCHIATRIST 64
#define ACCESS_XENOARCH 65

/*
 * CentCom Accesses
 *
 * Should leave plenty of room if we need to add more levels.
 * Mostly for admin fun times.
 */
// General facilities.
#define ACCESS_CENT_GENERAL 101
// Thunderdome.
#define ACCESS_CENT_THUNDER 102
// Special Ops.
#define ACCESS_CENT_SPECOPS 103
// Medical/Research.
#define ACCESS_CENT_MEDICAL 104
// Living quarters.
#define ACCESS_CENT_LIVING 105
// Generic storage areas.
#define ACCESS_CENT_STORAGE 106
// Teleporter.
#define ACCESS_CENT_TELEPORTER 107
// Creed's office.
#define ACCESS_CENT_CREED 108
// Captain's office/ID comp/AI.
#define ACCESS_CENT_CAPTAIN 109

/*
 * Syndicate Accesses
 */
// General Syndicate Access.
#define ACCESS_SYNDICATE 150

/*
 * Miscellaneous Accesses
 */
#define ACCESS_CRATE_CASH 200