/obj/machinery/atmospherics/binary/dp_vent_pump
	icon = 'icons/obj/atmospherics/dp_vent_pump.dmi'
	icon_state = "off"

	//node2 is output port
	//node1 is input port

	name = "dual-port air vent"
	desc = "Has a valve and pump attached to it. There are two ports."

	level = 1

	var/on = FALSE
	var/pump_direction = 1 //0 = siphoning, 1 = releasing

	var/external_pressure_bound = ONE_ATMOSPHERE
	var/input_pressure_min = 0
	var/output_pressure_max = 0

	var/pressure_checks = 1
	//1: Do not pass external_pressure_bound
	//2: Do not pass input_pressure_min
	//4: Do not pass output_pressure_max

	var/frequency = 0
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/binary/dp_vent_pump/high_volume
	name = "large dual-port air vent"

/obj/machinery/atmospherics/binary/dp_vent_pump/high_volume/New()
	. = ..()
	air1.volume = 1000
	air2.volume = 1000

/obj/machinery/atmospherics/binary/dp_vent_pump/atmos_initialise()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/dp_vent_pump/Destroy()
	unregister_radio(src, frequency)
	radio_connection = null
	return ..()

/obj/machinery/atmospherics/binary/dp_vent_pump/update_icon()
	if(on)
		if(pump_direction)
			icon_state = "[level == 1 && isopenturf(loc) ? "h" : "" ]out"
		else
			icon_state = "[level == 1 && isopenturf(loc) ? "h" : "" ]in"
	else
		icon_state = "[level == 1 && isopenturf(loc) ? "h" : "" ]off"
		on = FALSE

/obj/machinery/atmospherics/binary/dp_vent_pump/hide(i) //to make the little pipe section invisible, the icon changes.
	if(on)
		if(pump_direction)
			icon_state = "[i == 1 && isopenturf(loc) ? "h" : "" ]out"
		else
			icon_state = "[i == 1 && isopenturf(loc) ? "h" : "" ]in"
	else
		icon_state = "[i == 1 && isopenturf(loc) ? "h" : "" ]off"
		on = FALSE

/obj/machinery/atmospherics/binary/dp_vent_pump/process()
	..()

	if(!on)
		return 0

	var/datum/gas_mixture/environment = loc.return_air()
	var/environment_pressure = environment.return_pressure()

	if(pump_direction) //input -> external
		var/pressure_delta = 10000

		if(pressure_checks & 1)
			pressure_delta = min(pressure_delta, (external_pressure_bound - environment_pressure))
		if(pressure_checks & 2)
			pressure_delta = min(pressure_delta, (air1.return_pressure() - input_pressure_min))

		if(pressure_delta > 0)
			if(air1.temperature > 0)
				var/transfer_moles = pressure_delta * environment.volume / (air1.temperature * R_IDEAL_GAS_EQUATION)

				var/datum/gas_mixture/removed = air1.remove(transfer_moles)

				loc.assume_air(removed)

				if(isnotnull(network1))
					network1.update = TRUE

	else //external -> output
		var/pressure_delta = 10000

		if(pressure_checks & 1)
			pressure_delta = min(pressure_delta, (environment_pressure - external_pressure_bound))
		if(pressure_checks & 4)
			pressure_delta = min(pressure_delta, (output_pressure_max - air2.return_pressure()))

		if(pressure_delta > 0)
			if(environment.temperature > 0)
				var/transfer_moles = pressure_delta * air2.volume / (environment.temperature * R_IDEAL_GAS_EQUATION)

				var/datum/gas_mixture/removed = loc.remove_air(transfer_moles)

				air2.merge(removed)

				if(isnotnull(network2))
					network2.update = TRUE

	return 1

/obj/machinery/atmospherics/binary/dp_vent_pump/proc/broadcast_status()
	if(isnull(radio_connection))
		return 0

	var/datum/signal/signal = new /datum/signal()
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src

	signal.data = list(
		"tag" = id_tag,
		"device" = "ADVP",
		"power" = on,
		"direction" = pump_direction ? ("release") : ("siphon"),
		"checks" = pressure_checks,
		"input" = input_pressure_min,
		"output" = output_pressure_max,
		"external" = external_pressure_bound,
		"sigtype" = "status"
	)
	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	return 1

/obj/machinery/atmospherics/binary/dp_vent_pump/receive_signal(datum/signal/signal)
	if(!..())
		return

	var/signal_power = signal.data["power"]
	if(isnotnull(signal_power))
		on = text2num(signal_power)
	if(isnotnull(signal.data["power_toggle"]))
		on = !on

	var/signal_direction = signal.data["direction"]
	if(isnotnull(signal_direction))
		pump_direction = text2num(signal_direction)

	var/signal_checks = signal.data["checks"]
	if(isnotnull(signal_checks))
		pressure_checks = text2num(signal_checks)

	if(isnotnull(signal.data["purge"]))
		pressure_checks &= ~1
		pump_direction = 0

	if(isnotnull(signal.data["stabilise"]))
		pressure_checks |= 1
		pump_direction = 1

	var/signal_set_input_pressure = signal.data["set_input_pressure"]
	if(isnotnull(signal_set_input_pressure))
		input_pressure_min = clamp(text2num(signal_set_input_pressure), 0, ONE_ATMOSPHERE * 50)

	var/signal_set_output_pressure = signal.data["set_output_pressure"]
	if(isnotnull(signal_set_output_pressure))
		output_pressure_max = clamp(text2num(signal_set_output_pressure), 0, ONE_ATMOSPHERE * 50)

	var/signal_set_external_pressure = signal.data["set_external_pressure"]
	if(isnotnull(signal_set_external_pressure))
		external_pressure_bound = clamp(text2num(signal_set_external_pressure), 0, ONE_ATMOSPHERE * 50)

	if(isnotnull(signal.data["status"]))
		spawn(2)
			broadcast_status()
		return //do not update_icon
	//if(signal.data["tag"])
	spawn(2)
		broadcast_status()
	update_icon()