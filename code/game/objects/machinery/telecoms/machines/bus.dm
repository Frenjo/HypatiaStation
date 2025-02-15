/*
	The bus mainframe idles and waits for hubs to relay them signals. They act
	as junctions for the network.

	They transfer uncompressed subspace packets to processor units, and then take
	the processed packet to a server for logging.

	Link to a subspace hub if it can't send to a server.
*/
/obj/machinery/telecoms/bus
	name = "bus mainframe"
	icon_state = "bus"
	desc = "A mighty piece of hardware used to send massive amounts of data quickly."
	density = TRUE
	anchored = TRUE

	power_usage = list(
		USE_POWER_IDLE = 1000
	)

	machinetype = 2
	//heatgen = 20
	operating_temperature = 20 + T0C
	circuitboard = /obj/item/circuitboard/telecoms/bus
	netspeed = 40

	var/change_frequency = 0

/obj/machinery/telecoms/bus/receive_information(datum/signal/signal, obj/machinery/telecoms/machine_from)
	if(is_freq_listening(signal))
		if(change_frequency)
			signal.frequency = change_frequency

		if(!istype(machine_from, /obj/machinery/telecoms/processor) && machine_from != src) // Signal must be ready (stupid assuming machine), let's send it
			// send to one linked processor unit
			var/send_to_processor = relay_information(signal, /obj/machinery/telecoms/processor)
			if(send_to_processor)
				return
			// failed to send to a processor, relay information anyway
			signal.data["slow"] += rand(1, 5) // slow the signal down only slightly
			src.receive_information(signal, src)

		// Try sending it!
		var/list/try_send = list(/obj/machinery/telecoms/server, /obj/machinery/telecoms/hub, /obj/machinery/telecoms/broadcaster, /obj/machinery/telecoms/bus)
		var/i = 0
		for(var/send in try_send)
			if(i)
				signal.data["slow"] += rand(0, 1) // slow the signal down only slightly
			i++
			var/can_send = relay_information(signal, send)
			if(can_send)
				break