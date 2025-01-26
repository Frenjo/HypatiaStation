// BIOMASS (Note that this code is very similar to Space Vine code)
/obj/effect/biomass
	name = "biomass"
	desc = "Space barf from another dimension. It just keeps spreading!"
	icon = 'icons/obj/biomass.dmi'
	icon_state = "stage1"
	anchored = TRUE
	density = FALSE
	layer = 5
	pass_flags = PASS_FLAG_TABLE | PASS_FLAG_GRILLE

	var/energy = 0
	var/obj/effect/biomass_controller/master = null

/obj/effect/biomass/New()
	SHOULD_CALL_PARENT(FALSE)

/obj/effect/biomass/Destroy()
	if(isnotnull(master))
		master.vines.Remove(src)
		master.growth_queue.Remove(src)
	return ..()

/obj/effect/biomass/attackby(obj/item/W, mob/user)
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
			else if(iswelder(W))
				var/obj/item/weldingtool/WT = W
				if(WT.remove_fuel(0, user))
					qdel(src)
			else
				return
	..()

/obj/effect/biomass_controller
	var/list/obj/effect/biomass/vines = list()
	var/list/growth_queue = list()
	var/reached_collapse_size
	var/reached_slowdown_size
	//What this does is that instead of having the grow minimum of 1, required to start growing, the minimum will be 0,
	//meaning if you get the biomasssss..s' size to something less than 20 plots, it won't grow anymore.

/obj/effect/biomass_controller/New()
	. = ..()
	if(!isfloorturf(src.loc))
		qdel(src)

	spawn_biomass_piece(src.loc)
	GLOBL.processing_objects.Add(src)

/obj/effect/biomass_controller/Destroy()
	GLOBL.processing_objects.Remove(src)
	return ..()

/obj/effect/biomass_controller/proc/spawn_biomass_piece(turf/location)
	var/obj/effect/biomass/BM = new(location)
	growth_queue += BM
	vines += BM
	BM.master = src

/obj/effect/biomass_controller/process()
	if(!vines)
		qdel(src) //space  vines exterminated. Remove the controller
		return
	if(!growth_queue)
		qdel(src) //Sanity check
		return
	if(length(vines) >= 250 && !reached_collapse_size)
		reached_collapse_size = 1
	if(length(vines) >= 30 && !reached_slowdown_size )
		reached_slowdown_size = 1

	var/maxgrowth = 0
	if(reached_collapse_size)
		maxgrowth = 0
	else if(reached_slowdown_size)
		if(prob(25))
			maxgrowth = 1
		else
			maxgrowth = 0
	else
		maxgrowth = 4
	var/length = min(30, length(vines) / 5)
	var/i = 0
	var/growth = 0
	var/list/obj/effect/biomass/queue_end = list()

	for(var/obj/effect/biomass/BM in growth_queue)
		i++
		queue_end += BM
		growth_queue -= BM
		if(BM.energy < 2) //If tile isn't fully grown
			if(prob(20))
				BM.grow()

		if(BM.spread())
			growth++
			if(growth >= maxgrowth)
				break
		if(i >= length)
			break

	growth_queue = growth_queue + queue_end

/obj/effect/biomass/proc/grow()
	if(!energy)
		src.icon_state = "stage2"
		energy = 1
		src.opacity = FALSE
		src.density = FALSE
		layer = 5
	else
		src.icon_state = "stage3"
		src.opacity = FALSE
		src.density = TRUE
		energy = 2

/obj/effect/biomass/proc/spread()
	var/direction = pick(GLOBL.cardinal)
	var/step = get_step(src, direction)
	if(isfloorturf(step))
		var/turf/open/floor/F = step
		if(!locate(/obj/effect/biomass, F))
			if(F.Enter(src))
				if(master)
					master.spawn_biomass_piece(F)
					return 1
	return 0

/obj/effect/biomass/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(90))
				qdel(src)
				return
		if(3.0)
			if(prob(50))
				qdel(src)
				return
	return

/obj/effect/biomass/fire_act(null, temp, volume) //hotspots kill biomass
	qdel(src)

/proc/biomass_infestation()
	spawn() //to stop the secrets panel hanging
		var/list/turf/open/floor/turfs = list() //list of all the empty floor turfs in the hallway areas
		for(var/areapath in typesof(/area/station/hallway))
			var/area/A = locate(areapath)
			//for(var/area/B in A.related)
				//for(var/turf/open/floor/F in B.turf_list)
					//if(!length(F.contents))
						//turfs += F
			for(var/turf/open/floor/F in A.turf_list)
				if(!length(F.contents))
					turfs += F

		if(length(turfs)) //Pick a turf to spawn at if we can
			var/turf/open/floor/T = pick(turfs)
			new/obj/effect/biomass_controller(T) //spawn a controller at turf
			message_admins("\blue Event: Biomass spawned at [T.loc.loc] ([T.x],[T.y],[T.z])")