/datum/round_event/wormholes
	announce_when = 10
	end_when = 60

	var/list/turf/open/floor/pickable_turfs = list()
	var/list/obj/effect/portal/wormhole/wormholes = list()

	var/static/shift_frequency = 3
	var/static/total_wormholes = 1000

/datum/round_event/wormholes/setup()
	announce_when = rand(0, 20)
	end_when = rand(40, 80)

/datum/round_event/wormholes/announce()
	// Announces that bad juju is afoot.
	priority_announce("Space-time anomalies detected on the station. There is no additional data.", "Anomaly Alert", 'sound/AI/spanomalies.ogg')

/datum/round_event/wormholes/start()
	for(var/turf/open/floor/valid in GLOBL.open_turf_list)
		if(valid.z != 1)
			continue
		pickable_turfs.Add(valid)

	// Gets our entry and exit locations.
	for(var/i in 1 to total_wormholes)
		var/turf/open/floor/entry = pick(pickable_turfs)
		var/turf/open/floor/exit = pick(pickable_turfs)
		wormholes.Add(new /obj/effect/portal/wormhole(entry, exit))

/datum/round_event/wormholes/tick()
	if(IsMultiple(active_for, shift_frequency))
		for_no_type_check(var/obj/effect/portal/wormhole/hole, wormholes)
			var/turf/open/floor/T = pick(pickable_turfs)
			hole.forceMove(T)

/datum/round_event/wormholes/end()
	for_no_type_check(var/obj/effect/portal/wormhole/hole, wormholes)
		qdel(hole)
	QDEL_NULL(wormholes)

/obj/effect/portal/wormhole
	name = "wormhole"
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"

	failchance = 0

/obj/effect/portal/wormhole/New(loc, turf/exit)
	. = ..(loc)
	delete_time = rand(30 SECONDS, 1 MINUTE)
	target = exit