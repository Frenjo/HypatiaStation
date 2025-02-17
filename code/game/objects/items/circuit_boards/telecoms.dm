/*
 * Telecoms Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/message_monitor
	name = "circuit board (message monitor console)"
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
	matter_amounts = /datum/design/circuit/subspace_receiver::materials
	origin_tech = /datum/design/circuit/subspace_receiver::req_tech
	build_path = /obj/machinery/telecoms/receiver
	board_type = "machine"
	frame_desc = "Requires 1 subspace ansible, 1 hyperwave filter, 2 micro-manipulators, and 1 micro-laser."
	req_components = list(
		/obj/item/stock_part/subspace/ansible = 1,
		/obj/item/stock_part/subspace/filter = 1,
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stock_part/micro_laser = 1
	)

/obj/item/circuitboard/telecoms/hub
	name = "circuit board (hub mainframe)"
	matter_amounts = /datum/design/circuit/telecoms_hub::materials
	origin_tech = /datum/design/circuit/telecoms_hub::req_tech
	build_path = /obj/machinery/telecoms/hub
	board_type = "machine"
	frame_desc = "Requires 2 micro-manipulators, 2 pieces of cable and 2 hyperwave filter."
	req_components = list(
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/subspace/filter = 2
	)

/obj/item/circuitboard/telecoms/relay
	name = "circuit board (relay mainframe)"
	matter_amounts = /datum/design/circuit/telecoms_relay::materials
	origin_tech = /datum/design/circuit/telecoms_relay::req_tech
	build_path = /obj/machinery/telecoms/relay
	board_type = "machine"
	frame_desc = "Requires 2 micro-manipulators, 2 pieces of cable and 2 hyperwave filters."
	req_components = list(
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/subspace/filter = 2
	)

/obj/item/circuitboard/telecoms/bus
	name = "circuit board (bus mainframe)"
	matter_amounts = /datum/design/circuit/telecoms_bus::materials
	origin_tech = /datum/design/circuit/telecoms_bus::req_tech
	build_path = /obj/machinery/telecoms/bus
	board_type = "machine"
	frame_desc = "Requires 2 micro-manipulators, 1 piece of cable and 1 hyperwave filter."
	req_components = list(
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_part/subspace/filter = 1
	)

/obj/item/circuitboard/telecoms/processor
	name = "circuit board (processor unit)"
	matter_amounts = /datum/design/circuit/telecoms_processor::materials
	origin_tech = /datum/design/circuit/telecoms_processor::req_tech
	build_path = /obj/machinery/telecoms/processor
	board_type = "machine"
	frame_desc = "Requires 3 micro-manipulators, 1 hyperwave filter, 2 treatment disks, 1 wavelength analyser, 2 pieces of cable and 1 subspace amplifier."
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
	matter_amounts = /datum/design/circuit/telecoms_server::materials
	origin_tech = /datum/design/circuit/telecoms_server::req_tech
	build_path = /obj/machinery/telecoms/server
	board_type = "machine"
	frame_desc = "Requires 2 micro-manipulators, 1 piece of cable and 1 hyperwave filter."
	req_components = list(
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_part/subspace/filter = 1
	)

/obj/item/circuitboard/telecoms/broadcaster
	name = "circuit board (subspace broadcaster)"
	matter_amounts = /datum/design/circuit/subspace_broadcaster::materials
	origin_tech = /datum/design/circuit/subspace_broadcaster::req_tech
	build_path = /obj/machinery/telecoms/broadcaster
	board_type = "machine"
	frame_desc = "Requires 2 micro-manipulators, 1 piece of cable, 1 hyperwave filter, 1 ansible crystal and 2 high-powered micro-lasers. "
	req_components = list(
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stack/cable_coil = 1,
		/obj/item/stock_part/subspace/filter = 1,
		/obj/item/stock_part/subspace/crystal = 1,
		/obj/item/stock_part/micro_laser/high = 2
	)