/obj/machinery/portable_atmospherics
	name = "atmoalter"

	power_state = USE_POWER_OFF

	var/datum/gas_mixture/air_contents

	var/obj/machinery/atmospherics/unary/portables_connector/connected_port
	var/obj/item/tank/holding

	var/volume = 0
	var/destroyed = FALSE

	var/maximum_pressure = 90 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/New()
	. = ..()
	air_contents = new /datum/gas_mixture()
	air_contents.volume = volume
	air_contents.temperature = T20C

/obj/machinery/portable_atmospherics/initialize()
	. = ..()
	var/obj/machinery/atmospherics/unary/portables_connector/port = locate() in loc
	if(isnotnull(port))
		connect(port)
		update_icon()

/obj/machinery/portable_atmospherics/Destroy()
	qdel(air_contents)
	return ..()

/obj/machinery/portable_atmospherics/process()
	if(isnull(connected_port)) //only react when pipe_network will ont it do it for you
		//Allow for reactions
		air_contents.react()
	else
		update_icon()

/obj/machinery/portable_atmospherics/update_icon()
	return null

/obj/machinery/portable_atmospherics/proc/connect(obj/machinery/atmospherics/unary/portables_connector/new_port)
	//Make sure not already connected to something else
	if(isnotnull(connected_port) || isnull(new_port) || isnotnull(new_port.connected_device))
		return 0

	//Make sure are close enough for a valid connection
	if(new_port.loc != loc)
		return 0

	//Perform the connection
	connected_port = new_port
	connected_port.connected_device = src

	anchored = TRUE //Prevent movement

	//Actually enforce the air sharing
	var/datum/pipe_network/network = connected_port.return_network(src)
	if(isnotnull(network) && !network.gases.Find(air_contents))
		network.gases.Add(air_contents)
		network.update = TRUE

	return 1

/obj/machinery/portable_atmospherics/proc/disconnect()
	if(isnull(connected_port))
		return 0

	var/datum/pipe_network/network = connected_port.return_network(src)
	if(isnotnull(network))
		network.gases.Remove(air_contents)

	anchored = FALSE

	connected_port.connected_device = null
	connected_port = null

	return 1

/obj/machinery/portable_atmospherics/attackby(obj/item/W as obj, mob/user as mob)
	var/obj/icon = src
	if(istype(W, /obj/item/tank) && !destroyed)
		if(isnotnull(holding))
			return
		var/obj/item/tank/T = W
		user.drop_item()
		T.loc = src
		holding = T
		update_icon()
		return

	else if(istype(W, /obj/item/wrench))
		if(isnotnull(connected_port))
			disconnect()
			to_chat(user, SPAN_INFO("You disconnect [name] from the port."))
			update_icon()
			return
		else
			var/obj/machinery/atmospherics/unary/portables_connector/possible_port = locate(/obj/machinery/atmospherics/unary/portables_connector/) in loc
			if(isnotnull(possible_port))
				if(connect(possible_port))
					to_chat(user, SPAN_INFO("You connect [name] to the port."))
					update_icon()
					return
				else
					to_chat(user, SPAN_INFO("[name] failed to connect to the port."))
					return
			else
				to_chat(user, SPAN_INFO("Nothing happens."))
				return

	else if(istype(W, /obj/item/gas_analyser) && get_dist(user, src) <= 1)
		visible_message("\red [user] has used [W] on \icon[icon]")
		if(isnotnull(air_contents))
			var/pressure = air_contents.return_pressure()
			var/total_moles = air_contents.total_moles

			to_chat(user, SPAN_INFO("Results of analysis of \icon[icon]"))
			if(total_moles > 0)
				to_chat(user, SPAN_INFO("Pressure: [round(pressure, 0.1)] kPa"))
				for(var/g in air_contents.gas)
					to_chat(user, SPAN_INFO("[GLOBL.gas_data.name[g]]: [round((air_contents.gas[g] / total_moles) * 100)]%"))

				to_chat(user, SPAN_INFO("Temperature: [round(air_contents.temperature - T0C)]&deg;C"))
			else
				to_chat(user, SPAN_INFO("Tank is empty!"))
		else
			to_chat(user, SPAN_INFO("Tank is empty!"))
		return