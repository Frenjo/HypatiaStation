
/obj/machinery/power/generator
	name = "thermoelectric generator"
	desc = "It's a high efficiency thermoelectric generator."
	icon_state = "teg"
	density = TRUE
	anchored = FALSE

	power_state = USE_POWER_IDLE
	power_usage = alist(
		USE_POWER_IDLE = 100 //Watts, I hope.  Just enough to do the computer and display things.
	)

	var/obj/machinery/atmospherics/binary/circulator/circ1
	var/obj/machinery/atmospherics/binary/circulator/circ2

	var/lastgen = 0
	var/lastgenlev = -1

/obj/machinery/power/generator/initialise()
	. = ..()
	reconnect()

/obj/machinery/power/generator/Destroy()
	circ1 = null
	circ2 = null
	return ..()

//generators connect in dir and reverse_dir(dir) directions
//mnemonic to determine circulator/generator directions: the cirulators orbit clockwise around the generator
//so a circulator to the NORTH of the generator connects first to the EAST, then to the WEST
//and a circulator to the WEST of the generator connects first to the NORTH, then to the SOUTH
//note that the circulator's outlet dir is it's always facing dir, and it's inlet is always the reverse
/obj/machinery/power/generator/proc/reconnect()
	circ1 = null
	circ2 = null
	if(src.loc && anchored)
		if(src.dir & (EAST|WEST))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src, EAST)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src, WEST)

			if(circ1 && circ2)
				if(circ1.dir != SOUTH || circ2.dir != NORTH)
					circ1 = null
					circ2 = null

		else if(src.dir & (NORTH|SOUTH))
			circ1 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src, NORTH)
			circ2 = locate(/obj/machinery/atmospherics/binary/circulator) in get_step(src, SOUTH)

			if(circ1 && circ2 && (circ1.dir != EAST || circ2.dir != WEST))
				circ1 = null
				circ2 = null

/obj/machinery/power/generator/proc/updateicon()
	if(stat & (NOPOWER|BROKEN))
		cut_overlays()
	else
		cut_overlays()

		if(lastgenlev != 0)
			add_overlay("teg-op[lastgenlev]")
			// Add a flashy thing because why not. -Frenjo
			if(lastgen > 250000)
				add_overlay("teg-max-flash")

/obj/machinery/power/generator/process()
	if(!circ1 || !circ2 || !anchored || stat & (BROKEN|NOPOWER))
		return

	updateDialog()

	var/datum/gas_mixture/air1 = circ1.return_transfer_air()
	var/datum/gas_mixture/air2 = circ2.return_transfer_air()
	lastgen = 0

	if(air1 && air2)
		var/air1_heat_capacity = air1.heat_capacity()
		var/air2_heat_capacity = air2.heat_capacity()
		var/delta_temperature = abs(air2.temperature - air1.temperature)

		if(delta_temperature > 0 && air1_heat_capacity > 0 && air2_heat_capacity > 0)
			var/efficiency = 0.65
			var/energy_transfer = delta_temperature * air2_heat_capacity * air1_heat_capacity / (air2_heat_capacity + air1_heat_capacity)
			var/heat = energy_transfer * (1 - efficiency)
			lastgen = energy_transfer * efficiency * 0.05

			if(air2.temperature > air1.temperature)
				air2.temperature = air2.temperature - energy_transfer/air2_heat_capacity
				air1.temperature = air1.temperature + heat/air1_heat_capacity
			else
				air2.temperature = air2.temperature + heat/air2_heat_capacity
				air1.temperature = air1.temperature - energy_transfer/air1_heat_capacity

	//Transfer the air
	if(air1)
		circ1.air2.merge(air1)
	if(air2)
		circ2.air2.merge(air2)

	//Update the gas networks
	if(circ1.network2)
		circ1.network2.update = 1
	if(circ2.network2)
		circ2.network2.update = 1

	// update icon overlays and power usage only if displayed level has changed
	if(lastgen > 250000 && prob(10))
		make_sparks(3, TRUE, src)
		lastgen *= 0.5
	var/genlev = max(0, min(round(11 * lastgen / 250000), 11))
	if(lastgen > 100 && genlev == 0)
		genlev = 1
	if(genlev != lastgenlev)
		lastgenlev = genlev
		updateicon()
	add_avail(lastgen)

/obj/machinery/power/generator/attack_ai(mob/user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/power/generator/attack_tool(obj/item/tool, mob/user)
	if(iswrench(tool))
		anchored = !anchored
		user.visible_message(
			SPAN_NOTICE("[user] [anchored ? "attaches" : "detaches"] the bolts holding \the [src] [anchored ? "to" : "from"] the ground."),
			SPAN_NOTICE("You [anchored ? "attach" : "detach"] the bolts holding \the [src] [anchored ? "to" : "from"] the ground."),
			SPAN_INFO("You hear a ratchet.")
		)

		update_power_state(anchored)
		if(anchored) // Powernet connection stuff.
			connect_to_network()
		else
			disconnect_from_network()
		reconnect()
		return TRUE

	return ..()

/obj/machinery/power/generator/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER) || !anchored)
		return
	interact(user)

/obj/machinery/power/generator/interact(mob/user)
	if(!in_range(src, user) && !issilicon(user))
		user.unset_machine()
		user << browse(null, "window=teg")
		return

	user.set_machine(src)

	var/t = "<PRE><B>Thermo-Electric Generator</B><HR>"

	if(circ1 && circ2)
		t += "Output : [round(lastgen)] W<BR><BR>"

		t += "<B>Primary Circulator (top or right)</B><BR>"
		t += "Inlet Pressure: [round(circ1.air1.return_pressure(), 0.1)] kPa<BR>"
		t += "Inlet Temperature: [round(circ1.air1.temperature, 0.1)] K<BR>"
		t += "Outlet Pressure: [round(circ1.air2.return_pressure(), 0.1)] kPa<BR>"
		t += "Outlet Temperature: [round(circ1.air2.temperature, 0.1)] K<BR>"

		t += "<B>Secondary Circulator (bottom or left)</B><BR>"
		t += "Inlet Pressure: [round(circ2.air1.return_pressure(), 0.1)] kPa<BR>"
		t += "Inlet Temperature: [round(circ2.air1.temperature, 0.1)] K<BR>"
		t += "Outlet Pressure: [round(circ2.air2.return_pressure(), 0.1)] kPa<BR>"
		t += "Outlet Temperature: [round(circ2.air2.temperature, 0.1)] K<BR>"

	else
		t += "Unable to connect to circulators.<br>"
		t += "Ensure both are in position and wrenched into place."

	t += "<BR>"
	t += "<HR>"
	t += "<A href='byond://?src=\ref[src]'>Refresh</A> <A href='byond://?src=\ref[src];close=1'>Close</A>"

	user << browse(t, "window=teg;size=460x300")
	onclose(user, "teg")
	return 1

/obj/machinery/power/generator/Topic(href, href_list)
	..()
	if(href_list["close"])
		usr << browse(null, "window=teg")
		usr.unset_machine()
		return 0

	updateDialog()
	return 1

/obj/machinery/power/generator/power_change()
	..()
	updateicon()

/obj/machinery/power/generator/verb/rotate_clock()
	set category = PANEL_OBJECT
	set name = "Rotate Generator (Clockwise)"
	set src in view(1)

	if(usr.stat || usr.restrained() || anchored)
		return

	src.set_dir(turn(src.dir, 90))

/obj/machinery/power/generator/verb/rotate_anticlock()
	set category = PANEL_OBJECT
	set name = "Rotate Generator (Counterclockwise)"
	set src in view(1)

	if(usr.stat || usr.restrained() || anchored)
		return

	src.set_dir(turn(src.dir, -90))