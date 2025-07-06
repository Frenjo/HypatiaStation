/obj/machinery/r_n_d/server
	name = "\improper R&D server"
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"

	power_usage = alist(
		USE_POWER_IDLE = 600
	)

	req_access = list(ACCESS_RD) //Only the R&D can change server settings.
	light_color = "#a97faa"

	var/delay = 10
	var/datum/research/files
	var/health = 100
	var/list/id_with_upload = list()		//List of R&D consoles with upload to server access.
	var/list/id_with_download = list()	//List of R&D consoles with download from server access.
	var/id_with_upload_string = ""		//String versions for easy editing in map editor.
	var/id_with_download_string = ""
	var/server_id = 0
	//var/heat_gen = 100
	//var/heating_power = 40000
	var/operating_temperature = 100 + T0C

/obj/machinery/r_n_d/server/initialise()
	. = ..()
	if(!files)
		files = new /datum/research(src)
	var/list/temp_list
	if(!length(id_with_upload))
		temp_list = list()
		temp_list = splittext(id_with_upload_string, ";")
		for(var/N in temp_list)
			id_with_upload.Add(text2num(N))
	if(!length(id_with_download))
		temp_list = list()
		temp_list = splittext(id_with_download_string, ";")
		for(var/N in temp_list)
			id_with_download.Add(text2num(N))

/obj/machinery/r_n_d/server/Destroy()
	griefProtection()
	return ..()

/obj/machinery/r_n_d/server/add_parts()
	component_parts = list(
		new /obj/item/circuitboard/rdserver(src),
		new /obj/item/stock_part/scanning_module(src),
		new /obj/item/stack/cable_coil(src),
		new /obj/item/stack/cable_coil(src)
	)
	return TRUE

/obj/machinery/r_n_d/server/refresh_parts()
	var/total_rating = 0
	for(var/obj/item/stock_part/part in src)
		total_rating += part.rating
	//heat_gen /= max(1, tot_rating)
	operating_temperature /= max(1, total_rating)
	power_usage[USE_POWER_IDLE] /= max(1, total_rating)

/obj/machinery/r_n_d/server/process()
	var/datum/gas_mixture/environment = loc.return_air()
	switch(environment.temperature)
		if(0 to T0C)
			health = min(100, health + 1)
		if(T0C to (T20C + 20))
			health = clamp(health, 0, 100)
		if((T20C + 20) to (T0C + 70))
			health = max(0, health - 1)
	if(health <= 0)
		griefProtection() //I dont like putting this in process() but it's the best I can do without re-writing a chunk of rd servers.
		files.known_designs = list()
		for_no_type_check(var/decl/tech/T, files.known_tech)
			if(prob(1))
				T.level--
		files.refresh_research()
	if(delay)
		delay--
	else
		//produce_heat(heat_gen)
		produce_heat(operating_temperature)
		delay = initial(delay)

/obj/machinery/r_n_d/server/meteorhit(obj/O)
	griefProtection()
	..()

/obj/machinery/r_n_d/server/emp_act(severity)
	griefProtection()
	..()

/obj/machinery/r_n_d/server/ex_act(severity)
	griefProtection()
	..()

/obj/machinery/r_n_d/server/blob_act()
	griefProtection()
	..()

//Backup files to centcom to help admins recover data after greifer attacks
/obj/machinery/r_n_d/server/proc/griefProtection()
	FOR_MACHINES_TYPED(server, /obj/machinery/r_n_d/server/centcom)
		for_no_type_check(var/decl/tech/T, files.known_tech)
			server.files.AddTech2Known(T)
		for_no_type_check(var/datum/design/D, files.known_designs)
			server.files.AddDesign2Known(D)
		server.files.refresh_research()

/obj/machinery/r_n_d/server/proc/produce_heat(/*heat_amt*/new_temperature)
	if(!(stat & (NOPOWER | BROKEN))) //Blatently stolen from space heater.
		var/turf/open/L = loc
		if(istype(L))
			var/datum/gas_mixture/env = L.return_air()
			//if(env.temperature < (heat_amt+T0C))
			if(env.temperature < new_temperature)
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)
				if(removed)
					/*
					var/heat_capacity = removed.heat_capacity()
					if(heat_capacity == 0 || heat_capacity == null)
						heat_capacity = 1
					removed.temperature = min((removed.temperature*heat_capacity + heating_power)/heat_capacity, 1000)
					*/
					var/heat_produced = min(removed.get_thermal_energy_change(new_temperature), power_usage[USE_POWER_IDLE])	//obviously can't produce more heat than the machine draws from it's power source
					removed.add_thermal_energy(heat_produced)

				env.merge(removed)

/obj/machinery/r_n_d/server/attackby(obj/item/O, mob/user)
	if(..())
		return 1

	if(isscrewdriver(O))
		if(!opened)
			opened = TRUE
			icon_state = "server_o"
		else
			opened = FALSE
			icon_state = "server"
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, opened)
		return 1
	if(opened)
		if(iscrowbar(O))
			griefProtection()
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
			M.state = 2
			M.icon_state = "box_1"
			for_no_type_check(var/obj/item/part, component_parts)
				if(part.reliability != 100 && crit_fail)
					part.crit_fail = TRUE
				part.forceMove(loc)
			qdel(src)
			return 1

/obj/machinery/r_n_d/server/attack_hand(mob/user)
	if(disabled)
		return
	if(shocked)
		shock(user, 50)
	return


/obj/machinery/r_n_d/server/centcom
	name = "\improper CentCom central R&D database"
	server_id = -1

/obj/machinery/r_n_d/server/centcom/initialise()
	. = ..()
	var/list/no_id_servers = list()
	var/list/server_ids = list()
	FOR_MACHINES_SUBTYPED(server, /obj/machinery/r_n_d/server)
		switch(server.server_id)
			if(-1)
				continue
			if(0)
				no_id_servers.Add(server)
			else
				server_ids.Add(server.server_id)

	for(var/obj/machinery/r_n_d/server/S in no_id_servers)
		var/num = 1
		while(!S.server_id)
			if(num in server_ids)
				num++
			else
				S.server_id = num
				server_ids.Add(num)
		no_id_servers.Remove(S)

/obj/machinery/r_n_d/server/centcom/process()
	return PROCESS_KILL	//don't need process()


#define RDSCONTROL_SCREEN_MAIN_MENU 0
#define RDSCONTROL_SCREEN_ACCESS_MENU 1
#define RDSCONTROL_SCREEN_DATA_MENU 2
#define RDSCONTROL_SCREEN_TRANSFER_MENU 3
/obj/machinery/computer/rdservercontrol
	name = "\improper R&D server controller"
	icon_state = "rdcomp"
	circuit = /obj/item/circuitboard/rdservercontrol

	var/screen = RDSCONTROL_SCREEN_MAIN_MENU
	var/obj/machinery/r_n_d/server/temp_server
	var/list/servers = list()
	var/list/consoles = list()
	var/badmin = 0

/obj/machinery/computer/rdservercontrol/Topic(href, href_list)
	if(..())
		return

	add_fingerprint(usr)
	usr.set_machine(src)
	if(!src.allowed(usr) && !emagged)
		to_chat(usr, SPAN_WARNING("You do not have the required access level."))
		return

	if(href_list["main"])
		screen = RDSCONTROL_SCREEN_MAIN_MENU

	else if(href_list["access"] || href_list["data"] || href_list["transfer"])
		temp_server = null
		consoles = list()
		servers = list()
		FOR_MACHINES_SUBTYPED(server, /obj/machinery/r_n_d/server)
			if(server.server_id == text2num(href_list["access"]) || server.server_id == text2num(href_list["data"]) || server.server_id == text2num(href_list["transfer"]))
				temp_server = server
				break
		if(href_list["access"])
			screen = RDSCONTROL_SCREEN_ACCESS_MENU
			FOR_MACHINES_TYPED(console, /obj/machinery/computer/rdconsole)
				if(console.sync)
					consoles += console
		else if(href_list["data"])
			screen = RDSCONTROL_SCREEN_DATA_MENU
		else if(href_list["transfer"])
			screen = RDSCONTROL_SCREEN_TRANSFER_MENU
			FOR_MACHINES_SUBTYPED(server, /obj/machinery/r_n_d/server)
				if(server == src)
					continue
				servers += server

	else if(href_list["upload_toggle"])
		var/num = text2num(href_list["upload_toggle"])
		if(num in temp_server.id_with_upload)
			temp_server.id_with_upload -= num
		else
			temp_server.id_with_upload += num

	else if(href_list["download_toggle"])
		var/num = text2num(href_list["download_toggle"])
		if(num in temp_server.id_with_download)
			temp_server.id_with_download -= num
		else
			temp_server.id_with_download += num

	else if(href_list["reset_tech"])
		var/choice = alert("Technology Data Rest", "Are you sure you want to reset this technology to its default data? Data lost cannot be recovered.", "Continue", "Cancel")
		if(choice == "Continue")
			for_no_type_check(var/decl/tech/T, temp_server.files.known_tech)
				if(T.type == text2path(href_list["reset_tech"]))
					T.level = 1
					break
		temp_server.files.refresh_research()

	else if(href_list["reset_design"])
		var/choice = alert("Design Data Deletion", "Are you sure you want to delete this design? If you still have the prerequisites for the design, it'll reset to its base reliability. Data lost cannot be recovered.", "Continue", "Cancel")
		if(choice == "Continue")
			for_no_type_check(var/datum/design/D, temp_server.files.known_designs)
				if(D.type == text2path(href_list["reset_design"]))
					D.reliability_mod = 0
					temp_server.files.known_designs.Remove(D)
					break
		temp_server.files.refresh_research()

	updateUsrDialog()
	return

/obj/machinery/computer/rdservercontrol/attack_hand(mob/user as mob)
	if(stat & (BROKEN | NOPOWER))
		return
	user.set_machine(src)
	var/dat = ""

	switch(screen)
		if(RDSCONTROL_SCREEN_MAIN_MENU) //Main Menu
			dat += "Connected Servers:<BR><BR>"
			FOR_MACHINES_SUBTYPED(server, /obj/machinery/r_n_d/server)
				if(istype(server, /obj/machinery/r_n_d/server/centcom) && !badmin)
					continue
				dat += "[server.name] || "
				dat += "<A href='byond://?src=\ref[src];access=[server.server_id]'> Access Rights</A> | "
				dat += "<A href='byond://?src=\ref[src];data=[server.server_id]'>Data Management</A>"
				if(badmin)
					dat += " | <A href='byond://?src=\ref[src];transfer=[server.server_id]'>Server-to-Server Transfer</A>"
				dat += "<BR>"

		if(RDSCONTROL_SCREEN_ACCESS_MENU) //Access rights menu
			dat += "[temp_server.name] Access Rights<BR><BR>"
			dat += "Consoles with Upload Access<BR>"
			for(var/obj/machinery/computer/rdconsole/C in consoles)
				var/turf/console_turf = GET_TURF(C)
				dat += "* <A href='byond://?src=\ref[src];upload_toggle=[C.id]'>[console_turf.loc]" //FYI, these are all numeric ids, eventually.
				if(C.id in temp_server.id_with_upload)
					dat += " (Remove)</A><BR>"
				else
					dat += " (Add)</A><BR>"
			dat += "Consoles with Download Access<BR>"
			for(var/obj/machinery/computer/rdconsole/C in consoles)
				var/turf/console_turf = GET_TURF(C)
				dat += "* <A href='byond://?src=\ref[src];download_toggle=[C.id]'>[console_turf.loc]"
				if(C.id in temp_server.id_with_download)
					dat += " (Remove)</A><BR>"
				else
					dat += " (Add)</A><BR>"
			dat += "<HR><A href='byond://?src=\ref[src];main=1'>Main Menu</A>"

		if(RDSCONTROL_SCREEN_DATA_MENU) //Data Management menu
			dat += "[temp_server.name] Data ManagementP<BR><BR>"
			dat += "Known Technologies<BR>"
			for_no_type_check(var/decl/tech/T, temp_server.files.known_tech)
				dat += "* [T.name] "
				dat += "<A href='byond://?src=\ref[src];reset_tech=[T.type]'>(Reset)</A><BR>" //FYI, these are all strings.
			dat += "Known Designs<BR>"
			for_no_type_check(var/datum/design/D, temp_server.files.known_designs)
				dat += "* [D.name] "
				dat += "<A href='byond://?src=\ref[src];reset_design=[D.type]'>(Delete)</A><BR>"
			dat += "<HR><A href='byond://?src=\ref[src];main=1'>Main Menu</A>"

		if(RDSCONTROL_SCREEN_TRANSFER_MENU) //Server Data Transfer
			dat += "[temp_server.name] Server to Server Transfer<BR><BR>"
			dat += "Send Data to what server?<BR>"
			for(var/obj/machinery/r_n_d/server/S in servers)
				dat += "[S.name] <A href='byond://?src=\ref[src];send_to=[S.server_id]'> (Transfer)</A><BR>"
			dat += "<HR><A href='byond://?src=\ref[src];main=1'>Main Menu</A>"
	user << browse("<TITLE>R&D Server Control</TITLE><HR>[dat]", "window=server_control;size=575x400")
	onclose(user, "server_control")
	return

/obj/machinery/computer/rdservercontrol/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(stat & (BROKEN | NOPOWER))
		FEEDBACK_MACHINE_UNRESPONSIVE(user)
		return FALSE

	if(emagged)
		to_chat(user, SPAN_WARNING("\The [src]'s security protocols have already been disabled!"))
		return FALSE
	to_chat(user, SPAN_WARNING("You disable \the [src]'s security protocols."))
	playsound(src, 'sound/effects/sparks/sparks4.ogg', 75, 1)
	emagged = TRUE
	updateUsrDialog()
	return TRUE
#undef RDSCONTROL_SCREEN_MAIN_MENU
#undef RDSCONTROL_SCREEN_ACCESS_MENU
#undef RDSCONTROL_SCREEN_DATA_MENU
#undef RDSCONTROL_SCREEN_TRANSFER_MENU


/obj/machinery/r_n_d/server/robotics
	name = "robotics R&D server"
	id_with_upload_string = "1;2"
	id_with_download_string = "1;2"
	server_id = 2

/obj/machinery/r_n_d/server/core
	name = "core R&D server"
	id_with_upload_string = "1"
	id_with_download_string = "1"
	server_id = 1