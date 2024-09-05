/datum/event/carp_migration
	announceWhen = 50
	endWhen = 900
	oneShot = TRUE

	var/list/mob/living/simple/hostile/carp/spawned_carp = list()

/datum/event/carp_migration/setup()
	announceWhen = rand(40, 60)
	endWhen = rand(600, 1200)

/datum/event/carp_migration/announce()
	command_alert("Unknown biological entities have been detected near [station_name()], please stand-by.", "Lifesign Alert")

/datum/event/carp_migration/start()
	for_no_type_check(var/obj/effect/landmark/C, GLOBL.landmark_list)
		if(C.name == "carpspawn")
			spawned_carp.Add(new /mob/living/simple/hostile/carp(C.loc))

/datum/event/carp_migration/end()
	for_no_type_check(var/mob/living/simple/hostile/carp/C, spawned_carp)
		if(!C.stat)
			var/turf/T = get_turf(C)
			if(isspace(T))
				qdel(C)
