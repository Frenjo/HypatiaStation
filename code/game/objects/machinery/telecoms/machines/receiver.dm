/*
	The receiver idles and receives messages from subspace-compatible radio equipment;
	primarily headsets. They then just relay this information to all linked devices,
	which can would probably be network hubs.

	Link to Processor Units in case receiver can't send to bus units.
*/
/obj/machinery/telecoms/receiver
	name = "subspace receiver"
	icon_state = "broadcast receiver"
	desc = "This machine has a dish-like shape and green lights. It is designed to detect and process subspace radio activity."
	density = TRUE
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 600
	)

	machinetype = 1
	//heatgen = 0
	operating_temperature = null
	circuitboard = /obj/item/circuitboard/telecoms/receiver

/obj/machinery/telecoms/receiver/receive_signal(datum/signal/signal)
	if(!..())
		return
	if(!on) // has to be on to receive messages
		return
	if(!check_receive_level(signal))
		return

	if(signal.transmission_method == TRANSMISSION_SUBSPACE)
		if(is_freq_listening(signal)) // detect subspace signals
			//Remove the level and then start adding levels that it is being broadcasted in.
			signal.data["level"] = list()

			var/can_send = relay_information(signal, /obj/machinery/telecoms/hub) // ideally relay the copied information to relays
			if(!can_send)
				relay_information(signal, /obj/machinery/telecoms/bus) // Send it to a bus instead, if it's linked to one

/obj/machinery/telecoms/receiver/proc/check_receive_level(datum/signal/signal)
	if(signal.data["level"] != listening_level)
		for(var/obj/machinery/telecoms/hub/H in links)
			var/list/connected_levels = list()
			for(var/obj/machinery/telecoms/relay/R in H.links)
				if(R.can_receive(signal))
					connected_levels |= R.listening_level
			if(signal.data["level"] in connected_levels)
				return 1
		return 0
	return 1