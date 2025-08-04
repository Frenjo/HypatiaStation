//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/pod
	name = "pod launch control"
	desc = "A control for launching pods. Some people prefer firing mechas."
	icon_state = "computer_generic"
	circuit = /obj/item/circuitboard/pod
	var/id = 1.0
	var/obj/machinery/mass_driver/connected = null
	var/timing = 0.0
	var/time = 30.0
	var/title = "Mass Driver Controls"

	light_color = "#00b000"

/obj/machinery/computer/pod/initialise()
	. = ..()
	FOR_MACHINES_TYPED(driver, /obj/machinery/mass_driver)
		if(driver.id == id)
			connected = driver

/obj/machinery/computer/pod/proc/alarm()
	if(stat & (NOPOWER|BROKEN))
		return

	if(!(connected))
		viewers(null, null) << "Cannot locate mass driver connector. Cancelling firing sequence!"
		return

	FOR_MACHINES_TYPED(pod_door, /obj/machinery/door/poddoor)
		if(pod_door.id == id)
			pod_door.open()
			return

	sleep(20)

	FOR_MACHINES_TYPED(driver, /obj/machinery/mass_driver)
		if(driver.id == id)
			driver.power = connected.power
			driver.drive()

	sleep(50)

	FOR_MACHINES_TYPED(pod_door, /obj/machinery/door/poddoor)
		if(pod_door.id == id)
			pod_door.close()
			return
	return

/*
/obj/machinery/computer/pod/attackby(obj/item/I, mob/user)
	if(isscrewdriver(I))
		playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if(stat & BROKEN)
				FEEDBACK_BROKEN_GLASS_FALLS(user)
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( loc )
				new /obj/item/shard( loc )

				//generate appropriate circuitboard. Accounts for /pod/old computer types
				var/obj/item/circuitboard/pod/M = null
				if(istype(src, /obj/machinery/computer/pod/old))
					M = new /obj/item/circuitboard/olddoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/syndicate))
						M = new /obj/item/circuitboard/syndicatedoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/swf))
						M = new /obj/item/circuitboard/swfdoor( A )
				else //it's not an old computer. Generate standard pod circuitboard.
					M = new /obj/item/circuitboard/pod( A )

				for(var/obj/C in src)
					C.forceMove(loc)
				M.id = id
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = TRUE
				qdel(src)
			else
				FEEDBACK_DISCONNECT_MONITOR(user)
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( loc )

				//generate appropriate circuitboard. Accounts for /pod/old computer types
				var/obj/item/circuitboard/pod/M = null
				if(istype(src, /obj/machinery/computer/pod/old))
					M = new /obj/item/circuitboard/olddoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/syndicate))
						M = new /obj/item/circuitboard/syndicatedoor( A )
					if(istype(src, /obj/machinery/computer/pod/old/swf))
						M = new /obj/item/circuitboard/swfdoor( A )
				else //it's not an old computer. Generate standard pod circuitboard.
					M = new /obj/item/circuitboard/pod( A )

				for(var/obj/C in src)
					C.forceMove(loc)
				M.id = id
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = TRUE
				qdel(src)
	else
		attack_hand(user)
	return
*/

/obj/machinery/computer/pod/attack_ai(mob/user)
	return attack_hand(user)


/obj/machinery/computer/pod/attack_paw(mob/user)
	return attack_hand(user)


/obj/machinery/computer/pod/attack_hand(mob/user)
	if(..())
		return

	var/dat = "<HTML><BODY><TT><B>[title]</B>"
	user.set_machine(src)
	if(connected)
		var/d2
		if(timing)	//door controls do not need timers.
			d2 = "<A href='byond://?src=\ref[src];time=0'>Stop Time Launch</A>"
		else
			d2 = "<A href='byond://?src=\ref[src];time=1'>Initiate Time Launch</A>"
		var/second = time % 60
		var/minute = (time - second) / 60
		dat += "<HR>\nTimer System: [d2]\nTime Left: [minute ? "[minute]:" : null][second] <A href='byond://?src=\ref[src];tp=-30'>-</A> <A href='byond://?src=\ref[src];tp=-1'>-</A> <A href='byond://?src=\ref[src];tp=1'>+</A> <A href='byond://?src=\ref[src];tp=30'>+</A>"
		var/temp = ""
		var/list/L = list( 0.25, 0.5, 1, 2, 4, 8, 16 )
		for(var/t in L)
			if(t == connected.power)
				temp += "[t] "
			else
				temp += "<A href='byond://?src=\ref[src];power=[t]'>[t]</A> "
		dat += "<HR>\nPower Level: [temp]<BR>\n<A href='byond://?src=\ref[src];alarm=1'>Firing Sequence</A><BR>\n<A href='byond://?src=\ref[src];drive=1'>Test Fire Driver</A><BR>\n<A href='byond://?src=\ref[src];door=1'>Toggle Outer Door</A><BR>"
	else
		dat += "<BR>\n<A href='byond://?src=\ref[src];door=1'>Toggle Outer Door</A><BR>"
	dat += "<BR><BR><A href='byond://?src=\ref[user];mach_close=computer'>Close</A></TT></BODY></HTML>"
	SHOW_BROWSER(user, dat, "window=computer;size=400x500")
	add_fingerprint(usr)
	onclose(user, "computer")
	return


/obj/machinery/computer/pod/process()
	if(!..())
		return
	if(timing)
		if(time > 0)
			time = round(time) - 1
		else
			alarm()
			time = 0
			timing = 0
		updateDialog()
	return


/obj/machinery/computer/pod/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(loc))) || (issilicon(usr)))
		usr.set_machine(src)
		if(href_list["power"])
			var/t = text2num(href_list["power"])
			t = min(max(0.25, t), 16)
			if(connected)
				connected.power = t
		if(href_list["alarm"])
			alarm()
		if(href_list["time"])
			timing = text2num(href_list["time"])
		if(href_list["tp"])
			var/tp = text2num(href_list["tp"])
			time += tp
			time = min(max(round(time), 0), 120)
		if(href_list["door"])
			FOR_MACHINES_TYPED(pod_door, /obj/machinery/door/poddoor)
				if(pod_door.id == id)
					if(pod_door.density)
						pod_door.open()
					else
						pod_door.close()
		updateUsrDialog()
	return



/obj/machinery/computer/pod/old
	icon_state = "old"
	name = "DoorMex Control Computer"
	title = "Door Controls"



/obj/machinery/computer/pod/old/syndicate
	name = "ProComp Executive IIc"
	desc = "The Syndicate operate on a tight budget. Operates external airlocks."
	title = "External Airlock Controls"
	req_access = list(ACCESS_SYNDICATE)

/obj/machinery/computer/pod/old/syndicate/attack_hand(mob/user)
	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user)
		return
	else
		..()

/obj/machinery/computer/pod/old/swf
	name = "Magix System IV"
	desc = "An arcane artifact that holds much magic. Running E-Knock 2.2: Sorceror's Edition"
