////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// GPS Locater - locks into a radio frequency and tracks it
/obj/item/beacon_locator
	name = "locater device"
	desc = "Used to scan and locate signals on a particular frequency according ."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "pinoff"	//pinonfar, pinonmedium, pinonclose, pinondirect, pinonnull
	item_state = "electronic"

	var/frequency = FREQUENCY_COMMON
	var/scan_ticks = 0
	var/obj/item/radio/target_radio

/obj/item/beacon_locator/initialise()
	. = ..()
	START_PROCESSING(PCobj, src)

/obj/item/beacon_locator/Destroy()
	target_radio = null
	STOP_PROCESSING(PCobj, src)
	return ..()

/obj/item/beacon_locator/process()
	if(target_radio)
		dir = get_dir(src, target_radio)
		switch(get_dist(src, target_radio))
			if(0 to 3)
				icon_state = "pinondirect"
			if(4 to 10)
				icon_state = "pinonclose"
			if(11 to 30)
				icon_state = "pinonmedium"
			if(31 to INFINITY)
				icon_state = "pinonfar"
	else
		if(scan_ticks)
			icon_state = "pinonnull"
			scan_ticks++
			if(prob(scan_ticks * 10))
				spawn(0)
					set background = BACKGROUND_ENABLED
					if(global.PCobj.processing_list.Find(src))
						//scan radios in the world to try and find one
						var/cur_dist = 999
						for(var/obj/item/radio/beacon/R in GLOBL.movable_atom_list)
							if(R.z == src.z && R.frequency == src.frequency)
								var/check_dist = get_dist(src,R)
								if(check_dist < cur_dist)
									cur_dist = check_dist
									target_radio = R

						scan_ticks = 0
						var/turf/T = GET_TURF(src)
						if(target_radio)
							T.visible_message("\icon[src] [src] [pick("chirps", "chirrups", "cheeps")] happily.")
						else
							T.visible_message("\icon[src] [src] [pick("chirps", "chirrups", "cheeps")] sadly.")
		else
			icon_state = "pinoff"

/obj/item/beacon_locator/attack_self(mob/user)
	return src.interact(user)

/obj/item/beacon_locator/interact(mob/user)
	var/dat = "<b>Radio frequency tracker</b><br>"
	dat += {"
				<A href='byond://?src=\ref[src];reset_tracking=1'>Reset tracker</A><BR>
				Frequency:
				<A href='byond://?src=\ref[src];freq=-10'>-</A>
				<A href='byond://?src=\ref[src];freq=-2'>-</A>
				[format_frequency(frequency)]
				<A href='byond://?src=\ref[src];freq=2'>+</A>
				<A href='byond://?src=\ref[src];freq=10'>+</A><BR>
				"}

	dat += "<A href='byond://?src=\ref[src];close=1'>Close</a><br>"
	user << browse(dat,"window=locater;size=300x150")
	onclose(user, "locater")

/obj/item/beacon_locator/Topic(href, href_list)
	..()
	usr.set_machine(src)

	if(href_list["reset_tracking"])
		scan_ticks = 1
		target_radio = null
	else if(href_list["freq"])
		var/new_frequency = (frequency + text2num(href_list["freq"]))
		if(frequency < 1200 || frequency > 1600)
			new_frequency = sanitize_frequency(new_frequency, 1499)
		frequency = new_frequency

	else if(href_list["close"])
		usr.unset_machine()
		usr << browse(null, "window=locater")

	updateSelfDialog()