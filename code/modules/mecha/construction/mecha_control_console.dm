/obj/machinery/computer/mecha
	name = "exosuit control"
	icon_state = "mecha"
	req_access = list(ACCESS_ROBOTICS)
	circuit = /obj/item/circuitboard/mecha_control

	var/list/located = list()
	var/screen = 0
	var/stored_data

	light_color = "#a97faa"

/obj/machinery/computer/mecha/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/computer/mecha/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/computer/mecha/attack_hand(mob/user)
	if(..())
		return
	user.set_machine(src)
	var/dat = "<html><head><title>[src.name]</title><style>h3 {margin: 0px; padding: 0px;}</style></head><body>"
	if(screen == 0)
		dat += "<h3>Tracking beacons data</h3>"
		for(var/obj/item/mecha_part/tracking/TR in GLOBL.movable_atom_list)
			var/answer = TR.get_mecha_info()
			if(answer)
				dat += {"<hr>[answer]<br/>
							<a href='byond://?src=\ref[src];send_message=\ref[TR]'>Send message</a><br/>
							<a href='byond://?src=\ref[src];get_log=\ref[TR]'>Show exosuit log</a> | <a style='color: #f00;' href='byond://?src=\ref[src];shock=\ref[TR]'>(EMP pulse)</a><br>"}

	if(screen == 1)
		dat += "<h3>Log contents</h3>"
		dat += "<a href='byond://?src=\ref[src];return=1'>Return</a><hr>"
		dat += "[stored_data]"

	dat += "<A href='byond://?src=\ref[src];refresh=1'>(Refresh)</A><BR>"
	dat += "</body></html>"

	SHOW_BROWSER(user, dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/mecha/Topic(href, href_list)
	if(..())
		return
	var/datum/topic_input/topic_filter = new /datum/topic_input(href, href_list)
	if(href_list["send_message"])
		var/obj/item/mecha_part/tracking/MT = topic_filter.getObj("send_message")
		var/message = strip_html_simple(input(usr, "Input message", "Transmit message") as text)
		var/obj/mecha/M = MT.in_mecha()
		if(trim(message))
			M?.occupant_message(message)
		return
	if(href_list["shock"])
		var/obj/item/mecha_part/tracking/MT = topic_filter.getObj("shock")
		MT.shock()
	if(href_list["get_log"])
		var/obj/item/mecha_part/tracking/MT = topic_filter.getObj("get_log")
		stored_data = MT.get_mecha_log()
		screen = 1
	if(href_list["return"])
		screen = 0
	src.updateUsrDialog()
	return


/obj/item/mecha_part/tracking
	name = "exosuit tracking beacon"
	desc = "Device used to transmit exosuit data."
	icon = 'icons/obj/items/devices/device.dmi'
	icon_state = "motion2"
	origin_tech = alist(/decl/tech/magnets = 2, /decl/tech/programming = 2)

/obj/item/mecha_part/tracking/proc/get_mecha_info()
	var/obj/mecha/mech = in_mecha()
	if(isnull(mech))
		return null
	var/cell_charge = mech.get_charge()
	. = {"<b>Name:</b> [mech.name]<br>
		<b>Integrity:</b> [mech.health / initial(mech.health) * 100]%<br>
		<b>Cell charge:</b> [isnull(cell_charge) ? "Not found" : "[mech.cell.percent()]%"]<br>
		<b>Air Tank:</b> [mech.return_pressure()]kPa<br>
		<b>Pilot:</b> [mech.occupant || "None"]<br>
		<b>Location:</b> [GET_AREA(mech) || "Unknown"]<br>
		<b>Active equipment:</b> [mech.selected || "None"]"}
	if(istype(mech, /obj/mecha/working))
		var/obj/mecha/working/worker = mech
		. += "<b>Used cargo space:</b> [length(worker.cargo) / worker.cargo_capacity * 100]%<br>"

/obj/item/mecha_part/tracking/emp_act()
	qdel(src)
	return

/obj/item/mecha_part/tracking/ex_act()
	qdel(src)
	return

/obj/item/mecha_part/tracking/proc/in_mecha()
	if(ismecha(loc))
		return loc
	return null

/obj/item/mecha_part/tracking/proc/shock()
	var/obj/mecha/M = in_mecha()
	M?.emp_act(2)
	qdel(src)

/obj/item/mecha_part/tracking/proc/get_mecha_log()
	var/obj/mecha/M = in_mecha()
	return M?.get_log_html()


/obj/item/storage/box/mechabeacons
	name = "Exosuit Tracking Beacons"

	starts_with = list(
		/obj/item/mecha_part/tracking = 7
	)