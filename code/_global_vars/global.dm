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