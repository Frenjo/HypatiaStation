/obj/item/inflatable
	name = "inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_wall"
	w_class = 3.0

/obj/item/inflatable/attack_self(mob/user)
	playsound(loc, 'sound/items/zip.ogg', 75, 1)
	to_chat(user, SPAN_INFO("You inflate [src]."))
	var/obj/structure/inflatable/R = new /obj/structure/inflatable(user.loc)
	src.transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/inflatable
	name = "inflatable wall"
	desc = "An inflated membrane. Do not puncture."
	density = TRUE
	anchored = TRUE
	opacity = FALSE

	icon = 'icons/obj/inflatable.dmi'
	icon_state = "wall"

	var/health = 50.0

/obj/structure/inflatable/New(location)
	..()
	update_nearby_tiles(need_rebuild = 1)

/obj/structure/inflatable/Destroy()
	update_nearby_tiles()
	return ..()

/obj/structure/inflatable/proc/update_nearby_tiles(need_rebuild) //Copypasta from airlock code
	global.PCair?.mark_for_update(GET_TURF(src))

/obj/structure/inflatable/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	return FALSE

/obj/structure/inflatable/bullet_act(obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	if(health <= 0)
		deflate(1)
	return

/obj/structure/inflatable/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			deflate(1)
			return
		if(3.0)
			if(prob(50))
				deflate(1)
				return

/obj/structure/inflatable/blob_act()
	deflate(1)

/obj/structure/inflatable/meteorhit()
	//to_world("glass at [x],[y],[z] Mhit")
	deflate(1)

/obj/structure/inflatable/attack_paw(mob/user)
	return attack_generic(user, 15)

/obj/structure/inflatable/attack_hand(mob/user)
	add_fingerprint(user)
	return

/obj/structure/inflatable/proc/attack_generic(mob/user, damage = 0)	//used by attack_animal and attack_slime
	health -= damage
	if(health <= 0)
		user.visible_message(SPAN_DANGER("[user] tears open [src]!"))
		deflate(1)
	else	//for nicer text~
		user.visible_message(SPAN_DANGER("[user] tears at [src]!"))

/obj/structure/inflatable/attack_animal(mob/user)
	if(!issimple(user))
		return
	var/mob/living/simple/M = user
	if(M.melee_damage_upper <= 0 || (M.melee_damage_type != BRUTE && M.melee_damage_type != BURN))
		return
	attack_generic(M, M.melee_damage_upper)

/obj/structure/inflatable/attack_slime(mob/user)
	if(!isslimeadult(user))
		return
	attack_generic(user, rand(10, 15))

/obj/structure/inflatable/attackby(obj/item/W, mob/user)
	if(!istype(W))
		return

	if(can_puncture(W))
		visible_message(SPAN_DANGER("[user] pierces [src] with [W]!"))
		deflate(1)
	if(W.damtype == BRUTE || W.damtype == BURN)
		hit(W.force)
		..()
	return

/obj/structure/inflatable/proc/hit(damage, sound_effect = 1)
	health = max(0, health - damage)
	if(sound_effect)
		playsound(loc, 'sound/effects/glass/glass_hit.ogg', 75, 1)
	if(health <= 0)
		deflate(1)

/obj/structure/inflatable/proc/deflate(violent = 0)
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	if(violent)
		visible_message("[src] rapidly deflates!")
		var/obj/item/inflatable/torn/R = new /obj/item/inflatable/torn(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)
	else
		//user << "\blue You slowly deflate the inflatable wall."
		visible_message("[src] slowly deflates.")
		spawn(50)
			var/obj/item/inflatable/R = new /obj/item/inflatable(loc)
			src.transfer_fingerprints_to(R)
			qdel(src)

/obj/structure/inflatable/verb/hand_deflate()
	set category = PANEL_OBJECT
	set name = "Deflate"
	set src in oview(1)

	if(isghost(usr)) //to stop ghosts from deflating
		return

	deflate()

/obj/item/inflatable/door
	name = "inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_door"

/obj/item/inflatable/door/attack_self(mob/user)
	playsound(loc, 'sound/items/zip.ogg', 75, 1)
	to_chat(user, SPAN_INFO("You inflate [src]."))
	var/obj/structure/inflatable/door/R = new /obj/structure/inflatable/door(user.loc)
	src.transfer_fingerprints_to(R)
	R.add_fingerprint(user)
	qdel(src)

/obj/structure/inflatable/door //Based on mineral door code
	name = "inflatable door"
	density = TRUE
	anchored = TRUE
	opacity = FALSE

	icon = 'icons/obj/inflatable.dmi'
	icon_state = "door_closed"

	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0

	//Bumped(atom/user)
	//	..()
	//	if(!state)
	//		return TryToSwitchState(user)
	//	return

/obj/structure/inflatable/door/attack_ai(mob/user) //those aren't machinery, they're just big fucking slabs of a mineral
	if(isAI(user)) //so the AI can't open it
		return
	else if(isrobot(user)) //but cyborgs can
		if(get_dist(user, src) <= 1) //not remotely though
			return TryToSwitchState(user)

/obj/structure/inflatable/door/attack_paw(mob/user)
	return TryToSwitchState(user)

/obj/structure/inflatable/door/attack_hand(mob/user)
	return TryToSwitchState(user)

/obj/structure/inflatable/door/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group)
		return state
	if(istype(mover, /obj/effect/beam))
		return !opacity
	return !density

/obj/structure/inflatable/door/proc/TryToSwitchState(atom/user)
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

/obj/structure/inflatable/door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()
	update_nearby_tiles()

/obj/structure/inflatable/door/proc/Open()
	isSwitchingStates = 1
	//playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 100, 1)
	flick("door_opening", src)
	sleep(10)
	density = FALSE
	opacity = FALSE
	state = 1
	update_icon()
	isSwitchingStates = 0

/obj/structure/inflatable/door/proc/Close()
	isSwitchingStates = 1
	//playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 100, 1)
	flick("door_closing", src)
	sleep(10)
	density = TRUE
	opacity = FALSE
	state = 0
	update_icon()
	isSwitchingStates = 0

/obj/structure/inflatable/door/update_icon()
	if(state)
		icon_state = "door_open"
	else
		icon_state = "door_closed"

/obj/structure/inflatable/door/deflate(violent = 0)
	playsound(loc, 'sound/machines/hiss.ogg', 75, 1)
	if(violent)
		visible_message("[src] rapidly deflates!")
		var/obj/item/inflatable/door/torn/R = new /obj/item/inflatable/door/torn(loc)
		src.transfer_fingerprints_to(R)
		qdel(src)
	else
		//user << "\blue You slowly deflate the inflatable wall."
		visible_message("[src] slowly deflates.")
		spawn(50)
			var/obj/item/inflatable/door/R = new /obj/item/inflatable/door(loc)
			src.transfer_fingerprints_to(R)
			qdel(src)


/obj/item/inflatable/torn
	name = "torn inflatable wall"
	desc = "A folded membrane which rapidly expands into a large cubical shape on activation. It is too torn to be usable."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_wall_torn"

/obj/item/inflatable/torn/attack_self(mob/user)
	to_chat(user, SPAN_INFO("The inflatable wall is too torn to be inflated!"))
	add_fingerprint(user)

/obj/item/inflatable/door/torn
	name = "torn inflatable door"
	desc = "A folded membrane which rapidly expands into a simple door on activation. It is too torn to be usable."
	icon = 'icons/obj/inflatable.dmi'
	icon_state = "folded_door_torn"

/obj/item/inflatable/door/torn/attack_self(mob/user)
	to_chat(user, SPAN_INFO("The inflatable door is too torn to be inflated!"))
	add_fingerprint(user)

/obj/item/storage/briefcase/inflatable
	name = "inflatable barrier box"
	desc = "Contains inflatable walls and doors."
	icon_state = "inf_box"
	item_state = "syringe_kit"
	max_combined_w_class = 21

	starts_with = list(/obj/item/inflatable/door = 3, /obj/item/inflatable = 4)