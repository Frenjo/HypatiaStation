//I will need to recode parts of this but I am way too tired atm
/obj/effect/blob
	name = "blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob"
	//luminosity = 3
	light_range = 3
	desc = "Some blob creature thingy"
	density = TRUE
	opacity = FALSE
	anchored = TRUE

	var/active = 1
	var/health = 30
	var/brute_resist = 4
	var/fire_resist = 1
	var/blob_type = "blob"
	/*Types
	Blob
	Node
	Core
	Factory
	Shield
		*/

/obj/effect/blob/New(loc, h = 30)
	GLOBL.blobs.Add(src)
	src.health = h
	src.set_dir(pick(1, 2, 4, 8))
	src.update_icon()
	. = ..(loc)

/obj/effect/blob/Destroy()
	GLOBL.blobs.Remove(src)
	return ..()

/obj/effect/blob/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || height == 0)
		return TRUE
	if(istype(mover) && HAS_PASS_FLAGS(mover, PASS_FLAG_BLOB))
		return TRUE
	return FALSE

/obj/effect/blob/process()
	spawn(-1)
		Life()

/obj/effect/blob/proc/Pulse(pulse = 0, origin_dir = 0)//Todo: Fix spaceblob expand
	set background = BACKGROUND_ENABLED
	if(!istype(src, /obj/effect/blob/core) && !istype(src, /obj/effect/blob/node))//Ill put these in the children later
		if(run_action())//If we can do something here then we dont need to pulse more
			return

	if(!istype(src, /obj/effect/blob/shield) && !istype(src, /obj/effect/blob/core) && !istype(src, /obj/effect/blob/node) && (pulse <= 2) && (prob(30)))
		change_to("Shield")
		return

	if(pulse > 20)
		return//Inf loop check
	//Looking for another blob to pulse
	var/list/dirs = list(1, 2, 4, 8)
	dirs.Remove(origin_dir)//Dont pulse the guy who pulsed us
	for(var/i = 1 to 4)
		if(!length(dirs))
			break
		var/dirn = pick(dirs)
		dirs.Remove(dirn)
		var/turf/T = get_step(src, dirn)
		var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)
		if(isnull(B))
			expand(T)//No blob here so try and expand
			return
		B.Pulse((pulse + 1), get_dir(src.loc, T))

/obj/effect/blob/proc/run_action()
	return 0

/obj/effect/blob/proc/Life()
	update_icon()
	if(run_action())
		return 1
	return 0

/*	fire_act(datum/gas_mixture/air, temperature, volume) Blob is currently fireproof
		if(temperature > T0C+200)
			health -= 0.01 * temperature
			update()
			*/

/obj/effect/blob/proc/expand(turf/T = null)
	if(!prob(health))
		return
	if(isnull(T))
		var/list/dirs = list(1, 2, 4, 8)
		for(var/i = 1 to 4)
			var/dirn = pick(dirs)
			dirs.Remove(dirn)
			T = get_step(src, dirn)
			if(!(locate(/obj/effect/blob) in T))
				break
			else
				T = null

	if(isnull(T))
		return 0
	var/obj/effect/blob/B = new /obj/effect/blob(loc, min(health, 30))
	if(T.Enter(B, src))//Attempt to move into the tile
		B.forceMove(T)
	else
		T.blob_act()//If we cant move in hit the turf
		qdel(B)
	for_no_type_check(var/atom/movable/mover, T) // Hit everything in the turf.
		mover.blob_act()
	return 1

/obj/effect/blob/ex_act(severity)
	var/damage = 50
	switch(severity)
		if(1)
			health -= rand(100, 120)
		if(2)
			health -= rand(60, 100)
		if(3)
			health -= rand(20, 60)

	health -= (damage / brute_resist)
	update_icon()

/obj/effect/blob/update_icon()//Needs to be updated with the types
	if(health <= 0)
		playsound(src, 'sound/effects/splat.ogg', 50, 1)
		qdel(src)
		return
	if(health <= 15)
		icon_state = "blob_damaged"
		return
//	if(health <= 20)
//		icon_state = "blob_damaged2"
//		return

/obj/effect/blob/bullet_act(obj/item/projectile/proj)
	if(isnull(proj))
		return

	switch(proj.damage_type)
		if(BRUTE)
			health -= (proj.damage / brute_resist)
		if(BURN)
			health -= (proj.damage / fire_resist)

	update_icon()
	return 0

/obj/effect/blob/attackby(obj/item/W, mob/user)
	playsound(src, 'sound/effects/attackblob.ogg', 50, 1)
	visible_message(SPAN_DANGER("The [name] has been attacked with \the [W][(user ? " by [user]" : "")]."))
	var/damage = 0
	switch(W.damtype)
		if("fire")
			damage = (W.force / max(fire_resist, 1))
			if(iswelder(W))
				playsound(src, 'sound/items/Welder.ogg', 100, 1)
		if("brute")
			damage = (W.force / max(brute_resist, 1))

	health -= damage
	update_icon()
	return TRUE

/obj/effect/blob/proc/change_to(type = "Normal")
	switch(type)
		if("Normal")
			new /obj/effect/blob(loc, health)
		if("Node")
			new /obj/effect/blob/node(loc, health * 2)
		if("Factory")
			new /obj/effect/blob/factory(loc, health)
		if("Shield")
			new /obj/effect/blob/shield(loc, health * 2)
	qdel(src)

//////////////////////////////****IDLE BLOB***/////////////////////////////////////

/obj/effect/blob/idle
	name = "blob"
	desc = "it looks... tasty"
	icon_state = "blobidle0"

/obj/effect/blob/idle/New(loc, h = 10)
	. = ..(loc, h)
	update_idle()

/obj/effect/blob/idle/proc/update_idle()
	if(health <= 0)
		qdel(src)
		return
	if(health < 4)
		icon_state = "blobc0"
		return
	if(health < 10)
		icon_state = "blobb0"
		return
	icon_state = "blobidle0"

/obj/effect/blob/idle/Destroy()
	var/obj/effect/blob/B = new /obj/effect/blob(loc)
	spawn(30)
		B.Life()
	return ..()