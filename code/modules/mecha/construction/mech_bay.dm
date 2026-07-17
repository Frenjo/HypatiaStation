// Recharge Floor
/obj/machinery/mech_bay_recharge_floor
	name = "mech bay recharge station"
	icon = 'icons/obj/mecha/mech_bay.dmi'
	icon_state = "recharge_floor"

	var/obj/machinery/mech_bay_recharge_port/recharge_port
	var/obj/machinery/computer/mech_bay_power_console/recharge_console
	var/obj/mecha/recharging_mecha = null

/obj/machinery/mech_bay_recharge_floor/Crossed(atom/movable/mover)
	. = ..()
	if(!ismecha(mover))
		return

	var/obj/mecha/mecha = mover
	mecha.occupant_message(SPAN_INFO_B("Initializing power control devices."))
	init_devices()
	if(isnotnull(recharge_console) && isnotnull(recharge_port))
		recharging_mecha = mecha
		recharge_console.mecha_in(mecha)
		return

	if(isnull(recharge_console))
		mecha.occupant_message(SPAN_WARNING("Control console not found. Terminating."))
	else if(isnull(recharge_port))
		mecha.occupant_message(SPAN_WARNING("Power port not found. Terminating."))

/obj/machinery/mech_bay_recharge_floor/Uncrossed(atom/movable/mover)
	. = ..()
	if(mover != recharging_mecha)
		return

	recharging_mecha = null
	if(isnotnull(recharge_console))
		recharge_console.mecha_out()

/obj/machinery/mech_bay_recharge_floor/proc/init_devices()
	recharge_console = locate() in range(1, src)
	recharge_port = locate(/obj/machinery/mech_bay_recharge_port, get_step(src, WEST))
	if(isnotnull(recharge_console))
		recharge_console.recharge_floor = src
		if(isnotnull(recharge_port))
			recharge_console.recharge_port = recharge_port
	if(isnotnull(recharge_port))
		recharge_port.recharge_floor = src
		if(isnotnull(recharge_console))
			recharge_port.recharge_console = recharge_console

/obj/machinery/mech_bay_recharge_floor/asteroid
	icon_state = "recharge_floor_asteroid"

// Recharge Port
/obj/machinery/mech_bay_recharge_port
	name = "mech bay power port"
	icon = 'icons/obj/mecha/mech_bay.dmi'
	icon_state = "recharge_port"

	density = TRUE
	anchored = TRUE

	var/obj/machinery/mech_bay_recharge_floor/recharge_floor = null
	var/obj/machinery/computer/mech_bay_power_console/recharge_console = null

	var/charging = FALSE
	var/max_charge = 45
	var/obj/mecha/target = null

/obj/machinery/mech_bay_recharge_port/power_change()
	if(powered())
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			stop_charge()

/obj/machinery/mech_bay_recharge_port/process()
	. = ..()
	if(. == PROCESS_KILL)
		return .

	if(isnotnull(target) && (target in GET_TURF(recharge_floor)))
		if(isnull(target.cell))
			return
		var/delta = min(max_charge, target.cell.maxcharge - target.cell.charge)
		if(delta > 0)
			target.give_power(delta)
			use_power(delta * 150)
		else
			target.occupant_message(SPAN_INFO_B("Fully charged."))
			stop_charge()
	else
		stop_charge()


/obj/machinery/mech_bay_recharge_port/proc/start_charge(obj/mecha/mech)
	if(stat & (NOPOWER | BROKEN))
		mech.occupant_message(SPAN_WARNING("Power port not responding. Terminating."))
		return FALSE

	if(isnotnull(mech.cell))
		mech.occupant_message(SPAN_INFO("Now charging..."))
		charging = TRUE
		target = mech
		START_PROCESSING(PCobj, src)
		return TRUE
	return FALSE

/obj/machinery/mech_bay_recharge_port/proc/stop_charge()
	if(isnotnull(recharge_console) && !recharge_console.stat)
		recharge_console.icon_state = initial(recharge_console.icon_state)
	STOP_PROCESSING(PCobj, src)
	target = null
	charging = FALSE

/obj/machinery/mech_bay_recharge_port/proc/set_voltage(new_voltage)
	if(new_voltage && isnum(new_voltage))
		max_charge = new_voltage
		return TRUE
	return FALSE

// Power Console
/obj/machinery/computer/mech_bay_power_console
	name = "mech bay power control console"
	density = TRUE
	anchored = TRUE
	icon_state = "recharge_comp"
	circuit = /obj/item/circuitboard/mech_bay_power_console

	light_color = "#a97faa"

	var/autostart = TRUE
	var/voltage = 45
	var/obj/machinery/mech_bay_recharge_floor/recharge_floor
	var/obj/machinery/mech_bay_recharge_port/recharge_port

/obj/machinery/computer/mech_bay_power_console/proc/mecha_in(obj/mecha/mecha)
	if(stat & (NOPOWER | BROKEN))
		mecha.occupant_message(SPAN_WARNING("Control console not responding. Terminating..."))
		return
	if(isnotnull(recharge_port) && autostart)
		if(recharge_port.start_charge(mecha))
			recharge_port.set_voltage(voltage)
			icon_state = initial(icon_state) + "_on"

/obj/machinery/computer/mech_bay_power_console/proc/mecha_out()
	recharge_port?.stop_charge()

/obj/machinery/computer/mech_bay_power_console/power_change()
	if(stat & BROKEN)
		icon_state = initial(icon_state) + "_broken"
		recharge_port?.stop_charge()
	else if(powered())
		icon_state = initial(icon_state)
		stat &= ~NOPOWER
	else
		spawn(rand(0, 15))
			icon_state = initial(icon_state) + "_nopower"
			stat |= NOPOWER
			recharge_port?.stop_charge()

/obj/machinery/computer/mech_bay_power_console/set_broken()
	icon_state = initial(icon_state) + "_broken"
	stat |= BROKEN
	recharge_port?.stop_charge()

/obj/machinery/computer/mech_bay_power_console/attack_hand(mob/user)
	if(..())
		return
	var/output = "<html><head><title>[name]</title></head><body>"
	if(isnull(recharge_floor))
		output += "<font color='red'>Mech Bay Recharge Station not initialized.</font><br>"
	else
		output += {"<b>Mech Bay Recharge Station Data:</b><div style='margin-left: 15px;'>
						<b>Mecha: </b>[recharge_floor.recharging_mecha || "None"]<br>"}
		if(isnotnull(recharge_floor.recharging_mecha))
			var/cell_charge = recharge_floor.recharging_mecha.get_charge()
			output += "<b>Cell charge: </b>[isnull(cell_charge) ? "No powercell found" : "[recharge_floor.recharging_mecha.cell.charge] / [recharge_floor.recharging_mecha.cell.maxcharge]"]<br>"
		output += "</div>"
	if(isnull(recharge_port))
		output += "<font color='red'>Mech Bay Power Port not initialized.</font><br>"
	else
		output += "<b>Mech Bay Power Port Status: </b>[recharge_port.charging ? "Now charging" : "On hold"]<br>"

	/*
	output += {"<hr>
					<b>Settings:</b>
					<div style='margin-left: 15px;'>
					<b>Start sequence on succesful init: </b><a href='byond://?src=\ref[src];autostart=1'>[autostart?"On":"Off"]</a><br>
					<b>Recharge Port Voltage: </b><a href='byond://?src=\ref[src];voltage=30'>Low</a> - <a href='byond://?src=\ref[src];voltage=45'>Medium</a> - <a href='byond://?src=\ref[src];voltage=60'>High</a><br>
					</div>"}
	*/

	output += "</ body></html>"
	SHOW_BROWSER(user, output, "window=mech_bay_console")
	onclose(user, "mech_bay_console")

/obj/machinery/computer/mech_bay_power_console/Topic(href, href_list)
	. = ..()
	if(href_list["autostart"])
		autostart = !autostart
	if(href_list["voltage"])
		voltage = text2num(href_list["voltage"])
		if(recharge_port)
			recharge_port.set_voltage(voltage)
	updateUsrDialog()