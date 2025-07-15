/obj/machinery/atmospherics/unary/outlet_injector
	icon = 'icons/obj/atmospherics/outlet_injector.dmi'
	icon_state = "off"

	name = "air injector (off)"
	desc = "Has a valve and pump attached to it"

	level = 1

	var/on = FALSE
	var/injecting = FALSE

	var/volume_rate = 50

	var/frequency = 0
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/unary/outlet_injector/initialise()
	. = ..()
	name = "air injector"

/obj/machinery/atmospherics/unary/outlet_injector/atmos_initialise()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/unary/outlet_injector/Destroy()
	unregister_radio(src, frequency)
	radio_connection = null
	return ..()

/obj/machinery/atmospherics/unary/outlet_injector/update_icon()
	if(isnotnull(node))
		if(on && !(stat & NOPOWER))
			icon_state = "[level == 1 && isopenturf(loc) ? "h" : "" ]on"
		else
			icon_state = "[level == 1 && isopenturf(loc) ? "h" : "" ]off"
	else
		icon_state = "exposed"
		on = FALSE

/obj/machinery/atmospherics/unary/outlet_injector/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/unary/outlet_injector/process()
	..()
	injecting = FALSE

	if(!on || stat & NOPOWER)
		return 0

	if(air_contents.temperature > 0)
		var/transfer_moles = air_contents.return_pressure() * volume_rate / (air_contents.temperature * R_IDEAL_GAS_EQUATION)

		var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

		loc.assume_air(removed)

		network?.update = TRUE

	return 1

/obj/machinery/atmospherics/unary/outlet_injector/receive_signal(datum/signal/signal)
	if(!..())
		return

	if("power" in signal.data)
		on = text2num(signal.data["power"])

	if("power_toggle" in signal.data)
		on = !on

	if("inject" in signal.data)
		spawn inject()
		return

	if("set_volume_rate" in signal.data)
		volume_rate = clamp(text2num(signal.data["set_volume_rate"]), 0, air_contents.volume)

	if("status" in signal.data)
		spawn(2)
			broadcast_status()
		return //do not update_icon

		//log_admin("DEBUG \[[world.timeofday]\]: outlet_injector/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
		//return
	spawn(2)
		broadcast_status()
	update_icon()

/obj/machinery/atmospherics/unary/outlet_injector/hide(i) //to make the little pipe section invisible, the icon changes.
	if(node)
		if(on)
			icon_state = "[i == 1 && isopenturf(loc) ? "h" : "" ]on"
		else
			icon_state = "[i == 1 && isopenturf(loc) ? "h" : "" ]off"
	else
		icon_state = "[i == 1 && isopenturf(loc) ? "h" : "" ]exposed"
		on = FALSE

/obj/machinery/atmospherics/unary/outlet_injector/proc/inject()
	if(on || injecting)
		return 0

	injecting = TRUE

	if(air_contents.temperature > 0)
		var/transfer_moles = air_contents.return_pressure() * volume_rate / (air_contents.temperature * R_IDEAL_GAS_EQUATION)

		var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

		loc.assume_air(removed)

		network?.update = TRUE

	flick("inject", src)

/obj/machinery/atmospherics/unary/outlet_injector/broadcast_status()
	if(isnull(radio_connection))
		return 0

	var/datum/signal/signal = new /datum/signal()
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src
	signal.data = list(
		"tag" = id_tag,
		"device" = "AO",
		"power" = on,
		"volume_rate" = volume_rate,
		//"timestamp" = world.time,
		"sigtype" = "status"
	 )

	radio_connection.post_signal(src, signal)

	return 1

// Switched on variant.
/obj/machinery/atmospherics/unary/outlet_injector/on
	name = "air injector (on)"
	icon_state = "on"
	on = TRUE

// Acid proof variant.
/obj/machinery/atmospherics/unary/outlet_injector/acid_proof
	name = "acid-proof air injector (off)"
	obj_flags = OBJ_FLAG_UNACIDABLE

/obj/machinery/atmospherics/unary/outlet_injector/New()
	. = ..()
	name = "acid-proof air injector"

// Switched on acid proof variant.
/obj/machinery/atmospherics/unary/outlet_injector/acid_proof/on
	name = "acid-proof air injector (on)"
	icon_state = "on"
	on = TRUE