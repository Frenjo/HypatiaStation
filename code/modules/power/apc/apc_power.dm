/obj/machinery/power/apc/power_change()
	// Override because the APC shouldn't be receiving the NOPOWER flag.
	// An APC with the NOPOWER flag fails Topic() checks, thereby locking up the NanoUI.
	return

/obj/machinery/power/apc/connect_to_network()
	//Override because the APC does not directly connect to the network; it goes through a terminal.
	//The terminal is what the power computer looks for anyway.
	if(!terminal)
		make_terminal()
	if(terminal)
		terminal.connect_to_network()

/obj/machinery/power/apc/disconnect_terminal()
	if(terminal)
		terminal.master = null
		terminal = null

/obj/machinery/power/apc/draw_power(amount)
	if(terminal && terminal.powernet)
		return terminal.powernet.draw_power(amount)
	return 0

/obj/machinery/power/apc/surplus()
	if(terminal)
		return terminal.surplus()
	else
		return 0

/obj/machinery/power/apc/avail()
	if(terminal)
		return terminal.avail()
	else
		return 0

/obj/machinery/power/apc/process()
	if(stat & (BROKEN | MAINT))
		return
	if(!area.requires_power)
		return

	lastused_light = area.usage(LIGHT)
	lastused_equip = area.usage(EQUIP)
	lastused_environ = area.usage(ENVIRON)
	lastused_total = lastused_light + lastused_equip + lastused_environ
	area.clear_usage()

	//store states to update icon if any change
	var/last_lt = lighting
	var/last_eq = equipment
	var/last_en = environ
	var/last_ch = charging

	var/excess = surplus()

	if(!src.avail())
		main_status = 0
	else if(excess < 0)
		main_status = 1
	else
		main_status = 2

	if(cell && !shorted)
		// draw power from cell as before to power the area
		var/cellused = min(cell.charge, CELLRATE * lastused_total)	// clamp deduction to a max, amount left in cell
		cell.use(cellused)

		if(excess > lastused_total)		// if power excess recharge the cell
										// by the same amount just used
			var/draw = draw_power(cellused / CELLRATE) // draw the power needed to charge this cell
			cell.give(draw * CELLRATE)
		else		// no excess, and not enough per-apc
			if((cell.charge / CELLRATE + excess) >= lastused_total)		// can we draw enough from cell+grid to cover last usage?
				var/draw = draw_power(excess)
				cell.charge = min(cell.maxcharge, cell.charge + CELLRATE * draw)	//recharge with what we can
				charging = 0
			else	// not enough power available to run the last tick!
				charging = 0
				chargecount = 0
				// This turns everything off in the case that there is still a charge left on the battery, just not enough to run the room.
				equipment = autoset(equipment, 0)
				lighting = autoset(lighting, 0)
				environ = autoset(environ, 0)
				autoflag = 0

		// Set channels depending on how much charge we have left

		// Allow the APC to operate as normal if the cell can charge
		if(charging && longtermpower < 10)
			longtermpower += 1
		else if(longtermpower > -10)
			longtermpower -= 2

		if(cell.percent() >= AUTO_THRESHOLD_LIGHTING || longtermpower > 0)			// Put most likely at the top so we don't check it last, effeciency 101
			if(autoflag != 3)
				equipment = autoset(equipment, 1)
				lighting = autoset(lighting, 1)
				environ = autoset(environ, 1)
				autoflag = 3
				area.power_alert(1, src)
				if(cell.percent() >= 80)
					area.power_alert(1, src)

		else if(cell.percent() < AUTO_THRESHOLD_LIGHTING && cell.percent() > AUTO_THRESHOLD_EQUIPMENT && longtermpower < 0)		// <30%, turn off lighting
			if(autoflag != 2)
				equipment = autoset(equipment, 1)
				lighting = autoset(lighting, 2)
				environ = autoset(environ, 1)
				area.power_alert(0, src)
				autoflag = 2

		else if(cell.percent() < AUTO_THRESHOLD_EQUIPMENT)	// <15%, turn off lighting & equipment
			if((autoflag > 1 && longtermpower < 0) || (autoflag > 1 && longtermpower >= 0))
				equipment = autoset(equipment, 2)
				lighting = autoset(lighting, 2)
				environ = autoset(environ, 1)
				area.power_alert(0, src)
				autoflag = 1

		else if(cell.charge <= 0)							// zero charge, turn all off
			if(autoflag != 0)
				equipment = autoset(equipment, 0)
				lighting = autoset(lighting, 0)
				environ = autoset(environ, 0)
				area.power_alert(0, src)
				autoflag = 0

		// now trickle-charge the cell
		lastused_charging = 0 // Clear the variable for new use.
		if(src.attempt_charging())
			if(excess > 0)		// check to make sure we have enough to charge
				// Max charge is capped to % per second constant
				var/ch = min(excess * CELLRATE, cell.maxcharge * CHARGELEVEL)

				ch = draw_power(ch / CELLRATE) // Removes the power we're taking from the grid
				cell.give(ch * CELLRATE) // actually recharge the cell

				lastused_charging = ch
				lastused_total += ch // Sensors need this to stop reporting APC charging as "Other" load
			else
				charging = 0		// stop charging
				chargecount = 0

		// show cell as fully charged if so
		if(cell.charge >= cell.maxcharge)
			cell.charge = cell.maxcharge
			charging = 2

		//if we have excess power for long enough, think about re-enable charging.
		if(chargemode)
			if(!charging)
				if(excess > cell.maxcharge * CHARGELEVEL)
					chargecount++
				else
					chargecount = 0
					charging = 0

				if(chargecount >= 10)
					chargecount = 0
					charging = 1

		else // chargemode off
			charging = 0
			chargecount = 0

	else // no cell, switch everything off
		charging = 0
		chargecount = 0
		equipment = autoset(equipment, 0)
		lighting = autoset(lighting, 0)
		environ = autoset(environ, 0)
		area.power_alert(0, src)
		autoflag = 0

	// update icon & area power if anything changed
	if(last_lt != lighting || last_eq != equipment || last_en != environ)
		queue_icon_update()
		update()

	else if(last_ch != charging)
		queue_icon_update()

//Returns 1 if the APC should attempt to charge
/obj/machinery/power/apc/proc/attempt_charging()
	return (chargemode && charging == 1 && operating)

/obj/machinery/power/apc/proc/last_surplus()
	if(terminal && terminal.powernet)
		return terminal.powernet.last_surplus()
	else
		return 0

/obj/machinery/power/apc/proc/make_terminal()
	// create a terminal object at the same position as original turf loc
	// wires will attach to this
	terminal = new/obj/machinery/power/terminal(src.loc)
	terminal.set_dir(tdir)
	terminal.master = src

/obj/machinery/power/apc/proc/setsubsystem(val)
	if(cell && cell.charge > 0)
		return (val == 1) ? 0 : val
	else if(val == 3)
		return 1
	else
		return 0

/obj/machinery/power/apc/proc/shock(mob/user, prb)
	if(!prob(prb))
		return 0
	var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(electrocute_mob(user, src, src))
		return 1
	else
		return 0

// overload all the lights in this APC area
/obj/machinery/power/apc/proc/overload_lighting()
	if(/* !get_connection() || */ !operating || shorted)
		return
	if(cell && cell.charge >= 20)
		cell.use(20);
		spawn(0)
			for(var/obj/machinery/light/L in area)
				L.on = 1
				L.broken()
				sleep(1)

/obj/machinery/power/apc/proc/update()
	if(operating && !shorted)
		//prevent unnecessary updates to emergency lighting
		var/new_power_light = (lighting >= POWERCHAN_ON)
		if(area.power_light != new_power_light)
			area.power_light = new_power_light
			area.set_emergency_lighting(lighting == POWERCHAN_OFF_AUTO) //if lights go auto-off, emergency lights go on
		area.power_equip = (equipment >= POWERCHAN_ON)
		area.power_environ = (environ >= POWERCHAN_ON)
	else
		area.power_light = FALSE
		area.power_equip = FALSE
		area.power_environ = FALSE
	area.power_change()

// val 0=off, 1=off(auto) 2=on 3=on(auto)
// on 0=off, 1=on, 2=autooff
// defines a state machine, returns the new state
/obj/machinery/power/apc/proc/autoset(cur_state, on)
	switch(cur_state)
		if(POWERCHAN_OFF) //autoset will never turn on a channel set to off
		if(POWERCHAN_OFF_AUTO)
			if(on == 1)
				return POWERCHAN_ON_AUTO
		if(POWERCHAN_ON)
			if(on == 0)
				return POWERCHAN_OFF
		if(POWERCHAN_ON_AUTO)
			if(on == 0 || on == 2)
				return POWERCHAN_OFF_AUTO

	return cur_state //leave unchanged

/obj/machinery/power/apc/proc/set_broken()
	if(malfai && operating)
		if(IS_GAME_MODE(/datum/game_mode/malfunction))
			if(isstationlevel(src.z))
				var/datum/game_mode/malfunction/malf = global.PCticker.mode
				malf.apcs--
	stat |= BROKEN
	operating = 0
	if(occupant)
		malfvacate(1)
	update_icon()
	update()

/obj/machinery/power/apc/proc/toggle_breaker()
	operating = !operating
	if(malfai)
		if(IS_GAME_MODE(/datum/game_mode/malfunction))
			if(isstationlevel(src.z))
				var/datum/game_mode/malfunction/malf = global.PCticker.mode
				operating ? malf.apcs++ : malf.apcs--

	src.update()
	update_icon()