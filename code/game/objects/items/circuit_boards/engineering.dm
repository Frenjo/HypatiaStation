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
	name = "circuit board (station alert computer)"
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
	name = "circuit board (atmospheric alert computer)"
	build_path = /obj/machinery/computer/atmos_alert

/obj/item/circuitboard/turbine_control
	name = "circuit board (gas turbine control computer)"
	build_path = /obj/machinery/computer/turbine_control

/obj/item/circuitboard/solar_control
	name = "circuit board (solar panel control)"
	build_path = /obj/machinery/power/solar_control
	origin_tech = list(/decl/tech/power_storage = 2, /decl/tech/programming = 2)

/obj/item/circuitboard/powermonitor
	name = "circuit board (power monitoring computer)"
	build_path = /obj/machinery/power/monitor

// Added engineering shuttle to make use of the 'Ruskie DJ Station'. -Frenjo
/obj/item/circuitboard/engineering_shuttle
	name = "circuit board (engineering shuttle control console)"
	build_path = /obj/machinery/computer/shuttle_control/engineering

/obj/item/circuitboard/area_atmos
	name = "circuit board (area air control)"
	build_path = /obj/machinery/computer/area_atmos

/*
 * Machines
 */
/obj/item/circuitboard/pacman
	name = "circuit board (P.A.C.M.A.N.-type portable generator)"
	build_path = /obj/machinery/power/port_gen/pacman
	board_type = "machine"
	origin_tech = list(
		/decl/tech/engineering = 3, /decl/tech/power_storage = 3, /decl/tech/programming = 3,
		/decl/tech/plasma = 3
	)
	frame_desc = "Requires 1 matter bin, 1 micro-laser, 2 pieces of cable, and 1 capacitor."
	req_components = list(
		/obj/item/stock_part/matter_bin = 1,
		/obj/item/stock_part/micro_laser = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/capacitor = 1
	)

/obj/item/circuitboard/pacman/super
	name = "circuit board (S.U.P.E.R.P.A.C.M.A.N.-type portable generator)"
	build_path = /obj/machinery/power/port_gen/pacman/super
	origin_tech = list(/decl/tech/engineering = 4, /decl/tech/power_storage = 4, /decl/tech/programming = 3)

/obj/item/circuitboard/pacman/mrs
	name = "circuit board (M.R.S.P.A.C.M.A.N.-type portable generator)"
	build_path = /obj/machinery/power/port_gen/pacman/mrs
	origin_tech = list(/decl/tech/engineering = 5, /decl/tech/power_storage = 5, /decl/tech/programming = 3)

/obj/item/circuitboard/cell_rack
	name = "circuit board (CRES)"
	build_path = /obj/machinery/power/smes/cell_rack
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 2, /decl/tech/power_storage = 3)
	frame_desc = "Requires 3 power cells."
	req_components = list(/obj/item/cell = 3)

/obj/item/circuitboard/makeshift_cell_rack
	name = "circuit board (makeshift CRES)"
	desc = "An APC circuit repurposed into a basic energy storage unit controller."
	build_path = /obj/machinery/power/smes/cell_rack/makeshift
	board_type = "machine"
	frame_desc = "Requires 3 power cells."
	req_components = list(/obj/item/cell = 3)