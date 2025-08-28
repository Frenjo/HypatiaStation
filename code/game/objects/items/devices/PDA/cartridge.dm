/obj/item/cartridge
	name = "generic cartridge"
	desc = "A data cartridge for portable microcomputers."
	icon = 'icons/obj/items/devices/pda.dmi'
	icon_state = "cart"
	item_state = "electronic"
	w_class = WEIGHT_CLASS_TINY

	matter_amounts = /datum/design/pda_cartridge::materials
	origin_tech = /datum/design/pda_cartridge::req_tech

	var/obj/item/radio/integrated/radio = null
	var/access_security = FALSE
	var/access_engine = FALSE
	var/access_atmos = FALSE
	var/access_medical = FALSE
	var/access_clown = FALSE
	var/access_mime = FALSE
	var/access_janitor = FALSE
//	var/access_flora = FALSE
	var/access_reagent_scanner = FALSE
	var/access_remote_door = FALSE	//Control some blast doors remotely!!
	var/remote_door_id = ""
	var/access_status_display = FALSE
	var/access_quartermaster = FALSE
	var/access_hydroponics = FALSE
	var/charges = 0
	var/mode = null
	var/menu
	var/datum/record/active1 = null //General
	var/datum/record/active2 = null //Medical
	var/datum/record/active3 = null //Security
	var/obj/machinery/power/monitor/powmonitor = null // Power Monitor
	var/list/powermonitors = list()
	var/message1	// used for status_displays
	var/message2
	var/list/stored_data = list()

/obj/item/cartridge/proc/post_status(command, data1, data2)
	var/datum/radio_frequency/frequency = global.CTradio.return_frequency(1435)
	if(!frequency)
		return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = TRANSMISSION_RADIO
	status_signal.data["command"] = command

	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
			if(loc)
				var/obj/item/PDA = loc
				var/mob/user = PDA.last_fingerprints
				if(isliving(PDA.loc))
					name = PDA.loc
				log_admin("STATUS: [user] set status screen with [PDA]. Message: [data1] [data2]")
				message_admins("STATUS: [user] set status screen with [PDA]. Message: [data1] [data2]")

		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(src, status_signal)


/*
	This generates the nano values of the cart menus.
	Because we close the UI when we insert a new cart
	we don't have to worry about null values on items
	the user can't access.  Well, unless they are href hacking.
	But in that case their UI will just lock up.
*/
/obj/item/cartridge/proc/create_NanoUI_values(mob/user)
	var/values[0]

	/*		Signaler (Mode: 40)				*/
	if(istype(radio, /obj/item/radio/integrated/signal) && (mode == 40))
		var/obj/item/radio/integrated/signal/R = radio
		values["signal_freq"] = format_frequency(R.frequency)
		values["signal_code"] = R.code


	/*		Station Display (Mode: 42)			*/
	if(mode == 42)
		values["message1"] = message1 ? message1 : "(none)"
		values["message2"] = message2 ? message2 : "(none)"


	/*		Power Monitor (Mode: 43 / 433)			*/
	if(mode == 43 || mode == 433)
		var/pMonData[0]
		FOR_MACHINES_TYPED(power_monitor, /obj/machinery/power/monitor)
			if(!(power_monitor.stat & (NOPOWER | BROKEN)))
				pMonData[++pMonData.len] = list("Name" = power_monitor.name, "ref" = "\ref[power_monitor]")
				if(isnull(powmonitor))
					powmonitor = power_monitor

		values["powermonitors"] = pMonData

		values["poweravail"] = powmonitor.powernet.avail
		values["powerload"] = num2text(powmonitor.powernet.viewload, 10)

		var/list/L = list()
		for(var/obj/machinery/power/terminal/term in powmonitor.powernet.nodes)
			if(istype(term.master, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/A = term.master
				L += A

		var/list/Status = list(0, 0, 1, 1)	// Status:  off, auto-off, on, auto-on
		var/list/chg = list(0, 1, 1)		// Charging: nope, charging, full
		var/apcData[0]
		for(var/obj/machinery/power/apc/A in L)
			apcData[++apcData.len] = list(
				"Name" = html_encode(A.area.name),
				"Equipment" = Status[A.equipment + 1],
				"Lights" = Status[A.lighting + 1],
				"Environment" = Status[A.environ + 1],
				"CellPct" = A.cell ? round(A.cell.percent(), 1) : -1,
				"CellStatus" = A.cell ? chg[A.charging + 1] : 0
			)

		values["apcs"] = apcData


	/*		General Records (Mode: 44 / 441 / 45 / 451)	*/
	if(mode == 44 || mode == 441 || mode == 45 || mode == 451)
		if(istype(active1, /datum/record) && (active1 in GLOBL.data_core.general))
			values["general"] = active1.fields
			values["general_exists"] = 1

		else
			values["general_exists"] = 0


	/*		Medical Records (Mode: 44 / 441)	*/
	if(mode == 44 || mode == 441)
		var/medData[0]
		for_no_type_check(var/datum/record/R, sortRecord(GLOBL.data_core.general))
			medData[++medData.len] = list(Name = R.fields["name"], "ref" = "\ref[R]")
		values["medical_records"] = medData

		if(istype(active2, /datum/record) && (active2 in GLOBL.data_core.medical))
			values["medical"] = active2.fields
			values["medical_exists"] = 1
		else
			values["medical_exists"] = 0


	/*		Security Records (Mode: 45 / 451)	*/
	if(mode == 45 || mode == 451)
		var/secData[0]
		for_no_type_check(var/datum/record/R, sortRecord(GLOBL.data_core.general))
			secData[++secData.len] = list(Name = R.fields["name"], "ref" = "\ref[R]")
		values["security_records"] = secData

		if(istype(active3, /datum/record) && (active3 in GLOBL.data_core.security))
			values["security"] = active3.fields
			values["security_exists"] = 1
		else
			values["security_exists"] = 0


	/*		Security Bot Control (Mode: 46)		*/
	if(mode == 46)
		var/botsData[0]
		var/beepskyData[0]
		if(istype(radio, /obj/item/radio/integrated/beepsky))
			var/obj/item/radio/integrated/beepsky/SC = radio
			beepskyData["active"] = SC.active
			if(SC.active && isnotnull(SC.botstatus))
				var/area/loca = SC.botstatus["loca"]
				var/loca_name = sanitize(loca.name)
				beepskyData["botstatus"] = list("loca" = loca_name, "mode" = SC.botstatus["mode"])
			else
				beepskyData["botstatus"] = list("loca" = null, "mode" = -1)
			var/botsCount = 0
			if(length(SC.botlist))
				for(var/obj/machinery/bot/B in SC.botlist)
					botsCount++
					if(B.loc)
						botsData[++botsData.len] = list("Name" = sanitize(B.name), "Location" = sanitize(B.loc.loc.name), "ref" = "\ref[B]")

			if(!length(botsData))
				botsData[++botsData.len] = list("Name" = "No bots found", "Location" = "Invalid", "ref" = null)

			beepskyData["bots"] = botsData
			beepskyData["count"] = botsCount

		else
			beepskyData["active"] = 0
			botsData[++botsData.len] = list("Name" = "No bots found", "Location" = "Invalid", "ref" = null)
			beepskyData["botstatus"] = list("loca" = null, "mode" = null)
			beepskyData["bots"] = botsData
			beepskyData["count"] = 0

		values["beepsky"] = beepskyData


	/*		MULEBOT Control	(Mode: 48)		*/
	if(mode == 48)
		var/muleData[0]
		var/mulebotsData[0]
		if(istype(radio, /obj/item/radio/integrated/mule))
			var/obj/item/radio/integrated/mule/QC = radio
			muleData["active"] = QC.active
			if(QC.active && isnotnull(QC.botstatus))
				var/area/loca = QC.botstatus["loca"]
				var/loca_name = sanitize(loca.name)
				muleData["botstatus"] = list(
					"loca" = loca_name,
					"mode" = QC.botstatus["mode"],
					"home" = QC.botstatus["home"],
					"powr" = QC.botstatus["powr"],
					"retn" = QC.botstatus["retn"],
					"pick" = QC.botstatus["pick"],
					"load" = QC.botstatus["load"],
					"dest" = sanitize(QC.botstatus["dest"])
				)
			else
				muleData["botstatus"] = list(
					"loca" = null,
					"mode" = -1,
					"home" = null,
					"powr" = null,
					"retn" = null,
					"pick" = null,
					"load" = null,
					"dest" = null
				)

			var/mulebotsCount = 0
			for(var/obj/machinery/bot/B in QC.botlist)
				mulebotsCount++
				if(B.loc)
					mulebotsData[++mulebotsData.len] = list("Name" = sanitize(B.name), "Location" = sanitize(B.loc.loc.name), "ref" = "\ref[B]")

			if(!length(mulebotsData))
				mulebotsData[++mulebotsData.len] = list("Name" = "No bots found", "Location" = "Invalid", "ref" = null)

			muleData["bots"] = mulebotsData
			muleData["count"] = mulebotsCount

		else
			muleData["botstatus"] = list(
				"loca" = null,
				"mode" = -1,
				"home" = null,
				"powr" = null,
				"retn" = null,
				"pick" = null,
				"load" = null,
				"dest" = null
			)
			muleData["active"] = 0
			mulebotsData[++mulebotsData.len] = list("Name" = "No bots found", "Location" = "Invalid", "ref" = null)
			muleData["bots"] = mulebotsData
			muleData["count"] = 0

		values["mulebot"] = muleData


	/*	Supply Shuttle Requests Menu (Mode: 47)		*/
	// Edited this to reflect 'shuttles' port. -Frenjo
	if(mode == 47)
		var/supplyData[0]

		var/datum/shuttle/ferry/supply/supply_shuttle = global.PCsupply.shuttle
		if(supply_shuttle)
			supplyData["shuttle_moving"] = supply_shuttle.has_arrive_time()
			supplyData["shuttle_eta"] = supply_shuttle.eta_minutes()
			supplyData["shuttle_loc"] = supply_shuttle.at_station() ? "Station" : "Dock"

		var/supplyOrderCount = 0
		var/supplyOrderData[0]
		for(var/S in global.PCsupply.shoppinglist)
			var/datum/supply_order/SO = S
			supplyOrderData[++supplyOrderData.len] = list(
				"Number" = SO.ordernum,
				"Name" = html_encode(SO.object.name),
				"ApprovedBy" = SO.orderedby,
				"Comment" = html_encode(SO.comment)
			)
		if(!length(supplyOrderData))
			supplyOrderData[++supplyOrderData.len] = list("Number" = null, "Name" = null, "OrderedBy" = null)

		supplyData["approved"] = supplyOrderData
		supplyData["approved_count"] = supplyOrderCount

		var/requestCount = 0
		var/requestData[0]
		for(var/S in global.PCsupply.requestlist)
			var/datum/supply_order/SO = S
			requestCount++
			requestData[++requestData.len] = list(
				"Number" = SO.ordernum,
				"Name" = html_encode(SO.object.name),
				"OrderedBy" = SO.orderedby,
				"Comment" = html_encode(SO.comment)
			)
		if(!length(requestData))
			requestData[++requestData.len] = list("Number" = null, "Name" = null, "orderedBy" = null, "Comment" = null)

		supplyData["requests"] = requestData
		supplyData["requests_count"] = requestCount

		values["supply"] = supplyData


	/*	Janitor Supplies Locator (Mode: 49)	*/
	if(mode == 49)
		var/JaniData[0]
		var/turf/cl = GET_TURF(src)

		if(isnotnull(cl))
			JaniData["user_loc"] = list("x" = cl.x, "y" = cl.y)
		else
			JaniData["user_loc"] = list("x" = 0, "y" = 0)
		var/MopData[0]
		for(var/obj/item/mop/M in GLOBL.movable_atom_list)
			var/turf/ml = GET_TURF(M)
			if(isnotnull(ml))
				if(ml.z != cl.z)
					continue
				var/direction = get_dir(src, M)
				MopData[++MopData.len] = list ("x" = ml.x, "y" = ml.y, "dir" = uppertext(dir2text(direction)), "status" = M.reagents.total_volume ? "Wet" : "Dry")

		if(!length(MopData))
			MopData[++MopData.len] = list("x" = 0, "y" = 0, dir=null, status = null)


		var/BucketData[0]
		for(var/obj/structure/mopbucket/B in GLOBL.movable_atom_list)
			var/turf/bl = GET_TURF(B)
			if(isnotnull(bl))
				if(bl.z != cl.z)
					continue
				var/direction = get_dir(src, B)
				BucketData[++BucketData.len] = list ("x" = bl.x, "y" = bl.y, "dir" = uppertext(dir2text(direction)), "status" = B.reagents.total_volume / 100)

		if(!length(BucketData))
			BucketData[++BucketData.len] = list("x" = 0, "y" = 0, dir = null, status = null)

		var/CbotData[0]
		for(var/obj/machinery/bot/cleanbot/B in GLOBL.bots_list)
			var/turf/bl = GET_TURF(B)
			if(isnotnull(bl))
				if(bl.z != cl.z)
					continue
				var/direction = get_dir(src,B)
				CbotData[++CbotData.len] = list("x" = bl.x, "y" = bl.y, "dir" = uppertext(dir2text(direction)), "status" = B.on ? "Online" : "Offline")


		if(!length(CbotData))
			CbotData[++CbotData.len] = list("x" = 0, "y" = 0, dir = null, status = null)
		var/CartData[0]
		for(var/obj/structure/janitorialcart/B in GLOBL.movable_atom_list)
			var/turf/bl = GET_TURF(B)
			if(isnotnull(bl))
				if(bl.z != cl.z)
					continue
				var/direction = get_dir(src,B)
				CartData[++CartData.len] = list("x" = bl.x, "y" = bl.y, "dir" = uppertext(dir2text(direction)), "status" = B.reagents.total_volume / 100)
		if(!length(CartData))
			CartData[++CartData.len] = list("x" = 0, "y" = 0, dir = null, status = null)

		JaniData["mops"] = MopData
		JaniData["buckets"] = BucketData
		JaniData["cleanbots"] = CbotData
		JaniData["carts"] = CartData
		values["janitor"] = JaniData

	return values

/obj/item/cartridge/Topic(href, href_list)
	..()
	if(!usr.canmove || usr.stat || usr.restrained() || !in_range(loc, usr))
		usr.unset_machine()
		CLOSE_BROWSER(usr, "window=pda")
		return

	switch(href_list["choice"])
		if("Medical Records")
			var/datum/record/R = locate(href_list["target"])
			var/datum/record/M = locate(href_list["target"])
			loc:mode = 441
			mode = 441
			if(R in GLOBL.data_core.general)
				for_no_type_check(var/datum/record/E, GLOBL.data_core.medical)
					if(E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"])
						M = E
						break
				active1 = R
				active2 = M

		if("Security Records")
			var/datum/record/R = locate(href_list["target"])
			var/datum/record/S = locate(href_list["target"])
			loc:mode = 451
			mode = 451
			if(R in GLOBL.data_core.general)
				for_no_type_check(var/datum/record/E, GLOBL.data_core.security)
					if(E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"])
						S = E
						break
				active1 = R
				active3 = S

		if("Send Signal")
			spawn(0)
				radio:send_signal("ACTIVATE")
				return

		if("Signal Frequency")
			var/new_frequency = sanitize_frequency(radio:frequency + text2num(href_list["sfreq"]))
			radio:radio_connection = register_radio(radio, new_frequency, new_frequency, null)

		if("Signal Code")
			radio:code += text2num(href_list["scode"])
			radio:code = round(radio:code)
			radio:code = min(100, radio:code)
			radio:code = max(1, radio:code)

		if(PANEL_STATUS)
			switch(href_list["statdisp"])
				if("message")
					post_status("message", message1, message2)
				if("alert")
					post_status("alert", href_list["alert"])
				if("setmsg1")
					message1 = input("Line 1", "Enter Message Text", message1) as text | null
					updateSelfDialog()
				if("setmsg2")
					message2 = input("Line 2", "Enter Message Text", message2) as text | null
					updateSelfDialog()
				else
					post_status(href_list["statdisp"])
		if("Power Select")
			var/pref = href_list["target"]
			powmonitor = locate(pref)
			loc:mode = 433
			mode = 433

	return 1