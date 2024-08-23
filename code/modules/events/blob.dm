/datum/event/blob
	announceWhen	= 12
	endWhen			= 120

	var/obj/effect/blob/core/blob = null

/datum/event/blob/announce()
	command_alert("Confirmed outbreak of level 7 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert")
	world << sound('sound/AI/outbreak7.ogg')

/datum/event/blob/start()
	var/turf/T = pick(GLOBL.blobstart)
	if(isnull(T))
		kill()
		return
	blob = new /obj/effect/blob/core(T, 120)
	for(var/i = 1; i < rand(3, 4), i++)
		blob.process()

/datum/event/blob/tick()
	if(isnull(blob))
		kill()
		return
	if(IsMultiple(activeFor, 3))
		blob.process()