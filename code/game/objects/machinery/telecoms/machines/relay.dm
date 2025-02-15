/*
	The relay idles until it receives information. It then passes on that information
	depending on where it came from.

	The relay is needed in order to send information pass Z levels. It must be linked
	with a HUB, the only other machine that can send/receive pass Z levels.
*/
/obj/machinery/telecoms/relay
	name = "telecommunications relay"
	icon_state = "relay"
	desc = "A mighty piece of hardware used to send massive amounts of data far away."
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 600
	)

	machinetype = 8
	//heatgen = 0
	operating_temperature = null
	circuitboard = /obj/item/circuitboard/telecoms/relay
	netspeed = 5
	long_range_link = TRUE

	var/broadcasting = TRUE
	var/receiving = TRUE

/obj/machinery/telecoms/relay/receive_information(datum/signal/signal, obj/machinery/telecoms/machine_from)
	// Add our level and send it back
	if(can_send(signal))
		signal.data["level"] |= listening_level

// Checks to see if it can send/receive.
/obj/machinery/telecoms/relay/proc/can(datum/signal/signal)
	if(!on)
		return FALSE
	if(!is_freq_listening(signal))
		return FALSE
	return TRUE

/obj/machinery/telecoms/relay/proc/can_send(datum/signal/signal)
	if(!can(signal))
		return FALSE
	return broadcasting

/obj/machinery/telecoms/relay/proc/can_receive(datum/signal/signal)
	if(!can(signal))
		return FALSE
	return receiving