#define GAS_FILTER_NOTHING -1
#define GAS_FILTER_OXYGEN 0
#define GAS_FILTER_NITROGEN 1
#define GAS_FILTER_HYDROGEN 2
#define GAS_FILTER_CARBON_DIOXIDE 3
#define GAS_FILTER_CARBON_MOLECULES 4
#define GAS_FILTER_PLASMA 5
#define GAS_FILTER_OXYGEN_AGENT_B 6
#define GAS_FILTER_SLEEPING_AGENT 7

/obj/machinery/atmospherics/trinary/filter
	icon = 'icons/obj/atmospherics/filter.dmi'
	icon_state = "intact_off"
	density = 0 // Made filters and mixers not-dense so you can walk over them. -Frenjo

	name = "Gas filter"

	var/on = 0
	var/temp = null // -- TLE

	var/target_pressure = ONE_ATMOSPHERE

	var/filter_type = GAS_FILTER_CARBON_MOLECULES
/*
Filter types:
-1: Nothing
 0: Oxygen: Oxygen ONLY
 1: Nitrogen: Nitrogen ONLY
 2: Hydrogen: Hydrogen ONLY
 3: Carbon Dioxide: Carbon Dioxide ONLY
 4: Carbon Molecules: Plasma Toxin, Oxygen Agent B
 5: Plasma: Plasma ONLY
 6: Oxygen Agent B: Oxygen Agent B ONLY
 7: Sleeping Agent (N2O)
*/
	var/frequency = 0
	var/datum/radio_frequency/radio_connection

/obj/machinery/atmospherics/trinary/filter/proc/set_frequency(new_frequency)
	radio_controller.remove_object(src, frequency)
	frequency = new_frequency
	if(frequency)
		radio_connection = radio_controller.add_object(src, frequency, RADIO_ATMOSIA)

/obj/machinery/atmospherics/trinary/filter/update_icon()
	if(stat & NOPOWER)
		icon_state = "intact_off"
	else if(node2 && node3 && node1)
		icon_state = "intact_[on?("on"):("off")]"
	else
		icon_state = "intact_off"
		on = 0
	return

/obj/machinery/atmospherics/trinary/filter/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/atmospherics/trinary/filter/process()
	..()
	if(!on)
		return 0

	var/output_starting_pressure = air3.return_pressure()

	if(output_starting_pressure >= target_pressure || air2.return_pressure() >= target_pressure )
		//No need to mix if target is already full!
		return 1

	//Calculate necessary moles to transfer using PV=nRT
	var/pressure_delta = target_pressure - output_starting_pressure
	var/transfer_moles
	if(air1.temperature > 0)
		transfer_moles = pressure_delta * air3.volume / (air1.temperature * R_IDEAL_GAS_EQUATION)

	//Actually transfer the gas
	if(transfer_moles > 0)
		var/datum/gas_mixture/removed = air1.remove(transfer_moles)

		if(!removed)
			return
		var/datum/gas_mixture/filtered_out = new
		filtered_out.temperature = removed.temperature

		switch(filter_type)
			if(GAS_FILTER_OXYGEN) //removing O2
				filtered_out.gas[GAS_OXYGEN] = removed.gas[GAS_OXYGEN]
				removed.gas[GAS_OXYGEN] = 0

			if(GAS_FILTER_NITROGEN) //removing N2
				filtered_out.gas[GAS_NITROGEN] = removed.gas[GAS_NITROGEN]
				removed.gas[GAS_NITROGEN] = 0
			
			if(GAS_FILTER_HYDROGEN) //removing H2
				filtered_out.gas[GAS_HYDROGEN] = removed.gas[GAS_HYDROGEN]
				removed.gas[GAS_HYDROGEN] = 0

			if(GAS_FILTER_CARBON_DIOXIDE) //removing CO2
				filtered_out.gas[GAS_CARBON_DIOXIDE] = removed.gas[GAS_CARBON_DIOXIDE]
				removed.gas[GAS_CARBON_DIOXIDE] = 0
			
			if(GAS_FILTER_CARBON_MOLECULES) //removing hydrocarbons
				filtered_out.gas[GAS_PLASMA] = removed.gas[GAS_PLASMA]
				removed.gas[GAS_PLASMA] = 0

				filtered_out.gas[GAS_OXYGEN_AGENT_B] = removed.gas[GAS_OXYGEN_AGENT_B]
				removed.gas[GAS_OXYGEN_AGENT_B] = 0
			
			if(GAS_FILTER_PLASMA) //removing plasma
				filtered_out.gas[GAS_PLASMA] = removed.gas[GAS_PLASMA]
				removed.gas[GAS_PLASMA] = 0
			
			if(GAS_FILTER_OXYGEN_AGENT_B) //removing oxygen agent b
				filtered_out.gas[GAS_OXYGEN_AGENT_B] = removed.gas[GAS_OXYGEN_AGENT_B]
				removed.gas[GAS_OXYGEN_AGENT_B] = 0

			if(GAS_FILTER_SLEEPING_AGENT) //removing N2O
				filtered_out.gas[GAS_SLEEPING_AGENT] = removed.gas[GAS_SLEEPING_AGENT]
				removed.gas[GAS_SLEEPING_AGENT] = 0

			else
				filtered_out = null

		air2.merge(filtered_out)
		air3.merge(removed)

	if(network2)
		network2.update = TRUE

	if(network3)
		network3.update = TRUE

	if(network1)
		network1.update = TRUE

	return 1

/obj/machinery/atmospherics/trinary/filter/initialize()
	..()
	set_frequency(frequency)

/obj/machinery/atmospherics/trinary/filter/attackby(obj/item/weapon/W as obj, mob/user as mob)
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
		user.visible_message(
			"[user] unfastens \the [src].",
			SPAN_INFO("You have unfastened \the [src]."),
			"You hear a ratchet."
		)
		new /obj/item/pipe(loc, make_from = src)
		qdel(src)

/obj/machinery/atmospherics/trinary/filter/attack_hand(user as mob) // -- TLE
	if(..())
		return

	if(!src.allowed(user))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	// Edited this to reflect NanoUI port. -Frenjo
	usr.set_machine(src)
	ui_interact(user)
	return

obj/machinery/atmospherics/trinary/filter/Topic(href, href_list) // -- TLE
	if(..())
		return
	usr.set_machine(src)
	src.add_fingerprint(usr)

	// Edited this to reflect NanoUI port. -Frenjo
	switch(href_list["power"])
		if("off")
			on = 0
		if("on")
			on = 1

	if(href_list["filterset"])
		src.filter_type = text2num(href_list["filterset"])

	switch(href_list["pressure"])
		if("set_press")
			var/new_pressure = input(usr, "Enter new output pressure (0-4500kPa)", "Pressure control", src.target_pressure) as num
			src.target_pressure = max(0, min(4500, new_pressure))

	src.update_icon()
	src.updateUsrDialog()
/*
	for(var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			src.attack_hand(M)
*/
	return

// Porting this to NanoUI, it looks way better honestly. -Frenjo
/obj/machinery/atmospherics/trinary/filter/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(stat & BROKEN)
		return

	var/current_filter_type
	switch(filter_type)
		if(GAS_FILTER_CARBON_MOLECULES)
			current_filter_type = "Carbon Molecules"
		if(GAS_FILTER_OXYGEN)
			current_filter_type = "Oxygen"
		if(GAS_FILTER_NITROGEN)
			current_filter_type = "Nitrogen"
		if(GAS_FILTER_CARBON_DIOXIDE)
			current_filter_type = "Carbon Dioxide"
		if(GAS_FILTER_PLASMA)
			current_filter_type = "Plasma"
		if(GAS_FILTER_OXYGEN_AGENT_B)
			current_filter_type = "Oxygen Agent-B"
		if(GAS_FILTER_SLEEPING_AGENT)
			current_filter_type = "Nitrous Oxide"
		if(GAS_FILTER_HYDROGEN)
			current_filter_type = "Hydrogen"
		if(GAS_FILTER_NOTHING)
			current_filter_type = "Nothing"
		else
			current_filter_type = "ERROR - Report this bug to the admin, please!"

	var/data[0]
	data["on"] = on
	data["current_filter"] = current_filter_type
	data["target_pressure"] = round(target_pressure, 0.01) // Need to fix this later so it doesn't output 101.3xxxxxxxx. -Frenjo

	// Ported most of this by studying SMES code. -Frenjo
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data)
	if(!ui)
		ui = new(user, src, ui_key, "gas_filter.tmpl", "Gas Filter", 520, 380)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

#undef GAS_FILTER_NOTHING
#undef GAS_FILTER_OXYGEN
#undef GAS_FILTER_NITROGEN
#undef GAS_FILTER_HYDROGEN
#undef GAS_FILTER_CARBON_DIOXIDE
#undef GAS_FILTER_CARBON_MOLECULES
#undef GAS_FILTER_PLASMA
#undef GAS_FILTER_OXYGEN_AGENT_B
#undef GAS_FILTER_SLEEPING_AGENT