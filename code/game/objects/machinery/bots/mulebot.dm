//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

// MULEbot - carries crates around for Quartermaster
// Navigates via floor navbeacons
// Remote Controlled from QM's PDA

/obj/machinery/bot/mulebot
	name = "\improper MULEbot"
	desc = "A Multiple Utility Load Effector bot."
	icon = 'icons/mob/bot/mulebot.dmi'
	icon_state = "mulebot0"
	layer = MOB_LAYER
	density = TRUE
	anchored = TRUE
	animate_movement = 1
	health = 150 //yeah, it's tougher than ed209 because it is a big metal box with wheels --rastaf0
	maxhealth = 150
	fire_dam_coeff = 0.7
	brute_dam_coeff = 0.5

	var/static/static_mulebot_id = 0
	suffix = ""

	req_access = list(ACCESS_CARGO) // added robotics access so assembly line drop-off works properly -veyveyr //I don't think so, Tim. You need to add it to the MULE's hidden robot ID card. -NEO

	var/atom/movable/load = null		// the loaded crate (usually)
	var/beacon_freq = 1400
	var/control_freq = 1447

	var/turf/target				// this is turf to navigate to (location of beacon)
	var/loaddir = 0				// this the direction to unload onto/load from
	var/new_destination = ""	// pending new destination (waiting for beacon response)
	var/destination = ""		// destination description
	var/home_destination = "" 	// tag of home beacon
	var/list/path = list()

	var/mode = 0		//0 = idle/ready
						//1 = loading/unloading
						//2 = moving to deliver
						//3 = returning to home
						//4 = blocked
						//5 = computing navigation
						//6 = waiting for nav computation
						//7 = no destination beacon found (or no route)

	var/blockcount	= 0		//number of times retried a blocked path
	var/reached_target = 1 	//true if already reached the target

	var/refresh = 1		// true to refresh dialogue
	var/auto_return = 1	// true if auto return to home beacon after unload
	var/auto_pickup = 1 // true if auto-pickup at beacon

	var/obj/item/cell/cell // the installed power cell

	// constants for internal wiring bitflags
	var/datum/wires/mulebot/wires = null

	var/bloodiness = 0	// count of bloodiness

/obj/machinery/bot/mulebot/New()
	. = ..()
	if(!suffix)
		suffix = "#[++static_mulebot_id]"
	name = "MULEbot ([suffix])"

	verbs.Remove(/atom/movable/verb/pull)

	cell = new /obj/item/cell/apc(src) // This was originally an untyped cell with 2k charge/capacity. APC cells are the closest available prefab.
	wires = new /datum/wires/mulebot(src)

	botcard = new /obj/item/card/id(src)
	var/datum/job/cargo_tech/J = GLOBL.all_jobs["Cargo Technician"]
	botcard.access = J.get_access()
//	botcard.access += access_robotics //Why --Ikki

// must wait for map loading to finish
/obj/machinery/bot/mulebot/initialise()
	. = ..()
	register_radio(src, null, control_freq, RADIO_MULEBOT)
	register_radio(src, null, beacon_freq, RADIO_NAVBEACONS)

/obj/machinery/bot/mulebot/Destroy()
	unregister_radio(src, beacon_freq)
	unregister_radio(src, control_freq)
	QDEL_NULL(wires)
	return ..()


// attack by item
// emag : lock/unlock,
// screwdriver: open/close hatch
// cell: insert it
// other: chance to knock rider off bot
/obj/machinery/bot/mulebot/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	locked = !locked
	FEEDBACK_TOGGLE_CONTROLS_LOCK(user, locked)
	flick("mulebot-emagged", src)
	playsound(src, 'sound/effects/sparks/sparks1.ogg', 100, 0)
	return TRUE

/obj/machinery/bot/mulebot/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/cell) && open && !cell)
		var/obj/item/cell/C = I
		user.drop_item()
		C.forceMove(src)
		cell = C
		updateDialog()
	else if(isscrewdriver(I))
		if(locked)
			to_chat(user, SPAN_WARNING("The maintenance panel cannot be opened or closed while the controls are locked."))
			return

		open = !open
		if(open)
			on = FALSE
			icon_state = "mulebot-hatch"
		else
			icon_state = "mulebot0"
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, open)

		updateDialog()
	else if(iswrench(I))
		if(health < maxhealth)
			health = min(maxhealth, health + 25)
			user.visible_message(
				SPAN_NOTICE("[user] repairs [src]!"),
				SPAN_NOTICE("You repair [src]!")
			)
		else
			to_chat(user, SPAN_WARNING("[src] does not need repairs!"))
	else if(load && ismob(load))  // chance to knock off rider
		if(prob(1 + I.force * 2))
			unload(0)
			user.visible_message(
				SPAN_WARNING("[user] knocks [load] off [src] with \the [I]!"),
				SPAN_WARNING("You knock [load] off [src] with \the [I]!")
			)
		else
			to_chat(user, SPAN_WARNING("You hit [src] with \the [I] but to no effect."))
	else
		..()

/obj/machinery/bot/mulebot/ex_act(severity)
	unload(0)
	switch(severity)
		if(2)
			BITRESET(wires, rand(0, 9))
			BITRESET(wires, rand(0, 9))
			BITRESET(wires, rand(0, 9))
		if(3)
			BITRESET(wires, rand(0, 9))
	..()

/obj/machinery/bot/mulebot/bullet_act()
	if(prob(50) && isnotnull(load))
		unload(0)
	if(prob(25))
		visible_message(
			SPAN_WARNING("Something shorts out inside [src]!"),
			SPAN_WARNING("You hear an electrical sparking.")
		)
		var/index = 1 << rand(0, 9)
		if(wires & index)
			wires &= ~index
		else
			wires |= index
	..()

/obj/machinery/bot/mulebot/attack_ai(mob/user)
	user.set_machine(src)
	interact(user, 1)

/obj/machinery/bot/mulebot/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	user.set_machine(src)
	interact(user, 0)

/obj/machinery/bot/mulebot/interact(mob/user, ai = 0)
	var/dat
	dat += "<TT><B>Multiple Utility Load Effector Mk. III</B></TT><BR><BR>"
	dat += "ID: [suffix]<BR>"
	dat += "Power: [on ? "On" : "Off"]<BR>"

	if(!open)
		dat += "Status: "
		switch(mode)
			if(0)
				dat += "Ready"
			if(1)
				dat += "Loading/Unloading"
			if(2)
				dat += "Navigating to Delivery Location"
			if(3)
				dat += "Navigating to Home"
			if(4)
				dat += "Waiting for clear path"
			if(5,6)
				dat += "Calculating navigation path"
			if(7)
				dat += "Unable to locate destination"

		dat += "<BR>Current Load: [load ? load.name : "<i>none</i>"]<BR>"
		dat += "Destination: [!destination ? "<i>none</i>" : destination]<BR>"
		dat += "Power level: [cell ? cell.percent() : 0]%<BR>"

		if(locked && !ai)
			dat += "<HR>Controls are locked <A href='byond://?src=\ref[src];op=unlock'><I>(unlock)</I></A>"
		else
			dat += "<HR>Controls are unlocked <A href='byond://?src=\ref[src];op=lock'><I>(lock)</I></A><BR><BR>"

			dat += "<A href='byond://?src=\ref[src];op=power'>Toggle Power</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=stop'>Stop</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=go'>Proceed</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=home'>Return to Home</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=destination'>Set Destination</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=setid'>Set Bot ID</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=sethome'>Set Home</A><BR>"
			dat += "<A href='byond://?src=\ref[src];op=autoret'>Toggle Auto Return Home</A> ([auto_return ? "On":"Off"])<BR>"
			dat += "<A href='byond://?src=\ref[src];op=autopick'>Toggle Auto Pickup Crate</A> ([auto_pickup ? "On":"Off"])<BR>"

			if(load)
				dat += "<A href='byond://?src=\ref[src];op=unload'>Unload Now</A><BR>"
			dat += "<HR>The maintenance panel is closed.<BR>"

	else
		if(!ai)
			dat += "The maintenance panel is open.<BR><BR>"
			dat += "Power cell: "
			if(cell)
				dat += "<A href='byond://?src=\ref[src];op=cellremove'>Installed</A><BR>"
			else
				dat += "<A href='byond://?src=\ref[src];op=cellinsert'>Removed</A><BR>"

			dat += wires.GetInteractWindow()
		else
			dat += "The bot is in maintenance mode and cannot be controlled.<BR>"

	user << browse("<HEAD><TITLE>MULEbot [suffix ? "([suffix])" : ""]</TITLE></HEAD>[dat]", "window=mulebot;size=350x500")
	onclose(user, "mulebot")

/obj/machinery/bot/mulebot/Topic(href, href_list)
	if(..())
		return
	if(usr.stat)
		return
	if((in_range(src, usr) && isturf(loc)) || issilicon(usr))
		usr.set_machine(src)

		switch(href_list["op"])
			if("lock", "unlock")
				if(allowed(usr))
					locked = !locked
					updateDialog()
				else
					FEEDBACK_ACCESS_DENIED(usr)
					return
			if("power")
				if(on)
					turn_off()
				else if (cell && !open)
					if(!turn_on())
						to_chat(usr, SPAN_WARNING("You can't switch on [src]."))
						return
				else
					return
				visible_message(
					SPAN_INFO("[usr] switches [src] [on ? "on" : "off"]."),
					SPAN_INFO("You hear a switch being clicked.")
				)
				updateDialog()

			if("cellremove")
				if(open && cell && !usr.get_active_hand())
					cell.updateicon()
					usr.put_in_active_hand(cell)
					cell.add_fingerprint(usr)
					cell = null

					usr.visible_message(
						SPAN_INFO("[usr] removes the power cell from [src]."),
						SPAN_INFO("You remove the power cell from [src].")
					)
					updateDialog()

			if("cellinsert")
				if(open && !cell)
					var/obj/item/cell/C = usr.get_active_hand()
					if(istype(C))
						usr.drop_item()
						cell = C
						C.forceMove(src)
						C.add_fingerprint(usr)

						usr.visible_message(
							SPAN_INFO("[usr] inserts a power cell into [src]."),
							SPAN_INFO("You insert the power cell into [src].")
						)
						updateDialog()

			if("stop")
				if(mode >=2)
					mode = 0
					updateDialog()

			if("go")
				if(mode == 0)
					start()
					updateDialog()

			if("home")
				if(mode == 0 || mode == 2)
					start_home()
					updateDialog()

			if("destination")
				refresh = 0
				var/new_dest = input("Enter new destination tag", "MULEbot [suffix ? "([suffix])" : ""]", destination) as text | null
				refresh = 1
				if(new_dest)
					set_destination(new_dest)

			if("setid")
				refresh = 0
				var/new_id = copytext(sanitize(input("Enter new bot ID", "MULEbot [suffix ? "([suffix])" : ""]", suffix) as text | null), 1, MAX_NAME_LEN)
				refresh = 1
				if(new_id)
					suffix = new_id
					name = "MULEbot ([suffix])"
					updateDialog()

			if("sethome")
				refresh = 0
				var/new_home = input("Enter new home tag", "MULEbot [suffix ? "([suffix])" : ""]", home_destination) as text | null
				refresh = 1
				if(new_home)
					home_destination = new_home
					updateDialog()

			if("unload")
				if(load && mode !=1)
					if(loc == target)
						unload(loaddir)
					else
						unload(0)

			if("autoret")
				auto_return = !auto_return

			if("autopick")
				auto_pickup = !auto_pickup

			if("close")
				usr.unset_machine()
				usr << browse(null, "window=mulebot")

		updateDialog()
		//updateUsrDialog()
	else
		usr << browse(null, "window=mulebot")
		usr.unset_machine()

// returns true if the bot has power
/obj/machinery/bot/mulebot/proc/has_power()
	return !open && cell && cell.charge > 0 && wires.HasPower()

// mousedrop a crate to load the bot
// can load anything if emagged

/obj/machinery/bot/mulebot/MouseDrop_T(atom/movable/C, mob/user)
	if(user.stat)
		return
	if(!on || !istype(C)|| C.anchored || get_dist(user, src) > 1 || get_dist(src, C) > 1)
		return
	if(load)
		return

	load(C)

// called to load a crate
/obj/machinery/bot/mulebot/proc/load(atom/movable/C)
	if(wires.LoadCheck() && !istype(C, /obj/structure/closet/crate))
		visible_message(
			SPAN_INFO("[src] makes a sighing buzz."),
			SPAN_INFO("You hear an electronic buzzing sound.")
		)
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)
		return	// if not emagged, only allow crates to be loaded

	//I'm sure someone will come along and ask why this is here... well people were dragging screen items onto the mule, and that was not cool.
	//So this is a simple fix that only allows a selection of item types to be considered. Further narrowing-down is below.
	if(!isitem(C) && !istype(C, /obj/machinery) && !istype(C, /obj/structure) && !ismob(C))
		return
	if(!isturf(C.loc)) //To prevent the loading from stuff from someone's inventory, which wouldn't get handled properly.
		return

	if(get_dist(C, src) > 1 || load || !on)
		return
	for(var/obj/structure/plasticflaps/P in loc)//Takes flaps into account
		if(!CanPass(C, P))
			return
	mode = 1

	// if a create, close before loading
	var/obj/structure/closet/crate/crate = C
	if(istype(crate))
		crate.close()

	C.forceMove(loc)
	sleep(2)
	if(C.loc != loc) //To prevent you from going onto more thano ne bot.
		return
	C.forceMove(src)
	load = C

	C.pixel_y += 9
	if(C.layer < layer)
		C.layer = layer + 0.1
	add_overlay(C)

	if(ismob(C))
		var/mob/M = C
		if(isnotnull(M.client))
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src

	mode = 0
	send_status()

// called to unload the bot
// argument is optional direction to unload
// if zero, unload at bot's location
/obj/machinery/bot/mulebot/proc/unload(dirn = 0)
	if(!load)
		return

	mode = 1
	cut_overlays()

	load.forceMove(loc)
	load.pixel_y -= 9
	load.reset_plane_and_layer()
	if(ismob(load))
		var/mob/M = load
		if(isnotnull(M.client))
			M.client.perspective = MOB_PERSPECTIVE
			M.client.eye = src

	if(dirn)
		var/turf/T = loc
		T = get_step(T, dirn)
		if(CanPass(load, T))//Can't get off onto anything that wouldn't let you pass normally
			step(load, dirn)
		else
			load.forceMove(loc)//Drops you right there, so you shouldn't be able to get yourself stuck

	load = null

	// in case non-load items end up in contents, dump every else too
	// this seems to happen sometimes due to race conditions
	// with items dropping as mobs are loaded

	for_no_type_check(var/atom/movable/mover, src)
		if(mover == cell || mover == botcard)
			continue

		mover.forceMove(loc)
		mover.reset_plane_and_layer()
		mover.pixel_y = initial(mover.pixel_y)
		if(ismob(mover))
			var/mob/M = mover
			if(isnotnull(M.client))
				M.client.perspective = MOB_PERSPECTIVE
				M.client.eye = src
	mode = 0

/obj/machinery/bot/mulebot/process()
	if(!has_power())
		on = FALSE
		return
	if(on)
		var/speed = (wires.Motor1() ? 1:0) + (wires.Motor2() ? 2:0)
		//to_world("speed: [speed]")
		switch(speed)
			if(0)
				// do nothing
			if(1)
				process_bot()
				spawn(2)
					process_bot()
					sleep(2)
					process_bot()
					sleep(2)
					process_bot()
					sleep(2)
					process_bot()
			if(2)
				process_bot()
				spawn(4)
					process_bot()
			if(3)
				process_bot()

	if(refresh) updateDialog()

/obj/machinery/bot/mulebot/proc/process_bot()
	//if(mode) to_world("Mode: [mode]")
	switch(mode)
		if(0)		// idle
			icon_state = "mulebot0"
			return
		if(1)		// loading/unloading
			return
		if(2,3,4)		// navigating to deliver,home, or blocked
			if(loc == target)		// reached target
				at_target()
				return

			else if(length(path) && target)		// valid path
				var/turf/next = path[1]
				reached_target = 0
				if(next == loc)
					path -= next
					return

				if(isopenturf(next))
					//to_world("at ([x],[y]) moving to ([next.x],[next.y])")
					if(bloodiness)
						var/obj/effect/decal/cleanable/blood/tracks/B = new /obj/effect/decal/cleanable/blood/tracks(loc)
						var/newdir = get_dir(next, loc)
						if(newdir == dir)
							B.set_dir(newdir)
						else
							newdir = newdir | dir
							if(newdir == 3)
								newdir = 1
							else if(newdir == 12)
								newdir = 4
							B.set_dir(newdir)
						bloodiness--

					var/moved = step_towards(src, next)	// attempt to move
					cell?.use(1)
					if(moved)	// successful move
						//to_world("Successful move.")
						blockcount = 0
						path -= loc

						if(mode == 4)
							spawn(1)
								send_status()

						if(destination == home_destination)
							mode = 3
						else
							mode = 2

					else		// failed to move

						//to_world("Unable to move.")

						blockcount++
						mode = 4
						if(blockcount == 3)
							visible_message(
								"[src] makes an annoyed buzzing sound",
								"You hear an electronic buzzing sound."
							)
							playsound(src, 'sound/machines/buzz-two.ogg', 50, 0)

						if(blockcount > 5)	// attempt 5 times before recomputing
							// find new path excluding blocked turf
							visible_message(
								"[src] makes a sighing buzz.",
								"You hear an electronic buzzing sound."
							)
							playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)

							spawn(2)
								calc_path(next)
								if(length(path))
									visible_message(
										"[src] makes a delighted ping!",
										"You hear a ping."
									)
									playsound(src, 'sound/machines/ping.ogg', 50, 0)
								mode = 4
							mode = 6
							return
						return
				else
					visible_message(
						"[src] makes an annoyed buzzing sound",
						"You hear an electronic buzzing sound."
					)
					playsound(src, 'sound/machines/buzz-two.ogg', 50, 0)
					//to_world("Bad turf.")
					mode = 5
					return
			else
				//to_world("No path.")
				mode = 5
				return

		if(5)		// calculate new path
			//to_world("Calc new path.")
			mode = 6
			spawn(0)
				calc_path()

				if(length(path))
					blockcount = 0
					mode = 4
					visible_message(
						"[src] makes a delighted ping!",
						"You hear a ping."
					)
					playsound(src, 'sound/machines/ping.ogg', 50, 0)

				else
					visible_message(
						"[src] makes a sighing buzz.",
						"You hear an electronic buzzing sound."
					)
					playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)

					mode = 7
		//if(6)
			//to_world("Pending path calc.")
		//if(7)
			//to_world("No dest / no route.")

// calculates a path to the current destination
// given an optional turf to avoid
/obj/machinery/bot/mulebot/proc/calc_path(turf/avoid = null)
	path = AStar(loc, target, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 0, 250, id=botcard, exclude=avoid)
	if(!path)
		path = list()

// sets the current destination
// signals all beacons matching the delivery code
// beacons will return a signal giving their locations
/obj/machinery/bot/mulebot/proc/set_destination(var/new_dest)
	spawn(0)
		new_destination = new_dest
		post_signal(beacon_freq, "findbeacon", "delivery")
		updateDialog()

// starts bot moving to current destination
/obj/machinery/bot/mulebot/proc/start()
	if(destination == home_destination)
		mode = 3
	else
		mode = 2
	icon_state = "mulebot[wires.MobAvoid()]"

// starts bot moving to home
// sends a beacon query to find
/obj/machinery/bot/mulebot/proc/start_home()
	spawn(0)
		set_destination(home_destination)
		mode = 4
	icon_state = "mulebot[wires.MobAvoid()]"

// called when bot reaches current target
/obj/machinery/bot/mulebot/proc/at_target()
	if(!reached_target)
		visible_message("[src] makes a chiming sound!", "You hear a chime.")
		playsound(src, 'sound/machines/chime.ogg', 50, 0)
		reached_target = 1

		if(load)		// if loaded, unload at target
			unload(loaddir)
		else
			// not loaded
			if(auto_pickup)	// find a crate
				var/atom/movable/AM
				if(!wires.LoadCheck())	// if emagged, load first unanchored thing we find
					for_no_type_check(var/atom/movable/mover, get_step(loc, loaddir)) // I hope that get_step() returns a /turf.
						if(!mover.anchored)
							AM = mover
							break
				else			// otherwise, look for crates only
					AM = locate(/obj/structure/closet/crate) in get_step(loc,loaddir)
				if(AM)
					load(AM)
		// whatever happened, check to see if we return home

		if(auto_return && destination != home_destination)
			// auto return set and not at home already
			start_home()
			mode = 4
		else
			mode = 0	// otherwise go idle

	send_status()	// report status to anyone listening

// called when bot bumps into anything
/obj/machinery/bot/mulebot/Bump(atom/obs)
	if(!wires.MobAvoid())		//usually just bumps, but if avoidance disabled knock over mobs
		var/mob/M = obs
		if(ismob(M))
			if(isrobot(M))
				visible_message(SPAN_WARNING("[src] bumps into [M]!"))
			else
				visible_message(SPAN_WARNING("[src] knocks over [M]!"))
				M.stop_pulling()
				M.Stun(8)
				M.Weaken(5)
				M.lying = 1
	..()

/obj/machinery/bot/mulebot/alter_health()
	return GET_TURF(src)

// called from mob/living/carbon/human/Crossed()
// when mulebot is in the same loc
/obj/machinery/bot/mulebot/proc/RunOver(mob/living/carbon/human/H)
	visible_message(SPAN_WARNING("[src] drives over [H]!"))
	playsound(src, 'sound/effects/splat.ogg', 50, 1)

	var/damage = rand(5,15)
	H.apply_damage(2 * damage, BRUTE, "head")
	H.apply_damage(2 * damage, BRUTE, "chest")
	H.apply_damage(0.5 * damage, BRUTE, "l_leg")
	H.apply_damage(0.5 * damage, BRUTE, "r_leg")
	H.apply_damage(0.5 * damage, BRUTE, "l_arm")
	H.apply_damage(0.5 * damage, BRUTE, "r_arm")

	var/obj/effect/decal/cleanable/blood/B = new(loc)
	B.blood_DNA = list()
	B.blood_DNA[H.dna.unique_enzymes] = H.dna.b_type

	bloodiness += 4

// player on mulebot attempted to move
/obj/machinery/bot/mulebot/relaymove(mob/user)
	if(user.stat)
		return
	if(load == user)
		unload(0)

// receive a radio signal
// used for control and beacon reception

/obj/machinery/bot/mulebot/receive_signal(datum/signal/signal)
	if(!..())
		return
	if(!on)
		return

	/*
	to_world("rec signal: [signal.source]")
	for(var/x in signal.data)
		to_world("* [x] = [signal.data[x]]")
	*/
	var/recv = signal.data["command"]
	// process all-bot input
	if(recv == "bot_status" && wires.RemoteRX())
		send_status()

	recv = signal.data["command [suffix]"]
	if(wires.RemoteRX())
		// process control input
		switch(recv)
			if("stop")
				mode = 0
				return

			if("go")
				start()
				return

			if("target")
				set_destination(signal.data["destination"])
				return

			if("unload")
				if(loc == target)
					unload(loaddir)
				else
					unload(0)
				return

			if("home")
				start_home()
				return

			if("bot_status")
				send_status()
				return

			if("autoret")
				auto_return = text2num(signal.data["value"])
				return

			if("autopick")
				auto_pickup = text2num(signal.data["value"])
				return

	// receive response from beacon
	recv = signal.data["beacon"]
	if(wires.BeaconRX())
		if(recv == new_destination)	// if the recvd beacon location matches the set destination
									// the we will navigate there
			destination = new_destination
			target = signal.source.loc
			var/direction = signal.data["dir"]	// this will be the load/unload dir
			if(direction)
				loaddir = text2num(direction)
			else
				loaddir = 0
			icon_state = "mulebot[wires.MobAvoid()]"
			calc_path()
			updateDialog()

// send a radio signal with a single data key/value pair
/obj/machinery/bot/mulebot/proc/post_signal(freq, key, value)
	post_signal_multiple(freq, list("[key]" = value) )

// send a radio signal with multiple data key/values
/obj/machinery/bot/mulebot/proc/post_signal_multiple(freq, list/keyval)
	if(freq == beacon_freq && !wires.BeaconRX())
		return
	if(freq == control_freq && !wires.RemoteTX())
		return

	var/datum/radio_frequency/frequency = global.CTradio.return_frequency(freq)

	if(isnull(frequency))
		return

	var/datum/signal/signal = new()
	signal.source = src
	signal.transmission_method = TRANSMISSION_RADIO
	//for(var/key in keyval)
	//	signal.data[key] = keyval[key]
	signal.data = keyval
		//to_world("sent [key],[keyval[key]] on [freq]")
	if(signal.data["findbeacon"])
		frequency.post_signal(src, signal, filter = RADIO_NAVBEACONS)
	else if (signal.data["type"] == "mulebot")
		frequency.post_signal(src, signal, filter = RADIO_MULEBOT)
	else
		frequency.post_signal(src, signal)

// signals bot status etc. to controller
/obj/machinery/bot/mulebot/proc/send_status()
	var/list/kv = list(
		"type" = "mulebot",
		"name" = suffix,
		"loca" = (loc ? loc.loc : "Unknown"),	// somehow loc can be null and cause a runtime - Quarxink
		"mode" = mode,
		"powr" = (cell ? cell.percent() : 0),
		"dest" = destination,
		"home" = home_destination,
		"load" = load,
		"retn" = auto_return,
		"pick" = auto_pickup,
	)
	post_signal_multiple(control_freq, kv)

/obj/machinery/bot/mulebot/emp_act(severity)
	if(isnotnull(cell))
		cell.emp_act(severity)
	if(isnotnull(load))
		load.emp_act(severity)
	..()

/obj/machinery/bot/mulebot/explode()
	visible_message(SPAN_DANGER("[src] blows apart!"), 1)

	var/turf/T = GET_TURF(src)
	new /obj/item/assembly/prox_sensor(T)
	new /obj/item/stack/rods(T)
	new /obj/item/stack/rods(T)
	new /obj/item/stack/cable_coil/cut(T)
	if(isnotnull(cell))
		cell.forceMove(T)
		cell.update_icon()
		cell = null

	make_sparks(3, TRUE, src)

	new /obj/effect/decal/cleanable/blood/oil(loc)
	unload(0)
	return ..()