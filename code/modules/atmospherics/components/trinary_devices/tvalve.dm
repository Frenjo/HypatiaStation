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
		flick("tvalve[src.state][!src.state]",src)
	else
		icon_state = "tvalve[state]"

/obj/machinery/atmospherics/trinary/tvalve/proc/go_to_side()
	if(state)
		return 0

	state = 1
	update_icon()

	if(network1)
		qdel(network1)
	if(network3)
		qdel(network3)
	build_network()

	if(network1 && network2)
		network1.merge(network2)
		network2 = network1

	if(network1)
		network1.update = TRUE
	else if(network2)
		network2.update = TRUE

	return 1

/obj/machinery/atmospherics/trinary/tvalve/proc/go_straight()
	if(!state)
		return 0

	state = 0
	update_icon()

	if(network1)
		qdel(network1)
	if(network2)
		qdel(network2)
	build_network()

	if(network1 && network3)
		network1.merge(network3)
		network3 = network1

	if(network1)
		network1.update = TRUE
	else if(network3)
		network3.update = TRUE

	return 1

/obj/machinery/atmospherics/trinary/tvalve/attack_ai(mob/user as mob)
	return

/obj/machinery/atmospherics/trinary/tvalve/attack_paw(mob/user as mob)
	return attack_hand(user)

/obj/machinery/atmospherics/trinary/tvalve/attack_hand(mob/user as mob)
	src.add_fingerprint(usr)
	update_icon(1)
	sleep(10)
	if(src.state)
		src.go_straight()
	else
		src.go_to_side()

/obj/machinery/atmospherics/trinary/tvalve/process()
	..()
	GLOBL.machines.Remove(src)

/*	if(open && (!node1 || !node2))
		close()
	if(!node1)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1
	else if (!node2)
		if(!nodealert)
			//world << "Missing node from [src] at [src.x],[src.y],[src.z]"
			nodealert = 1
	else if (nodealert)
		nodealert = 0
*/
	return

/obj/machinery/atmospherics/trinary/tvalve/digital		// can be controlled by AI
	name = "digital switching valve"
	desc = "A digitally controlled valve."
	icon = 'icons/obj/atmospherics/digital_valve.dmi'

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/trinary/tvalve/digital/initialize()
	..()
	radio_connection = register_radio(src, frequency, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/trinary/tvalve/digital/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/atmospherics/trinary/tvalve/digital/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/atmospherics/trinary/tvalve/digital/attack_hand(mob/user as mob)
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	..()

/obj/machinery/atmospherics/trinary/tvalve/digital/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || signal.data["tag"] != id)
		return 0

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

/obj/machinery/atmospherics/trinary/tvalve/digital/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!istype(W, /obj/item/weapon/wrench))
		return ..()
	if(istype(src, /obj/machinery/atmospherics/trinary/tvalve/digital))
		to_chat(user, SPAN_WARNING("You cannot unwrench this [src], it's too complicated."))
		return 1

	var/turf/T = src.loc
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

/obj/machinery/atmospherics/trinary/tvalve/mirrored/New()
	..()
	switch(dir)
		if(NORTH)
			initialize_directions = SOUTH|NORTH|WEST
		if(SOUTH)
			initialize_directions = NORTH|SOUTH|EAST
		if(EAST)
			initialize_directions = WEST|EAST|NORTH
		if(WEST)
			initialize_directions = EAST|WEST|SOUTH

/obj/machinery/atmospherics/trinary/tvalve/mirrored/initialize()
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
		flick("tvalvem[src.state][!src.state]", src)
	else
		icon_state = "tvalvem[state]"


/obj/machinery/atmospherics/trinary/tvalve/mirrored/digital		// can be controlled by AI
	name = "digital switching valve"
	desc = "A digitally controlled valve."
	icon = 'icons/obj/atmospherics/digital_valve.dmi'

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/trinary/tvalve/mirrored/digital/initialize()
	..()
	radio_connection = register_radio(src, frequency, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/trinary/tvalve/mirrored/digital/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/atmospherics/trinary/tvalve/mirrored/digital/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/atmospherics/trinary/tvalve/mirrored/digital/attack_hand(mob/user as mob)
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	..()

/obj/machinery/atmospherics/trinary/tvalve/mirrored/digital/receive_signal(datum/signal/signal)
	if(!signal.data["tag"] || signal.data["tag"] != id)
		return 0

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