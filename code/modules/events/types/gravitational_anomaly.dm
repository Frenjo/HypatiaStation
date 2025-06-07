/datum/round_event/gravitational_anomaly
	startWhen = 10

	var/obj/effect/bhole/black_hole

/datum/round_event/gravitational_anomaly/setup()
	endWhen = rand(100, 600)

/datum/round_event/gravitational_anomaly/announce()
	priority_announce("Gravitational anomalies detected on the station. There is no additional data.", "Anomaly Alert", 'sound/AI/granomalies.ogg')

/datum/round_event/gravitational_anomaly/start()
	black_hole = new /obj/effect/bhole(GET_TURF(pick(GLOBL.blobstart)), 30)

/datum/round_event/gravitational_anomaly/end()
	QDEL_NULL(black_hole)

// The black hole itself.
/obj/effect/bhole
	name = "black hole"
	icon = 'icons/obj/objects.dmi'
	desc = "FUCK FUCK FUCK AAAHHH"
	icon_state = "bhole3"
	opacity = TRUE
	density = FALSE
	anchored = TRUE

/obj/effect/bhole/New()
	. = ..()
	spawn(4)
		controller()

/obj/effect/bhole/proc/controller()
	while(src)
		if(!isturf(loc))
			qdel(src)
			return

		//DESTROYING STUFF AT THE EPICENTER
		for(var/mob/living/M in orange(1, src))
			qdel(M)
		for(var/obj/O in orange(1, src))
			qdel(O)
		for(var/turf/open/ST in RANGE_TURFS(src, 1))
			ST.ChangeTurf(/turf/space)

		sleep(6)
		grav(10, 4, 10, 0)
		sleep(6)
		grav(8, 4, 10, 0)
		sleep(6)
		grav(9, 4, 10, 0)
		sleep(6)
		grav(7, 3, 40, 1)
		sleep(6)
		grav(5, 3, 40, 1)
		sleep(6)
		grav(6, 3, 40, 1)
		sleep(6)
		grav(4, 2, 50, 6)
		sleep(6)
		grav(3, 2, 50, 6)
		sleep(6)
		grav(2, 2, 75,25)
		sleep(6)

		//MOVEMENT
		if(prob(50))
			src.anchored = FALSE
			step(src, pick(GLOBL.alldirs))
			src.anchored = TRUE

/obj/effect/bhole/proc/grav(r, ex_act_force, pull_chance, turf_removal_chance)
	if(!isturf(loc))	//blackhole cannot be contained inside anything. Weird stuff might happen
		qdel(src)
		return
	for(var/t = -r, t < r, t++)
		affect_coord(x + t, y - r, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x - t, y + r, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x + r, y + t, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x - r, y - t, ex_act_force, pull_chance, turf_removal_chance)
	return

/obj/effect/bhole/proc/affect_coord(x, y, ex_act_force, pull_chance, turf_removal_chance)
	//Get turf at coordinate
	var/turf/T = locate(x, y, z)
	if(isnull(T))
		return

	//Pulling and/or ex_act-ing movable atoms in that turf
	if(prob(pull_chance))
		for(var/obj/O in T.contents)
			if(O.anchored)
				O.ex_act(ex_act_force)
			else
				step_towards(O, src)
		for(var/mob/living/M in T.contents)
			step_towards(M, src)

	//Destroying the turf
	if(T && isopenturf(T) && prob(turf_removal_chance))
		var/turf/open/ST = T
		ST.ChangeTurf(/turf/space)
	return