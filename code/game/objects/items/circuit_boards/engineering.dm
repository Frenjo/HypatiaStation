/*
 * Engineering Circuit Boards
 */

/*
 * Computers
 */
//obj/item/circuitboard/shield
//	name = "circuit board (Shield Control)"
//	build_path = /obj/machinery/computer/stationshield

/obj/item/circuitboard/stationalert
	name = "circuit board (Station Alerts)"
	build_path = /obj/machinery/computer/station_alert

/obj/item/circuitboard/atmospheresiphonswitch
	name = "circuit board (Atmosphere siphon control)"
//	build_path = /obj/machinery/computer/atmosphere/siphonswitch

/obj/item/circuitboard/air_management
	name = "circuit board (Atmospheric monitor)"
	build_path = /obj/machinery/computer/general_air_control

/obj/item/circuitboard/injector_control
	name = "circuit board (Injector control)"
	build_path = /obj/machinery/computer/general_air_control/fuel_injection

/obj/item/circuitboard/atmos_alert
	name = "circuit board (Atmospheric Alert)"
	build_path = /obj/machinery/computer/atmos_alert

/obj/item/circuitboard/turbine_control
	name = "circuit board (Turbine control)"
	build_path = /obj/machinery/computer/turbine_control

/obj/item/circuitboard/solar_control
	name = "circuit board (Solar Control)"	//name fixed 250810
	build_path = /obj/machinery/power/solar_control
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_POWERSTORAGE = 2)

/obj/item/circuitboard/powermonitor
	name = "circuit board (Power Monitor)"	//name fixed 250810
	build_path = /obj/machinery/power/monitor

// Added engineering shuttle to make use of the 'Ruskie DJ Station'. -Frenjo
/obj/item/circuitboard/engineering_shuttle
	name = "circuit board (Engineering Shuttle)"
	build_path = /obj/machinery/computer/shuttle_control/engineering
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)

/obj/item/circuitboard/area_atmos
	name = "circuit board (Area Air Control)"
	build_path = /obj/machinery/computer/area_atmos
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)

/*
 * Machines
 */
/obj/item/circuitboard/pacman
	name = "circuit board (PACMAN-type Generator)"
	build_path = /obj/machinery/power/port_gen/pacman
	board_type = "machine"
	origin_tech = list(
		RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_POWERSTORAGE = 3, RESEARCH_TECH_PLASMATECH = 3,
		RESEARCH_TECH_ENGINEERING = 3
	)
	frame_desc = "Requires 1 Matter Bin, 1 Micro-Laser, 2 Pieces of Cable, and 1 Capacitor."
	req_components = list(
		/obj/item/stock_part/matter_bin = 1,
		/obj/item/stock_part/micro_laser = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/capacitor = 1
	)

/obj/item/circuitboard/pacman/super
	name = "circuit board (SUPERPACMAN-type Generator)"
	build_path = /obj/machinery/power/port_gen/pacman/super
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_POWERSTORAGE = 4, RESEARCH_TECH_ENGINEERING = 4)

/obj/item/circuitboard/pacman/mrs
	name = "circuit board (MRSPACMAN-type Generator)"
	build_path = /obj/machinery/power/port_gen/pacman/mrs
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_POWERSTORAGE = 5, RESEARCH_TECH_ENGINEERING = 5)