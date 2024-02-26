// SPACE VINES (Note that this code is very similar to Biomass code)
/obj/effect/spacevine
	name = "space vines"
	desc = "An extremely expansionistic species of vine."
	icon = 'icons/effects/spacevines.dmi'
	icon_state = "Light1"
	anchored = TRUE
	density = FALSE
	layer = 5
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE

	var/energy = 0
	var/obj/effect/spacevine_controller/master = null
	var/mob/living/buckled_mob

/obj/effect/spacevine/New()
	SHOULD_CALL_PARENT(FALSE)

/obj/effect/spacevine/Destroy()
	if(master)
		master.vines -= src
		master.growth_queue -= src
	return ..()

/obj/effect/spacevine/attackby(obj/item/W as obj, mob/user as mob)
	if(!W || !user || !W.type)
		return

	switch(W.type)
		if(/obj/item/circular_saw)
			qdel(src)
		if(/obj/item/kitchen/utensil/knife)
			qdel(src)
		if(/obj/item/scalpel)
			qdel(src)
		if(/obj/item/twohanded/fireaxe)
			qdel(src)
		if(/obj/item/hatchet)
			qdel(src)
		if(/obj/item/melee/energy)
			qdel(src)

		//less effective weapons
		if(/obj/item/wirecutters)
			if(prob(25))
				qdel(src)
		if(/obj/item/shard)
			if(prob(25))
				qdel(src)

		else //weapons with subtypes
			if(istype(W, /obj/item/melee/energy/sword))
				qdel(src)
			else if(istype(W, /obj/item/weldingtool))
				var/obj/item/weldingtool/WT = W
				if(WT.remove_fuel(0, user))
					qdel(src)
			else
				manual_unbuckle(user)
				return
		//Plant-b-gone damage is handled in its entry in chemistry-reagents.dm
	..()

/obj/effect/spacevine/attack_hand(mob/user as mob)
	manual_unbuckle(user)

/obj/effect/spacevine/attack_paw(mob/user as mob)
	manual_unbuckle(user)

/obj/effect/spacevine/proc/unbuckle()
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
		buckled_mob = null
	return

/obj/effect/spacevine/proc/manual_unbuckle(mob/user as mob)
	if(buckled_mob)
		if(prob(50))
			if(buckled_mob.buckled == src)
				if(buckled_mob != user)
					buckled_mob.visible_message(\
						SPAN_NOTICE("[user.name] frees [buckled_mob.name] from the vines."),\
						SPAN_NOTICE("[user.name] frees you from the vines."),\
						SPAN_WARNING("You hear shredding and ripping."))
				else
					buckled_mob.visible_message(\
						SPAN_NOTICE("[buckled_mob.name] struggles free of the vines."),\
						SPAN_NOTICE("You untangle the vines from around yourself."),\
						SPAN_WARNING("You hear shredding and ripping."))
			unbuckle()
		else
			var/text = pick("rips", "tears", "pulls")
			user.visible_message(\
				SPAN_NOTICE("[user.name] [text] at the vines."),\
				SPAN_NOTICE("You [text] at the vines."),\
				SPAN_WARNING("You hear shredding and ripping."))
	return

/obj/effect/spacevine_controller
	var/list/obj/effect/spacevine/vines = list()
	var/list/growth_queue = list()
	var/reached_collapse_size
	var/reached_slowdown_size
	//What this does is that instead of having the grow minimum of 1, required to start growing, the minimum will be 0,
	//meaning if you get the spacevines' size to something less than 20 plots, it won't grow anymore.

/obj/effect/spacevine_controller/New()
	. = ..()
	if(!istype(src.loc, /turf/simulated/floor))
		qdel(src)

	spawn_spacevine_piece(src.loc)
	GLOBL.processing_objects.Add(src)

/obj/effect/spacevine_controller/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/effect/spacevine_controller/proc/spawn_spacevine_piece(turf/location)
	var/obj/effect/spacevine/SV = new(location)
	growth_queue += SV
	vines += SV
	SV.master = src

/obj/effect/spacevine_controller/process()
	if(!vines)
		qdel(src) //space vines exterminated. Remove the controller
		return
	if(!growth_queue)
		qdel(src) //Sanity check
		return
	if(length(vines) >= 250 && !reached_collapse_size)
		reached_collapse_size = 1
	if(length(vines) >= 30 && !reached_slowdown_size)
		reached_slowdown_size = 1

	var/length = 0
	if(reached_collapse_size)
		length = 0
	else if(reached_slowdown_size)
		if(prob(25))
			length = 1
		else
			length = 0
	else
		length = 1
	length = min(30, max(length, length(vines) / 5))
	var/i = 0
	var/list/obj/effect/spacevine/queue_end = list()

	for(var/obj/effect/spacevine/SV in growth_queue)
		i++
		queue_end += SV
		growth_queue -= SV
		if(SV.energy < 2) //If tile isn't fully grown
			if(prob(20))
				SV.grow()
		else //If tile is fully grown
			SV.buckle_mob()

		//if(prob(25))
		SV.spread()
		if(i >= length)
			break

	growth_queue = growth_queue + queue_end
	//sleep(5)
	//src.process()

/obj/effect/spacevine/proc/grow()
	if(!energy)
		src.icon_state = pick("Med1", "Med2", "Med3")
		energy = 1
		src.set_opacity(1)
		layer = 5
	else
		src.icon_state = pick("Hvy1", "Hvy2", "Hvy3")
		energy = 2

/obj/effect/spacevine/proc/buckle_mob()
	if(!buckled_mob && prob(25))
		for(var/mob/living/carbon/V in src.loc)
			if((V.stat != DEAD) && (V.buckled != src)) //if mob not dead or captured
				V.buckled = src
				V.loc = src.loc
				V.update_canmove()
				src.buckled_mob = V
				to_chat(V, SPAN_DANGER("The vines [pick("wind", "tangle", "tighten")] around you!"))
				break //only capture one mob at a time.

/obj/effect/spacevine/proc/spread()
	var/direction = pick(GLOBL.cardinal)
	var/step = get_step(src, direction)
	if(istype(step, /turf/simulated/floor))
		var/turf/simulated/floor/F = step
		if(!locate(/obj/effect/spacevine, F))
			if(F.Enter(src))
				if(master)
					master.spawn_spacevine_piece(F)

/*
/obj/effect/spacevine/proc/Life()
	if (!src) return
	var/Vspread
	if (prob(50)) Vspread = locate(src.x + rand(-1,1),src.y,src.z)
	else Vspread = locate(src.x,src.y + rand(-1, 1),src.z)
	var/dogrowth = 1
	if (!istype(Vspread, /turf/simulated/floor)) dogrowth = 0
	for(var/obj/O in Vspread)
		if (istype(O, /obj/structure/window) || istype(O, /obj/effect/forcefield) || istype(O, /obj/effect/blob) || istype(O, /obj/effect/alien/weeds) || istype(O, /obj/effect/spacevine)) dogrowth = 0
		if (istype(O, /obj/machinery/door/))
			if(O:p_open == 0 && prob(50)) O:open()
			else dogrowth = 0
	if (dogrowth == 1)
		var/obj/effect/spacevine/B = new /obj/effect/spacevine(Vspread)
		B.icon_state = pick("vine-light1", "vine-light2", "vine-light3")
		spawn(20)
			if(B)
				B.Life()
	src.growth += 1
	if (src.growth == 10)
		src.name = "Thick Space Kudzu"
		src.icon_state = pick("vine-med1", "vine-med2", "vine-med3")
		src.opacity = TRUE
		src.waittime = 80
	if (src.growth == 20)
		src.name = "Dense Space Kudzu"
		src.icon_state = pick("vine-hvy1", "vine-hvy2", "vine-hvy3")
		src.density = TRUE
	spawn(src.waittime)
		if (src.growth < 20) src.Life()
*/

/obj/effect/spacevine/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(90))
				qdel(src)
				return
		if(3.0)
			if (prob(50))
				qdel(src)
				return
	return

/obj/effect/spacevine/fire_act(null, temp, volume) //hotspots kill vines
	qdel(src)

//Carn: Spacevines random event.
/proc/spacevine_infestation()
	spawn() //to stop the secrets panel hanging
		var/list/turf/simulated/floor/turfs = list() //list of all the empty floor turfs in the hallway areas
		for(var/areapath in typesof(/area/hallway))
			var/area/A = locate(areapath)
			//for(var/area/B in A.related)
			//	for(var/turf/simulated/floor/F in B.contents)
			//		if(!length(F.contents))
			//			turfs += F
			for(var/turf/simulated/floor/F in A.contents)
				if(!length(F.contents))
					turfs += F

		if(length(turfs)) //Pick a turf to spawn at if we can
			var/turf/simulated/floor/T = pick(turfs)
			new/obj/effect/spacevine_controller(T) //spawn a controller at turf
			message_admins(SPAN_INFO("Event: Spacevines spawned at [T.loc] ([T.x],[T.y],[T.z])"))