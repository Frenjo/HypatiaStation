//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

#define TRAFFIC_SCREEN_MAIN_MENU 0
#define TRAFFIC_SCREEN_VIEWING_SERVER 1

/obj/machinery/computer/telecoms/traffic
	name = "telecommunications traffic control"
	icon_state = "computer_generic"
	req_access = list(ACCESS_TCOMSAT)

	circuit = /obj/item/circuitboard/comm_traffic

	var/screen = TRAFFIC_SCREEN_MAIN_MENU	// the screen number:
	var/list/obj/machinery/telecoms/server/servers = list()				// the servers located by the computer
	var/mob/editingcode
	var/mob/lasteditor
	var/list/viewingcode = list()
	var/obj/machinery/telecoms/server/SelectedServer

	var/network = "NULL"		// the network to probe
	var/temp = ""				// temporary feedback messages
	var/storedcode = ""			// code stored

/obj/machinery/computer/telecoms/traffic/attack_hand(mob/user)
	if(stat & (BROKEN|NOPOWER))
		return
	user.set_machine(src)
	var/dat = "<TITLE>Telecommunication Traffic Control</TITLE><center><b>Telecommunications Traffic Control</b></center>"

	switch(screen)
		// --- Main Menu ---
		if(TRAFFIC_SCREEN_MAIN_MENU)
			dat += "<br>[temp]<br>"
			dat += "<br>Current Network: <a href='byond://?src=\ref[src];network=1'>[network]</a><br>"
			if(length(servers))
				dat += "<br>Detected Telecommunication Servers:<ul>"
				for_no_type_check(var/obj/machinery/telecoms/server/T, servers)
					dat += "<li><a href='byond://?src=\ref[src];viewserver=[T.id]'>\ref[T] [T.name]</a> ([T.id])</li>"
				dat += "</ul>"
				dat += "<br><a href='byond://?src=\ref[src];operation=release'>\[Flush Buffer\]</a>"

			else
				dat += "<br>No servers detected. Scan for servers: <a href='byond://?src=\ref[src];operation=scan'>\[Scan\]</a>"

		// --- Viewing Server ---
		if(TRAFFIC_SCREEN_VIEWING_SERVER)
			dat += "<br>[temp]<br>"
			dat += "<center><a href='byond://?src=\ref[src];operation=mainmenu'>\[Main Menu\]</a>     <a href='byond://?src=\ref[src];operation=refresh'>\[Refresh\]</a></center>"
			dat += "<br>Current Network: [network]"
			dat += "<br>Selected Server: [SelectedServer.id]<br><br>"
			dat += "<br><a href='byond://?src=\ref[src];operation=editcode'>\[Edit Code\]</a>"
			dat += "<br>Signal Execution: "
			if(SelectedServer.autoruncode)
				dat += "<a href='byond://?src=\ref[src];operation=togglerun'>ALWAYS</a>"
			else
				dat += "<a href='byond://?src=\ref[src];operation=togglerun'>NEVER</a>"


	user << browse(dat, "window=traffic_control;size=575x400")
	onclose(user, "server_control")

	temp = ""
	return

/obj/machinery/computer/telecoms/traffic/Topic(href, href_list)
	if(..())
		return
	add_fingerprint(usr)
	usr.set_machine(src)

	if(!src.allowed(usr) && !emagged)
		FEEDBACK_ACCESS_DENIED(usr)
		return

	if(href_list["viewserver"])
		screen = TRAFFIC_SCREEN_VIEWING_SERVER
		for_no_type_check(var/obj/machinery/telecoms/server/T, servers)
			if(T.id == href_list["viewserver"])
				SelectedServer = T
				break

	if(href_list["operation"])
		switch(href_list["operation"])
			if("release")
				servers = list()
				screen = TRAFFIC_SCREEN_MAIN_MENU

			if("mainmenu")
				screen = TRAFFIC_SCREEN_MAIN_MENU

			if("scan")
				if(length(servers))
					temp = "<font color = #D70B00>- FAILED: CANNOT PROBE WHEN BUFFER FULL -</font color>"
				else
					for(var/obj/machinery/telecoms/server/T in range(25, src))
						if(T.network == network)
							servers.Add(T)
					if(!length(servers))
						temp = "<font color = #D70B00>- FAILED: UNABLE TO LOCATE SERVERS IN \[[network]\] -</font color>"
					else
						temp = "<font color = #336699>- [length(servers)] SERVERS PROBED & BUFFERED -</font color>"

					screen = TRAFFIC_SCREEN_MAIN_MENU

			if("editcode")
				if(editingcode == usr)
					return
				if(usr in viewingcode)
					return

				if(!editingcode)
					lasteditor = usr
					editingcode = usr
					winshow(editingcode, "Telecoms IDE", 1) // show the IDE
					winset(editingcode, "tcscode", "is-disabled=false")
					winset(editingcode, "tcscode", "text=\"\"")
					var/showcode = replacetext(storedcode, "\\\"", "\\\\\"")
					showcode = replacetext(storedcode, "\"", "\\\"")
					winset(editingcode, "tcscode", "text=\"[showcode]\"")
					spawn()
						update_ide()
				else
					viewingcode.Add(usr)
					winshow(usr, "Telecoms IDE", 1) // show the IDE
					winset(usr, "tcscode", "is-disabled=true")
					winset(editingcode, "tcscode", "text=\"\"")
					var/showcode = replacetext(storedcode, "\"", "\\\"")
					winset(usr, "tcscode", "text=\"[showcode]\"")

			if("togglerun")
				SelectedServer.autoruncode = !(SelectedServer.autoruncode)

	if(href_list["network"])
		var/newnet = input(usr, "Which network do you want to view?", "Comm Monitor", network) as null|text
		if(newnet && ((usr in range(1, src) || issilicon(usr))))
			if(length(newnet) > 15)
				temp = "<font color = #D70B00>- FAILED: NETWORK TAG STRING TOO LENGHTLY -</font color>"
			else
				network = newnet
				screen = TRAFFIC_SCREEN_MAIN_MENU
				servers = list()
				temp = "<font color = #336699>- NEW NETWORK TAG SET IN ADDRESS \[[network]\] -</font color>"

	updateUsrDialog()
	return

/obj/machinery/computer/telecoms/traffic/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE

	if(emagged)
		to_chat(user, SPAN_WARNING("\The [src]'s security protocols have already been disabled!"))
		return FALSE
	to_chat(user, SPAN_WARNING("You disable \the [src]'s security protocols."))
	playsound(src, 'sound/effects/sparks4.ogg', 75, 1)
	emagged = TRUE
	updateUsrDialog()
	return TRUE

/obj/machinery/computer/telecoms/traffic/proc/update_ide()
	// loop if there's someone manning the keyboard
	while(editingcode)
		if(!editingcode.client)
			editingcode = null
			break

		// For the typer, the input is enabled. Buffer the typed text
		if(editingcode)
			storedcode = "[winget(editingcode, "tcscode", "text")]"
		if(editingcode) // double if's to work around a runtime error
			winset(editingcode, "tcscode", "is-disabled=false")

		// If the player's not manning the keyboard anymore, adjust everything
		if((!(editingcode in range(1, src)) && !issilicon(editingcode)) || (editingcode.machine != src && !issilicon(editingcode)))
			if(editingcode)
				winshow(editingcode, "Telecoms IDE", 0) // hide the window!
			editingcode = null
			break

		// For other people viewing the typer type code, the input is disabled and they can only view the code
		// (this is put in place so that there's not any magical shenanigans with 50 people inputting different code all at once)
		if(length(viewingcode))
			// This piece of code is very important - it escapes quotation marks so string aren't cut off by the input element
			var/showcode = replacetext(storedcode, "\\\"", "\\\\\"")
			showcode = replacetext(storedcode, "\"", "\\\"")

			for(var/mob/M in viewingcode)
				if((M.machine == src && (M in view(1, src))) || issilicon(M))
					winset(M, "tcscode", "is-disabled=true")
					winset(M, "tcscode", "text=\"[showcode]\"")
				else
					viewingcode.Remove(M)
					winshow(M, "Telecoms IDE", 0) // hide the window!

		sleep(5)

	if(length(viewingcode) > 0)
		editingcode = pick(viewingcode)
		viewingcode.Remove(editingcode)
		update_ide()

#undef TRAFFIC_SCREEN_MAIN_MENU
#undef TRAFFIC_SCREEN_VIEWING_SERVER