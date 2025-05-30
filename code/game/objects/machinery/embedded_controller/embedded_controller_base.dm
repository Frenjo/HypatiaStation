// Adds docking controllers to go alongside airlock controllers, I couldn't be bothered to write these...
// But couldn't port it from a newer distro either... It was good I then remembered/found an older one...
// Ported this from an old Heaven's Gate - Eternal github I found, 22/11/2019. -Frenjo

/obj/machinery/embedded_controller
	name = "embedded controller"
	anchored = TRUE

	power_usage = alist(
		USE_POWER_IDLE = 10
	)

	var/datum/computer/file/embedded_program/program	//the currently executing program

	var/on = 1

/obj/machinery/embedded_controller/proc/post_signal(datum/signal/signal, comm_line)
	return 0

/obj/machinery/embedded_controller/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!..() || signal.encryption)
		return

	if(isnotnull(program))
		program.receive_signal(signal, receive_method, receive_param)
			//spawn(5) program.process() //no, program.process sends some signals and machines respond and we here again and we lag -rastaf0

/obj/machinery/embedded_controller/process()
	program?.process()

	update_icon()

/obj/machinery/embedded_controller/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/embedded_controller/attack_hand(mob/user)
	if(!user.IsAdvancedToolUser())
		return 0

	ui_interact(user)

/obj/machinery/embedded_controller/ui_interact()
	return


/obj/machinery/embedded_controller/radio
	icon = 'icons/obj/machines/airlock_machines.dmi'
	icon_state = "airlock_control_standby"
	density = FALSE

	obj_flags = OBJ_FLAG_UNACIDABLE

	power_channel = ENVIRON

	var/id_tag
	//var/radio_power_use = 50 //power used to xmit signals

	var/frequency = 1379
	var/radio_filter = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/embedded_controller/radio/initialise()
	. = ..()
	radio_connection = register_radio(src, null, frequency, radio_filter)

/obj/machinery/embedded_controller/radio/Destroy()
	unregister_radio(src, frequency)
	radio_connection = null
	return ..()

/obj/machinery/embedded_controller/radio/update_icon()
	if(on && program)
		if(program.memory["processing"])
			icon_state = "airlock_control_process"
		else
			icon_state = "airlock_control_standby"
	else
		icon_state = "airlock_control_off"

/obj/machinery/embedded_controller/radio/post_signal(datum/signal/signal, filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		//use_power(radio_power_use)	//neat idea, but causes way too much lag.
		return radio_connection.post_signal(src, signal, filter)
	else
		qdel(signal)