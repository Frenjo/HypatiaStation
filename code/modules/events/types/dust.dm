//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/*
Space dust
Commonish random event that causes small clumps of "space dust" to hit the station at high speeds.
No command report on the common version of this event.
The "dust" will damage the hull of the station causin minor hull breaches.
*/
/datum/round_event/space_dust
	var/quantity = 1
	var/min_quantity = 5
	var/max_quantity = 10
	var/dust_type = /obj/effect/space_dust

/datum/round_event/space_dust/setup()
	quantity = rand(min_quantity, max_quantity)

/datum/round_event/space_dust/start()
	while(quantity-- > 0)
		new dust_type()

/datum/round_event/space_dust/weak
	min_quantity = 2
	max_quantity = 4
	dust_type = /obj/effect/space_dust/weak

/datum/round_event/space_dust/strong
	min_quantity = 10
	max_quantity = 15
	dust_type = /obj/effect/space_dust/strong

/datum/round_event/space_dust/super
	min_quantity = 15
	max_quantity = 25
	dust_type = /obj/effect/space_dust/super

// The dust itself.
/obj/effect/space_dust
	name = "space dust"
	desc = "Dust in space."
	icon = 'icons/obj/meteor.dmi'
	icon_state = "space_dust"
	density = TRUE
	anchored = TRUE

	var/strength = 2 //ex_act severity number
	var/life = 2 //how many things we hit before qdel(src)

/obj/effect/space_dust/weak
	strength = 3
	life = 1

/obj/effect/space_dust/strong
	strength = 1
	life = 6

/obj/effect/space_dust/super
	strength = 1
	life = 40

/obj/effect/space_dust/New()
	..()
	var/startx = 0
	var/starty = 0
	var/endy = 0
	var/endx = 0
	var/startside = pick(GLOBL.cardinal)

	switch(startside)
		if(NORTH)
			starty = world.maxy - (TRANSITIONEDGE + 1)
			startx = rand((TRANSITIONEDGE + 1), world.maxx - (TRANSITIONEDGE + 1))
			endy = TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx - TRANSITIONEDGE)
		if(EAST)
			starty = rand((TRANSITIONEDGE + 1), world.maxy - (TRANSITIONEDGE + 1))
			startx = world.maxx - (TRANSITIONEDGE + 1)
			endy = rand(TRANSITIONEDGE, world.maxy - TRANSITIONEDGE)
			endx = TRANSITIONEDGE
		if(SOUTH)
			starty = (TRANSITIONEDGE + 1)
			startx = rand((TRANSITIONEDGE + 1), world.maxx - (TRANSITIONEDGE + 1))
			endy = world.maxy-TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(WEST)
			starty = rand((TRANSITIONEDGE + 1), world.maxy - (TRANSITIONEDGE + 1))
			startx = (TRANSITIONEDGE + 1)
			endy = rand(TRANSITIONEDGE, world.maxy - TRANSITIONEDGE)
			endx = world.maxx - TRANSITIONEDGE

	var/goal = locate(endx, endy, 1)
	src.x = startx
	src.y = starty
	src.z = pick(GLOBL.current_map.station_levels)
	spawn(0)
		walk_towards(src, goal, 1)
	return

/obj/effect/space_dust/Bump(atom/A)
	spawn(0)
		if(prob(50))
			for(var/mob/M in range(10, src))
				if(!M.stat && !isAI(M))
					shake_camera(M, 3, 1)
		if(A)
			playsound(src, 'sound/effects/meteorimpact.ogg', 40, 1)

			if(ismob(A))
				A.meteorhit(src)//This should work for now I guess
			else if(!istype(A, /obj/machinery/power/emitter) && !istype(A, /obj/machinery/field_generator)) //Protect the singularity from getting released every round!
				A.ex_act(strength) //Changing emitter/field gen ex_act would make it immune to bombs and C4

			life--
			if(life <= 0)
				walk(src, 0)
				spawn(1)
					qdel(src)
				return
	return

/obj/effect/space_dust/Bumped(atom/A)
	Bump(A)
	return

/obj/effect/space_dust/ex_act(severity)
	qdel(src)
	return