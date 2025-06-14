// update the APC icon to show the three base states
// also add overlays for indicator lights
/obj/machinery/power/apc/update_icon()
	var/update = check_updates()	//returns 0 if no need to update icons.
									// 1 if we need to update the icon_state
									// 2 if we need to update the overlays
	if(!update)
		return

	if(update & 1) // Updating the icon state
		if(update_state & UPSTATE_ALLGOOD)
			icon_state = "apc0"
		else if(update_state & (UPSTATE_OPENED1|UPSTATE_OPENED2))
			var/basestate = "apc[ cell ? "2" : "1" ]"
			if(update_state & UPSTATE_OPENED1)
				if(update_state & (UPSTATE_MAINT|UPSTATE_BROKE))
					icon_state = "apcmaint" //disabled APC cannot hold cell
				else
					icon_state = basestate
			else if(update_state & UPSTATE_OPENED2)
				icon_state = "[basestate]-nocover"
		else if(update_state & UPSTATE_BROKE)
			icon_state = "apc-b"
		else if(update_state & UPSTATE_BLUESCREEN)
			icon_state = "apcemag"
		else if(update_state & UPSTATE_WIREEXP)
			icon_state = "apcewires"

	if(!(update_state & UPSTATE_ALLGOOD))
		cut_overlays()
		return

	if(update & 2)
		cut_overlays()

		if(!(stat & (BROKEN|MAINT)) && update_state & UPSTATE_ALLGOOD)
			var/list/to_update = list(
				"apcox-[locked]",
				"apco3-[charging]"
			)
			if(operating)
				to_update.Add("apco0-[equipment]", "apco1-[lighting]", "apco2-[environ]")
			add_overlay(to_update)

	if(update & 3)
		if(update_state & UPSTATE_BLUESCREEN)
			set_light(l_range = 1, l_power = 1, l_color = "#0000FF")
		else if(!(stat & (BROKEN|MAINT)) && update_state & UPSTATE_ALLGOOD)
			var/color
			switch(charging)
				if(0)
					color = "#F86060"
				if(1)
					color = "#A8B0F8"
				if(2)
					color = "#82FF4C"
			set_light(l_range = 1, l_power = 1, l_color = color)
		else
			set_light(0)

// Used in process so it doesn't update the icon too much
/obj/machinery/power/apc/proc/queue_icon_update()
	if(!updating_icon)
		updating_icon = 1
		// Start the update
		spawn(APC_UPDATE_ICON_COOLDOWN)
			update_icon()
			updating_icon = 0

/obj/machinery/power/apc/proc/check_updates()
	var/last_update_state = update_state
	var/last_update_overlay = update_overlay
	update_state = 0
	update_overlay = 0

	if(cell)
		update_state |= UPSTATE_CELL_IN
	if(stat & BROKEN)
		update_state |= UPSTATE_BROKE
	if(stat & MAINT)
		update_state |= UPSTATE_MAINT
	if(opened)
		if(opened == 1)
			update_state |= UPSTATE_OPENED1
		if(opened == 2)
			update_state |= UPSTATE_OPENED2
	else if(emagged || malfai)
		update_state |= UPSTATE_BLUESCREEN
	else if(wiresexposed)
		update_state |= UPSTATE_WIREEXP
	if(update_state <= 1)
		update_state |= UPSTATE_ALLGOOD

	if(operating)
		update_overlay |= APC_UPOVERLAY_OPERATING

	if(update_state & UPSTATE_ALLGOOD)
		if(locked)
			update_overlay |= APC_UPOVERLAY_LOCKED

		if(!charging)
			update_overlay |= APC_UPOVERLAY_CHARGING0
		else if(charging == 1)
			update_overlay |= APC_UPOVERLAY_CHARGING1
		else if(charging == 2)
			update_overlay |= APC_UPOVERLAY_CHARGING2

		if(!equipment)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT0
		else if(equipment == 1)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT1
		else if(equipment == 2)
			update_overlay |= APC_UPOVERLAY_EQUIPMENT2

		if(!lighting)
			update_overlay |= APC_UPOVERLAY_LIGHTING0
		else if(lighting == 1)
			update_overlay |= APC_UPOVERLAY_LIGHTING1
		else if(lighting == 2)
			update_overlay |= APC_UPOVERLAY_LIGHTING2

		if(!environ)
			update_overlay |= APC_UPOVERLAY_ENVIRON0
		else if(environ == 1)
			update_overlay |= APC_UPOVERLAY_ENVIRON1
		else if(environ == 2)
			update_overlay |= APC_UPOVERLAY_ENVIRON2

	var/results = 0
	if(last_update_state == update_state && last_update_overlay == update_overlay)
		return 0
	if(last_update_state != update_state)
		results += 1
	if(last_update_overlay != update_overlay)
		results += 2
	return results