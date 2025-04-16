/*
Every cycle, the pump uses the air in air_in to try and make air_out the perfect pressure.

node1, air1, network1 correspond to input
node2, air2, network2 correspond to output

Thus, the two variables affect pump operation are set in New():
	air1.volume
		This is the volume of gas available to the pump that may be transfered to the output
	air2.volume
		Higher quantities of this cause more air to be perfected later
			but overall network volume is also increased as this increases...
*/

/obj/machinery/atmospherics/binary/pump
	icon = 'icons/obj/atmospherics/pump.dmi'
	icon_state = "intact_off"

	name = "gas pump"
	desc = "A pump"

	var/on = FALSE
	var/target_pressure = ONE_ATMOSPHERE
	var/max_pressure = 4500

	var/frequency = 0
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/binary/pump/highcap
	name = "high-capacity gas pump"
	desc = "A high capacity pump"
	target_pressure = 15000000
	max_pressure = 15000000

/obj/machinery/atmospherics/binary/pump/on
	on = TRUE
	icon_state = "intact_on"

/obj/machinery/atmospherics/binary/pump/New()
	. = ..()
	air1.volume = 200
	air2.volume = 200

/obj/machinery/atmospherics/binary/pump/atmos_initialise()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/pump/Destroy()
	unregister_radio(src, frequency)
	radio_connection = null
	return ..()

/obj/machinery/atmospherics/binary/pump/update_icon()
	if(stat & NOPOWER)
		icon_state = "intact_off"
	else if(isnotnull(node1) && isnotnull(node2))
		icon_state = "intact_[on?("on"):("off")]"
	else
		if(isnotnull(node1))
			icon_state = "exposed_1_off"
		else if(isnotnull(node2))
			icon_state = "exposed_2_off"
		else
			icon_state = "exposed_3_off"
	return

/obj/machinery/atmospherics/binary/pump/process()
	if(stat & (NOPOWER|BROKEN))
		return
	if(!on)
		return 0

	var/output_starting_pressure = air2.return_pressure()
	if((target_pressure - output_starting_pressure) < 0.01)
		//No need to pump gas if target is already reached!
		return 1

	//Calculate necessary moles to transfer using PV=nRT
	if(air1.total_moles > 0 && air1.temperature > 0)
		var/pressure_delta = target_pressure - output_starting_pressure
		var/transfer_moles = pressure_delta * air2.volume / (air1.temperature * R_IDEAL_GAS_EQUATION)

		//Actually transfer the gas
		var/datum/gas_mixture/removed = air1.remove(transfer_moles)
		air2.merge(removed)

		if(isnotnull(network1))
			network1.update = TRUE
		if(isnotnull(network2))
			network2.update = TRUE

	return 1

/obj/machinery/atmospherics/binary/pump/proc/broadcast_status()
	if(isnull(radio_connection))
		return 0

	var/datum/signal/signal = new /datum/signal()
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src
	signal.data = list(
		"tag" = id_tag,
		"device" = "AGP",
		"power" = on,
		"target_output" = target_pressure,
		"sigtype" = "status"
	)

	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)
	return 1

	// Commented this out due to NanoUI port. -Frenjo
	/*interact(mob/user as mob)
		var/dat = {"<b>Power: </b><a href='byond://?src=\ref[src];power=1'>[on?"On":"Off"]</a><br>
					<b>Desirable output pressure: </b>
					[round(target_pressure,0.1)]kPa | <a href='byond://?src=\ref[src];set_press=1'>Change</a>
					"}

		user << browse("<HEAD><TITLE>[src.name] control</TITLE></HEAD><TT>[dat]</TT>", "window=atmo_pump")
		onclose(user, "atmo_pump")*/

/obj/machinery/atmospherics/binary/pump/receive_signal(datum/signal/signal)
	if(!..())
		return

	var/signal_power = signal.data["power"]
	if(isnotnull(signal_power))
		on = text2num(signal_power)
	if(isnotnull(signal.data["power_toggle"]))
		on = !on

	var/signal_set_output_pressure = signal.data["set_output_pressure"]
	if(isnotnull(signal_set_output_pressure))
		target_pressure = clamp(text2num(signal_set_output_pressure), 0, ONE_ATMOSPHERE * 50)

	if(isnotnull(signal.data["status"]))
		spawn(2)
			broadcast_status()
		return //do not update_icon

	spawn(2)
		broadcast_status()
	update_icon()

/obj/machinery/atmospherics/binary/pump/attack_hand(mob/user)
	if(..())
		return
	add_fingerprint(usr)

	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user)
		return

	usr.set_machine(src)
	ui_interact(user) // Edited this to reflect NanoUI port. -Frenjo

/obj/machinery/atmospherics/binary/pump/Topic(href,href_list)
	if(..())
		return
	/*if(href_list["power"])
		on = !on
	if(href_list["set_press"])
		var/new_pressure = input(usr,"Enter new output pressure (0-4500kPa)","Pressure control",src.target_pressure) as num
		src.target_pressure = max(0, min(4500, new_pressure))*/

	// Edited this to reflect NanoUI port. -Frenjo
	switch(href_list["power"])
		if("off")
			on = FALSE
		if("on")
			on = TRUE

	switch(href_list["set_press"])
		if("min")
			src.target_pressure = 0
		if("max")
			src.target_pressure = max_pressure
		if("set")
			var/new_pressure = input(usr, "Enter new output pressure (0 - [max_pressure]kPa)", "Pressure Control", target_pressure) as num
			target_pressure = max(0, min(max_pressure, new_pressure))

	usr.set_machine(src)
	update_icon()
	updateUsrDialog()

/obj/machinery/atmospherics/binary/pump/power_change()
	..()
	update_icon()

/obj/machinery/atmospherics/binary/pump/attackby(obj/item/W, mob/user)
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

// Porting this to NanoUI, it looks way better honestly. -Frenjo
/obj/machinery/atmospherics/binary/pump/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(stat & BROKEN)
		return

	var/alist/data = alist(
		"on" = on,
		"target_pressure" = round(target_pressure, 0.1), // TODO: Need to fix this later so it doesn't output 101.3xxxxxxxx. -Frenjo
		"max_pressure" = max_pressure
	)

	// Ported most of this by studying SMES code. -Frenjo
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		ui = new /datum/nanoui(user, src, ui_key, "gas_pump.tmpl", "Gas Pump", 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update()