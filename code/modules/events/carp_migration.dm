/datum/event/carp_migration
	announceWhen = 50
	endWhen = 900
	oneShot = TRUE

	var/list/spawned_carp = list()

/datum/event/carp_migration/setup()
	announceWhen = rand(40, 60)
	endWhen = rand(600,1200)

/datum/event/carp_migration/announce()
	command_alert("Unknown biological entities have been detected near [station_name()], please stand-by.", "Lifesign Alert")

/datum/event/carp_migration/start()
	for(var/obj/effect/landmark/C in GLOBL.landmarks_list)
		if(C.name == "carpspawn")
			spawned_carp.Add(new /mob/living/simple_animal/hostile/carp(C.loc))

/datum/event/carp_migration/end()
	for(var/mob/living/simple_animal/hostile/carp/C in spawned_carp)
		if(!C.stat)
			var/turf/T = get_turf(C)
			if(isspace(T))
				qdel(C)
