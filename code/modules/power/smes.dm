// the SMES
// stores power

#define SMESMAXCHARGELEVEL 200000
#define SMESMAXOUTPUT 200000

/obj/machinery/power/smes
	name = "power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit."
	icon_state = "smes"
	density = TRUE
	anchored = TRUE

	var/output = 50000

	var/capacity = 5e6 // maximum charge
	var/charge = 1e6 // actual charge

	var/input_attempt = 0 			// 1 = attempting to charge, 0 = not attempting to charge
	var/inputting = 0 				// 1 = actually inputting, 0 = not inputting
	var/input_level = 50000 		// amount of power the SMES attempts to charge by
	var/input_level_max = SMESMAXCHARGELEVEL 	// cap on input_level
	var/input_available = 0 		// amount of charge available from input last tick

	var/output_attempt = 0 			// 1 = attempting to output, 0 = not attempting to output
	var/outputting = 0 				// 1 = actually outputting, 0 = not outputting
	var/output_level = 50000		// amount of power the SMES attempts to output
	var/output_level_max = SMESMAXOUTPUT	// cap on output_level
	var/output_used = 0				// amount of power actually outputted. may be less than output_level if the powernet returns excess power

	/*var/output = 50000		//Amount of power it tries to output
	var/lastout = 0			//Amount of power it actually outputs to the powernet
	var/loaddemand = 0		//For use in restore()
	var/capacity = 5e6		//Maximum amount of power it can hold
	var/charge = 1.0e6		//Current amount of power it holds
	var/charging = 0		//1 if it's actually charging, 0 if not
	var/chargemode = 0		//1 if it's trying to charge, 0 if not.
	var/chargelevel = 0		//Amount of power it tries to charge from powernet
	var/online = 1			//1 if it's outputting power, 0 if not.
	*/

	//Holders for powerout event.
	var/last_output_attempt	= 0
	var/last_input_attempt	= 0
	var/last_charge			= 0

	//For icon overlay updates
	var/last_disp
	var/last_chrg
	var/last_onln

	var/target_load = 0

	var/name_tag = null
	var/open_hatch = 0
	var/building_terminal = 0 //Suggestions about how to avoid clickspam building several terminals accepted!
	var/obj/machinery/power/terminal/terminal = null

/obj/machinery/power/smes/initialise()
	. = ..()
	if(!powernet)
		connect_to_network()

	dir_loop:
		for(var/d in GLOBL.cardinal)
			var/turf/T = get_step(src, d)
			for(var/obj/machinery/power/terminal/term in T)
				if(term && term.dir == turn(d, 180))
					terminal = term
					break dir_loop
	if(!terminal)
		stat |= BROKEN
		return
	terminal.master = src
	if(!terminal.powernet)
		terminal.connect_to_network()
	update_icon()

/obj/machinery/power/smes/Destroy()
	if(terminal)
		disconnect_terminal()
	return ..()

/obj/machinery/power/smes/update_icon()
	overlays.Cut()
	if(stat & BROKEN)	return

	overlays += image('icons/obj/power.dmi', "smes-op[outputting]")

	if(inputting)
		overlays += image('icons/obj/power.dmi', "smes-oc1")
	else
		if(input_attempt)
			overlays += image('icons/obj/power.dmi', "smes-oc0")

	var/clevel = chargedisplay()
	if(clevel>0)
		overlays += image('icons/obj/power.dmi', "smes-og[clevel]")
	return

/obj/machinery/power/smes/proc/chargedisplay()
	return round(5.5 * charge / (capacity ? capacity : 5e6))

/obj/machinery/power/smes/proc/input_power(percentage)
	var/inputted_power = target_load * (percentage / 100)
	inputted_power = between(0, inputted_power, target_load)
	if(terminal && terminal.powernet)
		inputted_power = terminal.powernet.draw_power(inputted_power)
		charge += inputted_power * SMESRATE
		if(inputted_power == input_level)
			inputting = 2
		else if(inputted_power)
			inputting = 1
		// else inputting = 0, as set in process()

/obj/machinery/power/smes/process()
	if(stat & BROKEN)	return

	// only update icon if state changed
	if(last_disp != chargedisplay() || last_chrg != inputting || last_onln != outputting)
		update_icon()

	//store machine state to see if we need to update the icon overlays
	last_disp = chargedisplay()
	last_chrg = inputting
	last_onln = outputting

	//inputting
	if(terminal && input_attempt)
		var/target_load = min((capacity - charge) / SMESRATE, input_level)	// charge at set rate, limited to spare capacity
		var/actual_load = draw_power(target_load)						// add the load to the terminal side network
		charge += actual_load * SMESRATE								// increase the charge

		if(actual_load >= target_load) // Did we charge at full rate?
			inputting = 2
		else if(actual_load) // If not, did we charge at least partially?
			inputting = 1
		else // Or not at all?
			inputting = 0

	///outputting
	if(outputting)
		output_used = min(charge / SMESRATE, output_level)		//limit output to that stored

		charge -= output_used * SMESRATE		// reduce the storage (may be recovered in /restore() if excessive)

		add_avail(output_used)				// add output to powernet (smes side)

		if(output_used < 0.0001)			// either from no charge or set to 0
			outputting = 0
			investigate_log("lost power and turned <font color='red'>off</font>","singulo")

	else if(output_attempt && charge > output_level && output_level > 0)
		outputting = 1
	else
		output_used = 0

// called after all power processes are finished
// restores charge level to smes if there was excess this ptick
/obj/machinery/power/smes/proc/restore()
	if(stat & BROKEN)
		return

	if(!outputting)
		output_used = 0
		return

	var/excess = powernet.netexcess		// this was how much wasn't used on the network last ptick, minus any removed by other SMESes

	excess = min(output_used, excess)				// clamp it to how much was actually output by this SMES last ptick

	excess = min((capacity - charge) / SMESRATE, excess)	// for safety, also limit recharge by space capacity of SMES (shouldn't happen)

	// now recharge this amount

	var/clev = chargedisplay()

	charge += excess * SMESRATE			// restore unused power
	powernet.netexcess -= excess		// remove the excess from the powernet, so later SMESes don't try to use it

	output_used -= excess

	if(clev != chargedisplay()) //if needed updates the icons overlay
		update_icon()

	return

//Will return 1 on failure
/obj/machinery/power/smes/proc/make_terminal(const/mob/user)
	if(user.loc == loc)
		to_chat(user, SPAN_WARNING("You must not be on the same tile as the [src]."))
		return 1

	//Direction the terminal will face to
	var/tempDir = get_dir(user, src)
	switch(tempDir)
		if(NORTHEAST, SOUTHEAST)
			tempDir = EAST
		if(NORTHWEST, SOUTHWEST)
			tempDir = WEST
	var/turf/tempLoc = get_step(src, reverse_direction(tempDir))
	if(isspace(tempLoc))
		to_chat(user, SPAN_WARNING("You can't build a terminal on space."))
		return 1
	else if(istype(tempLoc))
		if(tempLoc.intact)
			to_chat(user, SPAN_WARNING("You must remove the floor plating first."))
			return 1
	to_chat(user, SPAN_NOTICE("You start adding cable to the SMES."))
	if(do_after(user, 50))
		terminal = new /obj/machinery/power/terminal(tempLoc)
		terminal.set_dir(tempDir)
		terminal.master = src
		return 0
	return 1

/obj/machinery/power/smes/draw_power(amount)
	if(terminal && terminal.powernet)
		return terminal.powernet.draw_power(amount)
	return 0

/obj/machinery/power/smes/attack_ai(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/power/smes/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/power/smes/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		open_hatch = !open_hatch
		playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
		FEEDBACK_TOGGLE_MAINTENANCE_PANEL(user, open_hatch)
		return TRUE

	return ..()

/obj/machinery/power/smes/attackby(obj/item/W, mob/user)
	if(open_hatch)
		if(iscable(W) && !terminal && !building_terminal)
			building_terminal = 1
			var/obj/item/stack/cable_coil/CC = W
			if(CC.amount < 10)
				to_chat(user, SPAN_WARNING("You need more cables."))
				building_terminal = 0
				return
			if(make_terminal(user))
				building_terminal = 0
				return
			building_terminal = 0
			CC.use(10)
			user.visible_message(
				SPAN_NOTICE("[user] adds cables to \the [src]."),
				SPAN_NOTICE("You add cables to \the [src].")
			)
			terminal.connect_to_network()
			stat = 0

		else if(iswirecutter(W) && terminal && !building_terminal)
			building_terminal = 1
			var/turf/tempTDir = terminal.loc
			if(istype(tempTDir))
				if(tempTDir.intact)
					to_chat(user, SPAN_WARNING("You must remove the floor plating first."))
				else
					user.visible_message(
						SPAN_NOTICE("[user] begins to cut the cables out of the power terminal..."),
						SPAN_NOTICE("You begin to cut the cables out of the power terminal...")
					)
					playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
					if(do_after(user, 50))
						if(prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
							make_sparks(5, TRUE, src)
							building_terminal = 0
							return
						new /obj/item/stack/cable_coil(loc, 10)
						user.visible_message(
							SPAN_NOTICE("[user] cuts the cables and dismantles the power terminal."),
							SPAN_NOTICE("You cut the cables and dismantle the power terminal.")
						)
						qdel(terminal)
			building_terminal = 0

/obj/machinery/power/smes/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if(stat & BROKEN)
		return

	// this is the data which will be sent to the ui
	var/list/data = list()
	data["nameTag"] = name_tag
	data["storedCapacity"] = round(100.0 * charge / capacity, 0.1)
	data["charging"] = inputting
	data["chargeMode"] = input_attempt
	data["chargeLevel"] = input_level
	data["chargeMax"] = input_level_max
	data["outputOnline"] = output_attempt
	data["outputLevel"] = output_level
	data["outputMax"] = output_level_max
	data["outputLoad"] = round(output_used)
	data["outputting"] = outputting

	// update the ui if it exists, returns null if no ui is passed/found
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "smes.tmpl", "SMES Power Storage Unit", 540, 380)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update()

/obj/machinery/power/smes/Topic(href, href_list)
	..()

	if(usr.stat || usr.restrained())
		return

	if(!ishuman(usr) && !IS_GAME_MODE(/datum/game_mode/monkey))
		if(!issilicon(usr))
			FEEDBACK_NOT_ENOUGH_DEXTERITY(usr)
			return

	if(!isturf(src.loc) && !issilicon(usr))
		return 0 // Do not update ui

	if(href_list["cmode"])
		input_attempt = !input_attempt
		update_icon()

	else if(href_list["online"])
		output_attempt = !output_attempt
		update_icon()

	else if(href_list["input"])
		switch(href_list["input"])
			if("min")
				input_level = 0
			if("max")
				input_level = input_level_max
			if("set")
				input_level = input(usr, "Enter new input level (0-[input_level_max])", "SMES Input Power Control", input_level) as num
		input_level = max(0, min(input_level_max, input_level))	// clamp to range

	else if(href_list["output"])
		switch(href_list["output"])
			if("min")
				output_level = 0
			if("max")
				output_level = output_level_max
			if("set")
				output_level = input(usr, "Enter new output level (0-[output_level_max])", "SMES Output Power Control", output_level) as num
		output_level = max(0, min(output_level_max, output_level))	// clamp to range

	investigate_log("input/output; [input_level>output_level?"<font color='green'>":"<font color='red'>"][input_level]/[output_level]</font> | Output-mode: [output_attempt?"<font color='green'>on</font>":"<font color='red'>off</font>"] | Input-mode: [input_attempt?"<font color='green'>auto</font>":"<font color='red'>off</font>"] by [usr.key]","singulo")

	return 1

/obj/machinery/power/smes/proc/ion_act()
	if(isstationlevel(src.z))
		if(prob(1)) //explosion
			visible_message(
				SPAN_WARNING("The [name] starts to make strange noises!"),
				SPAN_WARNING("You hear sizzling electronics.")
			)
			sleep(10 * pick(4, 5, 6, 7, 10, 14))
			make_smoke(3, FALSE, loc, src)
			explosion(src.loc, -1, 0, 1, 3, 1, 0)
			qdel(src)
			return

		if(prob(15)) //Power drain
			make_sparks(3, TRUE, src)
			if(prob(50))
				emp_act(1)
			else
				emp_act(2)

		if(prob(5)) //smoke only
			make_smoke(3, FALSE, loc, src)

/obj/machinery/power/smes/emp_act(severity)
	inputting = rand(0, 1)
	outputting = rand(0, 1)
	output_level = rand(0, output_level_max)
	input_level = rand(0, input_level_max)
	charge -= 1e6/severity
	if(charge < 0)
		charge = 0

	update_icon()
	..()

/obj/machinery/power/smes/magical
	name = "magical power storage unit"
	desc = "A high-capacity superconducting magnetic energy storage (SMES) unit. Magically produces power."

/obj/machinery/power/smes/magical/process()
	capacity = INFINITY
	charge = INFINITY
	..()

#undef SMESMAXCHARGELEVEL
#undef SMESMAXOUTPUT