//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/*
	Hello, friends, this is Doohl from sexylands. You may be wondering what this
	monstrous code file is. Sit down, boys and girls, while I tell you the tale.


	The machines defined in this file were designed to be compatible with any radio
	signals, provided they use subspace transmission. Currently they are only used for
	headsets, but they can eventually be outfitted for real COMPUTER networks. This
	is just a skeleton, ladies and gentlemen.

	Look at radio.dm for the prequel to this code.
*/
GLOBAL_GLOBL_LIST_TYPED_NEW(telecoms_list, /obj/machinery/telecoms)

/obj/machinery/telecoms
	var/list/obj/machinery/telecoms/links = list() // list of machines this machine is linked to
	var/traffic = 0 // value increases as traffic increases
	var/netspeed = 5 // how much traffic to lose per tick (50 gigabytes/second * netspeed)
	var/list/autolinkers = list() // list of text/number values to link with
	var/id = "NULL" // identification string
	var/network = "NULL" // the network of the machinery

	var/list/freq_listening = list() // list of frequencies to tune into: if none, will listen to all

	var/machinetype = 0 // just a hacky way of preventing alike machines from pairing
	var/toggled = TRUE 	// Is it toggled on
	var/on = TRUE
	var/integrity = 100 // basically HP, loses integrity by heat
	//var/heatgen = 20 // how much heat to transfer to the environment
	var/operating_temperature = 20 + T0C
	var/delay = 10 // how many process() ticks to delay per heat
	var/heating_power = 40000
	var/long_range_link = FALSE // Can you link it across Z levels or on the otherside of the map? (Relay & Hub)
	var/circuitboard = null // string pointing to a circuitboard type
	var/hide = FALSE			// Is it a hidden machine?
	var/listening_level = 0	// 0 = auto set in New() - this is the z level that the machine is listening to.

/obj/machinery/telecoms/New()
	GLOBL.telecoms_list.Add(src)
	. = ..()

	//Set the listening_level if there's none.
	if(!listening_level)
		//Defaults to our Z level!
		listening_level = GET_TURF_Z(src)

/obj/machinery/telecoms/initialise()
	. = ..()
	if(length(autolinkers))
		// Links nearby machines
		if(!long_range_link)
			for(var/obj/machinery/telecoms/T in orange(20, src))
				add_link(T)
		else
			for_no_type_check(var/obj/machinery/telecoms/T, GLOBL.telecoms_list)
				add_link(T)

/obj/machinery/telecoms/Destroy()
	GLOBL.telecoms_list.Remove(src)
	for_no_type_check(var/obj/machinery/telecoms/comm, GLOBL.telecoms_list)
		comm.links.Remove(src)
	links = list()
	return ..()

/obj/machinery/telecoms/update_icon()
	icon_state = on ? initial(icon_state) : "[initial(icon_state)]_off"

/obj/machinery/telecoms/process()
	update_power()

	// Check heat and generate some
	checkheat()

	// Update the icon
	update_icon()

	if(traffic > 0)
		traffic -= netspeed

/obj/machinery/telecoms/emp_act(severity)
	if(prob(100 / severity))
		if(!(stat & EMPED))
			stat |= EMPED
			var/duration = (300 * 10) / severity
			spawn(rand(duration - 20, duration + 20)) // Takes a long time for the machines to reboot.
				stat &= ~EMPED
	..()

/obj/machinery/telecoms/proc/relay_information(datum/signal/signal, filter, copysig, amount = 20)
	// relay signal to all linked machinery that are of type [filter]. If signal has been sent [amount] times, stop sending
	if(!on)
		return
	//to_world("[src] ([src.id]) - [signal.debug_print()]")
	var/send_count = 0

	signal.data["slow"] += rand(0, round((100 - integrity))) // apply some lag based on integrity

	// Apply some lag based on traffic rates
	var/netlag = round(traffic / 50)
	if(netlag > signal.data["slow"])
		signal.data["slow"] = netlag

// Loop through all linked machines and send the signal or copy.
	for_no_type_check(var/obj/machinery/telecoms/machine, links)
		if(filter && !istype(machine, filter))
			continue
		if(!machine.on)
			continue
		if(amount && send_count >= amount)
			break
		if(machine.loc.z != listening_level)
			if(!long_range_link && !machine.long_range_link)
				continue
		// If we're sending a copy, be sure to create the copy for EACH machine and paste the data
		var/datum/signal/copy = new /datum/signal()
		if(copysig)
			copy.transmission_method = TRANSMISSION_SUBSPACE
			copy.frequency = signal.frequency
			// Copy the main data contents! Workaround for some nasty bug where the actual array memory is copied and not its contents.
			copy.data = list(
				"mob" = signal.data["mob"],
				"mobtype" = signal.data["mobtype"],
				"realname" = signal.data["realname"],
				"name" = signal.data["name"],
				"job" = signal.data["job"],
				"key" = signal.data["key"],
				"vmessage" = signal.data["vmessage"],
				"vname" = signal.data["vname"],
				"vmask" = signal.data["vmask"],
				"compression" = signal.data["compression"],
				"message" = signal.data["message"],
				"connection" = signal.data["connection"],
				"radio" = signal.data["radio"],
				"slow" = signal.data["slow"],
				"traffic" = signal.data["traffic"],
				"type" = signal.data["type"],
				"server" = signal.data["server"],
				"reject" = signal.data["reject"],
				"level" = signal.data["level"],
				"verbage" = signal.data["verbage"],
				"language" = signal.data["language"]
			)

			// Keep the "original" signal constant
			if(!signal.data["original"])
				copy.data["original"] = signal
			else
				copy.data["original"] = signal.data["original"]

		else
			qdel(copy)

		send_count++
		if(machine.is_freq_listening(signal))
			machine.traffic++

		if(copysig && copy)
			machine.receive_information(copy, src)
		else
			machine.receive_information(signal, src)

	if(send_count > 0 && is_freq_listening(signal))
		traffic++

	return send_count

/obj/machinery/telecoms/proc/relay_direct_information(datum/signal/signal, obj/machinery/telecoms/machine)
	// send signal directly to a machine
	machine.receive_information(signal, src)

/obj/machinery/telecoms/proc/receive_information(datum/signal/signal, obj/machinery/telecoms/machine_from)
	// receive information from linked machinery
	return

// Returns TRUE if found, FALSE if not found.
/obj/machinery/telecoms/proc/is_freq_listening(datum/signal/signal)
	if(!signal)
		return FALSE
	if((signal.frequency in freq_listening) || !length(freq_listening))
		return TRUE
	else
		return FALSE

// Used in auto linking
/obj/machinery/telecoms/proc/add_link(obj/machinery/telecoms/T)
	if(GET_TURF_Z(src) == GET_TURF_Z(T) || (long_range_link && T.long_range_link))
		for(var/x in autolinkers)
			if(T.autolinkers.Find(x))
				if(src != T)
					links |= T

/obj/machinery/telecoms/proc/update_power()
	if(toggled)
		if(stat & (BROKEN|NOPOWER|EMPED) || integrity <= 0) // if powered, on. if not powered, off. if too damaged, off
			on = FALSE
		else
			on = TRUE
	else
		on = FALSE

/obj/machinery/telecoms/proc/checkheat()
	// Checks heat from the environment and applies any integrity damage
	var/datum/gas_mixture/environment = loc.return_air()
	var/damage_chance = 0							// Percent based chance of applying 1 integrity damage this tick
	switch(environment.temperature)
		if((T0C + 40) to (T0C + 70))				// 40C-70C, minor overheat, 10% chance of taking damage
			damage_chance = 10
		if((T0C + 70) to (T0C + 130))				// 70C-130C, major overheat, 25% chance of taking damage
			damage_chance = 25
		if((T0C + 130) to (T0C + 200))				// 130C-200C, dangerous overheat, 50% chance of taking damage
			damage_chance = 50
		if((T0C + 200) to INFINITY)					// More than 200C, INFERNO. Takes damage every tick.
			damage_chance = 100
	if(damage_chance && prob(damage_chance))
		integrity = clamp(integrity - 1, 0, 100)

	if(delay)
		delay--
	else
		// If the machine is on, ready to produce heat, and has positive traffic, genn some heat
		if(on && traffic > 0)
			//produce_heat(heatgen)
			produce_heat(operating_temperature)
			delay = initial(delay)

/obj/machinery/telecoms/proc/produce_heat(/*heat_amt*/new_temperature)
	//if(heatgen == 0)
	//	return
	if(isnull(new_temperature))
		return

	if(!(stat & (NOPOWER|BROKEN))) //Blatently stolen from space heater.
		var/turf/open/L = loc
		if(istype(L))
			var/datum/gas_mixture/env = L.return_air()
			//if(env.temperature < (heat_amt+T0C))
			if(env.temperature < new_temperature)
				var/transfer_moles = 0.25 * env.total_moles
				var/datum/gas_mixture/removed = env.remove(transfer_moles)
				if(removed)
					/*
					var/heat_capacity = removed.heat_capacity()
					if(heat_capacity == 0 || heat_capacity == null)
						heat_capacity = 1
					removed.temperature = min((removed.temperature*heat_capacity + heating_power)/heat_capacity, 1000)
					*/
					var/heat_produced = min(removed.get_thermal_energy_change(new_temperature), power_usage[USE_POWER_IDLE])	//obviously can't produce more heat than the machine draws from it's power source
					removed.add_thermal_energy(heat_produced)

				env.merge(removed)