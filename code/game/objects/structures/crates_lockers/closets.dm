/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closets/closet.dmi'
	icon_state = "closed"
	density = TRUE

	var/icon_closed = "closed"
	var/icon_opened = "open"
	var/opened = 0
	var/welded = 0
	var/wall_mounted = FALSE //never solid (You can always pass over it)
	var/health = 100
	var/lastbang
	var/storage_capacity = 30 //This is so that someone can't pack hundreds of items in a locker/crate
							  //then open it in a populated area to crash clients.

	// This should probably be made null by default.
	var/list/starts_with = list() // A list of typepaths for things this closet will spawn with.

/obj/structure/closet/New()
	SHOULD_CALL_PARENT(TRUE)

	. = ..()
	// Spawns the items in the starts_with list.
	for(var/type in starts_with)
		new type(src)

/obj/structure/closet/initialise()
	. = ..()
	// If closed, any item at the crate's loc is put in the contents.
	if(!opened)
		for(var/obj/item/I in src.loc)
			if(I.density || I.anchored || I == src)
				continue
			I.loc = src

/obj/structure/closet/alter_health()
	return get_turf(src)

/obj/structure/closet/CanPass(atom/movable/mover, turf/target, height = 0, air_group = 0)
	if(air_group || (height == 0 || wall_mounted))
		return 1
	return (!density)

/obj/structure/closet/proc/can_open()
	if(src.welded)
		return 0
	return 1

/obj/structure/closet/proc/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src)
			return 0
	return 1

/obj/structure/closet/proc/dump_contents()
	//Cham Projector Exception
	for(var/obj/effect/dummy/chameleon/AD in src)
		AD.loc = src.loc

	for(var/obj/I in src)
		I.loc = src.loc

	for(var/mob/M in src)
		M.loc = src.loc
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/proc/open()
	if(src.opened)
		return 0

	if(!src.can_open())
		return 0

	src.dump_contents()

	src.icon_state = src.icon_opened
	src.opened = 1
	if(istype(src, /obj/structure/closet/body_bag))
		playsound(src, 'sound/items/zip.ogg', 15, 1, -3)
	else
		playsound(src, 'sound/machines/click.ogg', 15, 1, -3)
	density = FALSE
	return 1

/obj/structure/closet/proc/close()
	if(!src.opened)
		return 0
	if(!src.can_close())
		return 0

	var/itemcount = 0

	//Cham Projector Exception
	for(var/obj/effect/dummy/chameleon/AD in src.loc)
		if(itemcount >= storage_capacity)
			break
		AD.loc = src
		itemcount++

	for(var/obj/item/I in src.loc)
		if(itemcount >= storage_capacity)
			break
		if(!I.anchored)
			I.loc = src
			itemcount++

	for(var/mob/M in src.loc)
		if(itemcount >= storage_capacity)
			break
		if(isobserver(M))
			continue
		if(M.buckled)
			continue

		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src

		M.loc = src
		itemcount++

	src.icon_state = src.icon_closed
	src.opened = 0
	if(istype(src, /obj/structure/closet/body_bag))
		playsound(src, 'sound/items/zip.ogg', 15, 1, -3)
	else
		playsound(src, 'sound/machines/click.ogg', 15, 1, -3)
	density = TRUE
	return 1

/obj/structure/closet/proc/toggle(mob/user as mob)
	. = src.opened ? src.close() : src.open()
	if(!.)
		to_chat(user, SPAN_NOTICE("It won't budge!"))
	return

// this should probably use dump_contents()
/obj/structure/closet/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A as mob|obj in src)//pulls everything out of the locker and hits it with an explosion
				A.loc = src.loc
				A.ex_act(severity++)
			qdel(src)
		if(2)
			if(prob(50))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					A.ex_act(severity++)
				qdel(src)
		if(3)
			if(prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.loc = src.loc
					A.ex_act(severity++)
				qdel(src)

/obj/structure/closet/bullet_act(obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	if(health <= 0)
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		qdel(src)

	return

/obj/structure/closet/attack_animal(mob/living/user as mob)
	if(user.wall_smash)
		visible_message(SPAN_WARNING("[user] destroys the [src]."))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		qdel(src)

// this should probably use dump_contents()
/obj/structure/closet/blob_act()
	if(prob(75))
		for(var/atom/movable/A as mob|obj in src)
			A.loc = src.loc
		qdel(src)

/obj/structure/closet/meteorhit(obj/O as obj)
	if(O.icon_state == "flaming")
		for(var/mob/M in src)
			M.meteorhit(O)
		src.dump_contents()
		qdel(src)

/obj/structure/closet/attackby(obj/item/W as obj, mob/user as mob)
	if(src.opened)
		if(istype(W, /obj/item/grab))
			src.MouseDrop_T(W:affecting, user)		//act like they were dragged onto the closet
		if(istype(W, /obj/item/tk_grab))
			return 0
		if(istype(W, /obj/item/weldingtool))
			var/obj/item/weldingtool/WT = W
			if(!WT.remove_fuel(0, user))
				FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
				return
			new /obj/item/stack/sheet/metal(src.loc)
			visible_message(
				SPAN_NOTICE("\The [src] has been cut apart by [user] with \the [WT]."),
				SPAN_WARNING("You hear welding.")
			)
			qdel(src)
			return
		if(isrobot(user))
			return
		usr.drop_item()
		if(W)
			W.loc = src.loc
	else if(istype(W, /obj/item/package_wrap))
		return
	else if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W
		if(!WT.remove_fuel(0,user))
			FEEDBACK_NOT_ENOUGH_WELDING_FUEL(user)
			return
		src.welded = !src.welded
		src.update_icon()
		visible_message(
			SPAN_WARNING("[src] has been [welded ? "welded shut" : "unwelded"] by [user.name]."),
			SPAN_WARNING("You hear welding.")
		)
	else
		src.attack_hand(user)
	return

/obj/structure/closet/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
	if(istype(O, /obj/screen))	//fix for HUD elements making their way into the world	-Pete
		return
	if(O.loc == user)
		return
	if(user.restrained() || user.stat || user.weakened || user.stunned || user.paralysis)
		return
	if(!ismovable(O) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src))
		return
	if(user.loc == null) // just in case someone manages to get a closet into the blue light dimension, as unlikely as that seems
		return
	if(!isturf(user.loc)) // are you in a container/closet/pod/etc?
		return
	if(!src.opened)
		return
	if(istype(O, /obj/structure/closet))
		return
	step_towards(O, src.loc)
	if(user != O)
		user.show_viewers(SPAN_DANGER("[user] stuffs [O] into [src]!"))
	src.add_fingerprint(user)
	return

/obj/structure/closet/relaymove(mob/user as mob)
	if(user.stat || !isturf(src.loc))
		return

	if(!src.open())
		to_chat(user, SPAN_NOTICE("It won't budge!"))
		if(!lastbang)
			lastbang = 1
			for(var/mob/M in hearers(src, null))
				to_chat(M, "<FONT size=[max(0, 5 - get_dist(src, M))]>BANG, bang!</FONT>")
			spawn(30)
				lastbang = 0

/obj/structure/closet/attack_paw(mob/user as mob)
	return src.attack_hand(user)

/obj/structure/closet/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	src.toggle(user)

// tk grab then use on self
/obj/structure/closet/attack_self_tk(mob/user as mob)
	src.add_fingerprint(user)
	if(!src.toggle())
		to_chat(usr, SPAN_NOTICE("It won't budge!"))

/obj/structure/closet/verb/verb_toggleopen()
	set category = PANEL_OBJECT
	set src in oview(1)
	set name = "Toggle Open"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(ishuman(usr))
		src.add_fingerprint(usr)
		src.toggle(usr)
	else
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))

/obj/structure/closet/update_icon()//Putting the welded stuff in updateicon() so it's easy to overwrite for special cases (Fridges, cabinets, and whatnot)
	overlays.Cut()
	if(!opened)
		icon_state = icon_closed
		if(welded)
			overlays.Add("welded")
	else
		icon_state = icon_opened

/obj/structure/closet/hear_talk(mob/M as mob, text)
	for(var/atom/A in src)
		if(istype(A, /obj/))
			var/obj/O = A
			O.hear_talk(M, text)