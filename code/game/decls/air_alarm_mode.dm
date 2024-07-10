/*
 * Air Alarm Modes
 *
 * Each subtype represents a different mode and contains functionality executed when that mode is set.
 */
/decl/air_alarm_mode
	// The mode's name and description text.
	// Formatted as "name - description".
	var/description = null

/*
 * apply()
 *
 * air_alarm - The alarm which is currently having its mode changed.
 * applied_to - The area to which this mode is being applied.
 * target_pressure - The pressure target for the area, if applicable.
 */
/decl/air_alarm_mode/proc/apply(obj/machinery/air_alarm/alarm, area/applied_to, target_pressure)
	return

/*
 * Scrubbing
 *
 * The standard mode, scrubs and replaces as needed.
 */
/decl/air_alarm_mode/scrubbing
	description = "Filtering - Scrubs out contaminants"

/decl/air_alarm_mode/scrubbing/apply(obj/machinery/air_alarm/alarm, area/applied_to, target_pressure)
	for(var/device_id in applied_to.air_scrub_names)
		alarm.send_signal(device_id, list("power" = TRUE, "co2_scrub" = TRUE, "scrubbing" = TRUE, "panic_siphon" = FALSE))
	for(var/device_id in applied_to.air_vent_names)
		alarm.send_signal(device_id, list("power" = TRUE, "checks" = TRUE, "set_external_pressure" = target_pressure))

/*
 * Replacement
 *
 * Like scrubbing, but faster.
 */
/decl/air_alarm_mode/replacement/New()
	. = ..()
	description = SPAN_INFO("Replace Air - Siphons out air while replacing")

/decl/air_alarm_mode/replacement/apply(obj/machinery/air_alarm/alarm, area/applied_to, target_pressure)
	for(var/device_id in applied_to.air_scrub_names)
		alarm.send_signal(device_id, list("power" = TRUE, "panic_siphon" = TRUE))
	for(var/device_id in applied_to.air_vent_names)
		alarm.send_signal(device_id, list("power" = TRUE, "checks" = TRUE, "set_external_pressure" = target_pressure))

/*
 * Panic
 *
 * Constantly sucks all air.
 */
/decl/air_alarm_mode/panic/New()
	. = ..()
	description = SPAN_WARNING("Panic - Siphons air out of the room")

/decl/air_alarm_mode/panic/apply(obj/machinery/air_alarm/alarm, area/applied_to, target_pressure)
	for(var/device_id in applied_to.air_scrub_names)
		alarm.send_signal(device_id, list("power" = TRUE, "panic_siphon" = TRUE))
	for(var/device_id in applied_to.air_vent_names)
		alarm.send_signal(device_id, list("power" = FALSE))

/*
 * Cycle
 *
 * Sucks out all the air, then refills and switches to scrubbing.
 */
/decl/air_alarm_mode/cycle/New()
	. = ..()
	description = SPAN_WARNING("Cycle - Siphons air before replacing")

/decl/air_alarm_mode/cycle/apply(obj/machinery/air_alarm/alarm, area/applied_to, target_pressure)
	for(var/device_id in applied_to.air_scrub_names)
		alarm.send_signal(device_id, list("power" = TRUE, "panic_siphon" = TRUE))
	for(var/device_id in applied_to.air_vent_names)
		alarm.send_signal(device_id, list("power" = FALSE))

/*
 * Fill
 *
 * Emergency fill.
 */
/decl/air_alarm_mode/fill/New()
	. = ..()
	description = SPAN_ALIUM("Fill - Shuts off scrubbers and opens vents")

/decl/air_alarm_mode/fill/apply(obj/machinery/air_alarm/alarm, area/applied_to, target_pressure)
	for(var/device_id in applied_to.air_scrub_names)
		alarm.send_signal(device_id, list("power" = FALSE))
	for(var/device_id in applied_to.air_vent_names)
		alarm.send_signal(device_id, list("power" = TRUE, "checks" = TRUE, "set_external_pressure" = target_pressure))

/*
 * Off
 *
 * Shuts it all down.
 */
/decl/air_alarm_mode/off/New()
	. = ..()
	description = SPAN_INFO("Off - Shuts off vents and scrubbers")

/decl/air_alarm_mode/off/apply(obj/machinery/air_alarm/alarm, area/applied_to, target_pressure)
	for(var/device_id in applied_to.air_scrub_names)
		alarm.send_signal(device_id, list("power" = FALSE))
	for(var/device_id in applied_to.air_vent_names)
		alarm.send_signal(device_id, list("power" = FALSE))