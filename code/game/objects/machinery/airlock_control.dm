#define AIRLOCK_CONTROL_RANGE 5

// This code allows for airlocks to be controlled externally by setting an id_tag and comm frequency (disables ID access)
/obj/machinery/door/airlock
	var/id_tag
	var/frequency
	var/shockedby = list()
	var/datum/radio_frequency/radio_connection
	explosion_resistance = 15

/obj/machinery/door/airlock/receive_signal(datum/signal/signal)
	if(isnull(signal) || signal.encryption)
		return

	if(id_tag != signal.data["tag"] || isnull(signal.data["command"]))
		return

	switch(signal.data["command"])
		if("open")
			open(TRUE)

		if("close")
			close(TRUE)

		if("unlock")
			if(!locked)
				return
			locked = FALSE
			update_icon()

		if("lock")
			if(locked)
				return
			locked = TRUE
			update_icon()

		if("secure_open")
			if(locked)
				locked = FALSE
				update_icon()

			sleep(2)
			open(TRUE)

			locked = TRUE
			update_icon()

		if("secure_close")
			if(locked)
				locked = FALSE
				update_icon()

			sleep(2)
			close(TRUE)

			locked = TRUE
			update_icon()
	send_status()

/obj/machinery/door/airlock/proc/send_status()
	if(!isnull(radio_connection))
		var/datum/signal/signal = new /datum/signal()
		signal.transmission_method = TRANSMISSION_RADIO
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		signal.data["door_status"] = density ? "closed" : "open"
		signal.data["lock_status"] = locked ? "locked" : "unlocked"

		radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)

/obj/machinery/door/airlock/open(surpress_send)
	. = ..()
	if(!surpress_send)
		send_status()

/obj/machinery/door/airlock/close(surpress_send)
	. = ..()
	if(!surpress_send)
		send_status()

/obj/machinery/door/airlock/Bumped(atom/AM)
	..(AM)
	if(ismecha(AM))
		var/obj/mecha/mecha = AM
		if(density && !isnull(radio_connection) && !isnull(mecha.occupant) && (allowed(mecha.occupant) || check_access_list(mecha.operation_req_access)))
			var/datum/signal/signal = new
			signal.transmission_method = TRANSMISSION_RADIO
			signal.data["tag"] = id_tag
			signal.data["timestamp"] = world.time

			signal.data["door_status"] = density?("closed"):("open")
			signal.data["lock_status"] = locked?("locked"):("unlocked")

			signal.data["bumped_with_access"] = 1

			radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)
	return

/obj/machinery/door/airlock/initialize()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_AIRLOCK)

	update_icon()

/obj/machinery/door/airlock/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/airlock_sensor
	icon = 'icons/obj/machines/airlock_machines.dmi'
	icon_state = "airlock_sensor_off"
	name = "airlock sensor"

	anchored = TRUE
	power_channel = ENVIRON

	var/id_tag
	var/master_tag
	var/frequency = 1379
	var/command = "cycle"

	var/datum/radio_frequency/radio_connection

	var/on = 1
	var/alert = 0
	var/previousPressure

/obj/machinery/airlock_sensor/update_icon()
	if(on)
		if(alert)
			icon_state = "airlock_sensor_alert"
		else
			icon_state = "airlock_sensor_standby"
	else
		icon_state = "airlock_sensor_off"

/obj/machinery/airlock_sensor/attack_hand(mob/user)
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO
	signal.data["tag"] = master_tag
	signal.data["command"] = command

	radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)
	flick("airlock_sensor_cycle", src)

/obj/machinery/airlock_sensor/process()
	if(on)
		var/datum/gas_mixture/air_sample = return_air()
		var/pressure = round(air_sample.return_pressure(),0.1)

		if(abs(pressure - previousPressure) > 0.001 || previousPressure == null)
			var/datum/signal/signal = new
			signal.transmission_method = TRANSMISSION_RADIO
			signal.data["tag"] = id_tag
			signal.data["timestamp"] = world.time
			signal.data["pressure"] = num2text(pressure)

			radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)

			previousPressure = pressure

			alert = (pressure < ONE_ATMOSPHERE*0.8)

			update_icon()

/obj/machinery/airlock_sensor/initialize()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_AIRLOCK)

/obj/machinery/airlock_sensor/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/airlock_sensor/airlock_interior
	command = "cycle_interior"

/obj/machinery/airlock_sensor/airlock_exterior
	command = "cycle_exterior"

/obj/machinery/access_button
	icon = 'icons/obj/machines/airlock_machines.dmi'
	icon_state = "access_button_standby"
	name = "access button"

	anchored = TRUE
	power_channel = ENVIRON

	var/master_tag
	var/frequency = 1379 // Changes this from 1449 to 1379 to try and fix airlock cycling issues. -Frenjo
	var/command = "cycle"

	var/datum/radio_frequency/radio_connection

	var/on = 1


/obj/machinery/access_button/update_icon()
	if(on)
		icon_state = "access_button_standby"
	else
		icon_state = "access_button_off"


/obj/machinery/access_button/attack_hand(mob/user)
	add_fingerprint(usr)
	if(!allowed(user))
		to_chat(user, FEEDBACK_ACCESS_DENIED)

	else if(radio_connection)
		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO
		signal.data["tag"] = master_tag
		signal.data["command"] = command

		radio_connection.post_signal(src, signal, range = AIRLOCK_CONTROL_RANGE, filter = RADIO_AIRLOCK)
	flick("access_button_cycle", src)

/obj/machinery/access_button/initialize()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_AIRLOCK)

/obj/machinery/access_button/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/access_button/airlock_interior
	frequency = 1379
	command = "cycle_interior"

/obj/machinery/access_button/airlock_exterior
	frequency = 1379
	command = "cycle_exterior"

#undef AIRLOCK_CONTROL_RANGE