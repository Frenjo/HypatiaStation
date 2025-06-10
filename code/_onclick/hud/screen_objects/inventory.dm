/atom/movable/screen/inventory
	var/slot_id	//The indentifier for the slot. It has nothing to do with ID cards.

/atom/movable/screen/inventory/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(world.time <= usr.next_move)
		return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return 1
	if(ismecha(usr.loc)) // stops inventory actions in a mech
		return 1
	switch(name)
		if("r_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("r")
				usr.next_move = world.time + 2
		if("l_hand")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.activate_hand("l")
				usr.next_move = world.time + 2
		else
			if(usr.attack_ui(slot_id))
				usr.update_inv_l_hand(0)
				usr.update_inv_r_hand(0)
				usr.next_move = world.time + 6
	return 1

// The little button in the bottom left corner which hides the pop-up inventory slots.
/atom/movable/screen/inventory_toggle
	name = "inventory toggle"
	icon_state = "other"
	screen_loc = UI_INVENTORY_TOGGLE

/atom/movable/screen/inventory_toggle/Click(location, control, params)
	if(isnull(usr))
		return FALSE
	if(!ishuman(usr))
		return FALSE
	var/mob/living/carbon/human/user = usr
	var/datum/hud/human/hud_used = user.hud_used

	hud_used.inventory_shown = !hud_used.inventory_shown
	if(hud_used.inventory_shown)
		user.client.screen.Add(hud_used.other)
	else
		user.client.screen.Remove(hud_used.other)

	hud_used.hidden_inventory_update()
	return TRUE

/*
 * Grabs
 */
/atom/movable/screen/grab
	name = "grab"

/atom/movable/screen/grab/Click()
	var/obj/item/grab/G = master
	G.s_click(src)
	return 1

/atom/movable/screen/grab/attack_hand()
	return

/atom/movable/screen/grab/attackby()
	return

/*
 * Storage
 */
/atom/movable/screen/storage
	name = "storage"

/atom/movable/screen/storage/Click()
	if(world.time <= usr.next_move)
		return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return 1
	if(ismecha(usr.loc)) // stops inventory actions in a mech
		return 1
	if(isnotnull(master))
		var/obj/item/I = usr.get_active_hand()
		if(isnotnull(I))
			master.attackby(I, usr)
			usr.next_move = world.time + 2
	return 1

/atom/movable/screen/close
	name = "close"

/atom/movable/screen/close/Click()
	if(isnotnull(master))
		if(istype(master, /obj/item/storage))
			var/obj/item/storage/S = master
			S.close(usr)
	return 1