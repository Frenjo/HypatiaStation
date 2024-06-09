/obj/machinery/atmospherics/binary/valve
	icon = 'icons/obj/atmospherics/valve.dmi'
	icon_state = "valve0"

	name = "manual valve"
	desc = "A pipe valve"

	var/open = FALSE
	var/openDuringInit = FALSE

/obj/machinery/atmospherics/binary/valve/atmos_initialise()
	normalize_dir()

	var/node1_dir
	var/node2_dir

	for(var/direction in GLOBL.cardinal)
		if(direction & initialize_directions)
			if(!node1_dir)
				node1_dir = direction
			else if(!node2_dir)
				node2_dir = direction

	for(var/obj/machinery/atmospherics/target in get_step(src, node1_dir))
		if(target.initialize_directions & get_dir(target, src))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src, node2_dir))
		if(target.initialize_directions & get_dir(target, src))
			node2 = target
			break

	build_network()

	if(openDuringInit)
		close()
		open()
		openDuringInit = FALSE

/*
	var/connect_directions
	switch(dir)
		if(NORTH)
			connect_directions = NORTH|SOUTH
		if(SOUTH)
			connect_directions = NORTH|SOUTH
		if(EAST)
			connect_directions = EAST|WEST
		if(WEST)
			connect_directions = EAST|WEST
		else
			connect_directions = dir

	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if(target.initialize_directions & get_dir(target,src))
					connect_directions &= ~direction
					node1 = target
					break
			if(node1)
				break

	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if(target.initialize_directions & get_dir(target,src))
					node2 = target
					break
			if(node1)
				break
*/

/obj/machinery/atmospherics/binary/valve/open
	open = TRUE
	icon_state = "valve1"

/obj/machinery/atmospherics/binary/valve/update_icon(animation)
	if(animation)
		flick("valve[open][!open]", src)
	else
		icon_state = "valve[open]"

/obj/machinery/atmospherics/binary/valve/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(reference == node1)
		network1 = new_network
		if(open)
			network2 = new_network
	else if(reference == node2)
		network2 = new_network
		if(open)
			network1 = new_network

	if(new_network.normal_members.Find(src))
		return 0

	new_network.normal_members.Add(src)

	if(open)
		if(reference == node1)
			if(isnotnull(node2))
				return node2.network_expand(new_network, src)
		else if(reference == node2)
			if(isnotnull(node1))
				return node1.network_expand(new_network, src)

	return null

/obj/machinery/atmospherics/binary/valve/proc/open()
	if(open)
		return 0

	open = TRUE
	update_icon()

	if(isnotnull(network1) && isnotnull(network2))
		network1.merge(network2)
		network2 = network1

	if(isnotnull(network1))
		network1.update = TRUE
	else if(isnotnull(network2))
		network2.update = TRUE

	return 1

/obj/machinery/atmospherics/binary/valve/proc/close()
	if(!open)
		return 0

	open = FALSE
	update_icon()

	if(isnotnull(network1))
		qdel(network1)
	if(isnotnull(network2))
		qdel(network2)

	build_network()

	return 1

/obj/machinery/atmospherics/binary/valve/proc/normalize_dir()
	if(dir == 3)
		dir = 1
	else if(dir == 12)
		dir = 4

/obj/machinery/atmospherics/binary/valve/attack_ai(mob/user)
	return

/obj/machinery/atmospherics/binary/valve/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/atmospherics/binary/valve/attack_hand(mob/user)
	add_fingerprint(usr)
	update_icon(1)
	sleep(10)
	if(open)
		close()
	else
		open()

/obj/machinery/atmospherics/binary/valve/process()
	..()
	return PROCESS_KILL

/*	if(open && (!node1 || !node2))
		close()
	if(!node1)
		if(!nodealert)
			//to_world("Missing node from [src] at [src.x],[src.y],[src.z]")
			nodealert = 1
	else if (!node2)
		if(!nodealert)
			//to_world("Missing node from [src] at [src.x],[src.y],[src.z]")
			nodealert = 1
	else if (nodealert)
		nodealert = 0
*/

/obj/machinery/atmospherics/binary/valve/digital		// can be controlled by AI
	name = "digital valve"
	desc = "A digitally controlled valve."
	icon = 'icons/obj/atmospherics/digital_valve.dmi'

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/binary/valve/digital/atmos_initialise()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/valve/digital/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/atmospherics/binary/valve/digital/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/atmospherics/binary/valve/digital/attack_hand(mob/user)
	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user)
		return
	..()

/obj/machinery/atmospherics/binary/valve/digital/receive_signal(datum/signal/signal)
	if(isnull(signal.data["tag"]) || signal.data["tag"] != id)
		return 0

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

/obj/machinery/atmospherics/binary/valve/digital/attackby(obj/item/W, mob/user)
	if(!istype(W, /obj/item/wrench))
		return ..()
	if(istype(src, /obj/machinery/atmospherics/binary/valve/digital))
		to_chat(user, SPAN_WARNING("You cannot unwrench this [src], it's too complicated."))
		return 1

	var/turf/T = loc
	if(level == 1 && isturf(T) && T.intact)
		to_chat(user, SPAN_WARNING("You must remove the plating first."))
		return 1

	var/datum/gas_mixture/int_air = return_air()
	var/datum/gas_mixture/env_air = loc.return_air()
	if((int_air.return_pressure() - env_air.return_pressure()) > 2 * ONE_ATMOSPHERE)
		to_chat(user, SPAN_WARNING("You cannot unwrench this [src], it too exerted due to internal pressure."))
		add_fingerprint(user)
		return 1

	playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
	to_chat(user, SPAN_INFO("You begin to unfasten \the [src]..."))
	if(do_after(user, 40))
		user.visible_message(
			"[user] unfastens \the [src].",
			SPAN_INFO("You have unfastened \the [src]."),
			"You hear a ratchet."
		)
		new /obj/item/pipe(loc, make_from = src)
		qdel(src)