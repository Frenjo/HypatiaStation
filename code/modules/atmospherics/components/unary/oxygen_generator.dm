/obj/machinery/atmospherics/unary/oxygen_generator
	icon = 'icons/obj/atmospherics/oxygen_generator.dmi'
	icon_state = "intact_off"
	density = TRUE

	name = "oxygen generator"
	desc = ""

	dir = SOUTH
	initialize_directions = SOUTH

	var/on = FALSE

	var/oxygen_content = 10

/obj/machinery/atmospherics/unary/oxygen_generator/update_icon()
	if(node)
		icon_state = "intact_[on ? ("on") : ("off")]"
	else
		icon_state = "exposed_off"

		on = FALSE

/obj/machinery/atmospherics/unary/oxygen_generator/initialise()
	. = ..()
	air_contents.volume = 50

/obj/machinery/atmospherics/unary/oxygen_generator/process()
	..()
	if(!on)
		return 0

	var/total_moles = air_contents.total_moles

	if(total_moles < oxygen_content)
		var/current_heat_capacity = air_contents.heat_capacity()

		var/added_oxygen = oxygen_content - total_moles

		air_contents.temperature = (current_heat_capacity * air_contents.temperature + 20 * added_oxygen * T0C) / (current_heat_capacity + 20 * added_oxygen)
		air_contents.adjust_gas(/decl/xgm_gas/oxygen, added_oxygen)

		if(isnotnull(network))
			network.update = TRUE

	return 1