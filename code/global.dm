//#define TESTING
//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//////////////
var/skipupdate = 0
///////////////
var/event = 0
///////////////

var/datum/air_tunnel/air_tunnel1/SS13_airtunnel = null

var/datum/engine_eject/engine_eject_control = null
//var/goonsay_allowed = 0
var/dna_ident = 1
var/shuttle_frozen = 0
var/shuttle_left = 0

var/list/jobMax = list()
var/list/shuttles = list()
//list/traitobj = list()

var/shuttle_z = 2	//default
var/airtunnel_start = 68 // default
var/airtunnel_stop = 68 // default
var/airtunnel_bottom = 72 // default

//list/traitors = list()	//traitor list
// reverse_dir[dir] = reverse of dir
var/list/reverse_dir = list(
	2, 1, 3, 8, 10, 9, 11, 4, 6, 5, 7,
	12, 14, 13, 15, 32, 34, 33, 35, 40,
	42, 41, 43, 36, 38, 37, 39, 44, 46,
	45, 47, 16, 18, 17, 19, 24, 26, 25,
	27, 20, 22, 21, 23, 28, 30, 29, 31,
	48, 50, 49, 51, 56, 58, 57, 59, 52,
	54, 53, 55, 60, 62, 61, 63
)

var/datum/debug/debugobj

var/shuttlecoming = 0

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

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0
var/custom_event_msg = null

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