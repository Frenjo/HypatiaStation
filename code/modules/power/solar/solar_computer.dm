/proc/rate_control(S, V, C, Min = 1, Max = 5, Limit = null) //How not to name vars
	var/href = "<A href='byond://?src=\ref[S];rate control=1;[V]"
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
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "solar"
	anchored = TRUE
	density = TRUE

	power_state = USE_POWER_IDLE
	power_usage = alist(
		USE_POWER_IDLE = 250
	)

	var/id = 0
	var/cdir = 0
	var/targetdir = 0		// target angle in manual tracking (since it updates every game minute)
	var/gen = 0
	var/lastgen = 0
	var/track = TRACKING_OFF
	var/trackrate = 600		// 300-900 seconds
	var/nexttime = 0		// time for a panel to rotate of 1° in manual tracking
	var/obj/machinery/power/tracker/connected_tracker = null
	var/list/obj/machinery/power/solar/connected_panels = list()

/obj/machinery/power/solar_control/initialise()
	. = ..()
	if(isnull(powernet))
		return
	connect_to_network()

/obj/machinery/power/solar_control/Destroy()
	for_no_type_check(var/obj/machinery/power/solar/M, connected_panels)
		connected_panels.Remove(M)
		M.unset_control()
	connected_tracker?.unset_control()
	connected_tracker = null
	return ..()

/obj/machinery/power/solar_control/disconnect_from_network()
	..()
	GLOBL.solars_list.Remove(src)

/obj/machinery/power/solar_control/connect_to_network()
	var/to_return = ..()
	if(isnotnull(powernet)) //if connected and not already in solar_list...
		GLOBL.solars_list |= src //... add it
	return to_return

/obj/machinery/power/solar_control/update_icon()
	if(stat & BROKEN)
		icon_state = "broken"
		cut_overlays()
		return
	if(stat & NOPOWER)
		icon_state = "c_unpowered"
		cut_overlays()
		return
	icon_state = "solar"
	cut_overlays()
	if(cdir > -1)
		set_dir(angle2dir(cdir))
		add_overlay(mutable_appearance(icon, "solcon-o", layer = FLY_LAYER))
	return

/obj/machinery/power/solar_control/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN | NOPOWER))
		return
	interact(user)

/obj/machinery/power/solar_control/attack_hand(mob/user)
	if(!..())
		interact(user)

/obj/machinery/power/solar_control/interact(mob/user)
	user.set_machine(src)

	var/html = "<B><span class='highlight'>Generated power</span></B> : [round(lastgen)] W<BR>"
	html += "<B><span class='highlight'>Orientation</span></B>: [rate_control(src,"cdir","[cdir]&deg",1,15)] ([angle2text(cdir)])<BR>"
	html += "<B><span class='highlight'>Tracking:</B><div class='statusDisplay'>"
	switch(track)
		if(TRACKING_OFF)
			html += "<span class='linkOn'>Off</span> <A href='byond://?src=\ref[src];track=1'>Timed</A> <A href='byond://?src=\ref[src];track=2'>Auto</A><BR>"
		if(TRACKING_MANUAL)
			html += "<A href='byond://?src=\ref[src];track=0'>Off</A> <span class='linkOn'>Timed</span> <A href='byond://?src=\ref[src];track=2'>Auto</A><BR>"
		if(TRACKING_AUTO)
			html += "<A href='byond://?src=\ref[src];track=0'>Off</A> <A href='byond://?src=\ref[src];track=1'>Timed</A> <span class='linkOn'>Auto</span><BR>"

	html += "Tracking Rate: [rate_control(src,"tdir","[trackrate] deg/h ([trackrate<0 ? "CCW" : "CW"])",1,30,180)]</div><BR>"

	html += "<B><span class='highlight'>Connected devices:</span></B><div class='statusDisplay'>"

	html += "<A href='byond://?src=\ref[src];search_connected=1'>Search for devices</A><BR>"
	html += "Solar panels : [length(connected_panels)] connected<BR>"
	html += "Solar tracker : [connected_tracker ? "<span class='good'>Found</span>" : "<span class='bad'>Not found</span>"]</div><BR>"

	html += "<A href='byond://?src=\ref[src];close=1'>Close</A>"

	var/datum/browser/popup = new /datum/browser(user, "solcon", name)
	popup.set_content(html)
	popup.open()

/obj/machinery/power/solar_control/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 2 SECONDS))
			if(stat & BROKEN)
				FEEDBACK_BROKEN_GLASS_FALLS(user)
				var/obj/structure/computerframe/frame = new /obj/structure/computerframe(GET_TURF(src))
				new /obj/item/shard(GET_TURF(src))
				frame.circuit = new /obj/item/circuitboard/solar_control(frame)
				frame.state = 3
				frame.icon_state = "3"
				frame.anchored = TRUE
				for(var/obj/C in src)
					C.forceMove(loc)
				qdel(src)
			else
				FEEDBACK_DISCONNECT_MONITOR(user)
				var/obj/structure/computerframe/frame = new /obj/structure/computerframe(GET_TURF(src))
				frame.circuit = new /obj/item/circuitboard/solar_control(frame)
				frame.state = 4
				frame.icon_state = "4"
				frame.anchored = TRUE
				for(var/obj/C in src)
					C.forceMove(loc)
				qdel(src)
			return TRUE
	return ..()

/obj/machinery/power/solar_control/process()
	lastgen = gen
	gen = 0

	if(stat & (NOPOWER | BROKEN))
		return

	if(isnotnull(connected_tracker) && connected_tracker.powernet != powernet) //NOTE : handled here so that we don't add trackers to the processing list
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
		return
	if(href_list["close"] )
		usr << browse(null, "window=solcon")
		usr.unset_machine()
		return

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
				connected_tracker.set_angle(global.PCsun.angle)
				set_panels(cdir)
		else if(track == TRACKING_MANUAL) //begin manual tracking
			src.targetdir = src.cdir
			if(src.trackrate)
				nexttime = world.time + 36000 / abs(trackrate)
			set_panels(targetdir)

	if(href_list["search_connected"])
		search_for_connected()
		if(isnotnull(connected_tracker) && track == TRACKING_AUTO)
			connected_tracker.set_angle(global.PCsun.angle)
		set_panels(cdir)

	interact(usr)
	return 1

/obj/machinery/power/solar_control/power_change()
	. = ..()
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
	if(isnotnull(powernet))
		for(var/obj/machinery/power/M in powernet.nodes)
			if(istype(M, /obj/machinery/power/solar))
				var/obj/machinery/power/solar/S = M
				if(isnull(S.control)) //i.e unconnected
					S.set_control(src)
					connected_panels |= S
			else if(istype(M, /obj/machinery/power/tracker))
				if(isnull(connected_tracker)) //if there's already a tracker connected to the computer don't add another
					var/obj/machinery/power/tracker/T = M
					if(isnull(T.control)) //i.e unconnected
						connected_tracker = T
						T.set_control(src)

//called by the sun controller, update the facing angle (either manually or via tracking) and rotates the panels accordingly
/obj/machinery/power/solar_control/proc/update()
	if(stat & (NOPOWER | BROKEN))
		return

	switch(track)
		if(TRACKING_MANUAL)
			if(trackrate)	//we're manual tracking. If we set a rotation speed...
				cdir = targetdir	//...the current direction is the targetted one (and rotates panels to it)
		if(TRACKING_AUTO) // auto-tracking
			connected_tracker?.set_angle(global.PCsun.angle)

	set_panels(cdir)
	updateDialog()

/obj/machinery/power/solar_control/proc/set_panels(cdir)
	for_no_type_check(var/obj/machinery/power/solar/S, connected_panels)
		S.adir = cdir //instantly rotates the panel
		S.occlusion()//and
		S.update_icon() //update it

	update_icon()

/obj/machinery/power/solar_control/proc/broken()
	stat |= BROKEN
	update_icon()

// Variant that activates itself automatically on spawning.
/obj/machinery/power/solar_control/tracking
	track = TRACKING_AUTO

/obj/machinery/power/solar_control/tracking/initialise()
	. = ..()
	search_for_connected()
	if(isnotnull(connected_tracker) && track == TRACKING_AUTO)
		connected_tracker.set_angle(global.PCsun.angle)
	set_panels(cdir)