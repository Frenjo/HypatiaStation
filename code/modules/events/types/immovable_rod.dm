/*
Immovable rod random event.
The rod will spawn at some location outside the station, and travel in a straight line to the opposite side of the station
Everything solid in the way will be ex_act()'d
In my current plan for it, 'solid' will be defined as anything with density == 1

--NEOFite
*/
/datum/round_event/immovable_rod
	announce_when = 5

/datum/round_event/immovable_rod/announce()
	priority_announce("What the fuck was that?!", "General Alert")

/datum/round_event/immovable_rod/start()
	var/startx = 0
	var/starty = 0
	var/endy = 0
	var/endx = 0
	var/startside = pick(GLOBL.cardinal)

	switch(startside)
		if(NORTH)
			starty = 187
			startx = rand(41, 199)
			endy = 38
			endx = rand(41, 199)
		if(EAST)
			starty = rand(38, 187)
			startx = 199
			endy = rand(38, 187)
			endx = 41
		if(SOUTH)
			starty = 38
			startx = rand(41, 199)
			endy = 187
			endx = rand(41, 199)
		if(WEST)
			starty = rand(38, 187)
			startx = 41
			endy = rand(38, 187)
			endx = 199

	// Rod time!
	new /obj/effect/immovablerod(locate(startx, starty, 1), locate(endx, endy, 1))

/obj/effect/immovablerod
	name = "Immovable Rod"
	desc = "What the fuck is that?"
	icon = 'icons/obj/objects.dmi'
	icon_state = "immrod"
	throwforce = 100
	density = TRUE
	anchored = TRUE

	var/original_z = 0
	var/turf/destination = null

/obj/effect/immovablerod/New(turf/start, turf/end)
	. = ..(start)
	original_z = z
	destination = end
	if(end?.z == original_z)
		walk_towards(src, destination, 1)

/obj/effect/immovablerod/Move()
	if(z != original_z || loc == destination)
		qdel(src)
	return ..()

/obj/effect/immovablerod/Bump(atom/clong)
	if(istype(clong, /turf/closed/wall/shuttle) || istype(clong, /turf/open/floor/shuttle)) //Skip shuttles without actually deleting the rod
		return

	else if(isturf(clong))
		if(clong.density)
			clong.ex_act(2)
			for(var/mob/O in hearers(src, null))
				O.show_message("CLANG", 2)

	else if(isobj(clong))
		if(clong.density)
			clong.ex_act(2)
			for(var/mob/O in hearers(src, null))
				O.show_message("CLANG", 2)

	else if(ismob(clong))
		if(clong.density || prob(10))
			clong.meteorhit(src)
	else
		qdel(src)

	if(clong && prob(25))
		forceMove(clong.loc)