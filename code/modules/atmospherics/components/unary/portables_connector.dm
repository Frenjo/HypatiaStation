/obj/machinery/atmospherics/unary/portables_connector
	name = "connector port"
	desc = "For connecting portables devices related to atmospherics control."
	icon = 'icons/obj/atmospherics/portables_connector.dmi'
	icon_state = "intact"

	level = 0

	power_state = USE_POWER_OFF

	var/obj/machinery/portable_atmospherics/connected_device

	var/on = FALSE

/obj/machinery/atmospherics/unary/portables_connector/New()
	. = ..()

/obj/machinery/atmospherics/unary/portables_connector/atmos_initialise()
	. = ..()
	if(isnotnull(node))
		return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src, node_connect))
		if(target.initialize_directions & get_dir(target, src))
			node = target
			break

	update_icon()

/obj/machinery/atmospherics/unary/portables_connector/Destroy()
	connected_device?.disconnect()
	return ..()

/obj/machinery/atmospherics/unary/portables_connector/update_icon()
	if(isnotnull(node))
		icon_state = "[level == 1 && isopenturf(loc) ? "h" : "" ]intact"
		dir = get_dir(src, node)
	else
		icon_state = "exposed"

/obj/machinery/atmospherics/unary/portables_connector/hide(i) //to make the little pipe section invisible, the icon changes.
	if(isnotnull(node))
		icon_state = "[i == 1 && isopenturf(loc) ? "h" : "" ]intact"
		dir = get_dir(src, node)
	else
		icon_state = "exposed"

/obj/machinery/atmospherics/unary/portables_connector/process()
	..()
	if(!on)
		return
	if(isnull(connected_device))
		on = FALSE
		return
	if(isnotnull(network))
		network.update = TRUE
	return 1

/obj/machinery/atmospherics/unary/portables_connector/return_network(obj/machinery/atmospherics/reference)
	build_network()

	if(reference == node)
		return network

	if(reference == connected_device)
		return network

	return null

/obj/machinery/atmospherics/unary/portables_connector/return_network_air(datum/pipe_network/reference)
	var/list/results = list()

	if(isnotnull(connected_device))
		results.Add(connected_device.air_contents)

	return results

/obj/machinery/atmospherics/unary/portables_connector/attackby(obj/item/W, mob/user)
	if(!iswrench(W))
		return ..()
	if(isnotnull(connected_device))
		to_chat(user, SPAN_WARNING("You cannot unwrench this [src], dettach [connected_device] first."))
		return 1
	if(locate(/obj/machinery/portable_atmospherics, src.loc))
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