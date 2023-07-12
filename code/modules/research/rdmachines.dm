//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

/obj/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/machines/research.dmi'
	density = TRUE
	anchored = TRUE
	use_power = 1

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

	var/list/accepted_materials = list()
	var/list/stored_materials = list()
	var/max_storage_capacity

/obj/machinery/r_n_d/New()
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

/obj/machinery/r_n_d/attackby(obj/item/O as obj, mob/user as mob)
	if(stat)
		return 1
	if(disabled)
		to_chat(user, "\The [src.name] appears to not be working!")
		return 1
	if(busy)
		to_chat(user, SPAN_WARNING("\The [src.name] is busy. Please wait for completion of previous operation."))
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
		if(!istype(usr.get_active_hand(), /obj/item/wirecutters))
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

// Returns the total of all the stored materials. Makes code neater.
/obj/machinery/r_n_d/proc/get_total_stored_materials()
	for(var/material in stored_materials)
		. += stored_materials[material]

// Ejects all stored materials onto the ground.
/obj/machinery/r_n_d/proc/eject_stored_materials()
	if(stored_materials[MATERIAL_METAL] >= 3750)
		var/obj/item/stack/sheet/metal/G = new /obj/item/stack/sheet/metal(src.loc)
		G.amount = round(stored_materials[MATERIAL_METAL] / G.perunit)
	if(stored_materials[MATERIAL_GLASS] >= 3750)
		var/obj/item/stack/sheet/glass/G = new /obj/item/stack/sheet/glass(src.loc)
		G.amount = round(stored_materials[MATERIAL_GLASS] / G.perunit)
	if(stored_materials[MATERIAL_PLASMA] >= 2000)
		var/obj/item/stack/sheet/mineral/plasma/G = new /obj/item/stack/sheet/mineral/plasma(src.loc)
		G.amount = round(stored_materials[MATERIAL_PLASMA] / G.perunit)
	if(stored_materials[MATERIAL_SILVER] >= 2000)
		var/obj/item/stack/sheet/mineral/silver/G = new /obj/item/stack/sheet/mineral/silver(src.loc)
		G.amount = round(stored_materials[MATERIAL_SILVER] / G.perunit)
	if(stored_materials[MATERIAL_GOLD] >= 2000)
		var/obj/item/stack/sheet/mineral/gold/G = new /obj/item/stack/sheet/mineral/gold(src.loc)
		G.amount = round(stored_materials[MATERIAL_GOLD] / G.perunit)
	if(stored_materials[MATERIAL_URANIUM] >= 2000)
		var/obj/item/stack/sheet/mineral/uranium/G = new /obj/item/stack/sheet/mineral/uranium(src.loc)
		G.amount = round(stored_materials[MATERIAL_URANIUM] / G.perunit)
	if(stored_materials[MATERIAL_DIAMOND] >= 2000)
		var/obj/item/stack/sheet/mineral/diamond/G = new /obj/item/stack/sheet/mineral/diamond(src.loc)
		G.amount = round(stored_materials[MATERIAL_DIAMOND] / G.perunit)
	if(stored_materials[MATERIAL_BANANIUM] >= 2000)
		var/obj/item/stack/sheet/mineral/bananium/G = new /obj/item/stack/sheet/mineral/bananium(src.loc)
		G.amount = round(stored_materials[MATERIAL_BANANIUM] / G.perunit)
	if(stored_materials[MATERIAL_ADAMANTINE] >= 2000)
		var/obj/item/stack/sheet/mineral/adamantine/G = new /obj/item/stack/sheet/mineral/adamantine(src.loc)
		G.amount = round(stored_materials[MATERIAL_ADAMANTINE] / G.perunit)
	if(stored_materials[MATERIAL_MYTHRIL] >= 2000)
		var/obj/item/stack/sheet/mineral/mythril/G = new /obj/item/stack/sheet/mineral/mythril(src.loc)
		G.amount = round(stored_materials[MATERIAL_MYTHRIL] / G.perunit)