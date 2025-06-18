/datum/round_event/gravitational_anomaly
	start_when = 10

	var/obj/effect/bhole/black_hole

/datum/round_event/gravitational_anomaly/setup()
	end_when = rand(100, 600)

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

/obj/effect/bhole/initialise()
	. = ..()
	controller()

/obj/effect/bhole/proc/controller()
	set waitfor = FALSE

	while(src)
		if(!isturf(loc))
			qdel(src)
			return

		// DESTROYS STUFF AT THE EPICENTER.
		for(var/mob/living/M in orange(1, src))
			qdel(M)
		for(var/obj/O in orange(1, src))
			qdel(O)
		for(var/turf/open/open_turf in RANGE_TURFS(src, 1))
			open_turf.ChangeTurf(/turf/space)

		sleep(0.6 SECONDS)
		grav(10, 4, 10, 0)
		sleep(0.6 SECONDS)
		grav(8, 4, 10, 0)
		sleep(0.6 SECONDS)
		grav(9, 4, 10, 0)
		sleep(0.6 SECONDS)
		grav(7, 3, 40, 1)
		sleep(0.6 SECONDS)
		grav(5, 3, 40, 1)
		sleep(0.6 SECONDS)
		grav(6, 3, 40, 1)
		sleep(0.6 SECONDS)
		grav(4, 2, 50, 6)
		sleep(0.6 SECONDS)
		grav(3, 2, 50, 6)
		sleep(0.6 SECONDS)
		grav(2, 2, 75, 25)
		sleep(0.6 SECONDS)

		//MOVEMENT
		if(prob(50))
			anchored = FALSE
			step(src, pick(GLOBL.alldirs))
			anchored = TRUE

/obj/effect/bhole/proc/grav(r, ex_act_force, pull_chance, turf_removal_chance)
	if(!isturf(loc)) // Blackhole cannot be contained inside anything. Weird stuff might happen.
		qdel(src)
		return

	for(var/t = -r, t < r, t++)
		affect_coord(x + t, y - r, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x - t, y + r, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x + r, y + t, ex_act_force, pull_chance, turf_removal_chance)
		affect_coord(x - r, y - t, ex_act_force, pull_chance, turf_removal_chance)

/obj/effect/bhole/proc/affect_coord(x, y, ex_act_force, pull_chance, turf_removal_chance)
	// Get turf at coordinate.
	var/turf/T = locate(x, y, z)
	if(isnull(T))
		return

	// Pulling and/or ex_act-ing movable atoms in that turf.
	if(prob(pull_chance))
		for(var/obj/O in T)
			if(O.anchored)
				O.ex_act(ex_act_force)
			else
				step_towards(O, src)
		for(var/mob/living/M in T)
			step_towards(M, src)

	// Destroys the turf.
	if(isnotnull(T) && isopenturf(T) && prob(turf_removal_chance))
		var/turf/open/open_turf = T
		open_turf.ChangeTurf(/turf/space)