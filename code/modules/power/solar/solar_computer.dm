/proc/rate_control(S, V, C, Min = 1, Max = 5, Limit = null) //How not to name vars
	var/href = "<A href='?src=\ref[S];rate control=1;[V]"
	var/rate = "[href]=-[Max]'>-</A>[href]=-[Min]'>-</A> [(C?C : 0)] [href]=[Min]'>+</A>[href]=[Max]'>+</A>"
	if(Limit)
		return "[href]=-[Limit]'>-</A>" + rate + "[href]=[Limit]'>+</A>"
	return rate

//
// Solar Control Computer
//

/obj/machinery/power/solar_control
	name = "solar panel control"
	desc = "A controller for solar panel arrays."
	icon = 'icons/obj/computer.dmi'
	icon_state = "solar"
	anchored = TRUE
	density = TRUE
	use_power = TRUE
	idle_power_usage = 250

	var/id = 0
	var/cdir = 0
	var/targetdir = 0		// target angle in manual tracking (since it updates every game minute)
	var/gen = 0
	var/lastgen = 0
	var/track = TRACKING_OFF
	var/trackrate = 600		// 300-900 seconds
	var/nexttime = 0		// time for a panel to rotate of 1° in manual tracking
	var/obj/machinery/power/tracker/connected_tracker = null
	var/list/connected_panels = list()

/obj/machinery/power/solar_control/initialize()
	..()
	if(!powernet)
		return
	set_panels(cdir)
	connect_to_network()

/obj/machinery/power/solar_control/Destroy()
	for(var/obj/machinery/power/solar/M in connected_panels)
		M.unset_control()
	if(connected_tracker)
		connected_tracker.unset_control()
	return ..()

/obj/machinery/power/solar_control/disconnect_from_network()
	..()
	GLOBL.solars_list.Remove(src)

/obj/machinery/power/solar_control/connect_to_network()
	var/to_return = ..()
	if(powernet) //if connected and not already in solar_list...
		GLOBL.solars_list |= src //... add it
	return to_return

/obj/machinery/power/solar_control/update_icon()
	if(stat & BROKEN)
		icon_state = "broken"
		overlays.Cut()
		return
	if(stat & NOPOWER)
		icon_state = "c_unpowered"
		overlays.Cut()
		return
	icon_state = "solar"
	overlays.Cut()
	if(cdir > -1)
		overlays += image('icons/obj/computer.dmi', "solcon-o", FLY_LAYER, angle2dir(cdir))
	return

/obj/machinery/power/solar_control/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN | NOPOWER)) return
	interact(user)

/obj/machinery/power/solar_control/attack_hand(mob/user)
	if(!..())
		interact(user)

/obj/machinery/power/solar_control/interact(mob/user)
	var/t = "<B><span class='highlight'>Generated power</span></B> : [round(lastgen)] W<BR>"
	t += "<B><span class='highlight'>Orientation</span></B>: [rate_control(src,"cdir","[cdir]&deg",1,15)] ([angle2text(cdir)])<BR>"
	t += "<B><span class='highlight'>Tracking:</B><div class='statusDisplay'>"
	switch(track)
		if(0)
			t += "<span class='linkOn'>Off</span> <A href='?src=\ref[src];track=1'>Timed</A> <A href='?src=\ref[src];track=2'>Auto</A><BR>"
		if(1)
			t += "<A href='?src=\ref[src];track=0'>Off</A> <span class='linkOn'>Timed</span> <A href='?src=\ref[src];track=2'>Auto</A><BR>"
		if(2)
			t += "<A href='?src=\ref[src];track=0'>Off</A> <A href='?src=\ref[src];track=1'>Timed</A> <span class='linkOn'>Auto</span><BR>"

	t += "Tracking Rate: [rate_control(src,"tdir","[trackrate] deg/h ([trackrate<0 ? "CCW" : "CW"])",1,30,180)]</div><BR>"

	t += "<B><span class='highlight'>Connected devices:</span></B><div class='statusDisplay'>"

	t += "<A href='?src=\ref[src];search_connected=1'>Search for devices</A><BR>"
	t += "Solar panels : [length(connected_panels)] connected<BR>"
	t += "Solar tracker : [connected_tracker ? "<span class='good'>Found</span>" : "<span class='bad'>Not found</span>"]</div><BR>"

	t += "<A href='?src=\ref[src];close=1'>Close</A>"

	var/datum/browser/popup = new(user, "solar", name)
	popup.set_content(t)
	popup.open()
	return

/obj/machinery/power/solar_control/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if(src.stat & BROKEN)
				to_chat(user, SPAN_INFO("The broken glass falls out."))
				var/obj/structure/computerframe/A = new /obj/structure/computerframe(src.loc)
				new /obj/item/weapon/shard(src.loc)
				var/obj/item/weapon/circuitboard/solar_control/M = new /obj/item/weapon/circuitboard/solar_control(A)
				for(var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = TRUE
				qdel(src)
			else
				to_chat(user, SPAN_INFO("You disconnect the monitor."))
				var/obj/structure/computerframe/A = new /obj/structure/computerframe(src.loc)
				var/obj/item/weapon/circuitboard/solar_control/M = new /obj/item/weapon/circuitboard/solar_control(A)
				for(var/obj/C in src)
					C.loc = src.loc
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = TRUE
				qdel(src)
	else
		src.attack_hand(user)
	return

/obj/machinery/power/solar_control/process()
	lastgen = gen
	gen = 0

	if(stat & (NOPOWER | BROKEN))
		return

	if(connected_tracker) //NOTE : handled here so that we don't add trackers to the processing list
		if(connected_tracker.powernet != powernet)
			connected_tracker.unset_control()

	if(track == TRACKING_MANUAL && trackrate) //manual tracking and set a rotation speed
		if(nexttime <= world.time) //every time we need to increase/decrease the angle by 1°...
			targetdir = (targetdir + trackrate/abs(trackrate) + 360) % 360	//... do it
			nexttime += 36000 / abs(trackrate) //reset the counter for the next 1°

	updateDialog()

/obj/machinery/power/solar_control/Topic(href, href_list)
	if(..())
		usr << browse(null, "window=solcon")
		usr.unset_machine()
		return 0
	if(href_list["close"] )
		usr << browse(null, "window=solcon")
		usr.unset_machine()
		return 0

	if(href_list["rate control"])
		if(href_list["cdir"])
			src.targetdir = src.cdir
			if(track == TRACKING_AUTO) //manual update, so losing auto-tracking
				track = TRACKING_OFF
			spawn(1)
				set_panels(cdir)
		if(href_list["tdir"])
			src.trackrate = dd_range(-7200, 7200, src.trackrate + text2num(href_list["tdir"]))
			if(src.trackrate)
				nexttime = world.time + 36000 / abs(trackrate)

	if(href_list["track"])
		track = text2num(href_list["track"])
		if(track == TRACKING_AUTO)
			if(connected_tracker)
				connected_tracker.set_angle(global.sun.angle)
				set_panels(cdir)
		else if(track == TRACKING_MANUAL) //begin manual tracking
			src.targetdir = src.cdir
			if(src.trackrate)
				nexttime = world.time + 36000 / abs(trackrate)
			set_panels(targetdir)

	if(href_list["search_connected"])
		src.search_for_connected()
		if(connected_tracker && track == TRACKING_AUTO)
			connected_tracker.set_angle(global.sun.angle)
		src.set_panels(cdir)

	interact(usr)
	return 1

/obj/machinery/power/solar_control/power_change()
	..()
	update_icon()

/obj/machinery/power/solar_control/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				broken()
		if(3.0)
			if(prob(25))
				broken()
	return

/obj/machinery/power/solar_control/blob_act()
	if(prob(75))
		broken()
		src.density = FALSE

//search for unconnected panels and trackers in the computer powernet and connect them
/obj/machinery/power/solar_control/proc/search_for_connected()
	if(powernet)
		for(var/obj/machinery/power/M in powernet.nodes)
			if(istype(M, /obj/machinery/power/solar))
				var/obj/machinery/power/solar/S = M
				if(!S.control) //i.e unconnected
					S.set_control(src)
					connected_panels |= S
			else if(istype(M, /obj/machinery/power/tracker))
				if(!connected_tracker) //if there's already a tracker connected to the computer don't add another
					var/obj/machinery/power/tracker/T = M
					if(!T.control) //i.e unconnected
						connected_tracker = T
						T.set_control(src)

//called by the sun controller, update the facing angle (either manually or via tracking) and rotates the panels accordingly
/obj/machinery/power/solar_control/proc/update()
	if(stat & (NOPOWER | BROKEN))
		return

	switch(track)
		if(1)
			if(trackrate)	//we're manual tracking. If we set a rotation speed...
				cdir = targetdir	//...the current direction is the targetted one (and rotates panels to it)
		if(2) // auto-tracking
			if(connected_tracker)
				connected_tracker.set_angle(global.sun.angle)

	set_panels(cdir)
	updateDialog()

/obj/machinery/power/solar_control/proc/set_panels(cdir)
	for(var/obj/machinery/power/solar/S in connected_panels)
		S.adir = cdir //instantly rotates the panel
		S.occlusion()//and
		S.update_icon() //update it

	update_icon()

/obj/machinery/power/solar_control/proc/broken()
	stat |= BROKEN
	update_icon()