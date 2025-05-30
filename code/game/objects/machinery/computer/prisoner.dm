//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/prisoner
	name = "prisoner management"
	icon_state = "explosive"
	req_access = list(ACCESS_ARMOURY)
	circuit = /obj/item/circuitboard/prisoner

	var/id = 0.0
	var/temp = null
	var/status = 0
	var/timeleft = 60
	var/stop = 0.0
	var/screen = 0 // 0 - No Access Denied, 1 - Access allowed

	light_color = "#a91515"

/obj/machinery/computer/prisoner/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/computer/prisoner/attack_paw(mob/user)
	return

/obj/machinery/computer/prisoner/attack_hand(mob/user)
	if(..())
		return
	user.set_machine(src)
	var/dat
	dat += "<B>Prisoner Implant Manager System</B><BR>"
	if(screen == 0)
		dat += "<HR><A href='byond://?src=\ref[src];lock=1'>Unlock Console</A>"
	else if(screen == 1)
		dat += "<HR>Chemical Implants<BR>"
		var/turf/Tr = null
		for(var/obj/item/implant/chem/C in GLOBL.movable_atom_list)
			Tr = GET_TURF(C)
			if(isnotnull(Tr) && (Tr.z != src.z))
				continue//Out of range
			if(!C.implanted)
				continue
			dat += "[C.imp_in.name] | Remaining Units: [C.reagents.total_volume] | Inject: "
			dat += "<A href='byond://?src=\ref[src];inject1=\ref[C]'>(<font color=red>(1)</font>)</A>"
			dat += "<A href='byond://?src=\ref[src];inject5=\ref[C]'>(<font color=red>(5)</font>)</A>"
			dat += "<A href='byond://?src=\ref[src];inject10=\ref[C]'>(<font color=red>(10)</font>)</A><BR>"
			dat += "********************************<BR>"
		dat += "<HR>Tracking Implants<BR>"
		for(var/obj/item/implant/tracking/T in GLOBL.movable_atom_list)
			Tr = GET_TURF(T)
			if(isnotnull(Tr) && (Tr.z != src.z))
				continue//Out of range
			if(!T.implanted)
				continue
			var/loc_display = "Unknown"
			var/mob/living/carbon/M = T.imp_in
			if(isstationlevel(M.z) && !isspace(M.loc))
				loc_display = GET_AREA(M)
			if(T.malfunction)
				loc_display = pick(GLOBL.teleportlocs)
			dat += "ID: [T.id] | Location: [loc_display]<BR>"
			dat += "<A href='byond://?src=\ref[src];warn=\ref[T]'>(<font color=red><i>Message Holder</i></font>)</A> |<BR>"
			dat += "********************************<BR>"
		dat += "<HR><A href='byond://?src=\ref[src];lock=1'>Lock Console</A>"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/prisoner/process()
	if(!..())
		src.updateDialog()
	return

/obj/machinery/computer/prisoner/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(src.loc))) || (issilicon(usr)))
		usr.set_machine(src)

		if(href_list["inject1"])
			var/obj/item/implant/I = locate(href_list["inject1"])
			if(I)
				I.activate(1)

		else if(href_list["inject5"])
			var/obj/item/implant/I = locate(href_list["inject5"])
			if(I)
				I.activate(5)

		else if(href_list["inject10"])
			var/obj/item/implant/I = locate(href_list["inject10"])
			if(I)
				I.activate(10)

		else if(href_list["lock"])
			if(src.allowed(usr))
				screen = !screen
			else
				to_chat(usr, "Unauthorized Access.")

		else if(href_list["warn"])
			var/warning = copytext(sanitize(input(usr, "Message:", "Enter your message here!","")), 1, MAX_MESSAGE_LEN)
			if(!warning)
				return
			var/obj/item/implant/I = locate(href_list["warn"])
			if((I) && (I.imp_in))
				var/mob/living/carbon/R = I.imp_in
				to_chat(R, SPAN_ALIUM("You hear a voice in your head saying: '[warning]'"))

		src.add_fingerprint(usr)
	src.updateUsrDialog()
	return
