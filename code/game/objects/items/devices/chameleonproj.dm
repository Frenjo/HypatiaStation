/obj/item/chameleon
	name = "chameleon projector"
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "shield0"
	obj_flags = OBJ_FLAG_CONDUCT
	slot_flags = SLOT_BELT
	item_state = "electronic"
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	origin_tech = list(/datum/tech/magnets = 4, /datum/tech/syndicate = 4)
	var/can_use = 1
	var/obj/effect/dummy/chameleon/active_dummy = null
	var/saved_item = /obj/item/cigbutt
	var/saved_icon = 'icons/obj/items/clothing/masks.dmi'
	var/saved_icon_state = "cigbutt"
	var/saved_overlays

/obj/item/chameleon/dropped()
	disrupt()

/obj/item/chameleon/equipped()
	. = ..()
	disrupt()

/obj/item/chameleon/attack_self()
	toggle()

/obj/item/chameleon/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(!active_dummy)
		if(isitem(target) && !istype(target, /obj/item/disk/nuclear))
			playsound(GET_TURF(src), 'sound/weapons/flash.ogg', 100, 1, -6)
			user << "\blue Scanned [target]."
			saved_item = target.type
			saved_icon = target.icon
			saved_icon_state = target.icon_state
			saved_overlays = target.overlays

/obj/item/chameleon/proc/toggle()
	if(!can_use || !saved_item)
		return
	if(active_dummy)
		eject_all()
		playsound(GET_TURF(src), 'sound/effects/pop.ogg', 100, 1, -6)
		qdel(active_dummy)
		active_dummy = null
		to_chat(usr, SPAN_INFO("You deactivate the [src]."))
		var/obj/effect/overlay/T = new /obj/effect/overlay(GET_TURF(src))
		T.icon = 'icons/effects/effects.dmi'
		flick("emppulse", T)
		spawn(8)
			qdel(T)
	else
		playsound(GET_TURF(src), 'sound/effects/pop.ogg', 100, 1, -6)
		var/obj/O = new saved_item(src)
		if(!O)
			return
		var/obj/effect/dummy/chameleon/C = new/obj/effect/dummy/chameleon(usr.loc)
		C.activate(O, usr, saved_icon, saved_icon_state, saved_overlays, src)
		qdel(O)
		to_chat(usr, SPAN_INFO("You activate the [src]."))
		var/obj/effect/overlay/T = new /obj/effect/overlay(GET_TURF(src))
		T.icon = 'icons/effects/effects.dmi'
		flick("emppulse", T)
		spawn(8)
			qdel(T)

/obj/item/chameleon/proc/disrupt(delete_dummy = 1)
	if(active_dummy)
		make_sparks(5, FALSE, src, src)
		eject_all()
		if(delete_dummy)
			qdel(active_dummy)
		active_dummy = null
		can_use = 0
		spawn(50) can_use = 1

/obj/item/chameleon/proc/eject_all()
	for_no_type_check(var/atom/movable/mover, active_dummy)
		mover.forceMove(active_dummy.loc)
		if(ismob(mover))
			var/mob/M = mover
			M.reset_view(null)


/obj/effect/dummy/chameleon
	name = ""
	desc = ""
	density = FALSE
	anchored = TRUE
	var/can_move = 1
	var/obj/item/chameleon/master = null

/obj/effect/dummy/chameleon/proc/activate(obj/O, mob/M, new_icon, new_iconstate, new_overlays, obj/item/chameleon/C)
	name = O.name
	desc = O.desc
	icon = new_icon
	icon_state = new_iconstate
	overlays = new_overlays
	dir = O.dir
	M.forceMove(src)
	master = C
	master.active_dummy = src

/obj/effect/dummy/chameleon/attackby()
	for(var/mob/M in src)
		to_chat(M, SPAN_WARNING("Your chameleon-projector deactivates."))
	master.disrupt()

/obj/effect/dummy/chameleon/attack_hand()
	for(var/mob/M in src)
		to_chat(M, SPAN_WARNING("Your chameleon-projector deactivates."))
	master.disrupt()

/obj/effect/dummy/chameleon/ex_act()
	for(var/mob/M in src)
		to_chat(M, SPAN_WARNING("Your chameleon-projector deactivates."))
	master.disrupt()

/obj/effect/dummy/chameleon/bullet_act()
	for(var/mob/M in src)
		to_chat(M, SPAN_WARNING("Your chameleon-projector deactivates."))
	..()
	master.disrupt()

/obj/effect/dummy/chameleon/relaymove(mob/user, direction)
	if(isspace(loc))
		return //No magical space movement!

	if(can_move)
		can_move = 0
		switch(user.bodytemperature)
			if(300 to INFINITY)
				spawn(10)
					can_move = 1
			if(295 to 300)
				spawn(13)
					can_move = 1
			if(280 to 295)
				spawn(16)
					can_move = 1
			if(260 to 280)
				spawn(20)
					can_move = 1
			else
				spawn(25)
					can_move = 1
		step(src, direction)
	return

/obj/effect/dummy/chameleon/Destroy()
	master.disrupt(0)
	master = null
	return ..()