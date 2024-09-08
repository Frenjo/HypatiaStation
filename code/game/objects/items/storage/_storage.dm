// To clarify:
// For use_to_pickup and allow_quick_gather functionality,
// see item/attackby() (/game/objects/items.dm)
// Do not remove this functionality without good reason, cough reagent_containers cough.
// -Sayu

/obj/item/storage
	name = "storage"
	icon = 'icons/obj/storage/storage.dmi'
	w_class = 3.0

	var/list/can_hold = list() //List of objects which this item can store (if set, it can't store anything else)
	var/list/cant_hold = list() //List of objects which this item can't store (in effect only if can_hold isn't set)
	var/list/is_seeing = list() //List of mobs which are currently seeing the contents of this item's storage
	var/max_w_class = 2 //Max size of objects that this object can store (in effect only if can_hold isn't set)
	var/max_combined_w_class = 14 //The sum of the w_classes of all the items in this storage item.
	var/storage_slots = 7 //The number of storage slots in this container.
	var/atom/movable/screen/storage/boxes = null
	var/atom/movable/screen/close/closer = null
	var/use_to_pickup	//Set this to make it possible to use this item in an inverse way, so you can have the item in your hand and click items on the floor to pick them up.
	var/display_contents_with_number	//Set this to make the storage item group contents of the same type and display them as a number.
	var/allow_quick_empty	//Set this variable to allow the object to have the 'empty' verb, which dumps all the contents on the floor.
	var/allow_quick_gather	//Set this variable to allow the object to have the 'toggle mode' verb, which quickly collects all items from a tile.
	var/collection_mode = 1;  //0 = pick one at a time, 1 = pick all on tile
	var/foldable = null	// BubbleWrap - if set, can be folded (when empty) into a sheet of cardboard
	var/use_sound = "rustle"	//sound played when used. null for no sound.

	// An associative list of typepaths of things the item will spawn with and their quantities.
	// If an entry isn't associative, the quantity is assumed to be one.
	var/list/starts_with = null

/obj/item/storage/New()
	SHOULD_CALL_PARENT(TRUE)

	. = ..()
	if(allow_quick_empty)
		verbs.Add(/obj/item/storage/verb/quick_empty)
	else
		verbs.Remove(/obj/item/storage/verb/quick_empty)

	if(allow_quick_gather)
		verbs.Add(/obj/item/storage/verb/toggle_gathering_mode)
	else
		verbs.Remove(/obj/item/storage/verb/toggle_gathering_mode)

	boxes = new /atom/movable/screen/storage()
	boxes.name = "storage"
	boxes.master = src
	boxes.icon_state = "block"
	boxes.screen_loc = "7,7 to 10,8"

	closer = new /atom/movable/screen/close()
	closer.master = src
	closer.icon_state = "x"
	orient2hud()

	// Spawns the items in the starts_with list.
	if(isnotnull(starts_with))
		for(var/type in starts_with)
			// If the entry isn't associative, then assume we just want a single one.
			var/count = starts_with[type]
			if(isnull(count))
				new type(src)
			else
				for(var/i = 0; i < count; i++)
					new type(src)

/obj/item/storage/Destroy()
	close_all()
	qdel(boxes)
	qdel(closer)
	return ..()

/obj/item/storage/MouseDrop(obj/over_object)
	if(ishuman(usr) || ismonkey(usr)) //so monkeys can take off their backpacks -- Urist
		if(ismecha(usr.loc)) // stops inventory actions in a mech
			return

		if(over_object == usr && Adjacent(usr)) // this must come before the screen objects only block
			open(usr)

		if(!(istype(over_object, /atom/movable/screen)))
			return ..()

		//makes sure that the storage is equipped, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this.
		if(!(loc == usr) || (isnotnull(loc) && loc.loc == usr))
			return

		if(!(usr.restrained()) && !(usr.stat))
			switch(over_object.name)
				if("r_hand")
					usr.u_equip(src)
					usr.put_in_r_hand(src)
				if("l_hand")
					usr.u_equip(src)
					usr.put_in_l_hand(src)
			add_fingerprint(usr)
			return

/obj/item/storage/proc/return_inv()
	var/list/L = list()
	L.Add(contents)

	for(var/obj/item/storage/S in src)
		L.Add(S.return_inv())
	for(var/obj/item/gift/G in src)
		L.Add(G.gift)
		if(istype(G.gift, /obj/item/storage))
			L.Add(G.gift:return_inv())
	return L

/obj/item/storage/proc/show_to(mob/user)
	if(user.s_active != src)
		for(var/obj/item/I in src)
			if(I.on_found(user))
				return
	if(isnotnull(user.s_active))
		user.s_active.hide_from(user)
	user.client.screen.Remove(boxes)
	user.client.screen.Remove(closer)
	user.client.screen.Remove(contents)
	user.client.screen.Add(boxes)
	user.client.screen.Add(closer)
	user.client.screen.Add(contents)
	user.s_active = src
	is_seeing |= user

/obj/item/storage/proc/hide_from(mob/user)
	if(isnull(user.client))
		return
	user.client.screen.Remove(boxes)
	user.client.screen.Remove(closer)
	user.client.screen.Remove(contents)
	if(user.s_active == src)
		user.s_active = null
	is_seeing.Remove(user)

/obj/item/storage/proc/open(mob/user)
	if(isnotnull(use_sound))
		playsound(loc, use_sound, 50, 1, -5)

	orient2hud(user)
	user.s_active?.close(user)
	show_to(user)

/obj/item/storage/proc/close(mob/user)
	hide_from(user)
	user.s_active = null

/obj/item/storage/proc/close_all()
	for(var/mob/M in can_see_contents())
		close(M)
		. = 1

/obj/item/storage/proc/can_see_contents()
	var/list/cansee = list()
	for(var/mob/M in is_seeing)
		if(M.s_active == src && isnotnull(M.client))
			cansee |= M
		else
			is_seeing.Remove(M)
	return cansee

//This proc draws out the inventory and places the items on it. tx and ty are the upper left tile and mx, my are the bottm right.
//The numbers are calculated from the bottom-left The bottom-left slot being 1,1.
/obj/item/storage/proc/orient_objs(tx, ty, mx, my)
	var/cx = tx
	var/cy = ty
	boxes.screen_loc = "[tx]:,[ty] to [mx],[my]"
	for(var/obj/O in contents)
		O.screen_loc = "[cx],[cy]"
		O.layer_to_hud()
		cx++
		if(cx > mx)
			cx = tx
			cy--
	closer.screen_loc = "[mx + 1],[my]"

//This proc draws out the inventory and places the items on it. It uses the standard position.
/obj/item/storage/proc/standard_orient_objs(rows, cols, list/obj/item/display_contents)
	var/cx = 4
	var/cy = 2 + rows
	boxes.screen_loc = "4:16,2:16 to [4 + cols]:16,[2 + rows]:16"

	if(display_contents_with_number)
		for(var/datum/numbered_display/ND in display_contents)
			ND.sample_object.screen_loc = "[cx]:16,[cy]:16"
			ND.sample_object.maptext = "<font color='white'>[(ND.number > 1)? "[ND.number]" : ""]</font>"
			ND.sample_object.layer_to_hud()
			cx++
			if(cx > (4 + cols))
				cx = 4
				cy--
	else
		for(var/obj/O in contents)
			O.screen_loc = "[cx]:16,[cy]:16"
			O.maptext = ""
			O.layer_to_hud()
			cx++
			if(cx > (4 + cols))
				cx = 4
				cy--
	closer.screen_loc = "[4 + cols + 1]:16,2:16"

/datum/numbered_display
	var/obj/item/sample_object
	var/number

/datum/numbered_display/New(obj/item/sample)
	if(!istype(sample))
		qdel(src)
	sample_object = sample
	number = 1

//This proc determins the size of the inventory to be displayed. Please touch it only if you know what you're doing.
/obj/item/storage/proc/orient2hud(mob/user)
	var/adjusted_contents = length(contents)

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(display_contents_with_number)
		numbered_contents = list()
		adjusted_contents = 0
		for(var/obj/item/I in contents)
			var/found = FALSE
			for(var/datum/numbered_display/ND in numbered_contents)
				if(ND.sample_object.type == I.type)
					ND.number++
					found = TRUE
					break
			if(!found)
				adjusted_contents++
				numbered_contents.Add(new /datum/numbered_display(I))

	//var/mob/living/carbon/human/H = user
	var/row_num = 0
	var/col_count = min(7, storage_slots) -1
	if(adjusted_contents > 7)
		row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
	standard_orient_objs(row_num, col_count, numbered_contents)

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/obj/item/storage/proc/can_be_inserted(obj/item/W, stop_messages = FALSE)
	if(!istype(W))
		return //Not an item

	if(loc == W)
		return 0 //Means the item is already in the storage item
	if(length(contents) >= storage_slots)
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("[src] is full, make some space."))
		return 0 //Storage item is full

	if(length(can_hold))
		var/ok = FALSE
		for(var/A in can_hold)
			if(istype(W, A))
				ok = TRUE
				break
		if(!ok)
			if(!stop_messages)
				if(istype(W, /obj/item/hand_labeler))
					return 0
				to_chat(usr, SPAN_NOTICE("[src] cannot hold [W]."))
			return 0

	for(var/A in cant_hold) //Check for specific items which this container can't hold.
		if(istype(W, A))
			if(!stop_messages)
				to_chat(usr, SPAN_NOTICE("[src] cannot hold [W]."))
			return 0

	if(W.w_class > max_w_class)
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("[W] is too big for this [src]."))
		return 0

	var/sum_w_class = W.w_class
	for(var/obj/item/I in contents)
		sum_w_class += I.w_class //Adds up the combined w_classes which will be in the storage item if the item is added to it.

	if(sum_w_class > max_combined_w_class)
		if(!stop_messages)
			to_chat(usr, SPAN_NOTICE("[src] is full, make some space."))
		return 0

	if(W.w_class >= w_class && (istype(W, /obj/item/storage)))
		if(!istype(src, /obj/item/storage/backpack/holding))	//bohs should be able to hold backpacks again. The override for putting a boh in a boh is in backpack.dm.
			if(!stop_messages)
				to_chat(usr, SPAN_NOTICE("[src] cannot hold [W] as it's a storage item of the same size."))
			return 0 //To prevent the stacking of same sized storage items.

	return 1

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/obj/item/storage/proc/handle_item_insertion(obj/item/W, prevent_warning = 0)
	if(!istype(W))
		return 0
	if(isnotnull(usr))
		usr.u_equip(W)
		usr.update_icons()	//update our overlays
	W.loc = src
	W.on_enter_storage(src)
	if(isnotnull(usr))
		if(usr.s_active != src)
			usr.client?.screen.Remove(W)
		W.dropped(usr)
		add_fingerprint(usr)

		if(!prevent_warning && !istype(W, /obj/item/gun/energy/crossbow))
			for(var/mob/M in viewers(usr, null))
				if(M == usr)
					to_chat(usr, SPAN_NOTICE("You put \the [W] into [src]."))
				else if(M in range(1)) //If someone is standing close enough, they can tell what it is...
					M.show_message(SPAN_NOTICE("[usr] puts [W] into [src]."))
				else if(W?.w_class >= 3.0) //Otherwise they can only see large or normal items from a distance...
					M.show_message(SPAN_NOTICE("[usr] puts [W] into [src]."))

		orient2hud(usr)
		usr.s_active?.show_to(usr)
	update_icon()
	return 1

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/obj/item/storage/proc/remove_from_storage(obj/item/W, atom/new_location)
	if(!istype(W))
		return 0

	if(istype(src, /obj/item/storage/fancy))
		var/obj/item/storage/fancy/F = src
		F.update_icon(1)

	for(var/mob/M in range(1, loc))
		if(M.s_active == src)
			M.client?.screen.Remove(W)

	if(new_location)
		if(ismob(loc))
			W.dropped(usr)
		if(ismob(new_location))
			W.layer_to_hud()
		else
			W.reset_plane_and_layer()
		W.loc = new_location
	else
		W.loc = GET_TURF(src)

	if(isnotnull(usr))
		orient2hud(usr)
		usr.s_active?.show_to(usr)
	if(isnotnull(W.maptext))
		W.maptext = ""
	W.on_exit_storage(src)
	update_icon()
	return 1

//This proc is called when you want to place an item into the storage item.
/obj/item/storage/attackby(obj/item/W, mob/user)
	..()

	if(isrobot(user))
		to_chat(user, SPAN_INFO("You're a robot. No."))
		return //Robots can't interact with storage items.

	if(!can_be_inserted(W))
		return

	if(istype(W, /obj/item/tray))
		var/obj/item/tray/T = W
		if(T.calc_carry() > 0)
			if(prob(85))
				to_chat(user, SPAN_WARNING("The tray won't fit in [src]."))
				return
			else
				W.loc = user.loc
				if(user.s_active != src)
					user.client?.screen.Remove(W)
				W.dropped(user)
				to_chat(user, SPAN_WARNING("God damnit!"))

	W.add_fingerprint(user)
	handle_item_insertion(W)

/obj/item/storage/dropped(mob/user)
	return

/obj/item/storage/attack_hand(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_pocket == src && !H.get_active_hand())	//Prevents opening if it's in a pocket.
			H.put_in_hands(src)
			H.l_pocket = null
			return
		if(H.r_pocket == src && !H.get_active_hand())
			H.put_in_hands(src)
			H.r_pocket = null
			return

	if(loc == user)
		open(user)
	else
		..()
		for(var/mob/M in range(1))
			if(M.s_active == src)
				close(M)
	add_fingerprint(user)

/obj/item/storage/verb/toggle_gathering_mode()
	set category = PANEL_OBJECT
	set name = "Switch Gathering Method"

	collection_mode = !collection_mode
	switch(collection_mode)
		if(1)
			usr << "[src] now picks up all items in a tile at once."
		if(0)
			usr << "[src] now picks up one item at a time."

/obj/item/storage/verb/quick_empty()
	set category = PANEL_OBJECT
	set name = "Empty Contents"

	if((!ishuman(usr) && (loc != usr)) || usr.stat || usr.restrained())
		return

	var/turf/T = GET_TURF(src)
	hide_from(usr)
	for(var/obj/item/I in contents)
		remove_from_storage(I, T)

/obj/item/storage/emp_act(severity)
	if(!isliving(loc))
		for(var/obj/O in contents)
			O.emp_act(severity)
	..()

// BubbleWrap - A box can be folded up to make card
/obj/item/storage/attack_self(mob/user)
	//Clicking on itself will empty it, if it has the verb to do that.
	if(user.get_active_hand() == src)
		if(verbs.Find(/obj/item/storage/verb/quick_empty))
			quick_empty()
			return

	//Otherwise we'll try to fold it.
	if(length(contents))
		return

	if(!ispath(foldable))
		return
	var/found = FALSE
	// Close any open UI windows first
	for(var/mob/M in range(1))
		if(M.s_active == src)
			close(M)
		if(M == user)
			found = TRUE
	if(!found)	// User is too far away
		return
	// Now make the cardboard
	to_chat(user, SPAN_NOTICE("You fold [src] flat."))
	new foldable(GET_TURF(src))
	qdel(src)
//BubbleWrap END

/obj/item/storage/hear_talk(mob/M, text)
	for_no_type_check(var/atom/movable/mover, src)
		if(isobj(mover))
			var/obj/O = mover
			O.hear_talk(M, text)

//Returns the storage depth of an atom. This is the number of storage items the atom is contained in before reaching toplevel (the area).
//Returns -1 if the atom was not found on container.
/atom/proc/storage_depth(atom/container)
	var/depth = 0
	var/atom/cur_atom = src

	while(cur_atom && !(cur_atom in container.contents))
		if(isarea(cur_atom))
			return -1
		if(istype(cur_atom.loc, /obj/item/storage))
			depth++
		cur_atom = cur_atom.loc

	if(isnull(cur_atom))
		return -1	//inside something with a null loc.

	return depth

//Like storage depth, but returns the depth to the nearest turf
//Returns -1 if no top level turf (a loc was null somewhere, or a non-turf atom's loc was an area somehow).
/atom/proc/storage_depth_turf()
	var/depth = 0
	var/atom/cur_atom = src

	while(cur_atom && !isturf(cur_atom))
		if(isarea(cur_atom))
			return -1
		if(istype(cur_atom.loc, /obj/item/storage))
			depth++
		cur_atom = cur_atom.loc

	if(isnull(cur_atom))
		return -1	//inside something with a null loc.

	return depth