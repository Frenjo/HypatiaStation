/*
Immovable rod random event.
The rod will spawn at some location outside the station, and travel in a straight line to the opposite side of the station
Everything solid in the way will be ex_act()'d
In my current plan for it, 'solid' will be defined as anything with density == 1

--NEOFite
*/
/obj/effect/immovablerod
	name = "Immovable Rod"
	desc = "What the fuck is that?"
	icon = 'icons/obj/objects.dmi'
	icon_state = "immrod"
	throwforce = 100
	density = TRUE
	anchored = TRUE

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

/proc/immovablerod()
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

	//rod time!
	var/obj/effect/immovablerod/immrod = new /obj/effect/immovablerod(locate(startx, starty, 1))
	//to_world("Rod in play, starting at [start.loc.x],[start.loc.y] and going to [end.loc.x],[end.loc.y]")
	var/end = locate(endx, endy, 1)
	spawn(0)
		walk_towards(immrod, end, 1)
	sleep(1)
	while(immrod)
		if(isnotstationlevel(immrod.z))
			immrod.z = pick(GLOBL.current_map.station_levels)
		if(immrod.loc == end)
			qdel(immrod)
		sleep(10)
	for(var/obj/effect/immovablerod/imm in GLOBL.movable_atom_list)
		return
	sleep(50)
	priority_announce("What the fuck was that?!", "General Alert")