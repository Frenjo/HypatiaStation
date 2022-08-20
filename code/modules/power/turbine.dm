// Moved these around a bit to put them under /power/turbine. -Frenjo
/obj/machinery/power/turbine/compressor
	name = "compressor"
	desc = "The compressor stage of a gas turbine generator."
	icon = 'icons/obj/pipes.dmi'
	icon_state = "compressor"
	anchored = TRUE
	density = TRUE
	var/obj/machinery/power/turbine/turbine/turbine
	var/datum/gas_mixture/gas_contained
	var/turf/simulated/inturf
	var/starter = 0
	var/rpm = 0
	var/rpmtarget = 0
	var/capacity = 1e6
	var/comp_id = 0

// the inlet stage of the gas turbine electricity generator
/obj/machinery/power/turbine/compressor/New()
	..()
	gas_contained = new
	inturf = get_step(src, dir)

/obj/machinery/power/turbine/compressor/initialize()
	..()
	turbine = locate() in get_step(src, get_dir(inturf, src))
	if(!turbine)
		stat |= BROKEN

#define COMPFRICTION 5e5
#define COMPSTARTERLOAD 2800

/obj/machinery/power/turbine/compressor/process()
	if(!starter)
		return
	overlays.Cut()
	if(stat & BROKEN)
		return
	if(!turbine)
		stat |= BROKEN
		return

	rpm = 0.9 * rpm + 0.1 * rpmtarget
	var/datum/gas_mixture/environment = inturf.return_air()
	var/transfer_moles = environment.total_moles / 10
	var/datum/gas_mixture/removed = inturf.remove_air(transfer_moles)
	gas_contained.merge(removed)

	rpm = max(0, rpm - (rpm * rpm) / COMPFRICTION)

	if(starter && !(stat & NOPOWER))
		use_power(2800)
		if(rpm < 1000)
			rpmtarget = 1000
	else
		if(rpm < 1000)
			rpmtarget = 0

	if(rpm > 50000)
		overlays += image('icons/obj/pipes.dmi', "comp-o4", FLY_LAYER)
	else if(rpm > 10000)
		overlays += image('icons/obj/pipes.dmi', "comp-o3", FLY_LAYER)
	else if(rpm > 2000)
		overlays += image('icons/obj/pipes.dmi', "comp-o2", FLY_LAYER)
	else if(rpm > 500)
		overlays += image('icons/obj/pipes.dmi', "comp-o1", FLY_LAYER)
	 //TODO: DEFERRED


/obj/machinery/power/turbine/turbine
	name = "gas turbine generator"
	desc = "A gas turbine used for backup power generation."
	icon = 'icons/obj/pipes.dmi'
	icon_state = "turbine"
	anchored = TRUE
	density = TRUE
	var/obj/machinery/power/turbine/compressor/compressor
	var/turf/simulated/outturf
	var/lastgen = 0

/obj/machinery/power/turbine/turbine/New()
	..()

	outturf = get_step(src, dir)

/obj/machinery/power/turbine/turbine/initialize()
	..()
	compressor = locate() in get_step(src, get_dir(outturf, src))
	if(!compressor)
		stat |= BROKEN

#define TURBPRES 9000000
#define TURBGENQ 20000
#define TURBGENG 0.8

/obj/machinery/power/turbine/turbine/process()
	if(!compressor.starter)
		return
	overlays.Cut()
	if(stat & BROKEN)
		return
	if(!compressor)
		stat |= BROKEN
		return

	lastgen = ((compressor.rpm / TURBGENQ)**TURBGENG) * TURBGENQ
	if(!lastgen)
		lastgen = 0

	add_avail(lastgen)
	var/newrpm = ((compressor.gas_contained.temperature) * compressor.gas_contained.total_moles)/4
	newrpm = max(0, newrpm)

	if(!compressor.starter || newrpm > 1000)
		compressor.rpmtarget = newrpm

	if(compressor.gas_contained.total_moles > 0)
		var/oamount = min(compressor.gas_contained.total_moles, (compressor.rpm + 100) / 35000 * compressor.capacity)
		var/datum/gas_mixture/removed = compressor.gas_contained.remove(oamount)
		outturf.assume_air(removed)

	if(lastgen > 100)
		overlays += image('icons/obj/pipes.dmi', "turb-o", FLY_LAYER)


	for(var/mob/M in viewers(1, src))
		if((M.client && M.machine == src))
			src.interact(M)
	AutoUpdateAI(src)

/obj/machinery/power/turbine/turbine/interact(mob/user)
	if((get_dist(src, user) > 1) || (stat & (NOPOWER|BROKEN)) && (!istype(user, /mob/living/silicon/ai)) )
		user.machine = null
		user << browse(null, "window=turbine")
		return

	user.machine = src

	var/t = "<TT><B>Gas Turbine Generator</B><HR><PRE>"

	t += "Generated power : [round(lastgen)] W<BR><BR>"

	t += "Turbine: [round(compressor.rpm)] RPM<BR>"

	t += "Starter: [ compressor.starter ? "<A href='?src=\ref[src];str=1'>Off</A> <B>On</B>" : "<B>Off</B> <A href='?src=\ref[src];str=1'>On</A>"]"

	t += "</PRE><HR><A href='?src=\ref[src];close=1'>Close</A>"

	t += "</TT>"
	user << browse(t, "window=turbine")
	onclose(user, "turbine")

	return

/obj/machinery/power/turbine/turbine/Topic(href, href_list)
	..()
	if(stat & BROKEN)
		return
	if(usr.stat || usr.restrained())
		return
	if(!(ishuman(usr) || ticker) && ticker.mode.name != "monkey")
		if(!isAI(usr))
			to_chat(usr, SPAN_WARNING("You don't have the dexterity to do this!"))
			return

	if((usr.machine == src && (get_dist(src, usr) <= 1 && isturf(src.loc))) || isAI(usr))
		if(href_list["close"])
			usr << browse(null, "window=turbine")
			usr.machine = null
			return

		else if(href_list["str"])
			compressor.starter = !compressor.starter

		spawn(0)
			for(var/mob/M in viewers(1, src))
				if(M.client && M.machine == src)
					src.interact(M)

	else
		usr << browse(null, "window=turbine")
		usr.machine = null

	return


/obj/machinery/computer/turbine_computer
	name = "Gas turbine control computer"
	desc = "A computer to remotely control a gas turbine"
	icon = 'icons/obj/computer.dmi'
	icon_state = "airtunnel0e"
	circuit = /obj/item/weapon/circuitboard/turbine_control
	anchored = TRUE
	density = TRUE
	var/obj/machinery/power/turbine/compressor/compressor
	var/list/obj/machinery/door/poddoor/doors
	var/id = 0
	var/door_status = 0

/obj/machinery/computer/turbine_computer/initialize()
	..()
	for(var/obj/machinery/power/turbine/compressor/C in machines)
		if(id == C.comp_id)
			compressor = C
		doors = new /list()
		for(var/obj/machinery/door/poddoor/P in machines)
			if(P.id == id)
				doors += P

/*
/obj/machinery/computer/turbine_computer/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				user << "\blue The broken glass falls out."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				new /obj/item/weapon/shard( src.loc )
				var/obj/item/weapon/circuitboard/turbine_control/M = new /obj/item/weapon/circuitboard/turbine_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				M.id = src.id
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = TRUE
				qdel(src)
			else
				user << "\blue You disconnect the monitor."
				var/obj/structure/computerframe/A = new /obj/structure/computerframe( src.loc )
				var/obj/item/weapon/circuitboard/turbine_control/M = new /obj/item/weapon/circuitboard/turbine_control( A )
				for (var/obj/C in src)
					C.loc = src.loc
				M.id = src.id
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = TRUE
				qdel(src)
	else
		src.attack_hand(user)
	return
*/

/obj/machinery/computer/turbine_computer/attack_hand(mob/user as mob)
	user.machine = src
	ui_interact(user)
	return

/obj/machinery/computer/turbine_computer/Topic(href, href_list)
	if(..())
		return
	if((usr.contents.Find(src) || (in_range(src, usr) && isturf(src.loc))) || issilicon(usr))
		usr.machine = src

		// Edited this to reflect NanoUI port. -Frenjo
		switch(href_list["action"])
			if("view")
				usr.client.eye = src.compressor
			if("strt")
				src.compressor.starter = 1
			if("stop")
				src.compressor.starter = 0
			if("doors_open")
				for(var/obj/machinery/door/poddoor/D in src.doors)
					spawn(0)
					D.open()
					door_status = 1
			if("doors_close")
				for(var/obj/machinery/door/poddoor/D in src.doors)
					spawn(0)
					D.close()
					door_status = 0

		src.add_fingerprint(usr)
	src.updateDialog()
	return

/obj/machinery/computer/turbine_computer/process()
	src.updateDialog()
	return

// Porting this to NanoUI, it looks way better honestly. -Frenjo
/obj/machinery/computer/turbine_computer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(stat & BROKEN)
		return

	var/data[0]
	data["status"] = src.compressor.starter
	data["speed"] = round(src.compressor.rpm)
	data["power"] = round(src.compressor.turbine.lastgen)
	data["temp"] = round(src.compressor.gas_contained.temperature)
	data["doors"] = src.door_status

	// Ported most of this by studying SMES code. -Frenjo
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if(!ui)
		ui = new(user, src, ui_key, "turbine_ctrl.tmpl", "Gas Turbine Control Computer", 420, 360)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

#undef COMPFRICTION
#undef COMPSTARTERLOAD

#undef TURBPRES
#undef TURBGENQ
#undef TURBGENG