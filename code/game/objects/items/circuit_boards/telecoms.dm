/*
 * Telecoms Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/message_monitor
	name = "circuit board (message monitor)"
	build_path = /obj/machinery/computer/message_monitor
	origin_tech = list(/decl/tech/programming = 3)

/obj/item/circuitboard/comm_monitor
	name = "circuit board (telecommunications monitor)"
	build_path = /obj/machinery/computer/telecoms/monitor
	origin_tech = list(/decl/tech/programming = 3)

/obj/item/circuitboard/comm_server
	name = "circuit board (telecommunications server monitor)"
	build_path = /obj/machinery/computer/telecoms/server
	origin_tech = list(/decl/tech/programming = 3)

/obj/item/circuitboard/comm_traffic
	name = "circuit board (telecommunications traffic control)"
	build_path = /obj/machinery/computer/telecoms/traffic
	origin_tech = list(/decl/tech/programming = 3)

/*
 * Machines
 */
/obj/item/circuitboard/telecoms/receiver
	name = "circuit board (subspace receiver)"
	build_path = /obj/machinery/telecoms/receiver
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 3, /decl/tech/programming = 4, /decl/tech/bluespace = 2)
	frame_desc = "Requires 1 Subspace Ansible, 1 Hyperwave Filter, 2 Micro Manipulators, and 1 Micro-Laser."
	req_components = list(
		/obj/item/stock_part/subspace/ansible = 1,
		/obj/item/stock_part/subspace/filter = 1,
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stock_part/micro_laser = 1
	)

/obj/item/circuitboard/telecoms/hub
	name = "circuit board (hub mainframe)"
	build_path = /obj/machinery/telecoms/hub
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4)
	frame_desc = "Requires 2 Micro Manipulators, 2 Cable Coil and 2 Hyperwave Filter."
	req_components = list(
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/subspace/filter = 2
	)

/obj/item/circuitboard/telecoms/relay
	name = "circuit board (relay mainframe)"
	build_path = /obj/machinery/telecoms/relay
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 3, /decl/tech/bluespace = 3)
	frame_desc = "Requires 2 Micro Manipulators, 2 Cable Coil and 2 Hyperwave Filters."
	req_components = list(
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/subspace/filter = 2
	)

/obj/item/circuitboard/telecoms/bus
	name = "circuit board (bus mainframe)"
	build_path = /obj/machinery/telecoms/bus
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4)
	frame_desc = "Requires 2 Micro Manipulators, 1 Cable Coil and 1 Hyperwave Filter."
	req_components = list(
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_part/subspace/filter = 1
	)

/obj/item/circuitboard/telecoms/processor
	name = "circuit board (processor unit)"
	build_path = /obj/machinery/telecoms/processor
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4)
	frame_desc = "Requires 3 Micro Manipulators, 1 Hyperwave Filter, 2 Treatment Disks, 1 Wavelength Analyser, 2 Cable Coils and 1 Subspace Amplifier."
	req_components = list(
		/obj/item/stock_part/manipulator = 3,
		/obj/item/stock_part/subspace/filter = 1,
		/obj/item/stock_part/subspace/treatment = 2,
		/obj/item/stock_part/subspace/analyser = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/subspace/amplifier = 1
	)

/obj/item/circuitboard/telecoms/server
	name = "circuit board (telecommunication server)"
	build_path = /obj/machinery/telecoms/server
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4)
	frame_desc = "Requires 2 Micro Manipulators, 1 Cable Coil and 1 Hyperwave Filter."
	req_components = list(
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_part/subspace/filter = 1
	)

/obj/item/circuitboard/telecoms/broadcaster
	name = "circuit board (subspace broadcaster)"
	build_path = /obj/machinery/telecoms/broadcaster
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 4, /decl/tech/programming = 4, /decl/tech/bluespace = 2)
	frame_desc = "Requires 2 Micro Manipulators, 1 Cable Coil, 1 Hyperwave Filter, 1 Ansible Crystal and 2 High-Powered Micro-Lasers. "
	req_components = list(
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_part/subspace/filter = 1,
		/obj/item/stock_part/subspace/crystal = 1,
		/obj/item/stock_part/micro_laser/high = 2
	)