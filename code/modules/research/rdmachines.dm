//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

/obj/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/machines/research.dmi'
	density = TRUE
	anchored = TRUE
	use_power = 1

	var/busy = 0
	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/list/wires = list()
	var/hack_wire
	var/disable_wire
	var/shock_wire
	var/opened = 0
	var/obj/machinery/computer/rdconsole/linked_console

/obj/machinery/r_n_d/New()
	..()
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

/obj/machinery/r_n_d/proc/shock(mob/user, prb)
	if(stat & (BROKEN | NOPOWER))		// unpowered, no shock
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect/system/spark_spread/s = new /datum/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(electrocute_mob(user, get_area(src), src, 0.7))
		return 1
	else
		return 0

/obj/machinery/r_n_d/attack_hand(mob/user as mob)
	if(shocked)
		shock(user, 50)
	if(opened)
		var/dat
		dat += "[name] Wires:<BR>"
		for(var/wire in wires)
			dat += "[wire] Wire: <A href='?src=\ref[src];wire=[wire];cut=1'>[wires[wire] ? "Mend" : "Cut"]</A> <A href='?src=\ref[src];wire=[wire];pulse=1'>Pulse</A><BR>"
		dat += "The red light is [disabled ? "off" : "on"].<BR>"
		dat += "The green light is [shocked ? "off" : "on"].<BR>"
		dat += "The blue light is [hacked ? "off" : "on"].<BR>"
		user << browse("<HTML><HEAD><TITLE>[name] Hacking</TITLE></HEAD><BODY>[dat]</BODY></HTML>","window=hack_win")
	return

/obj/machinery/r_n_d/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["pulse"])
		var/temp_wire = href_list["wire"]
		if(!istype(usr.get_active_hand(), /obj/item/device/multitool))
			to_chat(usr, "You need a multitool!")
		else
			if(wires[temp_wire])
				to_chat(usr, "You can't pulse a cut wire.")
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
		if(!istype(usr.get_active_hand(), /obj/item/weapon/wirecutters))
			to_chat(usr, "You need wirecutters!")
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