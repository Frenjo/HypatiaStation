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

/obj/machinery/atmospherics/binary/volume_pump
	icon = 'icons/obj/atmospherics/volume_pump.dmi'
	icon_state = "intact_off"

	name = "volumetric gas pump"
	desc = "A volumetric pump"

	var/on = FALSE
	var/transfer_rate = 200
	var/max_transfer_rate = 200

	var/frequency = 0
	var/id = null
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/binary/volume_pump/on
	on = TRUE
	icon_state = "intact_on"

/obj/machinery/atmospherics/binary/volume_pump/atmos_initialise()
	. = ..()
	radio_connection = register_radio(src, null, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/binary/volume_pump/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/atmospherics/binary/volume_pump/update_icon()
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

/obj/machinery/atmospherics/binary/volume_pump/process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(!on)
		return 0

	var/input_starting_pressure = air1.return_pressure()
	var/output_starting_pressure = air2.return_pressure()
	// Pump mechanism just won't do anything if the pressure is too high/too low
	if((input_starting_pressure < 0.01) || (output_starting_pressure > 9000))
		return 1

	var/transfer_ratio = max(1, transfer_rate / air1.volume)
	var/datum/gas_mixture/removed = air1.remove_ratio(transfer_ratio)

	air2.merge(removed)

	if(isnotnull(network1))
		network1.update = TRUE
	if(isnotnull(network2))
		network2.update = TRUE

	return 1

/obj/machinery/atmospherics/binary/volume_pump/proc/broadcast_status()
	if(isnull(radio_connection))
		return 0

	var/datum/signal/signal = new /datum/signal()
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src
	signal.data = list(
		"tag" = id,
		"device" = "APV",
		"power" = on,
		"transfer_rate" = transfer_rate,
		"sigtype" = "status"
	)
	radio_connection.post_signal(src, signal)

	return 1

	// Commented this out due to NanoUI port. -Frenjo
	/*interact(mob/user as mob)
		var/dat = {"<b>Power: </b><a href='byond://?src=\ref[src];power=1'>[on?"On":"Off"]</a><br>
					<b>Desirable output flow: </b>
					[round(transfer_rate,1)]l/s | <a href='byond://?src=\ref[src];set_transfer_rate=1'>Change</a>
					"}

		user << browse("<HEAD><TITLE>[src.name] control</TITLE></HEAD><TT>[dat]</TT>", "window=atmo_pump")
		onclose(user, "atmo_pump")*/

/obj/machinery/atmospherics/binary/volume_pump/receive_signal(datum/signal/signal)
	if(isnull(signal.data["tag"]) || signal.data["tag"] != id || signal.data["sigtype"] != "command")
		return 0

	if("power" in signal.data)
		on = text2num(signal.data["power"])

	if("power_toggle" in signal.data)
		on = !on

	if("set_transfer_rate" in signal.data)
		transfer_rate = between(
			0,
			text2num(signal.data["set_transfer_rate"]),
			air1.volume
		)

	if("status" in signal.data)
		spawn(2)
			broadcast_status()
		return //do not update_icon

	spawn(2)
		broadcast_status()
	update_icon()

/obj/machinery/atmospherics/binary/volume_pump/attack_hand(mob/user)
	if(..())
		return
	add_fingerprint(usr)
	if(!allowed(user))
		FEEDBACK_ACCESS_DENIED(user)
		return

	usr.set_machine(src)
	ui_interact(user) // Edited this to reflect NanoUI port. -Frenjo

/obj/machinery/atmospherics/binary/volume_pump/Topic(href, href_list)
	if(..()) return
	/*if(href_list["power"])
		on = !on
	if(href_list["set_transfer_rate"])
		var/new_transfer_rate = input(usr,"Enter new output volume (0-200l/s)","Flow control",src.transfer_rate) as num
		src.transfer_rate = max(0, min(200, new_transfer_rate))*/

	// Edited this to reflect NanoUI port. -Frenjo
	switch(href_list["power"])
		if("off")
			on = FALSE
		if("on")
			on = TRUE

	switch(href_list["set_pressure"])
		if("min")
			src.transfer_rate = 0
		if("max")
			src.transfer_rate = max_transfer_rate
		if("set")
			var/new_transfer_rate = input(usr, "Enter new output volume (0 - [max_transfer_rate]l/s)", "Flow control", transfer_rate) as num
			transfer_rate = max(0, min(200, new_transfer_rate))

	usr.set_machine(src)
	update_icon()
	updateUsrDialog()

/obj/machinery/atmospherics/binary/volume_pump/power_change()
	..()
	update_icon()

/obj/machinery/atmospherics/binary/volume_pump/attackby(obj/item/W, mob/user)
	if(!istype(W, /obj/item/wrench))
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

// Porting this to NanoUI, it looks way better honestly. -Frenjo
/obj/machinery/atmospherics/binary/volume_pump/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(stat & BROKEN)
		return

	var/list/data = list()
	data["on"] = on
	data["target_transfer_rate"] = round(transfer_rate)
	data["max_transfer_rate"] = max_transfer_rate

	// Ported most of this by studying SMES code. -Frenjo
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		ui = new(user, src, ui_key, "volume_gas_pump.tmpl", "Volumetric Gas Pump", 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update()