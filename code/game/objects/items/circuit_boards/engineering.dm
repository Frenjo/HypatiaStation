/*
 * Engineering Circuit Boards
 */

/*
 * Computers
 */
//obj/item/circuitboard/shield
//	name = "circuit board (shield control)"
//	build_path = /obj/machinery/computer/stationshield

/obj/item/circuitboard/stationalert
	name = "circuit board (station alerts)"
	build_path = /obj/machinery/computer/station_alert

/obj/item/circuitboard/atmospheresiphonswitch
	name = "circuit board (atmosphere siphon control)"
//	build_path = /obj/machinery/computer/atmosphere/siphonswitch

/obj/item/circuitboard/air_management
	name = "circuit board (atmospheric monitor)"
	build_path = /obj/machinery/computer/general_air_control

/obj/item/circuitboard/injector_control
	name = "circuit board (injector control)"
	build_path = /obj/machinery/computer/general_air_control/fuel_injection

/obj/item/circuitboard/atmos_alert
	name = "circuit board (atmospheric alert)"
	build_path = /obj/machinery/computer/atmos_alert

/obj/item/circuitboard/turbine_control
	name = "circuit board (turbine control)"
	build_path = /obj/machinery/computer/turbine_control

/obj/item/circuitboard/solar_control
	name = "circuit board (solar control)"	//name fixed 250810
	build_path = /obj/machinery/power/solar_control
	origin_tech = list(/datum/tech/power_storage = 2, /datum/tech/programming = 2)

/obj/item/circuitboard/powermonitor
	name = "circuit board (power monitor)"	//name fixed 250810
	build_path = /obj/machinery/power/monitor

// Added engineering shuttle to make use of the 'Ruskie DJ Station'. -Frenjo
/obj/item/circuitboard/engineering_shuttle
	name = "circuit board (engineering shuttle)"
	build_path = /obj/machinery/computer/shuttle_control/engineering
	origin_tech = list(/datum/tech/programming = 2)

/obj/item/circuitboard/area_atmos
	name = "circuit board (area air control)"
	build_path = /obj/machinery/computer/area_atmos
	origin_tech = list(/datum/tech/programming = 2)

/*
 * Machines
 */
/obj/item/circuitboard/pacman
	name = "circuit board (PACMAN-type generator)"
	build_path = /obj/machinery/power/port_gen/pacman
	board_type = "machine"
	origin_tech = list(
		/datum/tech/engineering = 3, /datum/tech/power_storage = 3, /datum/tech/programming = 3,
		/datum/tech/plasma = 3
	)
	frame_desc = "Requires 1 Matter Bin, 1 Micro-Laser, 2 Pieces of Cable, and 1 Capacitor."
	req_components = list(
		/obj/item/stock_part/matter_bin = 1,
		/obj/item/stock_part/micro_laser = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/capacitor = 1
	)

/obj/item/circuitboard/pacman/super
	name = "circuit board (SUPERPACMAN-type generator)"
	build_path = /obj/machinery/power/port_gen/pacman/super
	origin_tech = list(/datum/tech/engineering = 4, /datum/tech/power_storage = 4, /datum/tech/programming = 3)

/obj/item/circuitboard/pacman/mrs
	name = "circuit board (MRSPACMAN-type generator)"
	build_path = /obj/machinery/power/port_gen/pacman/mrs
	origin_tech = list(/datum/tech/engineering = 5, /datum/tech/power_storage = 5, /datum/tech/programming = 3)

/obj/item/circuitboard/cell_rack
	name = "circuit board (CRES)"
	build_path = /obj/machinery/power/smes/cell_rack
	board_type = "machine"
	origin_tech = list(/datum/tech/engineering = 2, /datum/tech/power_storage = 3)
	frame_desc = "Requires 3 power cells."
	req_components = list(/obj/item/cell = 3)

/obj/item/circuitboard/makeshift_cell_rack
	name = "circuit board (makeshift CRES)"
	desc = "An APC circuit repurposed into a basic energy storage unit controller."
	build_path = /obj/machinery/power/smes/cell_rack/makeshift
	board_type = "machine"
	frame_desc = "Requires 3 power cells."
	req_components = list(/obj/item/cell = 3)