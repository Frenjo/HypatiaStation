/obj/machinery/atmospherics/unary/heat_reservoir/heater
	name = "gas heating system"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "freezer_0"

	density = TRUE
	anchored = TRUE

	current_heat_capacity = 1000

/obj/machinery/atmospherics/unary/heat_reservoir/heater/New()
	. = ..()
	initialize_directions = dir

/obj/machinery/atmospherics/unary/heat_reservoir/heater/atmos_initialise()
	. = ..()
	if(isnotnull(node))
		return

	var/node_connect = dir

	for(var/obj/machinery/atmospherics/target in get_step(src, node_connect))
		if(target.initialize_directions & get_dir(target, src))
			node = target
			break

	update_icon()

/obj/machinery/atmospherics/unary/heat_reservoir/heater/update_icon()
	if(isnotnull(node))
		if(on)
			icon_state = "heater_1"
		else
			icon_state = "heater"
	else
		icon_state = "heater_0"

/obj/machinery/atmospherics/unary/heat_reservoir/heater/attack_ai(mob/user as mob)
	ui_interact(user)

/obj/machinery/atmospherics/unary/heat_reservoir/heater/attack_paw(mob/user as mob)
	ui_interact(user)

/obj/machinery/atmospherics/unary/heat_reservoir/heater/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/atmospherics/unary/heat_reservoir/heater/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	// this is the data which will be sent to the ui
	var/list/data = list()
	data["on"] = on ? TRUE : FALSE
	data["gasPressure"] = round(air_contents.return_pressure())
	data["gasTemperature"] = round(air_contents.temperature)
	data["minGasTemperature"] = round(T20C)
	data["maxGasTemperature"] = round(T20C + 280)
	data["targetGasTemperature"] = round(current_temperature)

	var/temp_class = "normal"
	if(air_contents.temperature > (T20C + 40))
		temp_class = "bad"
	data["gasTemperatureClass"] = temp_class

	// update the ui if it exists, returns null if no ui is passed/found
	ui = global.PCnanoui.try_update_ui(user, src, ui_key, ui, data)
	if(isnull(ui))
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "freezer.tmpl", "Gas Heating System", 440, 300)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
		// auto update every Master Controller tick
		ui.set_auto_update()

/obj/machinery/atmospherics/unary/heat_reservoir/heater/Topic(href, href_list)
	if(href_list["toggleStatus"])
		on = !on
		update_icon()
	if(href_list["temp"])
		var/amount = text2num(href_list["temp"])
		if(amount > 0)
			current_temperature = min((T20C + 280), src.current_temperature + amount)
		else
			current_temperature = max(T20C, src.current_temperature + amount)

	add_fingerprint(usr)
	return 1

/obj/machinery/atmospherics/unary/heat_reservoir/heater/process()
	..()