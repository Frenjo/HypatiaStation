/*
	The HUB idles until it receives information. It then passes on that information
	depending on where it came from.

	This is the heart of the Telecommunications Network, sending information where it
	is needed. It mainly receives information from long-distance Relays and then sends
	that information to be processed. Afterwards it gets the uncompressed information
	from Servers/Buses and sends that back to the relay, to then be broadcasted.
*/
/obj/machinery/telecoms/hub
	name = "telecommunications hub"
	icon_state = "hub"
	desc = "A mighty piece of hardware used to send/receive massive amounts of data."
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 1600
	)

	machinetype = 7
	//heatgen = 40
	operating_temperature = 40 + T0C
	circuitboard = /obj/item/circuitboard/telecoms/hub
	long_range_link = TRUE
	netspeed = 40

/obj/machinery/telecoms/hub/receive_information(datum/signal/signal, obj/machinery/telecoms/machine_from)
	if(is_freq_listening(signal))
		if(istype(machine_from, /obj/machinery/telecoms/receiver))
			//If the signal is compressed, send it to the bus.
			relay_information(signal, /obj/machinery/telecoms/bus, 1) // ideally relay the copied information to bus units
		else
			// Get a list of relays that we're linked to, then send the signal to their levels.
			relay_information(signal, /obj/machinery/telecoms/relay, 1)
			relay_information(signal, /obj/machinery/telecoms/broadcaster, 1) // Send it to a broadcaster.