#define AIR_SENSOR_PRESSURE 1
#define AIR_SENSOR_TEMPERATURE 2
#define AIR_SENSOR_OXYGEN 4
#define AIR_SENSOR_NITROGEN 8
#define AIR_SENSOR_HYDROGEN 16
#define AIR_SENSOR_CARBON_DIOXIDE 32
#define AIR_SENSOR_PLASMA 64
#define AIR_SENSOR_OXYGEN_AGENT_B 128
#define AIR_SENSOR_SLEEPING_AGENT 256

/obj/machinery/air_sensor
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "gsensor1"
	name = "Gas Sensor"

	anchored = TRUE
	var/state = 0

	var/id_tag
	var/frequency = 1439

	var/on = 1
	var/output = (
		AIR_SENSOR_PRESSURE | AIR_SENSOR_TEMPERATURE | AIR_SENSOR_OXYGEN | AIR_SENSOR_NITROGEN | AIR_SENSOR_HYDROGEN \
		| AIR_SENSOR_CARBON_DIOXIDE | AIR_SENSOR_PLASMA | AIR_SENSOR_OXYGEN_AGENT_B | AIR_SENSOR_SLEEPING_AGENT \
	)
	//Flags:
	// 1 for pressure
	// 2 for temperature
	// Output >= 4 includes gas composition
	// 4 for oxygen concentration
	// 8 for nitrogen concentration
	// 16 for hydrogen concentration
	// 32 for carbon dioxide concentration
	// 64 for plasma concentration
	// 128 for oxygen agent b concentration
	// 256 for nitrous oxide concentration

	var/datum/radio_frequency/radio_connection

/obj/machinery/air_sensor/update_icon()
		icon_state = "gsensor[on]"

/obj/machinery/air_sensor/process()
	if(on)
		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO
		signal.data["tag"] = id_tag
		signal.data["timestamp"] = world.time

		var/datum/gas_mixture/air_sample = return_air()

		if(output & AIR_SENSOR_PRESSURE)
			signal.data["pressure"] = num2text(round(air_sample.return_pressure(), 0.1))
		if(output & AIR_SENSOR_TEMPERATURE)
			signal.data["temperature"] = round(air_sample.temperature, 0.1)

		if(output > 4)
			var/total_moles = air_sample.total_moles
			if(total_moles > 0)
				if(output & AIR_SENSOR_OXYGEN)
					signal.data[GAS_OXYGEN] = round(100 * air_sample.gas[GAS_OXYGEN] / total_moles, 0.1)
				if(output & AIR_SENSOR_NITROGEN)
					signal.data[GAS_NITROGEN] = round(100 * air_sample.gas[GAS_NITROGEN] / total_moles, 0.1)
				if(output & AIR_SENSOR_HYDROGEN)
					signal.data[GAS_HYDROGEN] = round(100 * air_sample.gas[GAS_HYDROGEN] / total_moles, 0.1)
				if(output & AIR_SENSOR_CARBON_DIOXIDE)
					signal.data[GAS_CARBON_DIOXIDE] = round(100 * air_sample.gas[GAS_CARBON_DIOXIDE] / total_moles, 0.1)
				if(output & AIR_SENSOR_PLASMA)
					signal.data[GAS_PLASMA] = round(100 * air_sample.gas[GAS_PLASMA] / total_moles, 0.1)
				if(output & AIR_SENSOR_OXYGEN_AGENT_B)
					signal.data[GAS_OXYGEN_AGENT_B] = round(100 * air_sample.gas[GAS_OXYGEN_AGENT_B] / total_moles, 0.1)
				if(output & AIR_SENSOR_SLEEPING_AGENT)
					signal.data[GAS_SLEEPING_AGENT] = round(100 * air_sample.gas[GAS_SLEEPING_AGENT] / total_moles, 0.1)
			else
				signal.data[GAS_OXYGEN] = 0
				signal.data[GAS_NITROGEN] = 0
				signal.data[GAS_HYDROGEN] = 0
				signal.data[GAS_CARBON_DIOXIDE] = 0
				signal.data[GAS_PLASMA] = 0
				signal.data[GAS_OXYGEN_AGENT_B] = 0
				signal.data[GAS_SLEEPING_AGENT] = 0
		signal.data["sigtype"] = "status"
		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

/obj/machinery/air_sensor/initialize()
	..()
	radio_connection = register_radio(src, null, frequency, RADIO_ATMOSIA)

/obj/machinery/air_sensor/Destroy()
	unregister_radio(src, frequency)
	return ..()

#undef AIR_SENSOR_PRESSURE
#undef AIR_SENSOR_TEMPERATURE
#undef AIR_SENSOR_OXYGEN
#undef AIR_SENSOR_NITROGEN
#undef AIR_SENSOR_HYDROGEN
#undef AIR_SENSOR_CARBON_DIOXIDE
#undef AIR_SENSOR_PLASMA
#undef AIR_SENSOR_OXYGEN_AGENT_B
#undef AIR_SENSOR_SLEEPING_AGENT

/obj/machinery/computer/general_air_control
	icon = 'icons/obj/computer.dmi'
	icon_state = "tank"

	name = "Computer"

	var/frequency = 1439
	var/list/sensors = list()

	var/list/sensor_information = list()
	var/datum/radio_frequency/radio_connection

/obj/machinery/computer/general_air_control/initialize()
	..()
	radio_connection = register_radio(src, null, frequency, RADIO_ATMOSIA)

/obj/machinery/computer/general_air_control/Destroy()
	unregister_radio(src, frequency)
	return ..()

/obj/machinery/computer/general_air_control/attack_hand(mob/user)
	if(..(user))
		return
	user << browse(return_text(), "window=computer")
	user.set_machine(src)
	onclose(user, "computer")

/obj/machinery/computer/general_air_control/process()
	..()
	src.updateUsrDialog()

/obj/machinery/computer/general_air_control/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if(src.stat & BROKEN)
				to_chat(user, SPAN_INFO("The broken glass falls out."))
				var/obj/structure/computerframe/A = new /obj/structure/computerframe(src.loc)
				new /obj/item/weapon/shard(src.loc)
				var/obj/item/weapon/circuitboard/air_management/M = new /obj/item/weapon/circuitboard/air_management(A)
				for(var/obj/C in src)
					C.loc = src.loc
				M.frequency = src.frequency
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = TRUE
				qdel(src)
			else
				to_chat(user, SPAN_INFO("You disconnect the monitor."))
				var/obj/structure/computerframe/A = new /obj/structure/computerframe(src.loc)
				var/obj/item/weapon/circuitboard/air_management/M = new /obj/item/weapon/circuitboard/air_management(A)
				for(var/obj/C in src)
					C.loc = src.loc
				M.frequency = src.frequency
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = TRUE
				qdel(src)
	else
		src.attack_hand(user)
	return

/obj/machinery/computer/general_air_control/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption)
		return

	var/id_tag = signal.data["tag"]
	if(!id_tag || !sensors.Find(id_tag))
		return

	sensor_information[id_tag] = signal.data

/obj/machinery/computer/general_air_control/proc/return_text()
	var/sensor_data
	if(length(sensors))
		for(var/id_tag in sensors)
			var/long_name = sensors[id_tag]
			var/list/data = sensor_information[id_tag]
			var/sensor_part = "<B>[long_name]</B>:<BR>"

			if(data)
				if(data["pressure"])
					sensor_part += "   <B>Pressure:</B> [data["pressure"]] kPa<BR>"
				if(data["temperature"])
					sensor_part += "   <B>Temperature:</B> [data["temperature"]] K<BR>"
				if(data[GAS_OXYGEN] || data[GAS_NITROGEN] || data[GAS_HYDROGEN] || data[GAS_CARBON_DIOXIDE] \
				|| data[GAS_PLASMA] || data[GAS_OXYGEN_AGENT_B] || data[GAS_SLEEPING_AGENT])
					sensor_part += "   <B>Gas Composition: </B>"
					if(data[GAS_OXYGEN])
						sensor_part += "<BR>"
						sensor_part += "[data[GAS_OXYGEN]]% O2;"
					if(data[GAS_NITROGEN])
						sensor_part += "<BR>"
						sensor_part += "[data[GAS_NITROGEN]]% N;"
					if(data[GAS_HYDROGEN])
						sensor_part += "<BR>"
						sensor_part += "[data[GAS_HYDROGEN]]% H2;"
					if(data[GAS_CARBON_DIOXIDE])
						sensor_part += "<BR>"
						sensor_part += "[data[GAS_CARBON_DIOXIDE]]% CO2;"
					if(data[GAS_PLASMA])
						sensor_part += "<BR>"
						sensor_part += "[data[GAS_PLASMA]]% TX;"
					if(data[GAS_OXYGEN_AGENT_B])
						sensor_part += "<BR>"
						sensor_part += "[data[GAS_OXYGEN_AGENT_B]]% O2A-B;"
					if(data[GAS_SLEEPING_AGENT])
						sensor_part += "<BR>"
						sensor_part += "[data[GAS_SLEEPING_AGENT]]% N2O;"
				sensor_part += "<HR>"
			else
				sensor_part = "<FONT color='red'>[long_name] can not be found!</FONT><BR>"
			sensor_data += sensor_part
	else
		sensor_data = "No sensors connected."

	var/output = {"<B>[name]</B><HR>
<B>Sensor Data:</B><HR><HR>[sensor_data]"}

	return output

/obj/machinery/computer/general_air_control/large_tank_control
	icon = 'icons/obj/computer.dmi'
	icon_state = "tank"

	var/input_tag
	var/output_tag

	var/list/input_info
	var/list/output_info

	var/pressure_setting = ONE_ATMOSPHERE * 45

/obj/machinery/computer/general_air_control/large_tank_control/return_text()
	var/output = ..()
	//if(signal.data)
	//	input_info = signal.data // Attempting to fix intake control -- TLE

	output += "<B>Tank Control System</B><BR>"
	if(input_info)
		var/power = (input_info["power"])
		var/volume_rate = input_info["volume_rate"]
		output += {"<B>Input</B>: [power?("Injecting"):("On Hold")] <A href='?src=\ref[src];in_refresh_status=1'>Refresh</A><BR>
Rate: [volume_rate] L/sec<BR>"}
		output += "Command: <A href='?src=\ref[src];in_toggle_injector=1'>Toggle Power</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find input port</FONT> <A href='?src=\ref[src];in_refresh_status=1'>Search</A><BR>"

	output += "<BR>"

	if(output_info)
		var/power = (output_info["power"])
		var/output_pressure = output_info["internal"]
		output += {"<B>Output</B>: [power?("Open"):("On Hold")] <A href='?src=\ref[src];out_refresh_status=1'>Refresh</A><BR>
Max Output Pressure: [output_pressure] kPa<BR>"}
		output += "Command: <A href='?src=\ref[src];out_toggle_power=1'>Toggle Power</A> <A href='?src=\ref[src];out_set_pressure=1'>Set Pressure</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find output port</FONT> <A href='?src=\ref[src];out_refresh_status=1'>Search</A><BR>"

	output += "Max Output Pressure Set: <A href='?src=\ref[src];adj_pressure=-1000'>-</A> <A href='?src=\ref[src];adj_pressure=-100'>-</A> <A href='?src=\ref[src];adj_pressure=-10'>-</A> <A href='?src=\ref[src];adj_pressure=-1'>-</A> [pressure_setting] kPa <A href='?src=\ref[src];adj_pressure=1'>+</A> <A href='?src=\ref[src];adj_pressure=10'>+</A> <A href='?src=\ref[src];adj_pressure=100'>+</A> <A href='?src=\ref[src];adj_pressure=1000'>+</A><BR>"

	return output

/obj/machinery/computer/general_air_control/large_tank_control/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption)
		return

	var/id_tag = signal.data["tag"]

	if(input_tag == id_tag)
		input_info = signal.data
	else if(output_tag == id_tag)
		output_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/large_tank_control/Topic(href, href_list)
	if(..())
		return

	if(href_list["adj_pressure"])
		var/change = text2num(href_list["adj_pressure"])
		pressure_setting = between(0, pressure_setting + change, 50 * ONE_ATMOSPHERE)
		spawn(1)
			src.updateUsrDialog()
		return

	if(!radio_connection)
		return 0
	var/datum/signal/signal = new
	signal.transmission_method = TRANSMISSION_RADIO
	signal.source = src
	if(href_list["in_refresh_status"])
		input_info = null
		signal.data = list ("tag" = input_tag, "status")

	if(href_list["in_toggle_injector"])
		input_info = null
		signal.data = list ("tag" = input_tag, "power_toggle")

	if(href_list["out_refresh_status"])
		output_info = null
		signal.data = list ("tag" = output_tag, "status")

	if(href_list["out_toggle_power"])
		output_info = null
		signal.data = list ("tag" = output_tag, "power_toggle")

	if(href_list["out_set_pressure"])
		output_info = null
		signal.data = list ("tag" = output_tag, "set_internal_pressure" = "[pressure_setting]")

	signal.data["sigtype"] = "command"
	radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	spawn(5)
		src.updateUsrDialog()

/obj/machinery/computer/general_air_control/fuel_injection
	icon = 'icons/obj/computer.dmi'
	icon_state = "atmos"

	var/device_tag
	var/list/device_info

	var/automation = 0

	var/cutoff_temperature = 2000
	var/on_temperature = 1200

/obj/machinery/computer/general_air_control/fuel_injection/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/weapon/screwdriver))
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		if(do_after(user, 20))
			if(src.stat & BROKEN)
				to_chat(user, SPAN_INFO("The broken glass falls out."))
				var/obj/structure/computerframe/A = new /obj/structure/computerframe(src.loc)
				new /obj/item/weapon/shard(src.loc)
				var/obj/item/weapon/circuitboard/injector_control/M = new /obj/item/weapon/circuitboard/injector_control(A)
				for(var/obj/C in src)
					C.loc = src.loc
				M.frequency = src.frequency
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = TRUE
				qdel(src)
			else
				to_chat(user, SPAN_INFO("You disconnect the monitor."))
				var/obj/structure/computerframe/A = new /obj/structure/computerframe(src.loc)
				var/obj/item/weapon/circuitboard/injector_control/M = new /obj/item/weapon/circuitboard/injector_control(A)
				for(var/obj/C in src)
					C.loc = src.loc
				M.frequency = src.frequency
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = TRUE
				qdel(src)
	else
		src.attack_hand(user)
	return

/obj/machinery/computer/general_air_control/fuel_injection/process()
	if(automation)
		if(!radio_connection)
			return 0

		var/injecting = 0
		for(var/id_tag in sensor_information)
			var/list/data = sensor_information[id_tag]
			if(data["temperature"])
				if(data["temperature"] >= cutoff_temperature)
					injecting = 0
					break
				if(data["temperature"] <= on_temperature)
					injecting = 1

		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO
		signal.source = src

		signal.data = list(
			"tag" = device_tag,
			"power" = injecting,
			"sigtype" = "command"
		)

		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	..()

/obj/machinery/computer/general_air_control/fuel_injection/return_text()
	var/output = ..()

	output += "<B>Fuel Injection System</B><BR>"
	if(device_info)
		var/power = device_info["power"]
		var/volume_rate = device_info["volume_rate"]
		output += {"Status: [power?("Injecting"):("On Hold")] <A href='?src=\ref[src];refresh_status=1'>Refresh</A><BR>
Rate: [volume_rate] L/sec<BR>"}

		if(automation)
			output += "Automated Fuel Injection: <A href='?src=\ref[src];toggle_automation=1'>Engaged</A><BR>"
			output += "Injector Controls Locked Out<BR>"
		else
			output += "Automated Fuel Injection: <A href='?src=\ref[src];toggle_automation=1'>Disengaged</A><BR>"
			output += "Injector: <A href='?src=\ref[src];toggle_injector=1'>Toggle Power</A> <A href='?src=\ref[src];injection=1'>Inject (1 Cycle)</A><BR>"

	else
		output += "<FONT color='red'>ERROR: Can not find device</FONT> <A href='?src=\ref[src];refresh_status=1'>Search</A><BR>"

	return output

/obj/machinery/computer/general_air_control/fuel_injection/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption) return

	var/id_tag = signal.data["tag"]

	if(device_tag == id_tag)
		device_info = signal.data
	else
		..(signal)

/obj/machinery/computer/general_air_control/fuel_injection/Topic(href, href_list)
	if(..())
		return

	if(href_list["refresh_status"])
		device_info = null
		if(!radio_connection)
			return 0

		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO
		signal.source = src
		signal.data = list(
			"tag" = device_tag,
			"status",
			"sigtype" = "command"
		)
		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	if(href_list["toggle_automation"])
		automation = !automation

	if(href_list["toggle_injector"])
		device_info = null
		if(!radio_connection)
			return 0

		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO
		signal.source = src
		signal.data = list(
			"tag" = device_tag,
			"power_toggle",
			"sigtype" = "command"
		)

		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)

	if(href_list["injection"])
		if(!radio_connection)
			return 0

		var/datum/signal/signal = new
		signal.transmission_method = TRANSMISSION_RADIO
		signal.source = src
		signal.data = list(
			"tag" = device_tag,
			"inject",
			"sigtype" = "command"
		)

		radio_connection.post_signal(src, signal, filter = RADIO_ATMOSIA)