/obj/machinery/space_heater
	name = "space heater"
	desc = "Made by Space Amish using traditional space techniques, this heater is guaranteed not to set the station on fire."
	icon = 'icons/obj/atmospherics/atmos.dmi'
	icon_state = "sheater0"

	anchored = FALSE
	density = TRUE

	var/obj/item/cell/cell
	var/on = 0
	var/open = 0
	var/set_temperature = 50		// in celcius, add T0C for kelvin
	var/heating_power = 40000

/obj/machinery/space_heater/New()
	. = ..()
	cell = new /obj/item/cell(src)
	update_icon()

/obj/machinery/space_heater/update_icon()
	cut_overlays()
	icon_state = "sheater[on]"
	if(open)
		overlays  += "sheater-open"
	return

/obj/machinery/space_heater/examine()
	set src in oview(12)
	if(!usr)
		return
	to_chat(usr, "This is \icon[src] \an [src.name].")
	to_chat(usr, src.desc)

	to_chat(usr, "The heater is [on ? "on" : "off"] and the hatch is [open ? "open" : "closed"].")
	if(open)
		to_chat(usr, "The power cell is [cell ? "installed" : "missing"].")
	else
		to_chat(usr, "The charge meter reads [cell ? round(cell.percent(), 1) : 0]%")
	return

/obj/machinery/space_heater/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/space_heater/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, "There is already a power cell inside.")
				return
			else
				// insert cell
				var/obj/item/cell/C = usr.get_active_hand()
				if(istype(C))
					user.drop_item()
					cell = C
					C.forceMove(src)
					C.add_fingerprint(usr)

					user.visible_message(
						SPAN_INFO("[user] inserts a power cell into [src]."),
						SPAN_INFO("You insert the power cell into [src].")
					)
		else
			to_chat(user, "The hatch must be open to insert a power cell.")
			return
	else if(isscrewdriver(I))
		open = !open
		user.visible_message(
			SPAN_INFO("[user] [open ? "opens" : "closes"] the hatch on the [src]."),
			SPAN_INFO("You [open ? "open" : "close"] the hatch on the [src].")
		)
		update_icon()
		if(!open && user.machine == src)
			user << browse(null, "window=spaceheater")
			user.unset_machine()
	else
		..()
	return

/obj/machinery/space_heater/attack_hand(mob/user)
	src.add_fingerprint(user)
	interact(user)

/obj/machinery/space_heater/interact(mob/user)
	if(open)
		var/dat
		dat = "Power cell: "
		if(cell)
			dat += "<A href='byond://?src=\ref[src];op=cellremove'>Installed</A><BR>"
		else
			dat += "<A href='byond://?src=\ref[src];op=cellinstall'>Removed</A><BR>"

		dat += "Power Level: [cell ? round(cell.percent(),1) : 0]%<BR><BR>"

		dat += "Set Temperature: "

		dat += "<A href='byond://?src=\ref[src];op=temp;val=-5'>-</A>"

		dat += " [set_temperature]&deg;C "
		dat += "<A href='byond://?src=\ref[src];op=temp;val=5'>+</A><BR>"

		user.set_machine(src)
		user << browse("<HEAD><TITLE>Space Heater Control Panel</TITLE></HEAD><TT>[dat]</TT>", "window=spaceheater")
		onclose(user, "spaceheater")
	else
		on = !on
		user.visible_message(
			SPAN_INFO("[user] switches [on ? "on" : "off"] the [src]."),
			SPAN_INFO("You switch [on ? "on" : "off"] the [src].")
		)
		update_icon()
	return

/obj/machinery/space_heater/Topic(href, href_list)
	if(usr.stat)
		return
	if((in_range(src, usr) && isturf(src.loc)) || issilicon(usr))
		usr.set_machine(src)

		switch(href_list["op"])
			if("temp")
				var/value = text2num(href_list["val"])
				// limit to 20-90 degC
				set_temperature = dd_range(0, 90, set_temperature + value)
			if("cellremove")
				if(open && cell && !usr.get_active_hand())
					cell.updateicon()
					usr.put_in_hands(cell)
					cell.add_fingerprint(usr)
					cell = null
					usr.visible_message(
						SPAN_INFO("[usr] removes the power cell from \the [src]."),
						SPAN_INFO("You remove the power cell from \the [src].")
					)
			if("cellinstall")
				if(open && !cell)
					var/obj/item/cell/C = usr.get_active_hand()
					if(istype(C))
						usr.drop_item()
						cell = C
						C.forceMove(src)
						C.add_fingerprint(usr)

						usr.visible_message(
							SPAN_INFO("[usr] inserts a power cell into \the [src]."),
							SPAN_INFO("You insert the power cell into \the [src].")
						)
		updateDialog()
	else
		usr << browse(null, "window=spaceheater")
		usr.unset_machine()
	return

/obj/machinery/space_heater/process()
	if(on)
		if(cell && cell.charge > 0)
			var/turf/open/L = loc
			if(istype(L))
				var/datum/gas_mixture/env = L.return_air()
				if(env.temperature != set_temperature + T0C)
					var/transfer_moles = 0.25 * env.total_moles

					var/datum/gas_mixture/removed = env.remove(transfer_moles)

					//to_world("got [transfer_moles] moles at [removed.temperature]")

					if(removed)
						var/heat_capacity = removed.heat_capacity()
						//to_world("heating ([heat_capacity])")
						if(heat_capacity) // Added check to avoid divide by zero (oshi-) runtime errors -- TLE
							if(removed.temperature < set_temperature + T0C)
								removed.temperature = min(removed.temperature + heating_power / heat_capacity, 1000) // Added min() check to try and avoid wacky superheating issues in low gas scenarios -- TLE
							else
								removed.temperature = max(removed.temperature - heating_power / heat_capacity, TCMB)
							cell.use(heating_power / 20000)

						//to_world("now at [removed.temperature]")

					env.merge(removed)

					//to_world("turf now at [env.temperature]")
		else
			on = 0
			update_icon()
	return