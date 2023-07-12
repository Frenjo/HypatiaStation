// Moved supply computer from /code/game/supplyshuttle.dm
// (Also ported a bunch more Heaven's Gate - Eternal code to here)
// Well technically it was from /code/game/supplyshuttle_old.dm but I haven't finished the new one yet. -Frenjo

/obj/machinery/computer/supplycomp
	name = "Supply shuttle console"
	icon_state = "supply"
	req_access = list(ACCESS_CARGO)
	circuit = /obj/item/circuitboard/supplycomp

	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/hacked = 0
	var/can_order_contraband = 0
	var/decl/hierarchy/supply_pack/current_category

/obj/machinery/computer/supplycomp/initialize()
	. = ..()
	current_category = GET_DECL_INSTANCE(/decl/hierarchy/supply_pack)

/obj/machinery/computer/supplycomp/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/supplycomp/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/ordercomp
	name = "Supply ordering console"
	icon_state = "request"
	circuit = /obj/item/circuitboard/ordercomp

	var/temp = null
	var/reqtime = 0 //Cooldown for requisitions - Quarxink
	var/decl/hierarchy/supply_pack/current_category

/obj/machinery/computer/ordercomp/initialize()
	. = ..()
	current_category = GET_DECL_INSTANCE(/decl/hierarchy/supply_pack)

/obj/machinery/computer/ordercomp/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/ordercomp/attack_paw(mob/user as mob)
	return attack_hand(user)

/*
/obj/effect/marker/supplymarker
	icon_state = "X"
	icon = 'icons/misc/mark.dmi'
	name = "X"
	invisibility = INVISIBILITY_MAXIMUM
	anchored = TRUE
	opacity = FALSE
*/

/obj/machinery/computer/ordercomp/attack_hand(mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	var/dat
	if(temp)
		dat = temp
	else
		// Edited this to reflect 'shuttles' port. -Frenjo
		var/datum/shuttle/ferry/supply/supply_shuttle = global.CTsupply.shuttle
		dat += {"<BR><B>Supply shuttle</B><HR>
		Location: [supply_shuttle.has_arrive_time() ? "Moving to station ([supply_shuttle.eta_minutes()] Mins.)":supply_shuttle.at_station() ? "Station":"Dock"]<BR>
		<HR>Supply points: [global.CTsupply.points]<BR>
		<BR>\n<A href='?src=\ref[src];order=categories'>Request items</A><BR><BR>
		<A href='?src=\ref[src];vieworders=1'>View approved orders</A><BR><BR>
		<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR><BR>
		<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/ordercomp/Topic(href, href_list)
	if(..())
		return

	if(isturf(loc) && (in_range(src, usr) || issilicon(usr)))
		usr.set_machine(src)

	if(href_list["order"])
		if(href_list["order"] == "categories")
			current_category = GET_DECL_INSTANCE(/decl/hierarchy/supply_pack)
		else
			var/decl/hierarchy/supply_pack/requested_category = locate(href_list["order"]) in current_category.children
			if(!requested_category || !requested_category.is_category())
				return
			current_category = requested_category

		temp = list()
		temp += "<b>Supply points: [global.CTsupply.points]</b><BR>"
		if(current_category == GET_DECL_INSTANCE(/decl/hierarchy/supply_pack))
			temp += "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><HR><BR><BR>"
			temp += "<b>Select a category</b><BR><BR>"
			for(var/decl/hierarchy/supply_pack/sp in current_category.children)
				if(!sp.is_category())
					continue
				temp += "<A href='?src=\ref[src];order=\ref[sp]'>[sp.name]</A><BR>"
		else
			temp += "<A href='?src=\ref[src];order=categories'>Back to all categories</A><HR><BR><BR>"
			temp += "<b>Request from: [current_category.name]</b><BR><BR>"
			for(var/decl/hierarchy/supply_pack/sp in current_category.children)
				if(sp.hidden || sp.contraband || sp.is_category())
					continue
				temp += "<A href='?src=\ref[src];doorder=\ref[sp]'>[sp.name]</A> Cost: [sp.cost]<BR>"

		temp = jointext(temp, null)

	else if(href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"")
			return

		//Find the correct supply_pack datum
		var/decl/hierarchy/supply_pack/P = locate(href_list["doorder"]) in current_category.children
		if(!istype(P) || P.is_category())
			return

		var/timeout = world.time + 1 MINUTE
		var/reason = copytext(sanitize(input(usr, "Reason:", "Why do you require this item?", "") as null | text), 1, MAX_MESSAGE_LEN)
		if(world.time > timeout)
			return
		if(!reason)
			return

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(issilicon(usr))
			idname = usr.real_name

		global.CTsupply.ordernum++ // Edited this to reflect 'shuttles' port. -Frenjo
		var/obj/item/paper/reqform = new /obj/item/paper(loc)
		reqform.name = "Requisition Form - [P.name]"
		reqform.info += "<h3>[GLOBL.current_map.station_name] Supply Requisition Form</h3><hr>"
		reqform.info += "INDEX: #[global.CTsupply.ordernum]<br>" // Edited this to reflect 'shuttles' port. -Frenjo
		reqform.info += "REQUESTED BY: [idname]<br>"
		reqform.info += "RANK: [idrank]<br>"
		reqform.info += "REASON: [reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [P.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [get_access_desc(P.access)]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += P.manifest
		reqform.info += "<hr>"
		reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

		reqform.update_icon()	//Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = global.CTsupply.ordernum // Edited this to reflect 'shuttles' port. -Frenjo
		O.object = P
		O.orderedby = idname
		global.CTsupply.requestlist += O // Edited this to reflect 'shuttles' port. -Frenjo

		temp = "Thanks for your request. The cargo team will process it as soon as possible.<BR>"
		temp += "<BR><A href='?src=\ref[src];order=\ref[current_category]'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if(href_list["vieworders"])
		temp = "Current approved orders: <BR><BR>"
		for(var/S in global.CTsupply.shoppinglist) // Edited this to reflect 'shuttles' port. -Frenjo
			var/datum/supply_order/SO = S
			temp += "[SO.object.name] approved by [SO.orderedby] [SO.comment ? "([SO.comment])":""]<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if(href_list["viewrequests"])
		temp = "Current requests: <BR><BR>"
		for(var/S in global.CTsupply.requestlist) // Edited this to reflect 'shuttles' port. -Frenjo
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby]<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if(href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/supplycomp/attack_hand(var/mob/user as mob)
	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user)
		return

	if(..())
		return
	user.set_machine(src)
	post_signal("supply")
	var/dat
	if (temp)
		dat = temp
	else
		// Edited this to reflect 'shuttles' port. -Frenjo
		var/datum/shuttle/ferry/supply/supply_shuttle = global.CTsupply.shuttle
		if (supply_shuttle)
			dat += {"<BR><B>Supply shuttle</B><HR>
		\nLocation: [supply_shuttle.has_arrive_time() ? "Moving to station ([supply_shuttle.eta_minutes()] Mins.)":supply_shuttle.at_station() ? "Station":"Away"]<BR>
		<HR>\nSupply points: [global.CTsupply.points]<BR>\n<BR>
		[supply_shuttle.has_arrive_time() ? "\n*Must be away to order items*<BR>\n<BR>":supply_shuttle.at_station() ? "\n*Must be away to order items*<BR>\n<BR>":"\n<A href='?src=\ref[src];order=categories'>Order items</A><BR>\n<BR>"]
		[supply_shuttle.has_arrive_time() ? "\n*Shuttle already called*<BR>\n<BR>":supply_shuttle.at_station() ? "\n<A href='?src=\ref[src];send=1'>Send away</A><BR>\n<BR>":"\n<A href='?src=\ref[src];send=1'>Send to station</A><BR>\n<BR>"]
		\n<A href='?src=\ref[src];viewrequests=1'>View requests</A><BR>\n<BR>
		\n<A href='?src=\ref[src];vieworders=1'>View orders</A><BR>\n<BR>
		\n<A href='?src=\ref[user];mach_close=computer'>Close</A>"}

	user << browse(dat, "window=computer;size=575x450")
	onclose(user, "computer")
	return

/obj/machinery/computer/supplycomp/attackby(I as obj, user as mob)
	if(istype(I,/obj/item/card/emag) && !hacked)
		to_chat(user, SPAN_INFO("Special supplies unlocked."))
		hacked = 1
		return
	else
		..()
	return

/obj/machinery/computer/supplycomp/Topic(href, href_list)
	if(!global.CTsupply) // Edited this to reflect 'shuttles' port. -Frenjo
		world.log << "## ERROR: Eek. The supply_shuttle controller datum is missing somehow."
		return

	var/datum/shuttle/ferry/supply/supply_shuttle = global.CTsupply.shuttle // Edited this to reflect 'shuttles' port. -Frenjo

	if(..())
		return

	if(isturf(loc) && (in_range(src, usr) || issilicon(usr)))
		usr.set_machine(src)

	//Calling the shuttle
	if(href_list["send"])
		if(supply_shuttle.forbidden_atoms_check()) // Edited this to reflect 'shuttles' port. -Frenjo
			temp = "For safety reasons the automated supply shuttle cannot transport live organisms, classified nuclear weaponry or homing beacons.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

		else if(supply_shuttle.at_station()) // Edited this to reflect 'shuttles' port. -Frenjo
			supply_shuttle.launch(src) // Edited this to reflect 'shuttles' port. -Frenjo
			temp = "The supply shuttle has departed.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
		else
			// Edited this to reflect 'shuttles' port. -Frenjo
			supply_shuttle.launch(src)
			temp = "The supply shuttle has been called and will arrive in [round(global.CTsupply.movetime/600,1)] minutes.<BR><BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
			//post_signal("supply")

	else if(href_list["order"])
		if(supply_shuttle.has_arrive_time()) // Edited this to reflect 'shuttles' port. -Frenjo
			return
		if(href_list["order"] == "categories")
			current_category = GET_DECL_INSTANCE(/decl/hierarchy/supply_pack)
		else
			var/decl/hierarchy/supply_pack/requested_category = locate(href_list["order"]) in current_category.children
			if(!requested_category || !requested_category.is_category())
				return
			current_category = requested_category

		temp = list()
		temp += "<b>Supply points: [global.CTsupply.points]</b><BR>"
		if(current_category == GET_DECL_INSTANCE(/decl/hierarchy/supply_pack))
			temp += "<A href='?src=\ref[src];mainmenu=1'>Main Menu</A><HR><BR><BR>"
			temp += "<b>Select a category</b><BR><BR>"
			for(var/decl/hierarchy/supply_pack/sp in current_category.children)
				if(!sp.is_category())
					continue
				temp += "<A href='?src=\ref[src];order=\ref[sp]'>[sp.name]</A><BR>"
		else
			temp += "<A href='?src=\ref[src];order=categories'>Back to all categories</A><HR><BR><BR>"
			temp += "<b>Request from: [current_category.name]</b><BR><BR>"
			for(var/decl/hierarchy/supply_pack/sp in current_category.children)
				if((sp.hidden && !hacked) || (sp.contraband && !can_order_contraband) || sp.is_category())
					continue
				temp += "<A href='?src=\ref[src];doorder=\ref[sp]'>[sp.name]</A> Cost: [sp.cost]<BR>"

		temp = jointext(temp, null)

	else if(href_list["doorder"])
		if(world.time < reqtime)
			for(var/mob/V in hearers(src))
				V.show_message("<b>[src]</b>'s monitor flashes, \"[world.time - reqtime] seconds remaining until another requisition form may be printed.\"")
			return

		//Find the correct supply_pack datum
		var/decl/hierarchy/supply_pack/P = locate(href_list["doorder"]) in current_category.children
		if(!P || P.is_category())
			return

		var/timeout = world.time + 600
		var/reason = copytext(sanitize(input(usr, "Reason:", "Why do you require this item?","") as null | text), 1, MAX_MESSAGE_LEN)
		if(world.time > timeout)
			return
		if(!reason)
			return

		var/idname = "*None Provided*"
		var/idrank = "*None Provided*"
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			idname = H.get_authentification_name()
			idrank = H.get_assignment()
		else if(issilicon(usr))
			idname = usr.real_name

		global.CTsupply.ordernum++ // Edited this to reflect 'shuttles' port. -Frenjo
		var/obj/item/paper/reqform = new /obj/item/paper(loc)
		reqform.name = "Requisition Form - [P.name]"
		reqform.info += "<h3>[GLOBL.current_map.station_name] Supply Requisition Form</h3><hr>"
		reqform.info += "INDEX: #[global.CTsupply.ordernum]<br>" // Edited this to reflect 'shuttles' port. -Frenjo
		reqform.info += "REQUESTED BY: [idname]<br>"
		reqform.info += "RANK: [idrank]<br>"
		reqform.info += "REASON: [reason]<br>"
		reqform.info += "SUPPLY CRATE TYPE: [P.name]<br>"
		reqform.info += "ACCESS RESTRICTION: [get_access_desc(P.access)]<br>"
		reqform.info += "CONTENTS:<br>"
		reqform.info += P.manifest
		reqform.info += "<hr>"
		reqform.info += "STAMP BELOW TO APPROVE THIS REQUISITION:<br>"

		reqform.update_icon()	//Fix for appearing blank when printed.
		reqtime = (world.time + 5) % 1e5

		//make our supply_order datum
		var/datum/supply_order/O = new /datum/supply_order()
		O.ordernum = global.CTsupply.ordernum // Edited this to reflect 'shuttles' port. -Frenjo
		O.object = P
		O.orderedby = idname
		global.CTsupply.requestlist += O // Edited this to reflect 'shuttles' port. -Frenjo

		temp = "Order request placed.<BR>"
		temp += "<BR><A href='?src=\ref[src];order=\ref[current_category]'>Back</A> | <A href='?src=\ref[src];mainmenu=1'>Main Menu</A> | <A href='?src=\ref[src];confirmorder=[O.ordernum]'>Authorize Order</A>"

	else if(href_list["confirmorder"])
		//Find the correct supply_order datum
		var/ordernum = text2num(href_list["confirmorder"])
		var/datum/supply_order/O
		var/decl/hierarchy/supply_pack/P
		temp = "Invalid Request"
		for(var/i = 1, i <= length(global.CTsupply.requestlist), i++) // Edited this to reflect 'shuttles' port. -Frenjo
			var/datum/supply_order/SO = global.CTsupply.requestlist[i] // Edited this to reflect 'shuttles' port. -Frenjo
			if(SO.ordernum == ordernum)
				O = SO
				P = O.object
				// Edited this to reflect 'shuttles' port. -Frenjo
				if(global.CTsupply.points >= P.cost)
					global.CTsupply.requestlist.Cut(i,i + 1)
					global.CTsupply.points -= P.cost
					global.CTsupply.shoppinglist += O

					temp = "Thanks for your order.<BR>"
					temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
				else
					temp = "Not enough supply points.<BR>"
					temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"
				break

	else if(href_list["vieworders"])
		temp = "Current approved orders: <BR><BR>"
		//for(var/S in supply_shuttle.shoppinglist)
		for(var/S in global.CTsupply.shoppinglist) // Edited this to reflect 'shuttles' port. -Frenjo
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] approved by [SO.orderedby][SO.comment ? " ([SO.comment])":""]<BR>"// <A href='?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
/*
	else if (href_list["cancelorder"])
		var/datum/supply_order/remove_supply = href_list["cancelorder"]
		supply_shuttle_shoppinglist -= remove_supply
		supply_shuttle_points += remove_supply.object.cost
		temp += "Canceled: [remove_supply.object.name]<BR><BR><BR>"

		for(var/S in supply_shuttle_shoppinglist)
			var/datum/supply_order/SO = S
			temp += "[SO.object.name] approved by [SO.orderedby][SO.comment ? " ([SO.comment])":""] <A href='?src=\ref[src];cancelorder=[S]'>(Cancel)</A><BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"
*/
	else if(href_list["viewrequests"])
		temp = "Current requests: <BR><BR>"
		for(var/S in global.CTsupply.requestlist) // Edited this to reflect 'shuttles' port. -Frenjo
			var/datum/supply_order/SO = S
			temp += "#[SO.ordernum] - [SO.object.name] requested by [SO.orderedby]  [supply_shuttle.has_arrive_time() ? "":supply_shuttle.at_station() ? "":"<A href='?src=\ref[src];confirmorder=[SO.ordernum]'>Approve</A> <A href='?src=\ref[src];rreq=[SO.ordernum]'>Remove</A>"]<BR>" // Edited this to reflect 'shuttles' port. -Frenjo

		temp += "<BR><A href='?src=\ref[src];clearreq=1'>Clear list</A>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if(href_list["rreq"])
		var/ordernum = text2num(href_list["rreq"])
		temp = "Invalid Request.<BR>"

		// Edited this to reflct 'shuttles' port. -Frenjo
		for(var/i = 1, i <= length(global.CTsupply.requestlist), i++)
			var/datum/supply_order/SO = global.CTsupply.requestlist[i]
			if(SO.ordernum == ordernum)
				global.CTsupply.requestlist.Cut(i,i + 1) // Edited this to reflct 'shuttles' port. -Frenjo
				temp = "Request removed.<BR>"
				break
		temp += "<BR><A href='?src=\ref[src];viewrequests=1'>Back</A> <A href='?src=\ref[src];mainmenu=1'>Main Menu</A>"

	else if(href_list["clearreq"])
		global.CTsupply.requestlist.Cut() // Edited this to reflct 'shuttles' port. -Frenjo
		temp = "List cleared.<BR>"
		temp += "<BR><A href='?src=\ref[src];mainmenu=1'>OK</A>"

	else if(href_list["mainmenu"])
		temp = null

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/supplycomp/proc/post_signal(command)
	var/datum/radio_frequency/frequency = global.CTradio.return_frequency(1435)

	if(!frequency)
		return

	var/datum/signal/status_signal = new
	status_signal.source = src
	status_signal.transmission_method = TRANSMISSION_RADIO
	status_signal.data["command"] = command

	frequency.post_signal(src, status_signal)