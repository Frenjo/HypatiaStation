// Magnetic attractor, creates variable magnetic fields and attraction.
// Can also be used to emit electron/proton beams to create a center of magnetism on another tile

// tl;dr: it's magnets lol
// This was created for firing ranges, but I suppose this could have other applications - Doohl

/obj/machinery/magnetic_module
	icon = 'icons/obj/objects.dmi'
	icon_state = "floor_magnet-f"
	name = "electromagnetic generator"
	desc = "A device that uses station power to create points of magnetic energy."
	level = 1		// underfloor
	layer = 2.5
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 50
	)

	var/freq = 1449		// radio frequency
	var/electricity_level = 1 // intensity of the magnetic pull
	var/magnetic_field = 1 // the range of magnetic attraction
	var/code = 0 // frequency code, they should be different unless you have a group of magnets working together or something
	var/turf/center // the center of magnetic attraction
	var/on = 0
	var/pulling = 0

	// x, y modifiers to the center turf; (0, 0) is centered on the magnet, whereas (1, -1) is one tile right, one tile down
	var/center_x = 0
	var/center_y = 0
	var/max_dist = 20 // absolute value of center_x,y cannot exceed this integer

/obj/machinery/magnetic_module/New()
	. = ..()
	var/turf/T = loc
	hide(T.intact)
	center = T

/obj/machinery/magnetic_module/initialise()
	. = ..()
	register_radio(src, null, freq, RADIO_MAGNETS)

	spawn()
		magnetic_process()

/obj/machinery/magnetic_module/Destroy()
	unregister_radio(src, freq)
	return ..()

// update the invisibility and icon
/obj/machinery/magnetic_module/hide(var/intact)
	invisibility = intact ? 101 : 0
	updateicon()

/obj/machinery/magnetic_module/receive_signal(datum/signal/signal)
	if(!..())
		return

	var/command = signal.data["command"]
	var/modifier = signal.data["modifier"]
	var/signal_code = signal.data["code"]
	if(command && (signal_code == code))
		Cmd(command, modifier)

/obj/machinery/magnetic_module/process()
	if(stat & NOPOWER)
		on = 0

	// Sanity checks:
	if(electricity_level <= 0)
		electricity_level = 1
	if(magnetic_field <= 0)
		magnetic_field = 1


	// Limitations:
	if(abs(center_x) > max_dist)
		center_x = max_dist
	if(abs(center_y) > max_dist)
		center_y = max_dist
	if(magnetic_field > 4)
		magnetic_field = 4
	if(electricity_level > 12)
		electricity_level = 12

	// Update power usage:
	if(on)
		power_usage[USE_POWER_ACTIVE] = electricity_level * 15
		update_power_state(USE_POWER_ACTIVE)
	else
		update_power_state(USE_POWER_OFF)


	// Overload conditions:
	/* // Eeeehhh kinda stupid
	if(on)
		if(electricity_level > 11)
			if(prob(electricity_level))
				explosion(loc, 0, 1, 2, 3) // ooo dat shit EXPLODES son
				spawn(2)
					del(src)
	*/

	updateicon()

// update the icon_state
/obj/machinery/magnetic_module/proc/updateicon()
	var/state = "floor_magnet"
	var/onstate = ""
	if(!on)
		onstate = "0"

	if(invisibility)
		icon_state = "[state][onstate]-f"	// if invisible, set icon to faded version
											// in case of being revealed by T-scanner
	else
		icon_state = "[state][onstate]"

/obj/machinery/magnetic_module/proc/magnetic_process() // proc that actually does the pulling
	if(pulling)
		return
	while(on)
		pulling = 1
		center = locate(x + center_x, y + center_y, z)
		if(center)
			for(var/obj/M in orange(magnetic_field, center))
				if(!M.anchored && HAS_OBJ_FLAGS(M, OBJ_FLAG_CONDUCT))
					step_towards(M, center)

			for(var/mob/living/silicon/S in orange(magnetic_field, center))
				if(isAI(S))
					continue
				step_towards(S, center)

		use_power(electricity_level * 5)
		sleep(13 - electricity_level)

	pulling = 0

/obj/machinery/magnetic_module/proc/Cmd(var/command, var/modifier)
	if(command)
		switch(command)
			if("set-electriclevel")
				if(modifier)	electricity_level = modifier
			if("set-magneticfield")
				if(modifier)	magnetic_field = modifier

			if("add-elec")
				electricity_level++
				if(electricity_level > 12)
					electricity_level = 12
			if("sub-elec")
				electricity_level--
				if(electricity_level <= 0)
					electricity_level = 1
			if("add-mag")
				magnetic_field++
				if(magnetic_field > 4)
					magnetic_field = 4
			if("sub-mag")
				magnetic_field--
				if(magnetic_field <= 0)
					magnetic_field = 1

			if("set-x")
				if(modifier)	center_x = modifier
			if("set-y")
				if(modifier)	center_y = modifier

			if("N") // NORTH
				center_y++
			if("S")	// SOUTH
				center_y--
			if("E") // EAST
				center_x++
			if("W") // WEST
				center_x--
			if("C") // CENTER
				center_x = 0
				center_y = 0
			if("R") // RANDOM
				center_x = rand(-max_dist, max_dist)
				center_y = rand(-max_dist, max_dist)

			if("set-code")
				if(modifier)	code = modifier
			if("toggle-power")
				on = !on

				if(on)
					spawn()
						magnetic_process()


/obj/machinery/magnetic_controller
	name = "magnetic control console"
	icon = 'icons/obj/machines/airlock_machines.dmi' // uses an airlock machine icon, THINK GREEN HELP THE ENVIRONMENT - RECYCLING!
	icon_state = "airlock_control_standby"
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 45
	)

	var/frequency = 1449
	var/code = 0
	var/list/magnets = list()
	var/title = "Magnetic Control Console"
	var/autolink = 0 // if set to 1, can't probe for other magnets!

	var/pathpos = 1 // position in the path
	var/path = "NULL" // text path of the magnet
	var/speed = 1 // lowest = 1, highest = 10
	var/list/rpath = list() // real path of the magnet, used in iterator

	var/moving = 0 // 1 if scheduled to loop
	var/looping = 0 // 1 if looping

	var/datum/radio_frequency/radio_connection

/obj/machinery/magnetic_controller/initialise()
	. = ..()
	if(autolink)
		FOR_MACHINES_TYPED(magnet, /obj/machinery/magnetic_module)
			if(magnet.freq == frequency && magnet.code == code)
				magnets.Add(magnet)

	if(path) // check for default path
		filter_path() // renders rpath

	radio_connection = register_radio(src, null, frequency, RADIO_MAGNETS)

/obj/machinery/magnetic_controller/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/magnetic_controller/process()
	if(!length(magnets) && autolink)
		FOR_MACHINES_TYPED(magnet, /obj/machinery/magnetic_module)
			if(magnet.freq == frequency && magnet.code == code)
				magnets.Add(magnet)

/obj/machinery/magnetic_controller/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/magnetic_controller/attack_hand(mob/user)
	if(stat & (BROKEN | NOPOWER))
		return
	user.set_machine(src)
	var/dat = "<B>Magnetic Control Console</B><BR><BR>"
	if(!autolink)
		dat += {"
		Frequency: <a href='byond://?src=\ref[src];operation=setfreq'>[frequency]</a><br>
		Code: <a href='byond://?src=\ref[src];operation=setfreq'>[code]</a><br>
		<a href='byond://?src=\ref[src];operation=probe'>Probe Generators</a><br>
		"}

	if(length(magnets))

		dat += "Magnets confirmed: <br>"
		var/i = 0
		for(var/obj/machinery/magnetic_module/M in magnets)
			i++
			dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;< \[[i]\] (<a href='byond://?src=\ref[src];radio-op=togglepower'>[M.on ? "On":"Off"]</a>) | Electricity level: <a href='byond://?src=\ref[src];radio-op=minuselec'>-</a> [M.electricity_level] <a href='byond://?src=\ref[src];radio-op=pluselec'>+</a>; Magnetic field: <a href='byond://?src=\ref[src];radio-op=minusmag'>-</a> [M.magnetic_field] <a href='byond://?src=\ref[src];radio-op=plusmag'>+</a><br>"

	dat += "<br>Speed: <a href='byond://?src=\ref[src];operation=minusspeed'>-</a> [speed] <a href='byond://?src=\ref[src];operation=plusspeed'>+</a><br>"
	dat += "Path: {<a href='byond://?src=\ref[src];operation=setpath'>[path]</a>}<br>"
	dat += "Moving: <a href='byond://?src=\ref[src];operation=togglemoving'>[moving ? "Enabled":"Disabled"]</a>"


	user << browse(dat, "window=magnet;size=400x500")
	onclose(user, "magnet")

/obj/machinery/magnetic_controller/Topic(href, href_list)
	if(stat & (BROKEN | NOPOWER))
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)

	if(href_list["radio-op"])
		// Prepare signal beforehand, because this is a radio operation
		var/datum/signal/signal = new /datum/signal()
		signal.transmission_method = TRANSMISSION_RADIO // radio transmission
		signal.source = src
		signal.frequency = frequency
		signal.data = list("code" = code)

		// Apply any necessary commands
		switch(href_list["radio-op"])
			if("togglepower")
				signal.data["command"] = "toggle-power"

			if("minuselec")
				signal.data["command"] = "sub-elec"
			if("pluselec")
				signal.data["command"] = "add-elec"

			if("minusmag")
				signal.data["command"] = "sub-mag"
			if("plusmag")
				signal.data["command"] = "add-mag"


		// Broadcast the signal
		radio_connection.post_signal(src, signal, filter = RADIO_MAGNETS)

		spawn(1)
			updateUsrDialog() // pretty sure this increases responsiveness

	if(href_list["operation"])
		switch(href_list["operation"])
			if("plusspeed")
				speed ++
				if(speed > 10)
					speed = 10
			if("minusspeed")
				speed --
				if(speed <= 0)
					speed = 1
			if("setpath")
				var/newpath = copytext(sanitize(input(usr, "Please define a new path!",,path) as text|null),1,MAX_MESSAGE_LEN)
				if(newpath && newpath != "")
					moving = 0 // stop moving
					path = newpath
					pathpos = 1 // reset position
					filter_path() // renders rpath

			if("togglemoving")
				moving = !moving
				if(moving)
					spawn() MagnetMove()

	updateUsrDialog()

/obj/machinery/magnetic_controller/proc/MagnetMove()
	if(looping)
		return

	while(moving && length(rpath))
		if(stat & (BROKEN|NOPOWER))
			break

		looping = 1

		// Prepare the radio signal
		var/datum/signal/signal = new /datum/signal()
		signal.transmission_method = TRANSMISSION_RADIO // radio transmission
		signal.source = src
		signal.frequency = frequency
		signal.data = list("code" = code)

		if(pathpos > length(rpath)) // if the position is greater than the length, we just loop through the list!
			pathpos = 1

		var/nextmove = uppertext(rpath[pathpos]) // makes it un-case-sensitive

		if(!(nextmove in list("N","S","E","W","C","R")))
			// N, S, E, W are directional
			// C is center
			// R is random (in magnetic field's bounds)
			qdel(signal)
			break // break the loop if the character located is invalid

		signal.data["command"] = nextmove

		pathpos++ // increase iterator

		// Broadcast the signal
		spawn()
			radio_connection.post_signal(src, signal, filter = RADIO_MAGNETS)

		if(speed == 10)
			sleep(1)
		else
			sleep(12 - speed)

	looping = 0

/obj/machinery/magnetic_controller/proc/filter_path()
	// Generates the rpath variable using the path string, think of this as "string2list"
	// Doesn't use params2list() because of the akward way it stacks entities
	rpath = list() //  clear rpath
	var/maximum_character = min(50, length(path)) // chooses the maximum length of the iterator. 50 max length

	for(var/i = 1, i <= maximum_character, i++) // iterates through all characters in path
		var/nextchar = copytext(path, i, i + 1) // find next character

		if(!(nextchar in list(";", "&", "*", " "))) // if char is a separator, ignore
			rpath += copytext(path, i, i + 1) // else, add to list

		// there doesn't HAVE to be separators but it makes paths syntatically visible