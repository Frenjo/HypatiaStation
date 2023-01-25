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
	icon = 'icons/obj/atmospherics/vent_pump.dmi'
	icon_state = "off"

	name = "Air Vent (Off)"
	desc = "Has a valve and pump attached to it"
	use_power = TRUE

	level = 1

	var/area/initial_loc
	var/area_uid
	var/id_tag = null

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

/obj/machinery/atmospherics/unary/vent_pump/New()
	..()
	air_contents.volume = 200
	initial_loc = get_area(loc)
	area_uid = initial_loc.uid

	if(!id_tag)
		assign_uid()
		id_tag = num2text(uid)

/obj/machinery/atmospherics/unary/vent_pump/atmos_initialise()
	..()
	//some vents work his own special way
	radio_filter_in = frequency == 1439 ? (RADIO_FROM_AIRALARM) : null
	radio_filter_out = frequency == 1439 ? (RADIO_TO_AIRALARM) : null
	radio_connection = register_radio(src, null, frequency, radio_filter_in)
	broadcast_status()

/obj/machinery/atmospherics/unary/vent_pump/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/atmospherics/unary/vent_pump/update_icon()
	if(welded)
		icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]weld"
		return
	if(on && !(stat & (NOPOWER|BROKEN)))
		if(pump_direction)
			icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]out"
		else
			icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]in"
	else
		icon_state = "[level == 1 && istype(loc, /turf/simulated) ? "h" : "" ]off"

	return

/obj/machinery/atmospherics/unary/vent_pump/process()
	..()
	if(stat & (NOPOWER|BROKEN))
		return
	if(!node)
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

				if(network)
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

				if(network)
					network.update = TRUE
	return 1

/obj/machinery/atmospherics/unary/vent_pump/proc/broadcast_status()
	if(!radio_connection)
		return 0

	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src

	signal.data = list(
		"area" = src.area_uid,
		"tag" = src.id_tag,
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
		var/new_name = "[initial_loc.name] Vent Pump #[initial_loc.air_vent_names.len+1]"
		initial_loc.air_vent_names[id_tag] = new_name
		src.name = new_name
	initial_loc.air_vent_info[id_tag] = signal.data

	radio_connection.post_signal(src, signal, radio_filter_out)
	return 1

/obj/machinery/atmospherics/unary/vent_pump/receive_signal(datum/signal/signal)
	if(stat & (NOPOWER|BROKEN))
		return

	//log_admin("DEBUG \[[world.timeofday]\]: /obj/machinery/atmospherics/unary/vent_pump/receive_signal([signal.debug_print()])")
	if(!signal.data["tag"] || signal.data["tag"] != id_tag || signal.data["sigtype"] != "command")
		return 0

	if(signal.data["purge"] != null)
		pressure_checks &= ~PRESSURE_CHECK_EXTERNAL
		pump_direction = SIPHONING

	if(signal.data["stabalize"] != null)
		pressure_checks |= PRESSURE_CHECK_EXTERNAL
		pump_direction = RELEASING

	if(signal.data["power"] != null)
		on = text2num(signal.data["power"])

	if(signal.data["power_toggle"] != null)
		on = !on

	if(signal.data["checks"] != null)
		pressure_checks = text2num(signal.data["checks"])

	if(signal.data["checks_toggle"] != null)
		pressure_checks = (pressure_checks ? PRESSURE_CHECK_NULL : PRESSURE_CHECK_BOTH)

	if(signal.data["direction"] != null)
		pump_direction = text2num(signal.data["direction"])

	if(signal.data["set_internal_pressure"] != null)
		internal_pressure_bound = between(
			0,
			text2num(signal.data["set_internal_pressure"]),
			ONE_ATMOSPHERE * 50
		)

	if(signal.data["set_external_pressure"] != null)
		external_pressure_bound = between(
			0,
			text2num(signal.data["set_external_pressure"]),
			ONE_ATMOSPHERE * 50
		)

	if(signal.data["adjust_internal_pressure"] != null)
		internal_pressure_bound = between(
			0,
			internal_pressure_bound + text2num(signal.data["adjust_internal_pressure"]),
			ONE_ATMOSPHERE * 50
		)

	if(signal.data["adjust_external_pressure"] != null)
		external_pressure_bound = between(
			0,
			external_pressure_bound + text2num(signal.data["adjust_external_pressure"]),
			ONE_ATMOSPHERE * 50
		)

	if(signal.data["init"] != null)
		name = signal.data["init"]
		return

	if(signal.data["status"] != null)
		spawn(2)
			broadcast_status()
		return //do not update_icon

	//log_admin("DEBUG \[[world.timeofday]\]: vent_pump/receive_signal: unknown command \"[signal.data["command"]]\"\n[signal.debug_print()]")
	spawn(2)
		broadcast_status()
	update_icon()
	return

/obj/machinery/atmospherics/unary/vent_pump/hide(i) //to make the little pipe section invisible, the icon changes.
	if(welded)
		icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]weld"
		return
	if(on&&node)
		if(pump_direction)
			icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]out"
		else
			icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]in"
	else
		icon_state = "[i == 1 && istype(loc, /turf/simulated) ? "h" : "" ]off"
		on = FALSE
	return

/obj/machinery/atmospherics/unary/vent_pump/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			to_chat(user, SPAN_INFO("You begin to weld the vent."))
			if(do_after(user, 20))
				if(!src || !WT.isOn())
					return
				playsound(src, 'sound/items/Welder2.ogg', 50, 1)
				if(!welded)
					user.visible_message(
						"[user] welds the vent shut.",
						"You weld the vent shut.",
						"You hear welding."
					)
					welded = TRUE
					update_icon()
				else
					user.visible_message(
						"[user] unwelds the vent.",
						"You unweld the vent.",
						"You hear welding."
					)
					welded = FALSE
					update_icon()
			else
				to_chat(user, SPAN_INFO("The welding tool needs to be on to start this task."))
		else
			to_chat(user, SPAN_INFO("You need more welding fuel to complete this task."))
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

/obj/machinery/atmospherics/unary/vent_pump/attackby(obj/item/weapon/W as obj, mob/user as mob)
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

/*
	Alt-click to ventcrawl - Monkeys, aliens, slimes and mice.
	This is a little buggy but somehow that just seems to plague ventcrawl.
	I am sorry, I don't know why.
*/
// Commenting this out for now, it's not critical, stated to be buggy, and seems like
// a really clumsy way of doing this. ~Z
/*/obj/machinery/atmospherics/unary/vent_pump/AltClick(var/mob/living/ML)
	if(istype(ML))
		var/list/ventcrawl_verbs = list(/mob/living/carbon/monkey/verb/ventcrawl, /mob/living/carbon/alien/verb/ventcrawl, /mob/living/carbon/slime/verb/ventcrawl,/mob/living/simple_animal/mouse/verb/ventcrawl)
		if(length(ML.verbs & ventcrawl_verbs)) // alien queens have this removed, an istype would be complicated
			ML.handle_ventcrawl(src)
			return
	..()*/

// Switched on variant.
/obj/machinery/atmospherics/unary/vent_pump/on
	name = "Air Vent (On)"
	on = TRUE
	icon_state = "out"

// Siphon variant.
/obj/machinery/atmospherics/unary/vent_pump/siphon
	name = "Air Vent (Siphon/Off)"
	pump_direction = SIPHONING
	icon_state = "off"

// Switched on siphon variant.
/obj/machinery/atmospherics/unary/vent_pump/siphon/on
	name = "Air Vent (Siphon/On)"
	on = TRUE
	icon_state = "in"

// Large variant.
/obj/machinery/atmospherics/unary/vent_pump/high_volume
	name = "Large Air Vent (Off)"
	power_channel = EQUIP

/obj/machinery/atmospherics/unary/vent_pump/high_volume/New()
	..()
	air_contents.volume = 1000

// Large switched on variant.
/obj/machinery/atmospherics/unary/vent_pump/high_volume/on
	name = "Large Air Vent (On)"
	on = TRUE
	icon_state = "out"

// Large siphon variant.
/obj/machinery/atmospherics/unary/vent_pump/high_volume/siphon
	name = "Large Air Vent (Siphon/Off)"
	pump_direction = SIPHONING

// Large switched on siphon variant.
/obj/machinery/atmospherics/unary/vent_pump/high_volume/siphon/on
	name = "Large Air Vent (Siphon/On)"
	on = TRUE
	icon_state = "in"
#undef PRESSURE_CHECK_NULL
#undef PRESSURE_CHECK_EXTERNAL
#undef PRESSURE_CHECK_INTERNAL
#undef PRESSURE_CHECK_BOTH

#undef SIPHONING
#undef RELEASING