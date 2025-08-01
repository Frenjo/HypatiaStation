// Baseline portable generator. Has all the default handling. Not intended to be used on it's own (since it generates unlimited power).
/obj/machinery/power/port_gen
	name = "portable generator"
	desc = "A portable generator for emergency backup power"
	icon = 'icons/obj/power.dmi'
	icon_state = "portgen0"
	density = TRUE
	anchored = FALSE

	var/active = 0
	var/power_gen = 5000
	var/open = 0
	var/recent_fault = 0
	var/power_output = 1

// Placeholder for fuel check.
/obj/machinery/power/port_gen/proc/has_fuel()
	return TRUE

// Placeholder for fuel use.
/obj/machinery/power/port_gen/proc/use_fuel()
	return

/obj/machinery/power/port_gen/proc/drop_fuel()
	return

/obj/machinery/power/port_gen/proc/handle_inactive()
	return

/obj/machinery/power/port_gen/process()
	if(active && has_fuel() && !crit_fail && anchored && isnotnull(powernet))
		add_avail(power_gen * power_output)
		use_fuel()
		updateDialog()
	else
		active = 0
		icon_state = initial(icon_state)
		handle_inactive()

/obj/machinery/power/port_gen/attack_hand(mob/user)
	. = ..()
	if(.)
		return TRUE
	if(!anchored)
		return TRUE

/obj/machinery/power/port_gen/get_examine_text()
	. = ..()
	. += SPAN_INFO("The generator is [active ? "on" : "off"].")