//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*

	All telecommunications interactions:

*/
#define STATION_Z 1
#define TELECOMM_Z 3

/obj/machinery/telecoms
	icon = 'icons/obj/machines/telecoms.dmi'
	var/temp = "" // output message
	var/construct_op = 0

/obj/machinery/telecoms/attack_tool(obj/item/tool, mob/user)
	// Using a multitool lets you access the receiver's interface
	if(ismultitool(tool))
		attack_hand(user)
		return TRUE

	return ..()

/obj/machinery/telecoms/attack_by(obj/item/I, mob/user)
	// REPAIRING: Use nanopaste to repair 10-20 integrity points.
	if(istype(I, /obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/paste = I
		if(integrity < 100) // Damaged, let's repair!
			integrity = clamp(integrity + rand(10, 20), 0, 100)
			paste.use(1)
			to_chat(user, SPAN_INFO("You apply \the [paste] to \the [src], repairing some of the damage."))
		else
			to_chat(user, SPAN_WARNING("This machine is already in perfect condition."))
		return TRUE

	return ..()

/obj/machinery/telecoms/attackby(obj/item/P, mob/user)
	switch(construct_op)
		if(0)
			if(isscrewdriver(P))
				to_chat(user, "You unfasten the bolts.")
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
				construct_op ++
		if(1)
			if(isscrewdriver(P))
				to_chat(user, "You fasten the bolts.")
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
				construct_op --
			if(iswrench(P))
				to_chat(user, "You dislodge the external plating.")
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				construct_op ++
		if(2)
			if(iswrench(P))
				to_chat(user, "You secure the external plating.")
				playsound(src, 'sound/items/Ratchet.ogg', 75, 1)
				construct_op --
			if(iswirecutter(P))
				playsound(src, 'sound/items/Wirecutter.ogg', 50, 1)
				to_chat(user, "You remove the cables.")
				construct_op ++
				var/obj/item/stack/cable_coil/A = new /obj/item/stack/cable_coil(user.loc)
				A.amount = 5
				stat |= BROKEN // the machine's been borked!
		if(3)
			if(iscable(P))
				var/obj/item/stack/cable_coil/A = P
				if(A.amount >= 5)
					to_chat(user, "You insert the cables.")
					A.amount -= 5
					if(A.amount <= 0)
						user.drop_item()
						qdel(A)
					construct_op --
					stat &= ~BROKEN // the machine's not borked anymore!
			if(iscrowbar(P))
				to_chat(user, "You begin prying out the circuit board and other components...")
				playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
				if(do_after(user, 60))
					to_chat(user, "You finish prying out the components.")

					// Drop all the component stuff
					if(length(contents))
						for_no_type_check(var/atom/movable/mover, src)
							mover.forceMove(user.loc)
					else
						// If the machine wasn't made during runtime, probably doesn't have components:
						// manually find the components and drop them!
						var/newpath = circuitboard
						var/obj/item/circuitboard/C = new newpath
						for(var/I in C.req_components)
							for(var/i = 1, i <= C.req_components[I], i++)
								newpath = I
								var/obj/item/s = new newpath
								s.forceMove(user.loc)
								if(iscable(P))
									var/obj/item/stack/cable_coil/A = P
									A.amount = 1

						// Drop a circuit board too
						C.forceMove(user.loc)

					// Create a machine frame and delete the current machine
					var/obj/machinery/constructable_frame/machine_frame/F = new
					F.forceMove(loc)
					qdel(src)

/obj/machinery/telecoms/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/telecoms/attack_hand(mob/user)
	// You need a multitool to use this, or be silicon
	if(!issilicon(user))
		// istype returns false if the value is null
		if(!ismultitool(user.get_active_hand()))
			return

	if(stat & (BROKEN|NOPOWER))
		return

	var/obj/item/multitool/P = get_multitool(user)

	user.set_machine(src)
	var/dat
	dat = "<font face = \"Courier\"><HEAD><TITLE>[src.name]</TITLE></HEAD><center><H3>[src.name] Access</H3></center>"
	dat += "<br>[temp]<br>"
	dat += "<br>Power Status: <a href='byond://?src=\ref[src];input=toggle'>[src.toggled ? "On" : "Off"]</a>"
	if(on && toggled)
		if(id != "" && id)
			dat += "<br>Identification String: <a href='byond://?src=\ref[src];input=id'>[id]</a>"
		else
			dat += "<br>Identification String: <a href='byond://?src=\ref[src];input=id'>NULL</a>"
		dat += "<br>Network: <a href='byond://?src=\ref[src];input=network'>[network]</a>"
		dat += "<br>Prefabrication: [length(autolinkers) ? "TRUE" : "FALSE"]"
		if(hide) dat += "<br>Shadow Link: ACTIVE</a>"

		//Show additional options for certain machines.
		dat += Options_Menu()

		dat += "<br>Linked Network Entities: <ol>"

		var/i = 0
		for_no_type_check(var/obj/machinery/telecoms/T, links)
			i++
			if(T.hide && !src.hide)
				continue
			dat += "<li>\ref[T] [T.name] ([T.id])  <a href='byond://?src=\ref[src];unlink=[i]'>\[X\]</a></li>"
		dat += "</ol>"

		dat += "<br>Filtering Frequencies: "

		i = 0
		if(length(freq_listening))
			for(var/x in freq_listening)
				i++
				if(i < length(freq_listening))
					dat += "[format_frequency(x)] GHz<a href='byond://?src=\ref[src];delete=[x]'>\[X\]</a>; "
				else
					dat += "[format_frequency(x)] GHz<a href='byond://?src=\ref[src];delete=[x]'>\[X\]</a>"
		else
			dat += "NONE"

		dat += "<br>  <a href='byond://?src=\ref[src];input=freq'>\[Add Filter\]</a>"
		dat += "<hr>"

		if(P)
			if(P.buffer)
				dat += "<br><br>MULTITOOL BUFFER: [P.buffer] ([P.buffer.id]) <a href='byond://?src=\ref[src];link=1'>\[Link\]</a> <a href='byond://?src=\ref[src];flush=1'>\[Flush\]"
			else
				dat += "<br><br>MULTITOOL BUFFER: <a href='byond://?src=\ref[src];buffer=1'>\[Add Machine\]</a>"

	dat += "</font>"
	temp = ""
	SHOW_BROWSER(user, dat, "window=tcommachine;size=520x500;can_resize=0")
	onclose(user, "dormitory")

/obj/machinery/telecoms/Topic(href, href_list)
	. = ..()
	if(!issilicon(usr))
		if(!ismultitool(usr.get_active_hand()))
			return

	if(stat & (BROKEN|NOPOWER))
		return

	var/obj/item/multitool/P = get_multitool(usr)

	if(href_list["input"])
		switch(href_list["input"])
			if("toggle")
				src.toggled = !src.toggled
				temp = "<font color = #666633>-% [src] has been [src.toggled ? "activated" : "deactivated"].</font color>"
				update_power()

			/*
			if("hide")
				src.hide = !hide
				temp = "<font color = #666633>-% Shadow Link has been [src.hide ? "activated" : "deactivated"].</font color>"
			*/

			if("id")
				var/newid = copytext(reject_bad_text(input(usr, "Specify the new ID for this machine", src, id) as null|text),1,MAX_MESSAGE_LEN)
				if(newid && canAccess(usr))
					id = newid
					temp = "<font color = #666633>-% New ID assigned: \"[id]\" %-</font color>"

			if("network")
				var/newnet = input(usr, "Specify the new network for this machine. This will break all current links.", src, network) as null|text
				if(newnet && canAccess(usr))
					if(length(newnet) > 15)
						temp = "<font color = #666633>-% Too many characters in new network tag %-</font color>"
					else
						for_no_type_check(var/obj/machinery/telecoms/T, links)
							T.links.Remove(src)
						network = newnet
						links = list()
						temp = "<font color = #666633>-% New network tag assigned: \"[network]\" %-</font color>"

			if("freq")
				var/newfreq = input(usr, "Specify a new frequency to filter (GHz). Decimals assigned automatically.", src, network) as null|num
				if(newfreq && canAccess(usr))
					if(findtext(num2text(newfreq), "."))
						newfreq *= 10 // shift the decimal one place
					if(!(newfreq in freq_listening) && newfreq < 10000)
						freq_listening.Add(newfreq)
						temp = "<font color = #666633>-% New frequency filter assigned: \"[newfreq] GHz\" %-</font color>"

	if(href_list["delete"])
		// changed the layout about to workaround a pesky runtime -- Doohl
		var/x = text2num(href_list["delete"])
		temp = "<font color = #666633>-% Removed frequency filter [x] %-</font color>"
		freq_listening.Remove(x)

	if(href_list["unlink"])
		if(text2num(href_list["unlink"]) <= length(links))
			var/obj/machinery/telecoms/T = links[text2num(href_list["unlink"])]
			temp = "<font color = #666633>-% Removed \ref[T] [T.name] from linked entities. %-</font color>"
			// Remove link entries from both T and src.
			if(src in T.links)
				T.links.Remove(src)
			links.Remove(T)

	if(href_list["link"])
		if(P)
			if(P.buffer && P.buffer != src)
				if(!(src in P.buffer.links))
					P.buffer.links.Add(src)
				if(!(P.buffer in src.links))
					src.links.Add(P.buffer)
				temp = "<font color = #666633>-% Successfully linked with \ref[P.buffer] [P.buffer.name] %-</font color>"
			else
				temp = "<font color = #666633>-% Unable to acquire buffer %-</font color>"

	if(href_list["buffer"])
		P.buffer = src
		temp = "<font color = #666633>-% Successfully stored \ref[P.buffer] [P.buffer.name] in buffer %-</font color>"

	if(href_list["flush"])
		temp = "<font color = #666633>-% Buffer successfully flushed. %-</font color>"
		P.buffer = null

	src.Options_Topic(href, href_list)

	usr.set_machine(src)
	src.add_fingerprint(usr)

	updateUsrDialog()


// Off-Site Relays
//
// You are able to send/receive signals from the station's z level (changeable in the STATION_Z #define) if
// the relay is on the telecomm satellite (changable in the TELECOMM_Z #define)
/obj/machinery/telecoms/relay/proc/toggle_level()
	var/position_z = GET_TURF_Z(src)

	// Toggle on/off getting signals from the station or the current Z level
	if(src.listening_level == STATION_Z) // equals the station
		src.listening_level = position_z
		return 1
	else if(position_z == TELECOMM_Z)
		src.listening_level = STATION_Z
		return 1
	return 0

// Returns a multitool from a user depending on their mobtype.
/obj/machinery/telecoms/proc/get_multitool(mob/user)
	var/obj/item/multitool/P = null
	// Let's double check
	if(!issilicon(user) && ismultitool(user.get_active_hand()))
		P = user.get_active_hand()
	else if(isAI(user))
		var/mob/living/silicon/ai/U = user
		P = U.aiMulti
	else if(isrobot(user) && in_range(user, src))
		if(ismultitool(user.get_active_hand()))
			P = user.get_active_hand()
	return P

// Additional Options for certain machines. Use this when you want to add an option to a specific machine.
// Example of how to use below.
/obj/machinery/telecoms/proc/Options_Menu()
	return ""

/*
// Add an option to the processor to switch processing mode. (COMPRESS -> UNCOMPRESS or UNCOMPRESS -> COMPRESS)
/obj/machinery/telecoms/processor/Options_Menu()
	var/dat = "<br>Processing Mode: <A href='byond://?src=\ref[src];process=1'>[process_mode ? "UNCOMPRESS" : "COMPRESS"]</a>"
	return dat
*/
// The topic for Additional Options. Use this for checking href links for your specific option.
// Example of how to use below.
/obj/machinery/telecoms/proc/Options_Topic(href, href_list)
	return

/*
/obj/machinery/telecoms/processor/Options_Topic(href, href_list)

	if(href_list["process"])
		temp = "<font color = #666633>-% Processing mode changed. %-</font color>"
		src.process_mode = !src.process_mode
*/

// RELAY
/obj/machinery/telecoms/relay/Options_Menu()
	var/dat = ""
	if(src.z == TELECOMM_Z)
		dat += "<br>Signal Locked to Station: <A href='byond://?src=\ref[src];change_listening=1'>[listening_level == STATION_Z ? "TRUE" : "FALSE"]</a>"
	dat += "<br>Broadcasting: <A href='byond://?src=\ref[src];broadcast=1'>[broadcasting ? "YES" : "NO"]</a>"
	dat += "<br>Receiving:    <A href='byond://?src=\ref[src];receive=1'>[receiving ? "YES" : "NO"]</a>"
	return dat

/obj/machinery/telecoms/relay/Options_Topic(href, href_list)
	if(href_list["receive"])
		receiving = !receiving
		temp = "<font color = #666633>-% Receiving mode changed. %-</font color>"
	if(href_list["broadcast"])
		broadcasting = !broadcasting
		temp = "<font color = #666633>-% Broadcasting mode changed. %-</font color>"
	if(href_list["change_listening"])
		//Lock to the station OR lock to the current position!
		//You need at least two receivers and two broadcasters for this to work, this includes the machine.
		var/result = toggle_level()
		if(result)
			temp = "<font color = #666633>-% [src]'s signal has been successfully changed.</font color>"
		else
			temp = "<font color = #666633>-% [src] could not lock it's signal onto the station. Two broadcasters or receivers required.</font color>"


// BUS
/obj/machinery/telecoms/bus/Options_Menu()
	var/dat = "<br>Change Signal Frequency: <A href='byond://?src=\ref[src];change_freq=1'>[change_frequency ? "YES ([change_frequency])" : "NO"]</a>"
	return dat

/obj/machinery/telecoms/bus/Options_Topic(href, href_list)
	if(href_list["change_freq"])
		var/newfreq = input(usr, "Specify a new frequency for new signals to change to. Enter null to turn off frequency changing. Decimals assigned automatically.", src, network) as null|num
		if(canAccess(usr))
			if(newfreq)
				if(findtext(num2text(newfreq), "."))
					newfreq *= 10 // shift the decimal one place
				if(newfreq < 10000)
					change_frequency = newfreq
					temp = "<font color = #666633>-% New frequency to change to assigned: \"[newfreq] GHz\" %-</font color>"
			else
				change_frequency = 0
				temp = "<font color = #666633>-% Frequency changing deactivated %-</font color>"

/obj/machinery/telecoms/proc/canAccess(mob/user)
	if(issilicon(user) || in_range(user, src))
		return TRUE
	return FALSE

#undef TELECOMM_Z
#undef STATION_Z