/obj/machinery/portable_atmospherics/pump
	name = "portable air pump"

	icon = 'icons/obj/atmospherics/atmos.dmi'
	icon_state = "psiphon:0"
	density = TRUE

	volume = 1000

	var/on = FALSE
	var/direction_out = 0 //0 = siphoning, 1 = releasing
	var/target_pressure = 100

/obj/machinery/portable_atmospherics/pump/update_icon()
	overlays = 0

	if(on)
		icon_state = "psiphon:1"
	else
		icon_state = "psiphon:0"

	if(isnotnull(holding))
		add_overlay("siphon-open")

	if(isnotnull(connected_port))
		add_overlay("siphon-connector")

/obj/machinery/portable_atmospherics/pump/emp_act(severity)
	if(stat & (BROKEN | NOPOWER))
		..(severity)
		return

	if(prob(50 / severity))
		on = !on

	if(prob(100 / severity))
		direction_out = !direction_out

	target_pressure = rand(0, 1300)
	update_icon()

	..(severity)

/obj/machinery/portable_atmospherics/pump/process()
	..()
	if(on)
		var/datum/gas_mixture/environment
		if(isnotnull(holding))
			environment = holding.air_contents
		else
			environment = loc.return_air()
		if(direction_out)
			var/pressure_delta = target_pressure - environment.return_pressure()
			//Can not have a pressure delta that would cause environment pressure > tank pressure

			var/transfer_moles = 0
			if(air_contents.temperature > 0)
				transfer_moles = pressure_delta * environment.volume / (air_contents.temperature * R_IDEAL_GAS_EQUATION)

				//Actually transfer the gas
				var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)

				if(isnotnull(holding))
					environment.merge(removed)
				else
					loc.assume_air(removed)
		else
			var/pressure_delta = target_pressure - air_contents.return_pressure()
			//Can not have a pressure delta that would cause environment pressure > tank pressure

			var/transfer_moles = 0
			if(environment.temperature > 0)
				transfer_moles = pressure_delta * air_contents.volume / (environment.temperature * R_IDEAL_GAS_EQUATION)

				//Actually transfer the gas
				var/datum/gas_mixture/removed
				if(isnotnull(holding))
					removed = environment.remove(transfer_moles)
				else
					removed = loc.remove_air(transfer_moles)

				air_contents.merge(removed)
		//src.update_icon()

	updateDialog()

/obj/machinery/portable_atmospherics/pump/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/pump/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/pump/attack_paw(mob/user)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/pump/attack_hand(mob/user)
	user.set_machine(src)
	var/holding_text

	if(isnotnull(holding))
		holding_text = {"<BR><B>Tank Pressure</B>: [holding.air_contents.return_pressure()] KPa<BR>
<A href='byond://?src=\ref[src];remove_tank=1'>Remove Tank</A><BR>
"}
	var/output_text = {"<TT><B>[name]</B><BR>
Pressure: [air_contents.return_pressure()] KPa<BR>
Port Status: [(connected_port)?("Connected"):("Disconnected")]
[holding_text]
<BR>
Power Switch: <A href='byond://?src=\ref[src];power=1'>[on?("On"):("Off")]</A><BR>
Pump Direction: <A href='byond://?src=\ref[src];direction=1'>[direction_out?("Out"):("In")]</A><BR>
Target Pressure: <A href='byond://?src=\ref[src];pressure_adj=-1000'>-</A> <A href='byond://?src=\ref[src];pressure_adj=-100'>-</A> <A href='byond://?src=\ref[src];pressure_adj=-10'>-</A> <A href='byond://?src=\ref[src];pressure_adj=-1'>-</A> [target_pressure] <A href='byond://?src=\ref[src];pressure_adj=1'>+</A> <A href='byond://?src=\ref[src];pressure_adj=10'>+</A> <A href='byond://?src=\ref[src];pressure_adj=100'>+</A> <A href='byond://?src=\ref[src];pressure_adj=1000'>+</A><BR>
<HR>
<A href='byond://?src=\ref[user];mach_close=pump'>Close</A><BR>
"}

	user << browse(output_text, "window=pump;size=600x300")
	onclose(user, "pump")

/obj/machinery/portable_atmospherics/pump/Topic(href, href_list)
	..()
	if(usr.stat || usr.restrained())
		return

	if((in_range(src, usr)) && isturf(loc))
		usr.set_machine(src)

		if(href_list["power"])
			on = !on

		if(href_list["direction"])
			direction_out = !direction_out

		if(href_list["remove_tank"])
			if(isnotnull(holding))
				holding.forceMove(loc)
				holding = null

		if(href_list["pressure_adj"])
			var/diff = text2num(href_list["pressure_adj"])
			target_pressure = min(10 * ONE_ATMOSPHERE, max(0, target_pressure + diff))

		updateUsrDialog()
		add_fingerprint(usr)
		update_icon()
	else
		usr << browse(null, "window=pump")