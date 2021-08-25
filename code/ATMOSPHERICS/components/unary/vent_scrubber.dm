/obj/machinery/atmospherics/unary/vent_scrubber
	icon = 'icons/obj/atmospherics/vent_scrubber.dmi'
	icon_state = "off"

	name = "Air Scrubber"
	desc = "Has a valve and pump attached to it"
	use_power = 1

	level = 1

	var/area/initial_loc
	var/id_tag = null
	var/frequency = 1439
	var/datum/radio_frequency/radio_connection

	var/on = 0
	var/scrubbing = 1 //0 = siphoning, 1 = scrubbing
	var/scrub_CO2 = 1
	var/scrub_Toxins = 0
	var/scrub_N2O = 0

	var/volume_rate = 120
	var/panic = 0 //is this scrubber panicked?

	var/area_uid
	var/radio_filter_out
	var/radio_filter_in

/obj/machinery/atmospherics/unary/vent_scrubber/New()
	initial_loc = get_area(loc)
	area_uid = initial_loc.uid
	if(!id_tag)
		assign_uid()
		id_tag = num2text(uid)
	..()

/obj/machinery/atmospherics/unary/vent_scrubber/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/update_icon()
	if(node && on && !(stat & (NOPOWER|BROKEN)))
		if(scrubbing)
			icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]on"
		else
			icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]in"
	else
		icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]off"
	return

/obj/machinery/atmospherics/unary/vent_scrubber/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	radio_connection = radio_controller.add_object(src, frequency, radio_filter_in)

/obj/machinery/atmospherics/unary/vent_scrubber/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = 1 //radio signal
	signal.source = src
	signal.data = list(
		"area" = area_uid,
		"tag" = id_tag,
		"device" = "AScr",
		"timestamp" = world.time,
		"power" = on,
		"scrubbing" = scrubbing,
		"panic" = panic,
		"filter_co2" = scrub_CO2,
		"filter_toxins" = scrub_Toxins,
		"filter_n2o" = scrub_N2O,
		"sigtype" = "status"
	)
	if(!initial_loc.air_scrub_names[id_tag])
		var/new_name = "[initial_loc.name] Air Scrubber #[initial_loc.air_scrub_names.len+1]"
		initial_loc.air_scrub_names[id_tag] = new_name
		src.name = new_name
	initial_loc.air_scrub_info[id_tag] = signal.data
	radio_connection.post_signal(src, signal, radio_filter_out)

	return 1

/obj/machinery/atmospherics/unary/vent_scrubber/initialize()
	..()
	radio_filter_in = frequency == initial(frequency) ? (RADIO_FROM_AIRALARM) : null
	radio_filter_out = frequency == initial(frequency) ? (RADIO_TO_AIRALARM) : null
	if(frequency)
		set_frequency(frequency)
		src.broadcast_status()

/obj/machinery/atmospherics/unary/vent_scrubber/process()
	..()
	if(stat & (NOPOWER|BROKEN))
		return
	if(!node)
		on = 0
	//broadcast_status()
	if(!on)
		return 0

	var/datum/gas_mixture/environment = loc.return_air()

	if(scrubbing)
		if(environment.gas["plasma"] > 0.001 || environment.gas["carbon_dioxide"] > 0.001 || environment.gas["oxygen_agent_b"] > 0.001 || environment.gas["sleeping_agent"] > 0.001)
			var/transfer_moles = min(1, volume_rate / environment.volume) * environment.total_moles

			//Take a gas sample
			var/datum/gas_mixture/removed = loc.remove_air(transfer_moles)
			if(isnull(removed)) //in space
				return

			//Filter it
			var/datum/gas_mixture/filtered_out = new
			filtered_out.temperature = removed.temperature
			if(scrub_Toxins)
				filtered_out.gas["plasma"] = removed.gas["plasma"]
				removed.gas["plasma"] = 0
			if(scrub_CO2)
				filtered_out.gas["carbon_dioxide"] = removed.gas["carbon_dioxide"]
				removed.gas["carbon_dioxide"] = 0
			if(scrub_N2O)
				filtered_out.gas["sleeping_agent"] = removed.gas["sleeping_agent"]
				removed.gas["sleeping_agent"] = 0
			if(removed.gas["oxygen_agent_b"])
				filtered_out.gas["oxygen_agent_b"] = removed.gas["oxygen_agent_b"]
				removed.gas["oxygen_agent_b"] = 0

			//Remix the resulting gases
			air_contents.merge(filtered_out)

			loc.assume_air(removed)

			if(network)
				network.update = 1

	else //Just siphoning all air
		if(air_contents.return_pressure() >= 50 * ONE_ATMOSPHERE)
			return

		var/transfer_moles = environment.total_moles * (volume_rate / environment.volume)

		var/datum/gas_mixture/removed = loc.remove_air(transfer_moles)

		air_contents.merge(removed)

		if(network)
			network.update = 1

	return 1

/* //unused piece of code
	hide(var/i) //to make the little pipe section invisible, the icon changes.
		if(on&&node)
			if(scrubbing)
				icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]on"
			else
				icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]in"
		else
			icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]off"
			on = 0
		return
*/

/obj/machinery/atmospherics/unary/vent_scrubber/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return
	if(!signal.data["tag"] || signal.data["tag"] != id_tag || signal.data["sigtype"] != "command")
		return 0

	if(signal.data["power"] != null)
		on = text2num(signal.data["power"])
	if(signal.data["power_toggle"] != null)
		on = !on

	if(signal.data["panic_siphon"]) //must be before if("scrubbing" thing
		panic = text2num(signal.data["panic_siphon"] != null)
		if(panic)
			on = 1
			scrubbing = 0
			volume_rate = 2000
		else
			scrubbing = 1
			volume_rate = initial(volume_rate)
	if(signal.data["toggle_panic_siphon"] != null)
		panic = !panic
		if(panic)
			on = 1
			scrubbing = 0
			volume_rate = 2000
		else
			scrubbing = 1
			volume_rate = initial(volume_rate)

	if(signal.data["scrubbing"] != null)
		scrubbing = text2num(signal.data["scrubbing"])
	if(signal.data["toggle_scrubbing"])
		scrubbing = !scrubbing

	if(signal.data["co2_scrub"] != null)
		scrub_CO2 = text2num(signal.data["co2_scrub"])
	if(signal.data["toggle_co2_scrub"])
		scrub_CO2 = !scrub_CO2

	if(signal.data["tox_scrub"] != null)
		scrub_Toxins = text2num(signal.data["tox_scrub"])
	if(signal.data["toggle_tox_scrub"])
		scrub_Toxins = !scrub_Toxins

	if(signal.data["n2o_scrub"] != null)
		scrub_N2O = text2num(signal.data["n2o_scrub"])
	if(signal.data["toggle_n2o_scrub"])
		scrub_N2O = !scrub_N2O

	if(signal.data["init"] != null)
		name = signal.data["init"]
		return

	if(signal.data["status"] != null)
		spawn(2)
			broadcast_status()
		return //do not update_icon

//		log_admin("DEBUG \[[world.timeofday]\]: vent_scrubber/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/unary/vent_scrubber/power_change()
	if(powered(power_channel))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER
	update_icon()

/obj/machinery/atmospherics/unary/vent_scrubber/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!istype(W, /obj/item/weapon/wrench))
		return ..()
	if(!(stat & NOPOWER) && on)
		to_chat(user, SPAN_WARNING("You cannot unwrench this [src], turn it off first."))
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

/obj/machinery/atmospherics/unary/vent_scrubber/Destroy()
	if(initial_loc)
		initial_loc.air_scrub_info -= id_tag
		initial_loc.air_scrub_names -= id_tag
	return ..()