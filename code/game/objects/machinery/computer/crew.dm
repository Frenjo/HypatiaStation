/obj/machinery/computer/crew
	name = "crew monitoring computer"
	desc = "Used to monitor active health sensors built into most of the crew's uniforms."
	icon_state = "crew"
	circuit = /obj/item/circuitboard/crew

	power_usage = alist(
		USE_POWER_IDLE = 250,
		USE_POWER_ACTIVE = 500
	)

	light_color = "#315ab4"

	var/list/tracked

/obj/machinery/computer/crew/New()
	. = ..()
	tracked = list()

/obj/machinery/computer/crew/attack_ai(mob/user)
	attack_hand(user)
	ui_interact(user)

/obj/machinery/computer/crew/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/crew/update_icon()
	if(stat & BROKEN)
		icon_state = "crewb"
	else
		if(stat & NOPOWER)
			src.icon_state = "c_unpowered"
			stat |= NOPOWER
		else
			icon_state = initial(icon_state)
			stat &= ~NOPOWER

/obj/machinery/computer/crew/Topic(href, href_list)
	if(..())
		return
	if(src.z > 6)
		to_chat(usr, "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!")
		return 0
	if(href_list["close"])
		var/mob/user = usr
		var/datum/nanoui/ui = global.PCnanoui.get_open_ui(user, src, "main")
		usr.unset_machine()
		ui.close()
		return 0
	if(href_list["update"])
		src.updateDialog()
		return 1

/obj/machinery/computer/crew/interact(mob/user)
	ui_interact(user)

/obj/machinery/computer/crew/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(stat & (BROKEN|NOPOWER))
		return
	user.set_machine(src)
	scan()
	var/alist/data = alist()
	var/list/crewmembers = list()

	for(var/obj/item/clothing/under/C in tracked)
		var/turf/pos = GET_TURF(C)
		if(isnotnull(C) && C.has_sensor && pos?.z == z && C.sensor_mode)
			if(ishuman(C.loc))
				var/mob/living/carbon/human/H = C.loc
				var/area/crew_area = GET_AREA(H)
				var/alist/crew_data = alist(
					"sensor_type" = C.sensor_mode,
					"dead" = H.stat > 1,
					"oxy" = round(H.getOxyLoss(), 1),
					"tox" = round(H.getToxLoss(), 1),
					"fire" = round(H.getFireLoss(), 1),
					"brute" = round(H.getBruteLoss(), 1),
					"name" = isnotnull(H.id_store) ? H.id_store.name : "Unknown",
					"area" = crew_area.name,
					"x" = pos.x,
					"y" = pos.y
				)

				// Works around list += list2 merging lists; it's not pretty but it works
				crewmembers += "temporary item"
				crewmembers[length(crewmembers)] = crew_data

	crewmembers = sortByKey(crewmembers, "name")
	data["crewmembers"] = crewmembers

	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		ui = new /datum/nanoui(user, src, ui_key, "crew_monitor.tmpl", "Crew Monitoring Computer", 900, 600)
		ui.set_initial_data(data)
		ui.open()
		// should make the UI auto-update; doesn't seem to?
		ui.set_auto_update()

/obj/machinery/computer/crew/proc/scan()
	for(var/mob/living/carbon/human/H in GLOBL.mob_list)
		var/obj/item/clothing/under/C = H.wear_uniform
		if(C?.has_sensor)
			tracked |= C
	return 1