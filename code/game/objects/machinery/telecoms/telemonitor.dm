//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
	Telecoms monitor tracks the overall trafficing of a telecommunications network
	and displays a heirarchy of linked machines.
*/

#define MONITOR_SCREEN_MAIN_MENU 0
#define MONITOR_SCREEN_VIEWING_MACHINE 1

/obj/machinery/computer/telecoms/monitor
	name = "telecommunications monitor"
	icon_state = "comm_monitor"

	circuit = /obj/item/circuitboard/comm_monitor

	var/screen = MONITOR_SCREEN_MAIN_MENU	// the screen number:
	var/list/machinelist = list()			// the machines located by the computer
	var/obj/machinery/telecoms/SelectedMachine

	var/network = "NULL"		// the network to probe
	var/temp = ""				// temporary feedback messages

/obj/machinery/computer/telecoms/monitor/attack_hand(mob/user)
	if(stat & (BROKEN|NOPOWER))
		return
	user.set_machine(src)
	var/dat = "<TITLE>Telecommunications Monitor</TITLE><center><b>Telecommunications Monitor</b></center>"

	switch(screen)
		// --- Main Menu ---
		if(MONITOR_SCREEN_MAIN_MENU)
			dat += "<br>[temp]<br><br>"
			dat += "<br>Current Network: <a href='byond://?src=\ref[src];network=1'>[network]</a><br>"
			if(length(machinelist))
				dat += "<br>Detected Network Entities:<ul>"
				for(var/obj/machinery/telecoms/T in machinelist)
					dat += "<li><a href='byond://?src=\ref[src];viewmachine=[T.id]'>\ref[T] [T.name]</a> ([T.id])</li>"
				dat += "</ul>"
				dat += "<br><a href='byond://?src=\ref[src];operation=release'>\[Flush Buffer\]</a>"
			else
				dat += "<a href='byond://?src=\ref[src];operation=probe'>\[Probe Network\]</a>"

		// --- Viewing Machine ---
		if(MONITOR_SCREEN_VIEWING_MACHINE)
			dat += "<br>[temp]<br>"
			dat += "<center><a href='byond://?src=\ref[src];operation=mainmenu'>\[Main Menu\]</a></center>"
			dat += "<br>Current Network: [network]<br>"
			dat += "Selected Network Entity: [SelectedMachine.name] ([SelectedMachine.id])<br>"
			dat += "Linked Entities: <ol>"
			for_no_type_check(var/obj/machinery/telecoms/T, SelectedMachine.links)
				if(!T.hide)
					dat += "<li><a href='byond://?src=\ref[src];viewmachine=[T.id]'>\ref[T.id] [T.name]</a> ([T.id])</li>"
			dat += "</ol>"

	user << browse(dat, "window=comm_monitor;size=575x400")
	onclose(user, "server_control")

	temp = ""
	return

/obj/machinery/computer/telecoms/monitor/Topic(href, href_list)
	if(..())
		return
	add_fingerprint(usr)
	usr.set_machine(src)

	if(href_list["viewmachine"])
		screen = MONITOR_SCREEN_VIEWING_MACHINE
		for(var/obj/machinery/telecoms/T in machinelist)
			if(T.id == href_list["viewmachine"])
				SelectedMachine = T
				break

	if(href_list["operation"])
		switch(href_list["operation"])
			if("release")
				machinelist = list()
				screen = MONITOR_SCREEN_MAIN_MENU

			if("mainmenu")
				screen = MONITOR_SCREEN_MAIN_MENU

			if("probe")
				if(length(machinelist))
					temp = "<font color = #D70B00>- FAILED: CANNOT PROBE WHEN BUFFER FULL -</font color>"
				else
					for(var/obj/machinery/telecoms/T in range(25, src))
						if(T.network == network)
							machinelist.Add(T)
					if(!length(machinelist))
						temp = "<font color = #D70B00>- FAILED: UNABLE TO LOCATE NETWORK ENTITIES IN \[[network]\] -</font color>"
					else
						temp = "<font color = #336699>- [length(machinelist)] ENTITIES LOCATED & BUFFERED -</font color>"

					screen = MONITOR_SCREEN_MAIN_MENU

	if(href_list["network"])
		var/newnet = input(usr, "Which network do you want to view?", "Comm Monitor", network) as null|text
		if(newnet && ((usr in range(1, src) || issilicon(usr))))
			if(length(newnet) > 15)
				temp = "<font color = #D70B00>- FAILED: NETWORK TAG STRING TOO LENGHTLY -</font color>"
			else
				network = newnet
				screen = MONITOR_SCREEN_MAIN_MENU
				machinelist = list()
				temp = "<font color = #336699>- NEW NETWORK TAG SET IN ADDRESS \[[network]\] -</font color>"

	updateUsrDialog()
	return

/obj/machinery/computer/telecoms/monitor/attack_emag(obj/item/card/emag/emag, mob/user, uses)
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

#undef MONITOR_SCREEN_MAIN_MENU
#undef MONITOR_SCREEN_VIEWING_MACHINE