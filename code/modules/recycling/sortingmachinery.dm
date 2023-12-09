/obj/structure/big_delivery
	desc = "A big wrapped package."
	name = "large parcel"
	icon = 'icons/obj/storage/delivery.dmi'
	icon_state = "deliverycloset"
	density = TRUE
	flags = NOBLUDGEON
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER

	var/obj/wrapped = null
	var/sortTag = 0

/obj/structure/big_delivery/Destroy()
	if(wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.loc = get_turf(loc)
		if(istype(wrapped, /obj/structure/closet))
			var/obj/structure/closet/O = wrapped
			O.welded = 0
	var/turf/T = get_turf(src)
	for(var/atom/movable/AM in contents)
		AM.loc = T
	return ..()

/obj/structure/big_delivery/attack_hand(mob/user as mob)
	if(wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.loc = get_turf(src.loc)
		if(istype(wrapped, /obj/structure/closet))
			var/obj/structure/closet/O = wrapped
			O.welded = 0
	qdel(src)
	return

/obj/structure/big_delivery/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/dest_tagger))
		var/obj/item/dest_tagger/O = W

		if(src.sortTag != O.currTag)
			var/tag = uppertext(GLOBL.tagger_locations[O.currTag])
			to_chat(user, SPAN_INFO("*[tag]*"))
			src.sortTag = O.currTag
			playsound(src, 'sound/machines/twobeep.ogg', 100, 1)

	else if(istype(W, /obj/item/pen))
		var/str = copytext(sanitize(input(usr, "Label text?", "Set label", "")), 1, MAX_NAME_LEN)
		if(!str || !length(str))
			to_chat(usr, SPAN_WARNING("Invalid text."))
			return
		for(var/mob/M in viewers())
			to_chat(M, SPAN_INFO("[user] labels [src] as [str]."))
		src.name = "[src.name] ([str])"
	return


/obj/item/small_delivery
	desc = "A small wrapped package."
	name = "small parcel"
	icon = 'icons/obj/storage/delivery.dmi'
	icon_state = "deliverycrateSmall"

	var/obj/item/wrapped = null
	var/sortTag = 0

/obj/item/small_delivery/attack_self(mob/user as mob)
	if(src.wrapped) //sometimes items can disappear. For example, bombs. --rastaf0
		wrapped.loc = user.loc
		if(ishuman(user))
			user.put_in_hands(wrapped)
		else
			wrapped.loc = get_turf(src)

	qdel(src)
	return

/obj/item/small_delivery/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/dest_tagger))
		var/obj/item/dest_tagger/O = W

		if(src.sortTag != O.currTag)
			var/tag = uppertext(GLOBL.tagger_locations[O.currTag])
			to_chat(user, SPAN_INFO("*[tag]*"))
			src.sortTag = O.currTag
			playsound(src, 'sound/machines/twobeep.ogg', 100, 1)

	else if(istype(W, /obj/item/pen))
		var/str = copytext(sanitize(input(usr, "Label text?", "Set label", "")), 1, MAX_NAME_LEN)
		if(!str || !length(str))
			to_chat(usr, SPAN_WARNING("Invalid text."))
			return
		for(var/mob/M in viewers())
			to_chat(M, SPAN_INFO("[user] labels [src] as [str]."))
		src.name = "[src.name] ([str])"
	return


/obj/item/package_wrap
	name = "package wrapper"
	icon = 'icons/obj/items.dmi'
	icon_state = "deliveryPaper"
	w_class = 3.0

	var/amount = 25.0

/obj/item/package_wrap/afterattack(obj/target as obj, mob/user as mob, proximity)
	if(!proximity)
		return
	if(!istype(target))	//this really shouldn't be necessary (but it is).	-Pete
		return
	if(istype(target, /obj/item/small_delivery) || istype(target, /obj/structure/big_delivery) \
	|| istype(target, /obj/item/gift) || istype(target, /obj/item/evidencebag))
		return
	if(target.anchored)
		return
	if(target in user)
		return

	user.attack_log += text("\[[time_stamp()]\] <font color='blue'>Has used [src.name] on \ref[target]</font>")

	if(isitem(target) && !(istype(target, /obj/item/storage) && !istype(target, /obj/item/storage/box)))
		var/obj/item/O = target
		if(src.amount > 1)
			var/obj/item/small_delivery/P = new /obj/item/small_delivery(get_turf(O.loc))	//Aaannd wrap it up!
			if(!istype(O.loc, /turf))
				if(user.client)
					user.client.screen -= O
			P.wrapped = O
			O.loc = P
			var/i = round(O.w_class)
			if(i in list(1, 2, 3, 4, 5))
				P.icon_state = "deliverycrate[i]"
			P.add_fingerprint(usr)
			O.add_fingerprint(usr)
			src.add_fingerprint(usr)
			src.amount -= 1
	else if(istype(target, /obj/structure/closet/crate))
		var/obj/structure/closet/crate/O = target
		if(src.amount > 3 && !O.opened)
			var/obj/structure/big_delivery/P = new /obj/structure/big_delivery(get_turf(O.loc))
			P.icon_state = "deliverycrate"
			P.wrapped = O
			O.loc = P
			src.amount -= 3
		else if(src.amount < 3)
			to_chat(user, SPAN_INFO("You need more paper."))
	else if(istype(target, /obj/structure/closet))
		var/obj/structure/closet/O = target
		if(src.amount > 3 && !O.opened)
			var/obj/structure/big_delivery/P = new /obj/structure/big_delivery(get_turf(O.loc))
			P.wrapped = O
			O.welded = 1
			O.loc = P
			src.amount -= 3
		else if(src.amount < 3)
			to_chat(user, SPAN_INFO("You need more paper."))
	else
		to_chat(user, SPAN_INFO("The object you are trying to wrap is unsuitable for the sorting machinery!"))
	if(src.amount <= 0)
		new /obj/item/c_tube(src.loc)
		qdel(src)
		return
	return

/obj/item/package_wrap/examine()
	if(src in usr)
		to_chat(usr, SPAN_INFO("There are [amount] units of package wrap left!"))
	..()
	return


/obj/item/dest_tagger
	name = "destination tagger"
	desc = "Used to set the destination of properly wrapped packages."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "dest_tagger"
	w_class = 1
	item_state = "electronic"
	flags = CONDUCT
	slot_flags = SLOT_BELT

	var/currTag = 0
	//The whole system for the sorttype var is determined based on the order of this list,
	//disposals must always be 1, since anything that's untagged will automatically go to disposals, or sorttype = 1 --Superxpdude

	//If you don't want to fuck up disposals, add to this list, and don't change the order.
	//If you insist on changing the order, you'll have to change every sort junction to reflect the new order. --Pete

/obj/item/dest_tagger/proc/openwindow(mob/user as mob)
	var/dat = "<tt><center><h1><b>TagMaster 2.2</b></h1></center>"

	dat += "<table style='width:100%; padding:4px;'><tr>"
	for(var/i = 1, i <= length(GLOBL.tagger_locations), i++)
		dat += "<td><a href='?src=\ref[src];nextTag=[i]'>[GLOBL.tagger_locations[i]]</a></td>"

		if (i % 4 == 0)
			dat += "</tr><tr>"

	dat += "</tr></table><br>Current Selection: [currTag ? GLOBL.tagger_locations[currTag] : "None"]</tt>"

	user << browse(dat, "window=destTagScreen;size=450x350")
	onclose(user, "destTagScreen")

/obj/item/dest_tagger/attack_self(mob/user as mob)
	openwindow(user)
	return

/obj/item/dest_tagger/Topic(href, href_list)
	src.add_fingerprint(usr)
	if(href_list["nextTag"])
		var/n = text2num(href_list["nextTag"])
		src.currTag = n
	openwindow(usr)


/obj/machinery/disposal/delivery_chute
	name = "Delivery chute"
	desc = "A chute for big and small packages alike!"
	density = TRUE
	icon_state = "intake"

	var/c_mode = 0

/obj/machinery/disposal/delivery_chute/initialize()
	. = ..()
	trunk = locate() in src.loc
	if(trunk)
		trunk.linked = src	// link the pipe trunk to self

/obj/machinery/disposal/delivery_chute/Destroy()
	if(trunk)
		trunk.linked = null
	return ..()

/obj/machinery/disposal/delivery_chute/interact()
	return

/obj/machinery/disposal/delivery_chute/update()
	return

/obj/machinery/disposal/delivery_chute/Bumped(atom/movable/AM) //Go straight into the chute
	if(istype(AM, /obj/item/projectile) || istype(AM, /obj/effect))
		return
	switch(dir)
		if(NORTH)
			if(AM.loc.y != src.loc.y + 1) return
		if(EAST)
			if(AM.loc.x != src.loc.x + 1) return
		if(SOUTH)
			if(AM.loc.y != src.loc.y - 1) return
		if(WEST)
			if(AM.loc.x != src.loc.x - 1) return

	if(isobj(AM))
		var/obj/O = AM
		O.loc = src
	else if(ismob(AM))
		var/mob/M = AM
		M.loc = src
	src.flush()

/obj/machinery/disposal/delivery_chute/flush()
	flushing = 1
	flick("intake-closing", src)
	var/deliveryCheck = 0
	var/obj/structure/disposalholder/H = new()	// virtual holder object which actually
												// travels through the pipes.
	for(var/obj/structure/big_delivery/O in src)
		deliveryCheck = 1
		if(O.sortTag == 0)
			O.sortTag = 1
	for(var/obj/item/small_delivery/O in src)
		deliveryCheck = 1
		if(O.sortTag == 0)
			O.sortTag = 1
	if(deliveryCheck == 0)
		H.destinationTag = 1

	air_contents = new()		// new empty gas resv.

	sleep(10)
	playsound(src, 'sound/machines/disposalflush.ogg', 50, 0, 0)
	sleep(5) // wait for animation to finish

	H.init(src)	// copy the contents of disposer to holder

	H.start(src) // start the holder processing movement
	flushing = 0
	// now reset disposal state
	flush = 0
	if(mode == 2)	// if was ready,
		mode = 1	// switch to charging
	update()
	return

/obj/machinery/disposal/delivery_chute/attackby(obj/item/I, mob/user)
	if(!I || !user)
		return

	if(istype(I, /obj/item/screwdriver))
		if(c_mode == 0)
			c_mode = 1
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "You remove the screws around the power connection.")
			return
		else if(c_mode == 1)
			c_mode = 0
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			to_chat(user, "You attach the screws around the power connection.")
			return
	else if(istype(I, /obj/item/weldingtool) && c_mode == 1)
		var/obj/item/weldingtool/W = I
		if(W.remove_fuel(0, user))
			playsound(src, 'sound/items/Welder2.ogg', 100, 1)
			to_chat(user, "You start slicing the floorweld off the delivery chute.")
			if(do_after(user, 20))
				if(!src || !W.isOn())
					return
				to_chat(user, "You sliced the floorweld off the delivery chute.")
				var/obj/structure/disposalconstruct/C = new(src.loc)
				C.ptype = 8 // 8 =  Delivery chute
				C.update()
				C.anchored = TRUE
				C.density = TRUE
				qdel(src)
			return
		else
			to_chat(user, "You need more welding fuel to complete this task.")
			return