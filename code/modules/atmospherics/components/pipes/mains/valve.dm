/obj/machinery/atmospherics/mains_pipe/valve
	icon_state = "mvalve0"
	name = "mains shutoff valve"
	desc = "A mains pipe valve"
	dir = SOUTH
	initialize_mains_directions = SOUTH|NORTH

	var/open = TRUE

/obj/machinery/atmospherics/mains_pipe/valve/New()
	nodes.len = 2
	. = ..()
	initialize_mains_directions = dir | turn(dir, 180)

/obj/machinery/atmospherics/mains_pipe/valve/update_icon(animation)
	var/turf/open/floor = loc
	var/hide = istype(floor) ? floor.intact : 0
	level = 1
	for(var/obj/machinery/atmospherics/mains_pipe/node in nodes)
		if(node.level == 2)
			hide = 0
			level = 2
			break

	if(animation)
		flick("[hide ? "h" : ""]mvalve[open][!open]", src)
	else
		icon_state = "[hide?"h":""]mvalve[open]"

/obj/machinery/atmospherics/mains_pipe/valve/atmos_initialise()
	normalize_dir()

	var/node1_dir
	var/node2_dir
	for(var/direction in GLOBL.cardinal)
		if(direction & initialize_mains_directions)
			if(!node1_dir)
				node1_dir = direction
			else if(!node2_dir)
				node2_dir = direction

	for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, node1_dir))
		if(target.initialize_mains_directions & get_dir(target, src))
			nodes[1] = target
			break
	for(var/obj/machinery/atmospherics/mains_pipe/target in get_step(src, node2_dir))
		if(target.initialize_mains_directions & get_dir(target, src))
			nodes[2] = target
			break

	if(open)
		..() // initialize internal pipes

	update_icon()

/obj/machinery/atmospherics/mains_pipe/valve/proc/normalize_dir()
	if(dir == 3)
		dir = 1
	else if(dir == 12)
		dir = 4

/obj/machinery/atmospherics/mains_pipe/valve/proc/open()
	if(open)
		return FALSE

	open = TRUE
	update_icon()

	atmos_initialise()

	return TRUE

/obj/machinery/atmospherics/mains_pipe/valve/proc/close()
	if(!open)
		return FALSE

	open = FALSE
	update_icon()

	for(var/obj/machinery/atmospherics/pipe/mains_component/node in src)
		for(var/obj/machinery/atmospherics/pipe/mains_component/o in node.nodes)
			o.disconnect(node)
			o.build_network()

	return TRUE

/obj/machinery/atmospherics/mains_pipe/valve/attack_ai(mob/user)
	return

/obj/machinery/atmospherics/mains_pipe/valve/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/atmospherics/mains_pipe/valve/attack_hand(mob/user)
	src.add_fingerprint(usr)
	update_icon(1)
	sleep(10)
	if(open)
		close()
	else
		open()


/obj/machinery/atmospherics/mains_pipe/valve/digital	// can be controlled by AI
	name = "digital mains valve"
	desc = "A digitally controlled valve."
	icon_state = "dvalve0"

	var/frequency = 0
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/mains_pipe/valve/digital/atmos_initialise()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/mains_pipe/valve/digital/Destroy()
	unregister_radio(src, frequency)
	radio_connection = null
	return ..()

/obj/machinery/atmospherics/mains_pipe/valve/digital/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/atmospherics/mains_pipe/valve/digital/attack_hand(mob/user)
	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user)
		return
	..()

/obj/machinery/atmospherics/mains_pipe/valve/digital/update_icon(animation)
	var/turf/open/floor = loc
	var/hide = istype(floor) ? floor.intact : 0
	level = 1
	for(var/obj/machinery/atmospherics/mains_pipe/node in nodes)
		if(node.level == 2)
			hide = 0
			level = 2
			break

	if(animation)
		flick("[hide?"h":""]dvalve[open][!open]", src)
	else
		icon_state = "[hide?"h":""]dvalve[open]"

/obj/machinery/atmospherics/mains_pipe/valve/digital/receive_signal(datum/signal/signal)
	if(!..())
		return

	switch(signal.data["command"])
		if("valve_open")
			if(!open)
				open()

		if("valve_close")
			if(open)
				close()

		if("valve_toggle")
			if(open)
				close()
			else
				open()