/obj/machinery/computer/turbine_control
	name = "gas turbine control computer"
	desc = "A computer to remotely control a gas turbine."
	icon_state = "airtunnel0e"
	circuit = /obj/item/circuitboard/turbine_control
	anchored = TRUE
	density = TRUE

	var/obj/machinery/compressor/compressor
	var/list/obj/machinery/door/poddoor/doors
	var/id = 0
	var/door_status = 0

/obj/machinery/computer/turbine_control/initialise()
	. = ..()
	FOR_MACHINES_TYPED(comp, /obj/machinery/compressor)
		if(id == comp.comp_id)
			compressor = comp
			break
	doors = list()
	FOR_MACHINES_TYPED(pod_door, /obj/machinery/door/poddoor)
		if(pod_door.id == id)
			doors.Add(pod_door)

/obj/machinery/computer/turbine_control/attack_hand(mob/user)
	user.machine = src
	ui_interact(user)
	return

/obj/machinery/computer/turbine_control/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(src.loc))) || issilicon(usr))
		usr.machine = src

		// Edited this to reflect NanoUI port. -Frenjo
		switch(href_list["action"])
			if("view")
				usr.client.eye = src.compressor
			if("strt")
				src.compressor.starter = 1
			if("stop")
				src.compressor.starter = 0
			if("doors_open")
				for(var/obj/machinery/door/poddoor/D in src.doors)
					spawn(0)
					D.open()
					door_status = 1
			if("doors_close")
				for(var/obj/machinery/door/poddoor/D in src.doors)
					spawn(0)
					D.close()
					door_status = 0

		src.add_fingerprint(usr)
	src.updateDialog()
	return

/obj/machinery/computer/turbine_control/process()
	src.updateDialog()
	return

// Porting this to NanoUI, it looks way better honestly. -Frenjo
/obj/machinery/computer/turbine_control/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(stat & BROKEN)
		return

	var/alist/data = alist(
		"status" = compressor.starter,
		"speed" = round(compressor.rpm),
		"power" = round(compressor.turbine.lastgen),
		"temp" = round(compressor.gas_contained.temperature),
		"doors" = door_status
	)

	// Ported most of this by studying SMES code. -Frenjo
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		ui = new /datum/nanoui(user, src, ui_key, "turbine_ctrl.tmpl", "Gas Turbine Control Computer", 420, 360)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update()