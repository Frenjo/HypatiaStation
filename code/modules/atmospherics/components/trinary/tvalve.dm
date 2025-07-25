/obj/machinery/atmospherics/trinary/tvalve
	icon = 'icons/obj/atmospherics/valve.dmi'
	icon_state = "tvalve0"

	name = "manual switching valve"
	desc = "A pipe valve"

	dir = SOUTH
	initialize_directions = SOUTH|NORTH|WEST

	var/state = 0 // 0 = go straight, 1 = go to side

	// like a trinary component, node1 is input, node2 is side output, node3 is straight output

/obj/machinery/atmospherics/trinary/tvalve/update_icon(animation)
	if(animation)
		flick("tvalve[state][!state]",src)
	else
		icon_state = "tvalve[state]"

/obj/machinery/atmospherics/trinary/tvalve/proc/go_to_side()
	if(state)
		return 0

	state = 1
	update_icon()

	if(isnotnull(network1))
		qdel(network1)
	if(isnotnull(network3))
		qdel(network3)
	build_network()

	if(isnotnull(network1) && isnotnull(network2))
		network1.merge(network2)
		network2 = network1

	if(isnotnull(network1))
		network1.update = TRUE
	else if(isnotnull(network2))
		network2.update = TRUE

	return 1

/obj/machinery/atmospherics/trinary/tvalve/proc/go_straight()
	if(!state)
		return 0

	state = 0
	update_icon()

	if(isnotnull(network1))
		qdel(network1)
	if(isnotnull(network2))
		qdel(network2)
	build_network()

	if(isnotnull(network1) && isnotnull(network3))
		network1.merge(network3)
		network3 = network1

	if(isnotnull(network1))
		network1.update = TRUE
	else if(isnotnull(network3))
		network3.update = TRUE

	return 1

/obj/machinery/atmospherics/trinary/tvalve/attack_ai(mob/user)
	return

/obj/machinery/atmospherics/trinary/tvalve/attack_paw(mob/user)
	return attack_hand(user)

/obj/machinery/atmospherics/trinary/tvalve/attack_hand(mob/user)
	add_fingerprint(usr)
	update_icon(1)
	sleep(10)
	if(state)
		go_straight()
	else
		go_to_side()

/obj/machinery/atmospherics/trinary/tvalve/process()
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

/obj/machinery/atmospherics/trinary/tvalve/digital		// can be controlled by AI
	name = "digital switching valve"
	desc = "A digitally controlled valve."
	icon = 'icons/obj/atmospherics/digital_valve.dmi'

	var/frequency = 0
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/trinary/tvalve/digital/atmos_initialise()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/trinary/tvalve/digital/Destroy()
	unregister_radio(src, frequency)
	radio_connection = null
	return ..()

/obj/machinery/atmospherics/trinary/tvalve/digital/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/atmospherics/trinary/tvalve/digital/attack_hand(mob/user)
	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user)
		return
	..()

/obj/machinery/atmospherics/trinary/tvalve/digital/receive_signal(datum/signal/signal)
	if(!..())
		return

	switch(signal.data["command"])
		if("valve_open")
			if(!state)
				go_to_side()

		if("valve_close")
			if(state)
				go_straight()

		if("valve_toggle")
			if(state)
				go_straight()
			else
				go_to_side()

/obj/machinery/atmospherics/trinary/tvalve/digital/attackby(obj/item/W, mob/user)
	if(!iswrench(W))
		return ..()
	if(istype(src, /obj/machinery/atmospherics/trinary/tvalve/digital))
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


/obj/machinery/atmospherics/trinary/tvalve/mirrored
	icon_state = "tvalvem0"

/obj/machinery/atmospherics/trinary/tvalve/mirrored/initialise()
	. = ..()
	switch(dir)
		if(NORTH)
			initialize_directions = SOUTH|NORTH|WEST
		if(SOUTH)
			initialize_directions = NORTH|SOUTH|EAST
		if(EAST)
			initialize_directions = WEST|EAST|NORTH
		if(WEST)
			initialize_directions = EAST|WEST|SOUTH

/obj/machinery/atmospherics/trinary/tvalve/mirrored/atmos_initialise()
	var/node1_dir
	var/node2_dir
	var/node3_dir

	node1_dir = turn(dir, 180)
	node2_dir = turn(dir, 90)
	node3_dir = dir

	for(var/obj/machinery/atmospherics/target in get_step(src, node1_dir))
		if(target.initialize_directions & get_dir(target, src))
			node1 = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src, node2_dir))
		if(target.initialize_directions & get_dir(target, src))
			node2 = target
			break
	for(var/obj/machinery/atmospherics/target in get_step(src, node3_dir))
		if(target.initialize_directions & get_dir(target, src))
			node3 = target
			break

/obj/machinery/atmospherics/trinary/tvalve/mirrored/update_icon(animation)
	if(animation)
		flick("tvalvem[state][!state]", src)
	else
		icon_state = "tvalvem[state]"


/obj/machinery/atmospherics/trinary/tvalve/mirrored/digital		// can be controlled by AI
	name = "digital switching valve"
	desc = "A digitally controlled valve."
	icon = 'icons/obj/atmospherics/digital_valve.dmi'

	var/frequency = 0
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/trinary/tvalve/mirrored/digital/atmos_initialise()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/trinary/tvalve/mirrored/digital/Destroy()
	unregister_radio(src, frequency)
	radio_connection = null
	return ..()

/obj/machinery/atmospherics/trinary/tvalve/mirrored/digital/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/atmospherics/trinary/tvalve/mirrored/digital/attack_hand(mob/user)
	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user)
		return
	..()

/obj/machinery/atmospherics/trinary/tvalve/mirrored/digital/receive_signal(datum/signal/signal)
	if(!..())
		return

	switch(signal.data["command"])
		if("valve_open")
			if(!state)
				go_to_side()

		if("valve_close")
			if(state)
				go_straight()

		if("valve_toggle")
			if(state)
				go_straight()
			else
				go_to_side()