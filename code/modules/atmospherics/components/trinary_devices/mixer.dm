/obj/machinery/atmospherics/trinary/mixer
	icon = 'icons/obj/atmospherics/mixer.dmi'
	icon_state = "intact_off"
	//density = 1
	density = 0 // Made filters and mixers not-dense so you can walk over them. -Frenjo

	name = "Gas mixer"

	var/on = 0

	var/target_pressure = ONE_ATMOSPHERE
	var/node1_concentration = 0.5
	var/node2_concentration = 0.5

	//node 3 is the outlet, nodes 1 & 2 are intakes

/obj/machinery/atmospherics/trinary/mixer/update_icon()
	if(stat & NOPOWER)
		icon_state = "intact_off"
	else if(node2 && node3 && node1)
		icon_state = "intact_[on?("on"):("off")]"
	else
		icon_state = "intact_off"
		on = 0

	return

/obj/machinery/atmospherics/trinary/mixer/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/trinary/mixer/New()
	..()
	air3.volume = 300

/obj/machinery/atmospherics/trinary/mixer/process()
	..()
	if(!on)
		return 0

	var/output_starting_pressure = air3.return_pressure()

	if(output_starting_pressure >= target_pressure)
		//No need to mix if target is already full!
		return 1

	//Calculate necessary moles to transfer using PV=nRT

	var/pressure_delta = target_pressure - output_starting_pressure
	var/transfer_moles1 = 0
	var/transfer_moles2 = 0

	if(air1.temperature > 0)
		transfer_moles1 = (node1_concentration * pressure_delta) * air3.volume / (air1.temperature * R_IDEAL_GAS_EQUATION)

	if(air2.temperature > 0)
		transfer_moles2 = (node2_concentration * pressure_delta) * air3.volume / (air2.temperature * R_IDEAL_GAS_EQUATION)

	var/air1_moles = air1.total_moles
	var/air2_moles = air2.total_moles

	if((air1_moles < transfer_moles1) || (air2_moles < transfer_moles2))
		if(!transfer_moles1 || !transfer_moles2) return
		var/ratio = min(air1_moles/transfer_moles1, air2_moles/transfer_moles2)

		transfer_moles1 *= ratio
		transfer_moles2 *= ratio

	//Actually transfer the gas

	if(transfer_moles1 > 0)
		var/datum/gas_mixture/removed1 = air1.remove(transfer_moles1)
		air3.merge(removed1)

	if(transfer_moles2 > 0)
		var/datum/gas_mixture/removed2 = air2.remove(transfer_moles2)
		air3.merge(removed2)

	if(network1 && transfer_moles1)
		network1.update = TRUE

	if(network2 && transfer_moles2)
		network2.update = TRUE

	if(network3)
		network3.update = TRUE

	return 1

/obj/machinery/atmospherics/trinary/mixer/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(!istype(W, /obj/item/weapon/wrench))
		return ..()
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
		user.visible_message( \
			"[user] unfastens \the [src].", \
			SPAN_INFO("You have unfastened \the [src]."), \
			"You hear a ratchet.")
		new /obj/item/pipe(loc, make_from=src)
		qdel(src)

/obj/machinery/atmospherics/trinary/mixer/attack_hand(user as mob)
	if(..())
		return
	src.add_fingerprint(usr)
	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return
	usr.set_machine(src)
	/*var/dat = {"<b>Power: </b><a href='?src=\ref[src];power=1'>[on?"On":"Off"]</a><br>
				<b>Desirable output pressure: </b>
				[target_pressure]kPa | <a href='?src=\ref[src];set_press=1'>Change</a>
				<br>
				<b>Node 1 Concentration:</b>
				<a href='?src=\ref[src];node1_c=-0.1'><b>-</b></a>
				<a href='?src=\ref[src];node1_c=-0.01'>-</a>
				[node1_concentration]([node1_concentration*100]%)
				<a href='?src=\ref[src];node1_c=0.01'><b>+</b></a>
				<a href='?src=\ref[src];node1_c=0.1'>+</a>
				<br>
				<b>Node 2 Concentration:</b>
				<a href='?src=\ref[src];node2_c=-0.1'><b>-</b></a>
				<a href='?src=\ref[src];node2_c=-0.01'>-</a>
				[node2_concentration]([node2_concentration*100]%)
				<a href='?src=\ref[src];node2_c=0.01'><b>+</b></a>
				<a href='?src=\ref[src];node2_c=0.1'>+</a>
				"}

	user << browse("<HEAD><TITLE>[src.name] control</TITLE></HEAD><TT>[dat]</TT>", "window=atmo_mixer")
	onclose(user, "atmo_mixer")*/
	ui_interact(user) // Edited this to reflect NanoUI port. -Frenjo
	return

/obj/machinery/atmospherics/trinary/mixer/Topic(href, href_list)
	if(..()) return
	/*if(href_list["power"])
		on = !on
	if(href_list["set_press"])
		var/new_pressure = input(usr,"Enter new output pressure (0-4500kPa)","Pressure control",src.target_pressure) as num
		src.target_pressure = max(0, min(4500, new_pressure))
	if(href_list["node1_c"])
		var/value = text2num(href_list["node1_c"])
		src.node1_concentration = max(0, min(1, src.node1_concentration + value))
		src.node2_concentration = max(0, min(1, src.node2_concentration - value))
	if(href_list["node2_c"])
		var/value = text2num(href_list["node2_c"])
		src.node2_concentration = max(0, min(1, src.node2_concentration + value))
		src.node1_concentration = max(0, min(1, src.node1_concentration - value))*/

	// Edited this to reflect NanoUI port. -Frenjo
	switch(href_list["power"])
		if("off")
			on = 0
		if("on")
			on = 1

	if(href_list["node1_c"])
		var/value = text2num(href_list["node1_c"])
		src.node1_concentration = max(0, min(1, src.node1_concentration + value))
		src.node2_concentration = max(0, min(1, src.node2_concentration - value))

	if(href_list["node2_c"])
		var/value = text2num(href_list["node2_c"])
		src.node2_concentration = max(0, min(1, src.node2_concentration + value))
		src.node1_concentration = max(0, min(1, src.node1_concentration - value))

	switch(href_list["pressure"])
		if("set_press")
			var/new_pressure = input(usr, "Enter new output pressure (0-4500kPa)", "Pressure control", src.target_pressure) as num
			src.target_pressure = max(0, min(4500, new_pressure))

	src.update_icon()
	src.updateUsrDialog()
	return

// Porting this to NanoUI, it looks way better honestly. -Frenjo
// Porting this one was literally satan, just saying.
/obj/machinery/atmospherics/trinary/mixer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(stat & BROKEN)
		return

	var/data[0]
	data["on"] = on
	data["node1_concentration"] = node1_concentration
	data["node2_concentration"] = node2_concentration
	data["target_pressure"] = round(target_pressure, 0.1) // Need to fix this later so it doesn't output 101.3xxxxxxxx. -Frenjo

	// Ported most of this by studying SMES code. -Frenjo
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if(!ui)
		ui = new(user, src, ui_key, "gas_mixer.tmpl", "Gas Mixer", 540, 380)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)