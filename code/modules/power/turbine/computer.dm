/obj/machinery/computer/turbine_control
	name = "gas turbine control computer"
	desc = "A computer to remotely control a gas turbine"
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
	for(var/obj/machinery/compressor/C in GLOBL.machines)
		if(id == C.comp_id)
			compressor = C
		doors = list()
		for(var/obj/machinery/door/poddoor/P in GLOBL.machines)
			if(P.id == id)
				doors.Add(P)

/*
/obj/machinery/computer/turbine_control/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/screwdriver))
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				FEEDBACK_BROKEN_GLASS_FALLS(user)
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				new /obj/item/shard( src.loc )
				var/obj/item/circuitboard/turbine_control/M = new /obj/item/circuitboard/turbine_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				M.id = src.id
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = TRUE
				qdel(src)
			else
				FEEDBACK_DISCONNECT_MONITOR(user)
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				var/obj/item/circuitboard/turbine_control/M = new /obj/item/circuitboard/turbine_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				M.id = src.id
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = TRUE
				qdel(src)
	else
		src.attack_hand(user)
	return
*/

/obj/machinery/computer/turbine_control/attack_hand(mob/user as mob)
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

	var/list/data = list()
	data["status"] = src.compressor.starter
	data["speed"] = round(src.compressor.rpm)
	data["power"] = round(src.compressor.turbine.lastgen)
	data["temp"] = round(src.compressor.gas_contained.temperature)
	data["doors"] = src.door_status

	// Ported most of this by studying SMES code. -Frenjo
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		ui = new(user, src, ui_key, "turbine_ctrl.tmpl", "Gas Turbine Control Computer", 420, 360)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update()