// Moved from /code/game/machinery/computer/supply.dm
/obj/structure/plasticflaps //HOW DO YOU CALL THOSE THINGS ANYWAY
	name = "\improper plastic flaps"
	desc = "I definitely cant get past those. No way."
	icon = 'icons/obj/stationobjs.dmi' //Change this.
	icon_state = "plasticflaps"
	density = FALSE
	anchored = TRUE
	layer = 4
	explosion_resistance = 5

	light_color = "#b88b2e"

/obj/structure/plasticflaps/CanPass(atom/A, turf/T)
	if(istype(A) && A.checkpass(PASSGLASS))
		return prob(60)

	var/obj/structure/stool/bed/B = A
	if(istype(A, /obj/structure/stool/bed) && B.buckled_mob)//if it's a bed/chair and someone is buckled, it will not pass
		return FALSE

	else if(isliving(A)) // You Shall Not Pass!
		var/mob/living/M = A
		if(!M.lying && !ismonkey(M) && !isslime(M) && !ismouse(M) && !isdrone(M))  //If your not laying down, or a small creature, no pass.
			return FALSE
	return ..()

/obj/structure/plasticflaps/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)
		if(3)
			if(prob(5))
				qdel(src)

/obj/structure/plasticflaps/mining //A specific type for mining that doesn't allow airflow because of them damn crates
	name = "\improper Airtight plastic flaps"
	desc = "Heavy duty, airtight, plastic flaps."

/obj/structure/plasticflaps/mining/New() //set the turf below the flaps to block air
	. = ..()
	var/turf/T = get_turf(loc)
	if(isnotnull(T))
		SET_TURF_FLAGS(T, TURF_FLAG_BLOCKS_AIR)

/obj/structure/plasticflaps/mining/Destroy() //lazy hack to set the turf to allow air to pass if it's a simulated floor
	var/turf/T = get_turf(loc)
	if(isnotnull(T))
		if(istype(T, /turf/simulated/floor))
			UNSET_TURF_FLAGS(T, TURF_FLAG_BLOCKS_AIR)
	return ..()