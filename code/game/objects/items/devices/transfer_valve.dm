/obj/item/transfer_valve
	icon = 'icons/obj/items/assemblies/assemblies.dmi'
	name = "tank transfer valve"
	icon_state = "valve_1"
	desc = "Regulates the transfer of air between two tanks"
	var/obj/item/tank/tank_one
	var/obj/item/tank/tank_two
	var/obj/item/attached_device
	var/mob/attacher = null
	var/valve_open = 0
	var/toggle = 1

/obj/item/transfer_valve/proc/process_activation(obj/item/D)

/obj/item/transfer_valve/IsAssemblyHolder()
	return 1

/obj/item/transfer_valve/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/tank))
		if(isnotnull(tank_one) && isnotnull(tank_two))
			to_chat(user, SPAN_WARNING("There are already two tanks attached, remove one first."))
			return TRUE
		if(isnull(tank_one))
			tank_one = I
			user.drop_item()
			I.forceMove(src)
			to_chat(user, SPAN_NOTICE("You attach the tank to the transfer valve."))
		else if(isnull(tank_two))
			tank_two = I
			user.drop_item()
			I.forceMove(src)
			to_chat(user, SPAN_NOTICE("You attach the tank to the transfer valve."))
		update_icon()
		global.PCnanoui.update_uis(src) // update all UIs attached to src
		return TRUE

	if(isassembly(I)) //TODO: Have this take an assemblyholder
		var/obj/item/assembly/A = I
		if(A.secured)
			to_chat(user, SPAN_NOTICE("The device is secured."))
			return TRUE
		if(isnotnull(attached_device))
			to_chat(user, SPAN_WARNING("There is already a device attached to the valve, remove it first."))
			return TRUE
		user.remove_from_mob(I)
		attached_device = A
		A.forceMove(src)
		to_chat(user, SPAN_NOTICE("You attach \the [I] to the valve controls and secure it."))
		A.holder = src
		A.toggle_secure()	//this calls update_icon(), which calls update_icon() on the holder (i.e. the bomb).

		GLOBL.bombers += "[key_name(user)] attached \a [I] to a transfer valve."
		message_admins("[key_name_admin(user)] attached \a [I] to a transfer valve.")
		log_game("[key_name_admin(user)] attached \a [I] to a transfer valve.")
		attacher = user
		global.PCnanoui.update_uis(src) // update all UIs attached to src
		return TRUE

	return ..()

/obj/item/transfer_valve/HasProximity(atom/movable/AM)
	if(!attached_device)
		return
	attached_device.HasProximity(AM)
	return

/obj/item/transfer_valve/attack_self(mob/user)
	ui_interact(user)

/obj/item/transfer_valve/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	// this is the data which will be sent to the ui
	var/alist/data = alist(
		"attachmentOne" = tank_one?.name,
		"attachmentTwo" = tank_two?.name,
		"valveAttachment" = attached_device?.name,
		"valveOpen" = valve_open
	)

	// update the ui if it exists, returns null if no ui is passed/found
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new /datum/nanoui(user, src, ui_key, "transfer_valve.tmpl", "Tank Transfer Valve", 460, 280)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		//ui.set_auto_update(1)

/obj/item/transfer_valve/Topic(href, href_list)
	..()
	if(usr.stat || usr.restrained())
		return 0
	if(src.loc != usr)
		return 0
	if(tank_one && href_list["tankone"])
		split_gases()
		valve_open = 0
		tank_one.forceMove(GET_TURF(src))
		tank_one = null
		update_icon()
	else if(tank_two && href_list["tanktwo"])
		split_gases()
		valve_open = 0
		tank_two.forceMove(GET_TURF(src))
		tank_two = null
		update_icon()
	else if(href_list["open"])
		toggle_valve()
	else if(attached_device)
		if(href_list["rem_device"])
			attached_device.forceMove(GET_TURF(src))
			attached_device:holder = null
			attached_device = null
			update_icon()
		if(href_list["device"])
			attached_device.attack_self(usr)
	src.add_fingerprint(usr)
	return 1 // Returning 1 sends an update to attached UIs

/obj/item/transfer_valve/process_activation(obj/item/D)
	if(toggle)
		toggle = 0
		toggle_valve()
		spawn(50) // To stop a signal being spammed from a proxy sensor constantly going off or whatever
			toggle = 1

/obj/item/transfer_valve/update_icon()
	cut_overlays()
	underlays = null

	if(!tank_one && !tank_two && !attached_device)
		icon_state = "valve_1"
		return
	icon_state = "valve"

	if(tank_one)
		add_overlay("[tank_one.icon_state]")
	if(tank_two)
		var/icon/J = new(icon, icon_state = "[tank_two.icon_state]")
		J.Shift(WEST, 13)
		underlays += J
	if(attached_device)
		add_overlay("device")

/obj/item/transfer_valve/proc/merge_gases()
	tank_two.air_contents.volume += tank_one.air_contents.volume
	var/datum/gas_mixture/temp
	temp = tank_one.air_contents.remove_ratio(1)
	tank_two.air_contents.merge(temp)

/obj/item/transfer_valve/proc/split_gases()
	if(!valve_open || !tank_one || !tank_two)
		return
	var/ratio1 = tank_one.air_contents.volume/tank_two.air_contents.volume
	var/datum/gas_mixture/temp
	temp = tank_two.air_contents.remove_ratio(ratio1)
	tank_one.air_contents.merge(temp)
	tank_two.air_contents.volume -=  tank_one.air_contents.volume

	/*
	Exadv1: I know this isn't how it's going to work, but this was just to check
	it explodes properly when it gets a signal (and it does).
	*/

/obj/item/transfer_valve/proc/toggle_valve()
	if(valve_open == 0 && (tank_one && tank_two))
		valve_open = 1
		var/turf/bombturf = GET_TURF(src)
		var/area/A = GET_AREA(bombturf)

		var/attacher_name = ""
		if(!attacher)
			attacher_name = "Unknown"
		else
			attacher_name = "[attacher.name]([attacher.ckey])"

		var/log_str = "Bomb valve opened in <A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name]</a> "
		log_str += "with [attached_device ? attached_device : "no device"] attacher: [attacher_name]"

		if(attacher)
			log_str += "(<A href='byond://?_src_=holder;adminmoreinfo=\ref[attacher]'>?</A>)"

		var/mob/mob = get_mob_by_key(src.last_fingerprints)
		var/last_touch_info = ""
		if(mob)
			last_touch_info = "(<A href='byond://?_src_=holder;adminmoreinfo=\ref[mob]'>?</A>)"

		log_str += " Last touched by: [src.last_fingerprints][last_touch_info]"
		GLOBL.bombers += log_str
		message_admins(log_str, 0, 1)
		log_game(log_str)
		merge_gases()
		spawn(20) // In case one tank bursts
			for(var/i = 0, i < 5, i++)
				src.update_icon()
				sleep(10)
			src.update_icon()

	else if(valve_open == 1 && (tank_one && tank_two))
		split_gases()
		valve_open = 0
		src.update_icon()

// this doesn't do anything but the timer etc. expects it to be here
// eventually maybe have it update icon to show state (timer, prox etc.) like old bombs
/obj/item/transfer_valve/proc/c_state()
	return