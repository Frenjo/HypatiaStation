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
	blobs += src
	src.health = h
	src.set_dir(pick(1, 2, 4, 8))
	src.update_icon()
	..(loc)
	return

/obj/effect/blob/Destroy()
	blobs -= src
	return ..()

/obj/effect/blob/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || (height == 0))
		return 1
	if(istype(mover) && mover.checkpass(PASSBLOB))
		return 1
	return 0

/obj/effect/blob/process()
	spawn(-1)
		Life()
	return

/obj/effect/blob/proc/Pulse(pulse = 0, origin_dir = 0)//Todo: Fix spaceblob expand
	set background = 1
	if(!istype(src, /obj/effect/blob/core) && !istype(src, /obj/effect/blob/node))//Ill put these in the children later
		if(run_action())//If we can do something here then we dont need to pulse more
			return

	if(!istype(src, /obj/effect/blob/shield) && !istype(src, /obj/effect/blob/core) && !istype(src, /obj/effect/blob/node) && (pulse <= 2) && (prob(30)))
		change_to("Shield")
		return

	if(pulse > 20)	return//Inf loop check
	//Looking for another blob to pulse
	var/list/dirs = list(1, 2, 4, 8)
	dirs.Remove(origin_dir)//Dont pulse the guy who pulsed us
	for(var/i = 1 to 4)
		if(!dirs.len)	break
		var/dirn = pick(dirs)
		dirs.Remove(dirn)
		var/turf/T = get_step(src, dirn)
		var/obj/effect/blob/B = (locate(/obj/effect/blob) in T)
		if(!B)
			expand(T)//No blob here so try and expand
			return
		B.Pulse((pulse + 1), get_dir(src.loc, T))
		return
	return

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
	if(!T)
		var/list/dirs = list(1, 2, 4, 8)
		for(var/i = 1 to 4)
			var/dirn = pick(dirs)
			dirs.Remove(dirn)
			T = get_step(src, dirn)
			if(!(locate(/obj/effect/blob) in T))
				break
			else
				T = null

	if(!T)
		return 0
	var/obj/effect/blob/B = new /obj/effect/blob(src.loc, min(src.health, 30))
	if(T.Enter(B, src))//Attempt to move into the tile
		B.loc = T
	else
		T.blob_act()//If we cant move in hit the turf
		qdel(B)
	for(var/atom/A in T)//Hit everything in the turf
		A.blob_act()
	return 1

/obj/effect/blob/ex_act(severity)
	var/damage = 50
	switch(severity)
		if(1)
			src.health -= rand(100, 120)
		if(2)
			src.health -= rand(60, 100)
		if(3)
			src.health -= rand(20, 60)

	health -= (damage/brute_resist)
	update_icon()
	return

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

/obj/effect/blob/bullet_act(obj/item/projectile/Proj)
	if(!Proj)
		return
	switch(Proj.damage_type)
		if(BRUTE)
			health -= (Proj.damage/brute_resist)
		if(BURN)
			health -= (Proj.damage/fire_resist)

	update_icon()
	return 0

/obj/effect/blob/attackby(obj/item/weapon/W, mob/user)
	playsound(src, 'sound/effects/attackblob.ogg', 50, 1)
	src.visible_message(SPAN_DANGER("The [src.name] has been attacked with \the [W][(user ? " by [user]" : "")]."))
	var/damage = 0
	switch(W.damtype)
		if("fire")
			damage = (W.force / max(src.fire_resist, 1))
			if(istype(W, /obj/item/weapon/weldingtool))
				playsound(src, 'sound/items/Welder.ogg', 100, 1)
		if("brute")
			damage = (W.force / max(src.brute_resist, 1))

	health -= damage
	update_icon()
	return

/obj/effect/blob/proc/change_to(type = "Normal")
	switch(type)
		if("Normal")
			new/obj/effect/blob(src.loc, src.health)
		if("Node")
			new/obj/effect/blob/node(src.loc, src.health * 2)
		if("Factory")
			new/obj/effect/blob/factory(src.loc, src.health)
		if("Shield")
			new/obj/effect/blob/shield(src.loc, src.health * 2)
	qdel(src)
	return

//////////////////////////////****IDLE BLOB***/////////////////////////////////////

/obj/effect/blob/idle
	name = "blob"
	desc = "it looks... tasty"
	icon_state = "blobidle0"

/obj/effect/blob/idle/New(loc, h = 10)
	src.health = h
	src.set_dir(pick(1, 2, 4, 8))
	src.update_idle()

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
	var/obj/effect/blob/B = new /obj/effect/blob(src.loc)
	spawn(30)
		B.Life()
	return ..()