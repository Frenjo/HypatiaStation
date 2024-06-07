//NOT using the existing /obj/machinery/door type, since that has some complications on its own, mainly based on its
//machineryness
/obj/structure/mineral_door
	name = "mineral door"
	icon = 'icons/obj/doors/mineral/mineral_doors.dmi'
	density = TRUE
	anchored = TRUE
	opacity = TRUE

	var/decl/material/material
	var/sound_path = 'sound/effects/stonedoor_openclose.ogg'
	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/hardness = 1
	var/oreAmount = 7

/obj/structure/mineral_door/New(location)
	if(isnotnull(material))
		material = GET_DECL_INSTANCE(material)
	. = ..()
	update_nearby_tiles(need_rebuild = 1)

/obj/structure/mineral_door/Destroy()
	update_nearby_tiles()
	return ..()

/obj/structure/mineral_door/Bumped(atom/user)
	..()
	if(!state)
		return TryToSwitchState(user)
	return

/obj/structure/mineral_door/attack_ai(mob/user) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(get_dist(user, src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/mineral_door/attack_paw(mob/user)
	return TryToSwitchState(user)

/obj/structure/mineral_door/attack_hand(mob/user)
	return TryToSwitchState(user)

/obj/structure/mineral_door/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group)
		return FALSE
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/mineral_door/proc/TryToSwitchState(atom/user)
	if(isSwitchingStates)
		return
	if(ismob(user))
		var/mob/M = user
		if(world.time - user.last_bumped <= 60)
			return //NOTE do we really need that?
		if(M.client)
			if(iscarbon(M))
				var/mob/living/carbon/C = M
				if(!C.handcuffed)
					SwitchState()
			else
				SwitchState()
	else if(ismecha(user))
		SwitchState()

/obj/structure/mineral_door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()

/obj/structure/mineral_door/proc/Open()
	isSwitchingStates = 1
	playsound(loc, sound_path, 100, 1)
	flick("[material.icon_prefix]opening", src)
	sleep(10)
	density = FALSE
	opacity = FALSE
	state = 1
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/mineral_door/proc/Close()
	isSwitchingStates = 1
	playsound(loc, sound_path, 100, 1)
	flick("[material.icon_prefix]closing", src)
	sleep(10)
	density = TRUE
	opacity = TRUE
	state = 0
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()

/obj/structure/mineral_door/update_icon()
	if(state)
		icon_state = "[material.icon_prefix]open"
	else
		icon_state = material.icon_prefix

/obj/structure/mineral_door/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/pickaxe))
		var/obj/item/pickaxe/digTool = W
		to_chat(user, "You start digging the [name].")
		if(do_after(user, digTool.digspeed * hardness) && src)
			to_chat(user, "You finished digging.")
			Dismantle()
	else if(isitem(W)) //not sure, can't not just weapons get passed to this proc?
		hardness -= W.force / 100
		to_chat(user, "You hit the [name] with your [W.name]!")
		CheckHardness()
	else
		attack_hand(user)
	return

/obj/structure/mineral_door/proc/CheckHardness()
	if(hardness <= 0)
		Dismantle(1)

/obj/structure/mineral_door/proc/Dismantle(devastated = 0)
	if(isnotnull(material.sheet_path))
		var/turf/T = get_turf(src)
		if(!devastated)
			for(var/i = 1, i <= oreAmount, i++)
				new material.sheet_path(T)
		else
			for(var/i = 3, i <= oreAmount, i++)
				new material.sheet_path(T)
	qdel(src)

/obj/structure/mineral_door/ex_act(severity = 1)
	switch(severity)
		if(1)
			Dismantle(1)
		if(2)
			if(prob(20))
				Dismantle(1)
			else
				hardness--
				CheckHardness()
		if(3)
			hardness -= 0.1
			CheckHardness()
	return

/obj/structure/mineral_door/proc/update_nearby_tiles(need_rebuild) //Copypasta from airlock code
	if(!global.PCair)
		return 0
	global.PCair.mark_for_update(get_turf(src))
	return 1