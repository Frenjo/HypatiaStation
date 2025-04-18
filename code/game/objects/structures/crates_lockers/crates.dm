//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/storage/crate.dmi'
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
	climbable = 1
//	mouse_drag_pointer = MOUSE_ACTIVE_POINTER	//???

	var/rigged = 0

/obj/structure/closet/crate/can_open()
	return 1

/obj/structure/closet/crate/can_close()
	return 1

/obj/structure/closet/crate/open()
	if(src.opened)
		return 0
	if(!src.can_open())
		return 0

	if(rigged && locate(/obj/item/radio/electropack) in src)
		if(isliving(usr))
			var/mob/living/L = usr
			if(L.electrocute_act(17, src))
				make_sparks(5, TRUE, src)
				return 2

	playsound(src, 'sound/machines/click.ogg', 15, 1, -3)
	for(var/obj/O in src)
		O.forceMove(GET_TURF(src))
	icon_state = icon_opened
	src.opened = 1

	if(climbable)
		structure_shaken()

	return

/obj/structure/closet/crate/close()
	if(!src.opened)
		return 0
	if(!src.can_close())
		return 0

	playsound(src, 'sound/machines/click.ogg', 15, 1, -3)
	var/itemcount = 0
	for(var/obj/O in GET_TURF(src))
		if(itemcount >= storage_capacity)
			break
		if(O.density || O.anchored || istype(O, /obj/structure/closet))
			continue
		if(istype(O, /obj/structure/stool/bed)) //This is only necessary because of rollerbeds and swivel chairs.
			var/obj/structure/stool/bed/B = O
			if(B.buckled_mob)
				continue
		O.forceMove(src)
		itemcount++

	icon_state = icon_closed
	src.opened = 0
	return 1

/obj/structure/closet/crate/attackby(obj/item/W, mob/user)
	if(opened)
		if(isrobot(user))
			return
		user.drop_item()
		if(W)
			W.forceMove(loc)
	else if(istype(W, /obj/item/package_wrap))
		return
	else if(iscable(W))
		if(rigged)
			to_chat(user, SPAN_NOTICE("[src] is already rigged!"))
			return
		to_chat(user, SPAN_NOTICE("You rig [src]."))
		user.drop_item()
		qdel(W)
		rigged = 1
		return
	else if(istype(W, /obj/item/radio/electropack))
		if(rigged)
			to_chat(user, SPAN_NOTICE("You attach [W] to [src]."))
			user.drop_item()
			W.forceMove(src)
			return
	else if(iswirecutter(W))
		if(rigged)
			to_chat(user, SPAN_NOTICE("You cut away the wiring."))
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			rigged = 0
			return
	else
		return attack_hand(user)

/obj/structure/closet/crate/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/obj/O in src.contents)
				qdel(O)
			qdel(src)
			return
		if(2.0)
			for(var/obj/O in src.contents)
				if(prob(50))
					qdel(O)
			qdel(src)
			return
		if(3.0)
			if(prob(50))
				qdel(src)
			return
		else
	return