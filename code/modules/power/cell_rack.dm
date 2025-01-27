
// The one that works safely.
/obj/machinery/power/smes/cell_rack
	name = "CRES"
	desc = "A cell rack energy storage (CRES) unit. It's basically a rack of power cells configured as stationary power storage."
	icon_state = "cellrack"

	charge = 0 // You dont really want to make a potato ESU which is already overloaded.
	output_attempt = 0
	input_level = 0
	output_level = 0
	input_level_max = 0
	output_level_max = 0

	var/cells_amount = 0
	var/capacitors_amount = 0

/obj/machinery/power/smes/cell_rack/add_parts()
	component_parts = list(
		new /obj/item/circuitboard/cell_rack(src),
		new /obj/item/cell/high(src),
		new /obj/item/cell/high(src),
		new /obj/item/cell/high(src)
	)
	return TRUE

/obj/machinery/power/smes/cell_rack/refresh_parts()
	capacitors_amount = 0
	cells_amount = 0
	var/max_level = 0 // For both input and output.
	for(var/obj/item/stock_part/capacitor/part in component_parts)
		max_level += part.rating
		capacitors_amount++
	input_level_max = 50000 + max_level * 20000
	output_level_max = 50000 + max_level * 20000

	var/C = 0
	for(var/obj/item/cell/part in component_parts)
		C += part.maxcharge
		cells_amount++
	capacity = C * 40 // Basic cells are such crap. Hyper cells are needed to get on normal SMES levels.

/obj/machinery/power/smes/cell_rack/update_icon()
	overlays.Cut()
	if(stat & BROKEN)
		return

	if(output_attempt)
		overlays.Add(image(icon, "[icon_state]_outputting"))
	if(input_attempt)
		overlays.Add(image(icon, "[icon_state]_charging"))

	var/clevel = chargedisplay()
	if(clevel > 0)
		overlays.Add(image(icon, "[icon_state]_og[clevel]"))

/obj/machinery/power/smes/cell_rack/chargedisplay()
	return round(4 * charge/(capacity ? capacity : 5e6))

/obj/machinery/power/smes/cell_rack/attackby(obj/item/I, mob/user) //these can only be moved by being reconstructed, solves having to remake the powernet.
	. = ..() // SMES attackby for now handles screwdriver, cable coils and wirecutters, no need to repeat that here
	if(open_hatch)
		if(iscrowbar(I))
			if(charge < (capacity / 100))
				if(!output_attempt && !input_attempt)
					playsound(GET_TURF(src), 'sound/items/Crowbar.ogg', 50, 1)
					var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(loc)
					M.state = 2
					M.icon_state = "box_1"
					for_no_type_check(var/obj/item/part, component_parts)
						if(part.reliability != 100 && crit_fail)
							part.crit_fail = 1
						part.forceMove(loc)
					qdel(src)
					return 1
				else
					to_chat(user, SPAN_WARNING("Turn off \the [src] before dismantling it."))
			else
				to_chat(user, SPAN_WARNING("Better let \the [src] discharge before dismantling it."))
		else if((istype(I, /obj/item/stock_part/capacitor) && capacitors_amount < 5) || (istype(I, /obj/item/cell) && cells_amount < 5))
			if(charge < (capacity / 100))
				if(!output_attempt && !input_attempt)
					user.drop_item()
					component_parts.Add(I)
					I.forceMove(src)
					refresh_parts()
					to_chat(user, SPAN_NOTICE("You upgrade \the [src] with \the [I]."))
				else
					to_chat(user, SPAN_WARNING("Turn off \the [src] before dismantling it."))
			else
				to_chat(user, SPAN_WARNING("Better let \the [src] discharge before putting your hand inside it."))
		else
			user.set_machine(src)
			interact(user)
			return 1
	return

// The shitty one that will blow up.
/obj/machinery/power/smes/cell_rack/makeshift
	name = "makeshift CRES"
	desc = "A rack of power cells connected by a mess of wires posing as a cell rack energy storage (CRES) unit."
	icon_state = "makeshift"

	var/overcharge_percent = 0

/obj/machinery/power/smes/cell_rack/makeshift/add_parts()
	component_parts = list(
		new /obj/item/circuitboard/makeshift_cell_rack(src),
		new /obj/item/cell/high(src),
		new /obj/item/cell/high(src),
		new /obj/item/cell/high(src)
	)
	return TRUE

/obj/machinery/power/smes/cell_rack/makeshift/update_icon()
	. = ..()
	if(overcharge_percent > 100)
		overlays.Add(image(icon, "[icon_state]_overcharge"))

//This mess of if-elses and magic numbers handles what happens if the engies don't pay attention and let it eat too much charge
//What happens depends on how much capacity has the ghetto smes and how much it is overcharged.
//Under 1.2M: 5% of ion_act() per process() tick from 125% and higher overcharges. 1.2M is achieved with 3 high cells.
//[1.2M-2.4M]: 6% ion_act from 120%. 1% of EMP from 140%.
//(2.4M-3.6M] :7% ion_act from 115%. 1% of EMP from 130%. 1% of non-hull-breaching explosion at 150%.
//(3.6M-INFI): 8% ion_act from 115%. 2% of EMP from 125%. 1% of Hull-breaching explosion from 140%.
/obj/machinery/power/smes/cell_rack/makeshift/proc/overcharge_consequences()
	switch(capacity)
		if(0 to (1.2e6-1))
			if(overcharge_percent >= 125)
				if(prob(5))
					ion_act()
		if(1.2e6 to 2.4e6)
			if(overcharge_percent >= 120)
				if(prob(6))
					ion_act()
			else
				return
			if(overcharge_percent >= 140)
				if(prob(1))
					empulse(loc, 3, 8, 1)
		if((2.4e6+1) to 3.6e6)
			if(overcharge_percent >= 115)
				if(prob(7))
					ion_act()
			else
				return
			if(overcharge_percent >= 130)
				if(prob(1))
					empulse(loc, 3, 8, 1)
			if(overcharge_percent >= 150)
				if(prob(1))
					explosion(loc, 0, 1, 3, 5)
		if((3.6e6+1) to INFINITY)
			if(overcharge_percent >= 115)
				if(prob(8))
					ion_act()
			else
				return
			if(overcharge_percent >= 125)
				if(prob(2))
					empulse(loc, 4, 10, 1)
			if(overcharge_percent >= 140)
				if(prob(1))
					explosion(loc, 1, 3, 5, 8)
		else //how the hell was this proc called for negative charge
			charge = 0

/obj/machinery/power/smes/cell_rack/makeshift/process()
	if(stat & BROKEN)
		return

	//store machine state to see if we need to update the icon overlays
	var/last_disp = chargedisplay()
	var/last_chrg = inputting
	var/last_onln = output_attempt
	var/last_overcharge = overcharge_percent

	if(isnotnull(terminal))
		var/excess = terminal.surplus()

		if(input_attempt)
			if(excess >= 0) // if there's power available, try to charge
				var/target_load = min((capacity * 1.5 - charge) / SMESRATE, input_level) // charge at set rate, limited to spare capacity
				var/actual_load = draw_power(target_load) // add the load to the terminal side network
				charge += actual_load * SMESRATE // increase the charge

				if(actual_load >= target_load) // did the powernet have enough power available for us?
					inputting = 1
				else
					inputting = 0

	if(output_attempt) // if outputting
		output_used = min(charge / SMESRATE, output_level) // limit output to that stored
		charge -= output_used * SMESRATE // reduce the storage (may be recovered in /restore() if excessive)
		add_avail(output_used) // add output to powernet (smes side)
		if(charge < 0.0001)
			outputting = 0 // stop output if charge falls to zero

	overcharge_percent = round((charge / capacity) * 100)
	if(overcharge_percent > 115) //115% is the minimum overcharge for anything to happen
		overcharge_consequences()

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != inputting || last_onln != output_attempt || ((overcharge_percent > 100) ^ (last_overcharge > 100)))
		update_icon()
	return