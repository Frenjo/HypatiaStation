GLOBAL_GLOBL_LIST_NEW(spawntypes)

/proc/populate_spawn_points()
	for(var/type in SUBTYPESOF(/datum/spawnpoint))
		var/datum/spawnpoint/S = new type()
		GLOBL.spawntypes[S.display_name] = S

/datum/spawnpoint
	var/msg				//Message to display on the arrivals computer.
	var/list/turfs		//List of turfs to spawn on.
	var/display_name	//Name used in preference setup.

/datum/spawnpoint/arrivals
	display_name = "Arrivals Shuttle"
	msg = "has arrived on the station"

/datum/spawnpoint/arrivals/New()
	..()
	turfs = GLOBL.latejoin

/*
/datum/spawnpoint/gateway
	display_name = "Gateway"
	msg = "has completed translation from offsite gateway"
/datum/spawnpoint/gateway/New()
	..()
	turfs = global.latejoin_gateway
*/

/datum/spawnpoint/cryo
	display_name = "Cryogenic Storage"
	msg = "has completed cryogenic revival"

/datum/spawnpoint/cryo/New()
	..()
	turfs = GLOBL.latejoin_cryo