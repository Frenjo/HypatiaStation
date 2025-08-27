//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

/obj/machinery/r_n_d
	name = "\improper R&D device"
	icon = 'icons/obj/machines/research.dmi'
	density = TRUE
	anchored = TRUE

	var/busy = FALSE
	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE
	var/list/wires = list()
	var/hack_wire
	var/disable_wire
	var/shock_wire
	var/opened = FALSE

	var/obj/machinery/computer/rdconsole/linked_console

/obj/machinery/r_n_d/initialise()
	. = ..()
	wires["Red"] = 0
	wires["Blue"] = 0
	wires["Green"] = 0
	wires["Yellow"] = 0
	wires["Black"] = 0
	wires["White"] = 0
	var/list/w = list("Red", "Blue", "Green", "Yellow", "Black", "White")
	hack_wire = pick(w)
	w -= hack_wire
	shock_wire = pick(w)
	w -= shock_wire
	disable_wire = pick(w)
	w -= disable_wire

/obj/machinery/r_n_d/Destroy()
	linked_console = null
	return ..()

/obj/machinery/r_n_d/attack_hand(mob/user)
	if(shocked)
		shock(user, 50)
	if(opened)
		var/dat
		dat += "[name] Wires:<BR>"
		for(var/wire in wires)
			dat += "[wire] Wire: <A href='byond://?src=\ref[src];wire=[wire];cut=1'>[wires[wire] ? "Mend" : "Cut"]</A> <A href='byond://?src=\ref[src];wire=[wire];pulse=1'>Pulse</A><BR>"
		dat += "The red light is [disabled ? "off" : "on"].<BR>"
		dat += "The green light is [shocked ? "off" : "on"].<BR>"
		dat += "The blue light is [hacked ? "off" : "on"].<BR>"
		SHOW_BROWSER(user, "<HTML><HEAD><TITLE>[name] Hacking</TITLE></HEAD><BODY>[dat]</BODY></HTML>","window=hack_win")
	return

/obj/machinery/r_n_d/attackby(obj/item/O, mob/user)
	if(stat)
		return 1
	if(disabled)
		to_chat(user, "\The [src] appears to not be working!")
		return 1
	if(busy)
		to_chat(user, SPAN_WARNING("\The [src] is busy. Please wait for completion of previous operation."))
		return 1

	if(shocked)
		shock(user, 50)

	return 0

/obj/machinery/r_n_d/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["pulse"])
		var/temp_wire = href_list["wire"]
		if(!ismultitool(usr.get_active_hand()))
			to_chat(usr, SPAN_WARNING("You need a multitool!"))
		else
			if(wires[temp_wire])
				to_chat(usr, SPAN_WARNING("You can't pulse a cut wire."))
			else
				if(hack_wire == href_list["wire"])
					hacked = !hacked
					spawn(100)
						hacked = !hacked
				if(disable_wire == href_list["wire"])
					disabled = !disabled
					shock(usr, 50)
					spawn(100)
						disabled = !disabled
				if(shock_wire == href_list["wire"])
					shocked = !shocked
					shock(usr, 50)
					spawn(100)
						shocked = !shocked
	if(href_list["cut"])
		if(!iswirecutter(usr.get_active_hand()))
			to_chat(usr, SPAN_WARNING("You need wirecutters!"))
		else
			var/temp_wire = href_list["wire"]
			wires[temp_wire] = !wires[temp_wire]
			if(hack_wire == temp_wire)
				hacked = !hacked
			if(disable_wire == temp_wire)
				disabled = !disabled
				shock(usr, 50)
			if(shock_wire == temp_wire)
				shocked = !shocked
				shock(usr, 50)
	updateUsrDialog()

/obj/machinery/r_n_d/proc/shock(mob/user, prb)
	if(stat & (BROKEN | NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	make_sparks(5, TRUE, src)
	if(electrocute_mob(user, GET_AREA(src), src, 0.7))
		return 1
	else
		return 0