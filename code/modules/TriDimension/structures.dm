///////////////////////////////////////
//Contents: Ladders, Hatches, Stairs.//
///////////////////////////////////////
// Base
/obj/multiz
	icon = 'icons/obj/structures/structures.dmi'
	density = FALSE
	opacity = FALSE
	anchored = TRUE

/obj/multiz/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

// Ladder
/obj/multiz/ladder
	icon_state = "ladderdown"
	name = "ladder"
	desc = "A ladder.  You climb up and down it."

	var/d_state = 1
	var/obj/multiz/target

/obj/multiz/ladder/Destroy()
	spawn(1)
		if(isnotnull(target) && icon_state == "ladderdown")
			QDEL_NULL(target)
	return ..()

/obj/multiz/ladder/attack_paw(mob/M)
	return attack_hand(M)

/obj/multiz/ladder/attackby(obj/item/C, mob/user)
	..(C, user)
// construction commented out for balance concerns
/*	if (!target && istype(C, /obj/item/stack/rods))
		var/turf/controllerlocation = locate(1, 1, z)
		var/found = 0
		var/obj/item/stack/rods/S = C
		if(S.amount < 2)
			user << "You dont have enough rods to finish the ladder."
			return
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if(controller.down)
				found = 1
				var/turf/below = locate(src.x, src.y, controller.down_target)
				var/blocked = 0
				for(var/atom/A in below.contents)
					if(A.density)
						blocked = 1
						break
				if(!blocked && !istype(below, /turf/closed/wall))
					var/obj/multiz/ladder/X = new /obj/multiz/ladder(below)
					S.amount = S.amount - 2
					if(S.amount == 0) S.Del()
					X.icon_state = "ladderup"
					connect()
					user << "You finish the ladder."
				else
					user << "The area below is blocked."
		if(!found)
			user << "You cant build a ladder down there."
		return

	else if(icon_state == "ladderdown" && d_state == 0 && iswrench(C))
		user << "<span class='notice'>You start loosening the anchoring bolts which secure the ladder to the frame.</span>"
		playsound(src.loc, 'sound/items/Ratchet.ogg', 100, 1)

		sleep(30)
		if(!user || !C)	return

		src.d_state = 1
		if(target)
			var/obj/item/stack/rods/R = new /obj/item/stack/rods(target.loc)
			R.amount = 2
			target.Del()

			user << "<span class='notice'>You remove the bolts anchoring the ladder.</span>"
		return

	else if(icon_state == "ladderdown" && d_state == 1 && iswelder(C))
		var/obj/item/weldingtool/WT = C
		if(WT.remove_fuel(0,user))

			user << "<span class='notice'>You begin to remove the ladder.</span>"
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)

			sleep(60)
			if(!user || !WT || !WT.isOn())	return

			var/obj/item/stack/sheet/steel/S = new /obj/item/stack/sheet/steel(src, 2)
			user << "<span class='notice'>You remove the ladder and close the hole.</span>"
			Del()
		return

	else
		src.attack_hand(user)
		return*/
	src.attack_hand(user)
	return

/obj/multiz/ladder/attack_hand(mob/M)
	if(!target || !isturf(target.loc))
		to_chat(M, "The ladder is incomplete and can't be climbed.")
	else
		var/turf/T = target.loc
		var/blocked = FALSE
		for_no_type_check(var/atom/movable/mover, T)
			if(mover.density)
				blocked = TRUE
				break
		if(blocked || istype(T, /turf/closed/wall))
			to_chat(M, "Something is blocking the ladder.")
		else
			M.visible_message(
				SPAN_INFO("\The [M] climbs [src.icon_state == "ladderup" ? "up" : "down"] \the [src]!"),
				"You climb [src.icon_state == "ladderup"  ? "up" : "down"] \the [src]!",
				"You hear some grunting, and clanging of a metal ladder being used."
			)
			M.Move(target.loc)

/*
	ex_act(severity)
		switch(severity)
			if(1.0)
				if(icon_state == "ladderup" && prob(10))
					Del()
			if(2.0)
				if(prob(50))
					Del()
			if(3.0)
				Del()
		return
*/

/obj/multiz/ladder/proc/connect()
	if(icon_state == "ladderdown") // the upper will connect to the lower
		d_state = 1
		var/turf/controllerlocation = locate(1, 1, z)
		for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
			if(controller.down)
				var/turf/below = locate(src.x, src.y, controller.down_target)
				for(var/obj/multiz/ladder/L in below)
					if(L.icon_state == "ladderup")
						target = L
						L.target = src
						d_state = 0
						break
	return

/*
// Hatch
/obj/multiz/ladder/hatch
	icon_state = "hatchdown"
	name = "hatch"
	desc = "A hatch. You climb down it, and it will automatically seal against pressure loss behind you."
	top_icon_state = "hatchdown"
	var/top_icon_state_open = "hatchdown-open"
	var/top_icon_state_close = "hatchdown-close"

	bottom_icon_state = "ladderup"

	var/image/green_overlay
	var/image/red_overlay

	var/active = 0

/obj/multiz/ladder/hatch/New()
	. = ..()
	red_overlay = "red-ladderlight"
	green_overlay = "green-ladderlight"

/obj/multiz/ladder/hatch/attack_hand(var/mob/M)
	if(!target || !isturf(target.loc))
		del src

	if(active)
		to_chat(M, "That [src] is being used.")
		return // It is a tiny airlock, only one at a time.

	active = 1
	var/obj/multiz/ladder/hatch/top_hatch = target
	var/obj/multiz/ladder/hatch/bottom_hatch = src
	if(icon_state == top_icon_state)
		top_hatch = src
		bottom_hatch = target

	flick(top_icon_state_open, top_hatch)
	bottom_hatch.add_overlay(green_overlay)

	spawn(7)
		if(!target || !isturf(target.loc))
			del src
		if(M.z == z && get_dist(src, M) <= 1)
			var/list/adjacent_to_me = global_adjacent_z_levels["[z]"]
			M.visible_message(SPAN_INFO("\The [M] scurries [target.z == adjacent_to_me["up"] ? "up" : "down"] \the [src]!"), "You scramble [target.z == adjacent_to_me["up"] ? "up" : "down"] \the [src]!", "You hear some grunting, and a hatch sealing.")
			M.Move(target.loc)
		flick(top_icon_state_close, top_hatch)
		bottom_hatch.remove_overlay(green_overlay)
		bottom_hatch.add_overlay(red_overlay)

		spawn(7)
			top_hatch.icon_state = top_icon_state
			bottom_hatch.remove_overlay(red_overlay)
			active = 0
*/

// Stairs
/obj/multiz/stairs
	name = "Stairs"
	desc = "Stairs.  You walk up and down them."
	icon_state = "rampbottom"

	var/obj/multiz/stairs/connected
	var/turf/target

/obj/multiz/stairs/initialise()
	. = ..()
	var/turf/cl = locate(1, 1, src.z)
	for(var/obj/effect/landmark/zcontroller/c in cl)
		if(c.up)
			var/turf/O = locate(src.x, src.y, c.up_target)
			if(isspace(O))
				O.ChangeTurf(/turf/open/floor/open)

	for(var/dir in GLOBL.cardinal)
		var/turf/T = get_step(loc, dir)
		for(var/obj/multiz/stairs/S in T)
			if(isnotnull(S) && S.icon_state == "rampbottom" && !S.connected)
				S.set_dir(dir)
				set_dir(dir)
				S.connected = src
				connected = S
				icon_state = "ramptop"
				density = TRUE
				var/turf/controllerlocation = locate(1, 1, z)
				for(var/obj/effect/landmark/zcontroller/controller in controllerlocation)
					if(controller.up)
						var/turf/above = locate(x, y, controller.up_target)
						if(isspace(above) || isopenspace(above))
							target = above
				break
		if(target)
			break

/obj/multiz/stairs/Bumped(atom/movable/M)
	if(connected && target && istype(src, /obj/multiz/stairs) && locate(/obj/multiz/stairs) in M.loc)
		var/obj/multiz/stairs/con = locate(/obj/multiz/stairs) in M.loc
		if(con == src.connected) //make sure the atom enters from the approriate lower stairs tile
			M.Move(target)
	return