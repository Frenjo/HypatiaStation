//#define TESTING
//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//////////////
var/skipupdate = 0
///////////////
var/event = 0
///////////////

//var/station_name = "Hypatia Station"
/var/global/station_name = "NSS Hypatia" // Fixed this to be a proper name. -Frenjo
/var/global/game_version = "Hypatia"
/var/global/changelog_hash = ""
/var/global/game_year = (text2num(time2text(world.realtime, "YYYY")) + 544)

var/datum/air_tunnel/air_tunnel1/SS13_airtunnel = null
/var/global/roundstart_progressing = TRUE
/var/global/master_mode = "extended"		//"extended"
/var/global/secret_force_mode = "secret"	// if this is anything but "secret", the secret rotation will forceably choose this mode

var/datum/engine_eject/engine_eject_control = null
/var/global/host = null
/var/global/aliens_allowed = FALSE
/var/global/ooc_allowed = TRUE
/var/global/dsay_allowed = TRUE
/var/global/dooc_allowed = TRUE
//var/goonsay_allowed = 0
var/dna_ident = 1
/var/global/abandon_allowed = TRUE
/var/global/enter_allowed = TRUE
/var/global/guests_allowed = TRUE
var/shuttle_frozen = 0
var/shuttle_left = 0
/var/global/tinted_weldhelh = TRUE

var/list/jobMax = list()
var/list/bombers = list()
var/list/admin_log = list ()
var/list/lastsignalers = list()	//keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
var/list/lawchanges = list() //Stores who uploaded laws to which silicon-based lifeform, and what the law was
var/list/shuttles = list()
var/list/reg_dna = list()
//	list/traitobj = list()

var/shuttle_z = 2	//default
var/airtunnel_start = 68 // default
var/airtunnel_stop = 68 // default
var/airtunnel_bottom = 72 // default
var/list/monkeystart = list()
var/list/wizardstart = list()
var/list/newplayer_start = list()

var/list/prisonwarp = list()	//prisoners go to these
var/list/holdingfacility = list()	//captured people go here
var/list/xeno_spawn = list()//Aliens spawn at these.
//	list/mazewarp = list()
var/list/tdome1 = list()
var/list/tdome2 = list()
var/list/tdomeobserve = list()
var/list/tdomeadmin = list()
var/list/prisonsecuritywarp = list()	//prison security goes to these
var/list/prisonwarped = list()	//list of players already warped
var/list/blobstart = list()
var/list/ninjastart = list()
//	list/traitors = list()	//traitor list
var/list/cardinal = list(NORTH, SOUTH, EAST, WEST)
var/list/alldirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
// reverse_dir[dir] = reverse of dir
var/list/reverse_dir = list(2, 1, 3, 8, 10, 9, 11, 4, 6, 5, 7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42, 41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21, 23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63)

var/datum/station_state/start_state = null

var/list/combatlog = list()
var/list/IClog = list()
var/list/OOClog = list()
var/list/adminlog = list()

/var/global/debug2 = FALSE

var/datum/debug/debugobj

var/shuttlecoming = 0

/var/global/join_motd = null
var/forceblob = 0

//airlockWireColorToIndex takes a number representing the wire color, e.g. the orange wire is always 1, the dark red wire is always 2, etc. It returns the index for whatever that wire does.
//airlockIndexToWireColor does the opposite thing - it takes the index for what the wire does, for example AIRLOCK_WIRE_IDSCAN is 1, AIRLOCK_WIRE_POWER1 is 2, etc. It returns the wire color number.
//airlockWireColorToFlag takes the wire color number and returns the flag for it (1, 2, 4, 8, 16, etc)
var/list/airlockWireColorToFlag = RandomAirlockWires()
var/list/airlockIndexToFlag
var/list/airlockIndexToWireColor
var/list/airlockWireColorToIndex
var/list/APCWireColorToFlag = RandomAPCWires()
var/list/APCIndexToFlag
var/list/APCIndexToWireColor
var/list/APCWireColorToIndex
var/list/BorgWireColorToFlag = RandomBorgWires()
var/list/BorgIndexToFlag
var/list/BorgIndexToWireColor
var/list/BorgWireColorToIndex
var/list/AAlarmWireColorToFlag = RandomAAlarmWires()
var/list/AAlarmIndexToFlag
var/list/AAlarmIndexToWireColor
var/list/AAlarmWireColorToIndex

//Don't set this very much higher then 1024 unless you like inviting people in to dos your server with message spam
#define MAX_MESSAGE_LEN			1024
#define MAX_PAPER_MESSAGE_LEN	3072
#define MAX_BOOK_MESSAGE_LEN	9216
#define MAX_NAME_LEN			26

//away missions
var/list/awaydestinations = list()	//a list of landmarks that the warpgate can take you to

// MySQL configuration

var/sqladdress = "localhost"
var/sqlport = "3306"
var/sqldb = "tgstation"
var/sqllogin = "root"
var/sqlpass = ""

// Feedback gathering sql connection

var/sqlfdbkdb = "test"
var/sqlfdbklogin = "root"
var/sqlfdbkpass = ""

var/sqllogging = 0 // Should we log deaths, population stats, etc?



// Forum MySQL configuration (for use with forum account/key authentication)
// These are all default values that will load should the forumdbconfig.txt
// file fail to read for whatever reason.

var/forumsqladdress = "localhost"
var/forumsqlport = "3306"
var/forumsqldb = "tgstation"
var/forumsqllogin = "root"
var/forumsqlpass = ""
var/forum_activated_group = "2"
var/forum_authenticated_group = "10"

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0
var/custom_event_msg = null

//Database connections
//A connection is established on world creation. Ideally, the connection dies when the server restarts (After feedback logging.).
var/DBConnection/dbcon = new()	//Feedback database (New database)
var/DBConnection/dbcon_old = new()	//Tgstation database (Old database) - See the files in the SQL folder for information what goes where.

// TODO: Replace
/proc/RandomAPCWires()
	//to make this not randomize the wires, just set index to 1 and increment it in the flag for loop (after doing everything else).
	var/list/apcwires = list(0, 0, 0, 0)
	APCIndexToFlag = list(0, 0, 0, 0)
	APCIndexToWireColor = list(0, 0, 0, 0)
	APCWireColorToIndex = list(0, 0, 0, 0)
	var/flagIndex = 1
	for(var/flag = 1, flag < 16, flag += flag)
		var/valid = 0
		while(!valid)
			var/colorIndex = rand(1, 4)
			if(apcwires[colorIndex] == 0)
				valid = 1
				apcwires[colorIndex] = flag
				APCIndexToFlag[flagIndex] = flag
				APCIndexToWireColor[flagIndex] = colorIndex
				APCWireColorToIndex[colorIndex] = flagIndex
		flagIndex += 1
	return apcwires