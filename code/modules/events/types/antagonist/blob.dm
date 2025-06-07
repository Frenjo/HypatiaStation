/datum/round_event/blob
	announce_when = 12
	end_when = 120

	var/obj/effect/blob/core/blob = null

/datum/round_event/blob/announce()
	priority_announce(
		"Confirmed outbreak of level 5 biohazard aboard [station_name()]. All personnel must contain the outbreak.",
		"Biohazard Alert", 'sound/AI/outbreak5.ogg'
	)

/datum/round_event/blob/start()
	var/turf/T = pick(GLOBL.blobstart)
	if(isnull(T))
		kill()
		return
	blob = new /obj/effect/blob/core(T, 120)
	for(var/i = 1; i < rand(3, 4), i++)
		blob.process()

/datum/round_event/blob/tick()
	if(isnull(blob))
		kill()
		return
	if(IsMultiple(active_for, 3))
		blob.process()