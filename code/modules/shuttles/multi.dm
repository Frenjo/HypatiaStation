// Ported 'shuttles' module from Heaven's Gate - NSS Eternal, 22/11/2019...
// As part of the docking controller port, because rewriting that code is spaghetti.
// And I ain't doing it. -Frenjo

//This is a holder for things like the Vox and Nuke shuttle.
/datum/shuttle/multi_shuttle
	var/cloaked = 1
	var/at_origin = 1
	var/returned_home = FALSE
	var/move_time = 240
	var/cooldown = 20 SECONDS
	COOLDOWN_DECLARE(move_cooldown)

	var/announcer
	var/arrival_message
	var/departure_message

	var/area/interim
	var/area/last_departed
	var/list/destinations
	var/area/origin
	var/return_warning = FALSE

/datum/shuttle/multi_shuttle/New()
	. = ..()
	if(isnotnull(origin))
		last_departed = origin

/datum/shuttle/multi_shuttle/move(area/origin, area/destination)
	. = ..()
	COOLDOWN_START(src, move_cooldown, cooldown)
	if(destination == src.origin)
		returned_home = TRUE

/datum/shuttle/multi_shuttle/proc/announce_departure()
	if(cloaked || isnull(departure_message))
		return

	priority_announce(departure_message, (announcer ? announcer : "Central Command"))

/datum/shuttle/multi_shuttle/proc/announce_arrival()
	if(cloaked || isnull(arrival_message))
		return

	priority_announce(arrival_message, (announcer ? announcer : "Central Command"))