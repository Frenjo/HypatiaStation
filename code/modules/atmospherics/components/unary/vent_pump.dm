#define SIPHONING 0
#define RELEASING 1

#define PRESSURE_CHECK_NULL		0
#define PRESSURE_CHECK_EXTERNAL	1
#define PRESSURE_CHECK_INTERNAL	2
#define PRESSURE_CHECK_BOTH		3
//1: Do not pass external_pressure_bound
//2: Do not pass internal_pressure_bound
//3: Do not pass either

/obj/machinery/atmospherics/unary/vent_pump
	name = "air vent (off)"
	desc = "Has a valve and pump attached to it"
	icon = 'icons/obj/atmospherics/vent_pump.dmi'
	icon_state = "off"

	level = 1

	var/area/initial_loc
	var/area_uid

	var/on = FALSE
	var/pump_direction = RELEASING

	var/external_pressure_bound = ONE_ATMOSPHERE
	var/internal_pressure_bound = 0

	var/pressure_checks = PRESSURE_CHECK_EXTERNAL

	var/welded = FALSE // Added for aliens -- TLE

	var/frequency = 1439
	var/datum/radio_frequency/radio_connection

	var/radio_filter_out
	var/radio_filter_in

/obj/machinery/atmospherics/unary/vent_pump/initialise()
	. = ..()
	air_contents.volume = 200
	initial_loc = GET_AREA(src)
	area_uid = initial_loc.uid

	if(!id_tag)
		uid = ++static_uid
		id_tag = num2text(uid)

/obj/machinery/atmospherics/unary/vent_pump/atmos_initialise()
	. = ..()
	//some vents work his own special way
	radio_filter_in = frequency == 1439 ? (RADIO_FROM_AIRALARM) : null
	radio_filter_out = frequency == 1439 ? (RADIO_TO_AIRALARM) : null
	radio_connection = register_radio(src, null, frequency, radio_filter_in)
	broadcast_status()

/obj/machinery/atmospherics/unary/vent_pump/Destroy()
	unregister_radio(src, frequency)
	radio_connection = null
	return ..()

/obj/machinery/atmospherics/unary/vent_pump/update_icon()
	if(welded)
		icon_state = "[level == 1 && isopenturf(loc) ? "h" : "" ]weld"
		return
	if(on && !(stat & (NOPOWER|BROKEN)))
		if(pump_direction)
			icon_state = "[level == 1 && isopenturf(loc) ? "h" : "" ]out"
		else
			icon_state = "[level == 1 && isopenturf(loc) ? "h" : "" ]in"
	else
		icon_state = "[level == 1 && isopenturf(loc) ? "h" : "" ]off"

/obj/machinery/atmospherics/unary/vent_pump/process()
	..()
	if(stat & (NOPOWER|BROKEN))
		return
	if(isnull(node))
		on = FALSE
	//broadcast_status() // from now air alarm/control computer should request update purposely --rastaf0
	if(!on)
		return 0
	if(welded)
		return 0

	var/datum/gas_mixture/environment = loc.return_air()
	var/environment_pressure = environment.return_pressure()

	if(pump_direction) //internal -> external
		var/pressure_delta = 10000

		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta = min(pressure_delta, (external_pressure_bound - environment_pressure))
		if(pressure_checks & PRESSURE_CHECK_INTERNAL)
			pressure_delta = min(pressure_delta, (air_contents.return_pressure() - internal_pressure_bound))

		if(pressure_delta > 0.5)
			if(air_contents.temperature > 0)
				var/transfer_moles = pressure_delta * environment.volume / (air_contents.temperature * R_IDEAL_GAS_EQUATION)

				var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

				loc.assume_air(removed)

				if(isnotnull(network))
					network.update = TRUE

	else //external -> internal
		var/pressure_delta = 10000
		if(pressure_checks & PRESSURE_CHECK_EXTERNAL)
			pressure_delta = min(pressure_delta, (environment_pressure - external_pressure_bound))
		if(pressure_checks & PRESSURE_CHECK_INTERNAL)
			pressure_delta = min(pressure_delta, (internal_pressure_bound - air_contents.return_pressure()))

		if(pressure_delta > 0.5)
			if(environment.temperature > 0)
				var/transfer_moles = pressure_delta * air_contents.volume / (environment.temperature * R_IDEAL_GAS_EQUATION)

				var/datum/gas_mixture/removed = loc.remove_air(transfer_moles)
				if(isnull(removed)) //in space
					return

				air_contents.merge(removed)

				if(isnotnull(network))
					network.update = TRUE
	return 1

/obj/machinery/atmospherics/unary/vent_pump/broadcast_status()
	if(isnull(radio_connection))
		return 0

	var/datum/signal/signal = new /datum/signal()
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src
	signal.data = list(
		"area" = area_uid,
		"tag" = id_tag,
		"device" = "AVP",
		"power" = on,
		"direction" = pump_direction ? ("release") : ("siphon"),
		"checks" = pressure_checks,
		"internal" = internal_pressure_bound,
		"external" = external_pressure_bound,
		"timestamp" = world.time,
		"sigtype" = "status"
	)

	if(!initial_loc.air_vent_names[id_tag])
		var/new_name = "[initial_loc.name] Vent Pump #[length(initial_loc.air_vent_names) + 1]"
		initial_loc.air_vent_names[id_tag] = new_name
		name = new_name
	initial_loc.air_vent_info[id_tag] = signal.data

	radio_connection.post_signal(src, signal, radio_filter_out)
	return 1

/obj/machinery/atmospherics/unary/vent_pump/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return

	//log_admin("DEBUG \[[world.timeofday]\]: /obj/machinery/atmospherics/unary/vent_pump/receive_signal([signal.debug_print()])")
	if(!..())
		return

	if(isnotnull(signal.data["purge"]))
		pressure_checks &= ~PRESSURE_CHECK_EXTERNAL
		pump_direction = SIPHONING

	if(isnotnull(signal.data["stabilise"]))
		pressure_checks |= PRESSURE_CHECK_EXTERNAL
		pump_direction = RELEASING

	var/signal_power = signal.data["power"]
	if(isnotnull(signal_power))
		on = text2num(signal_power)

	if(isnotnull(signal.data["power_toggle"]))
		on = !on

	var/signal_checks = signal.data["checks"]
	if(isnotnull(signal_checks))
		pressure_checks = text2num(signal_checks)

	if(isnotnull(signal.data["checks_toggle"]))
		pressure_checks = (pressure_checks ? PRESSURE_CHECK_NULL : PRESSURE_CHECK_BOTH)

	var/signal_direction = signal.data["direction"]
	if(isnotnull(signal_direction))
		pump_direction = text2num(signal_direction)

	var/signal_set_internal_pressure = signal.data["set_internal_pressure"]
	if(isnotnull(signal_set_internal_pressure))
		internal_pressure_bound = clamp(text2num(signal_set_internal_pressure), 0, ONE_ATMOSPHERE * 50)

	var/signal_set_external_pressure = signal.data["set_external_pressure"]
	if(isnotnull(signal_set_external_pressure))
		external_pressure_bound = clamp(text2num(signal_set_external_pressure), 0, ONE_ATMOSPHERE * 50)

	var/signal_adjust_internal_pressure = signal.data["adjust_internal_pressure"]
	if(isnotnull(signal_adjust_internal_pressure))
		internal_pressure_bound = clamp(internal_pressure_bound + text2num(signal_adjust_internal_pressure), 0, ONE_ATMOSPHERE * 50)

	var/signal_adjust_external_pressure = signal.data["adjust_external_pressure"]
	if(isnotnull(signal_adjust_external_pressure))
		external_pressure_bound = clamp(external_pressure_bound + text2num(signal_adjust_external_pressure), 0, ONE_ATMOSPHERE * 50)

	if(isnotnull(signal.data["status"]))
		spawn(2)
			broadcast_status()
		return //do not update_icon

	//log_admin("DEBUG \[[world.timeofday]\]: vent_pump/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	update_icon()

/obj/machinery/atmospherics/unary/vent_pump/hide(i) //to make the little pipe section invisible, the icon changes.
	if(welded)
		icon_state = "[i == 1 && isopenturf(loc) ? "h" : "" ]weld"
		return
	if(on && isnotnull(node))
		if(pump_direction)
			icon_state = "[i == 1 && isopenturf(loc) ? "h" : "" ]out"
		else
			icon_state = "[i == 1 && isopenturf(loc) ? "h" : "" ]in"
	else
		icon_state = "[i == 1 && isopenturf(loc) ? "h" : "" ]off"
		on = FALSE

/obj/machinery/atmospherics/unary/vent_pump/attackby(obj/item/W, mob/user)
	if(iswelder(W))
		var/obj/item/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			to_chat(user, SPAN_INFO("You begin to weld the vent."))
			if(do_after(user, 20))
				if(isnull(src) || !WT.isOn())
					return
				playsound(src, 'sound/items/Welder2.ogg', 50, 1)
				if(!welded)
					user.visible_message(
						"[user] welds the vent shut.",
						"You weld the vent shut.",
						SPAN_WARNING("You hear welding.")
					)
					welded = TRUE
					update_icon()
				else
					user.visible_message(
						"[user] unwelds the vent.",
						"You unweld the vent.",
						SPAN_WARNING("You hear welding.")
					)
					welded = FALSE
					update_icon()
			else
				to_chat(user, SPAN_INFO("The welding tool needs to be on to start this task."))
		else
			return 1

/obj/machinery/atmospherics/unary/vent_pump/examine()
	set src in oview(1)
	..()
	if(welded)
		to_chat(usr, "It seems welded shut.")

/obj/machinery/atmospherics/unary/vent_pump/power_change()
	if(powered(power_channel))
		stat &= ~NOPOWER
	else
		stat |= NOPOWER
	update_icon()

/obj/machinery/atmospherics/unary/vent_pump/attackby(obj/item/W, mob/user)
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

/*
	Alt-click to ventcrawl - Monkeys, aliens, slimes and mice.
	This is a little buggy but somehow that just seems to plague ventcrawl.
	I am sorry, I don't know why.
*/
// Commenting this out for now, it's not critical, stated to be buggy, and seems like
// a really clumsy way of doing this. ~Z
/*/obj/machinery/atmospherics/unary/vent_pump/AltClick(var/mob/living/ML)
	if(istype(ML))
		var/list/ventcrawl_verbs = list(/mob/living/carbon/monkey/verb/ventcrawl, /mob/living/carbon/alien/verb/ventcrawl, /mob/living/carbon/slime/verb/ventcrawl,/mob/living/simple/mouse/verb/ventcrawl)
		if(length(ML.verbs & ventcrawl_verbs)) // alien queens have this removed, an istype would be complicated
			ML.handle_ventcrawl(src)
			return
	..()*/

// Switched on variant.
/obj/machinery/atmospherics/unary/vent_pump/on
	name = "air vent (on)"
	on = TRUE
	icon_state = "out"

// Siphon variant.
/obj/machinery/atmospherics/unary/vent_pump/siphon
	name = "air vent (siphon/off)"
	pump_direction = SIPHONING
	icon_state = "off"

// Switched on siphon variant.
/obj/machinery/atmospherics/unary/vent_pump/siphon/on
	name = "air vent (siphon/on)"
	on = TRUE
	icon_state = "in"

// Large variant.
/obj/machinery/atmospherics/unary/vent_pump/high_volume
	name = "large air vent (off)"
	power_channel = EQUIP

/obj/machinery/atmospherics/unary/vent_pump/high_volume/initialise()
	. = ..()
	air_contents.volume = 1000

// Large switched on variant.
/obj/machinery/atmospherics/unary/vent_pump/high_volume/on
	name = "large air vent (on)"
	on = TRUE
	icon_state = "out"

// Large siphon variant.
/obj/machinery/atmospherics/unary/vent_pump/high_volume/siphon
	name = "large air vent (siphon/off)"
	pump_direction = SIPHONING

// Large switched on siphon variant.
/obj/machinery/atmospherics/unary/vent_pump/high_volume/siphon/on
	name = "large air vent (siphon/on)"
	on = TRUE
	icon_state = "in"

#undef PRESSURE_CHECK_NULL
#undef PRESSURE_CHECK_EXTERNAL
#undef PRESSURE_CHECK_INTERNAL
#undef PRESSURE_CHECK_BOTH

#undef SIPHONING
#undef RELEASING