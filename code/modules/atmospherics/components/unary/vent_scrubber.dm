#define SIPHONING 0
#define SCRUBBING 1
/obj/machinery/atmospherics/unary/vent_scrubber
	name = "air scrubber (off)"
	desc = "Has a valve and pump attached to it"
	icon = 'icons/obj/atmospherics/vent_scrubber.dmi'
	icon_state = "off"

	level = 1

	var/area/initial_loc
	var/frequency = 1439
	var/datum/radio_frequency/radio_connection

	var/on = FALSE
	var/scrubbing = SCRUBBING //0 = siphoning, 1 = scrubbing
	var/scrub_CO2 = TRUE
	var/scrub_Toxins = FALSE
	var/scrub_N2O = FALSE

	var/volume_rate = 120
	var/panic = FALSE //is this scrubber panicked?

	var/area_uid
	var/radio_filter_out
	var/radio_filter_in

/obj/machinery/atmospherics/unary/vent_scrubber/New()
	initial_loc = GET_AREA(src)
	area_uid = initial_loc.uid
	if(!id_tag)
		uid = ++static_uid
		id_tag = num2text(uid)
	. = ..()

/obj/machinery/atmospherics/unary/vent_scrubber/atmos_initialise()
	. = ..()
	radio_filter_in = frequency == initial(frequency) ? RADIO_FROM_AIRALARM : null
	radio_filter_out = frequency == initial(frequency) ? RADIO_TO_AIRALARM : null
	radio_connection = register_radio(src, null, frequency, radio_filter_in)
	broadcast_status()

/obj/machinery/atmospherics/unary/vent_scrubber/Destroy()
	unregister_radio(src, frequency)
	if(isnotnull(initial_loc))
		initial_loc.air_scrub_info -= id_tag
		initial_loc.air_scrub_names -= id_tag
	return ..()

/obj/machinery/atmospherics/unary/vent_scrubber/update_icon()
	if(node && on && !(stat & (NOPOWER|BROKEN)))
		if(scrubbing)
			icon_state = "[level == 1 && issimulated(loc) ? "h" : "" ]on"
		else
			icon_state = "[level == 1 && issimulated(loc) ? "h" : "" ]in"
	else
		icon_state = "[level == 1 && issimulated(loc) ? "h" : "" ]off"
	return

/obj/machinery/atmospherics/unary/vent_scrubber/proc/broadcast_status()
	if(isnull(radio_connection))
		return 0

	var/datum/signal/signal = new /datum/signal()
	signal.transmission_method = TRANSMISSION_RADIO
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
		var/new_name = "[initial_loc.name] Air Scrubber #[length(initial_loc.air_scrub_names) + 1]"
		initial_loc.air_scrub_names[id_tag] = new_name
		name = new_name
	initial_loc.air_scrub_info[id_tag] = signal.data
	radio_connection.post_signal(src, signal, radio_filter_out)

	return 1

/obj/machinery/atmospherics/unary/vent_scrubber/process()
	..()
	if(stat & (NOPOWER | BROKEN))
		return
	if(isnull(node))
		on = FALSE
	//broadcast_status()
	if(!on)
		return 0

	var/datum/gas_mixture/environment = loc.return_air()

	if(scrubbing)
		if(environment.gas[/decl/xgm_gas/plasma] > 0.001 || environment.gas[/decl/xgm_gas/carbon_dioxide] > 0.001 \
		|| environment.gas[/decl/xgm_gas/oxygen_agent_b] > 0.001 || environment.gas[/decl/xgm_gas/nitrous_oxide] > 0.001 \
		|| environment.gas[/decl/xgm_gas/hydrogen] > 0.001)
			var/transfer_moles = min(1, volume_rate / environment.volume) * environment.total_moles

			//Take a gas sample
			var/datum/gas_mixture/removed = loc.remove_air(transfer_moles)
			if(isnull(removed)) //in space
				return

			//Filter it
			var/datum/gas_mixture/filtered_out = new
			filtered_out.temperature = removed.temperature
			if(scrub_Toxins)
				filtered_out.gas[/decl/xgm_gas/plasma] = removed.gas[/decl/xgm_gas/plasma]
				removed.gas[/decl/xgm_gas/plasma] = 0
			if(scrub_CO2)
				filtered_out.gas[/decl/xgm_gas/carbon_dioxide] = removed.gas[/decl/xgm_gas/carbon_dioxide]
				removed.gas[/decl/xgm_gas/carbon_dioxide] = 0
			if(scrub_N2O)
				filtered_out.gas[/decl/xgm_gas/nitrous_oxide] = removed.gas[/decl/xgm_gas/nitrous_oxide]
				removed.gas[/decl/xgm_gas/nitrous_oxide] = 0
			if(removed.gas[/decl/xgm_gas/oxygen_agent_b])
				filtered_out.gas[/decl/xgm_gas/oxygen_agent_b] = removed.gas[/decl/xgm_gas/oxygen_agent_b]
				removed.gas[/decl/xgm_gas/oxygen_agent_b] = 0
			// TODO: Set this up so you can manually toggle scrubbing of each individual gas.
			// Temporary solution is to just always scrub hydrogen in the same way as Oxygen Agent-B. -Frenjo
			if(removed.gas[/decl/xgm_gas/hydrogen])
				filtered_out.gas[/decl/xgm_gas/hydrogen] = removed.gas[/decl/xgm_gas/hydrogen]
				removed.gas[/decl/xgm_gas/hydrogen] = 0

			//Remix the resulting gases
			air_contents.merge(filtered_out)

			loc.assume_air(removed)

			if(isnotnull(network))
				network.update = TRUE

	else //Just siphoning all air
		if(air_contents.return_pressure() >= 50 * ONE_ATMOSPHERE)
			return

		var/transfer_moles = environment.total_moles * (volume_rate / environment.volume)

		var/datum/gas_mixture/removed = loc.remove_air(transfer_moles)

		air_contents.merge(removed)

		if(isnotnull(network))
			network.update = TRUE

	return 1

/* //unused piece of code
	hide(var/i) //to make the little pipe section invisible, the icon changes.
		if(on&&node)
			if(scrubbing)
				icon_state = "[i == 1 && issimulated(loc) ? "h" : "" ]on"
			else
				icon_state = "[i == 1 && issimulated(loc) ? "h" : "" ]in"
		else
			icon_state = "[i == 1 && issimulated(loc) ? "h" : "" ]off"
			on = 0
		return
*/

/obj/machinery/atmospherics/unary/vent_scrubber/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return

	if(!..())
		return

	var/signal_power = signal.data["power"]
	if(isnotnull(signal_power))
		on = text2num(signal_power)
	if(isnotnull(signal.data["power_toggle"]))
		on = !on

	var/signal_panic_siphon = signal.data["panic_siphon"]
	if(isnotnull(signal_panic_siphon)) //must be before if("scrubbing" thing
		panic = text2num(signal_panic_siphon)
		if(panic)
			on = TRUE
			scrubbing = SIPHONING
			volume_rate = 2000
		else
			scrubbing = SCRUBBING
			volume_rate = initial(volume_rate)
	if(isnotnull(signal.data["toggle_panic_siphon"]))
		panic = !panic
		if(panic)
			on = TRUE
			scrubbing = SIPHONING
			volume_rate = 2000
		else
			scrubbing = SCRUBBING
			volume_rate = initial(volume_rate)

	var/signal_scrubbing = signal.data["scrubbing"]
	if(isnotnull(signal_scrubbing))
		scrubbing = text2num(signal_scrubbing)
	if(signal.data["toggle_scrubbing"])
		scrubbing = !scrubbing

	var/signal_co2_scrub = signal.data["co2_scrub"]
	if(isnotnull(signal_co2_scrub))
		scrub_CO2 = text2num(signal_co2_scrub)
	if(signal.data["toggle_co2_scrub"])
		scrub_CO2 = !scrub_CO2

	var/signal_tox_scrub = signal.data["tox_scrub"]
	if(isnotnull(signal_tox_scrub))
		scrub_Toxins = text2num(signal_tox_scrub)
	if(signal.data["toggle_tox_scrub"])
		scrub_Toxins = !scrub_Toxins

	var/signal_n2o_scrub = signal.data["n2o_scrub"]
	if(isnotnull(signal_n2o_scrub))
		scrub_N2O = text2num(signal_n2o_scrub)
	if(signal.data["toggle_n2o_scrub"])
		scrub_N2O = !scrub_N2O

	var/signal_init = signal.data["init"]
	if(isnotnull(signal_init))
		name = signal_init
		return

	if(isnotnull(signal.data["status"]))
		spawn(2)
			broadcast_status()
		return //do not update_icon

//		log_admin("DEBUG \[[world.timeofday]\]: vent_scrubber/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	update_icon()

/obj/machinery/atmospherics/unary/vent_scrubber/power_change()
	if(powered(power_channel))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER
	update_icon()

/obj/machinery/atmospherics/unary/vent_scrubber/attackby(obj/item/W, mob/user)
	if(!iswrench(W))
		return ..()
	if(!(stat & NOPOWER) && on)
		to_chat(user, SPAN_WARNING("You cannot unwrench this [src], turn it off first."))
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

// Switched on variant.
/obj/machinery/atmospherics/unary/vent_scrubber/on
	name = "air scrubber (on)"
	on = TRUE
	icon_state = "on"

// Siphon variant.
/obj/machinery/atmospherics/unary/vent_scrubber/siphon
	name = "air scrubber (siphon/off)"
	scrubbing = SIPHONING
	icon_state = "off"

// Switched on siphon variant.
/obj/machinery/atmospherics/unary/vent_scrubber/siphon/on
	name = "air scrubber (siphon/on)"
	on = TRUE
	icon_state = "in"

#undef SIPHONING
#undef SCRUBBING