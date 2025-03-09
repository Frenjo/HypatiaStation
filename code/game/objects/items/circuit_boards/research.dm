/*
 * Research Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/robotics
	name = "circuit board (robotics control)"
	build_path = /obj/machinery/computer/robotics
	origin_tech = alist(/decl/tech/programming = 3)

/obj/item/circuitboard/rdconsole
	name = "circuit board (core R&D console)"
	build_path = /obj/machinery/computer/rdconsole/core

/obj/item/circuitboard/rdconsole/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		user.visible_message(
			SPAN_NOTICE("[user] adjusts the jumper on \the [src]'s access protocol pins."),
			SPAN_NOTICE("You adjust the jumper on the access protocol pins."),
			SPAN_INFO("You hear someone using a screwdriver.")
		)
		if(ispath(build_path, /obj/machinery/computer/rdconsole/core))
			name = "circuit board (robotics R&D console)"
			build_path = /obj/machinery/computer/rdconsole/robotics
			to_chat(user, SPAN_NOTICE("Access protocols set to robotics."))
		else
			name = "circuit board (core R&D console)"
			build_path = /obj/machinery/computer/rdconsole/core
			to_chat(user, SPAN_NOTICE("Access protocols defaulted."))
		return TRUE

	return ..()

/obj/item/circuitboard/mecha_control
	name = "circuit board (exosuit control console)"
	build_path = /obj/machinery/computer/mecha

/obj/item/circuitboard/rdservercontrol
	name = "circuit board (R&D server control)"
	matter_amounts = /datum/design/circuit/rdservercontrol::materials
	origin_tech = /datum/design/circuit/rdservercontrol::req_tech
	build_path = /obj/machinery/computer/rdservercontrol

/obj/item/circuitboard/mech_bay_power_console
	name = "circuit board (mech bay power control console)"
	build_path = /obj/machinery/computer/mech_bay_power_console
	origin_tech = alist(/decl/tech/power_storage = 3, /decl/tech/programming = 2)

/obj/item/circuitboard/research_shuttle
	name = "circuit board (research shuttle control console)"
	build_path = /obj/machinery/computer/shuttle_control/research

/*
 * Machines
 */
/obj/item/circuitboard/destructive_analyser
	name = "circuit board (destructive analyser)"
	matter_amounts = /datum/design/circuit/destructive_analyser::materials
	origin_tech = /datum/design/circuit/destructive_analyser::req_tech
	build_path = /obj/machinery/r_n_d/destructive_analyser
	board_type = "machine"
	frame_desc = "Requires 1 scanning module, 1 micro-manipulator, and 1 micro-laser."
	req_components = list(
		/obj/item/stock_part/scanning_module = 1,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/micro_laser = 1
	)

/obj/item/circuitboard/autolathe
	name = "circuit board (autolathe)"
	matter_amounts = /datum/design/circuit/autolathe::materials
	origin_tech = /datum/design/circuit/autolathe::req_tech
	build_path = /obj/machinery/autolathe
	board_type = "machine"
	frame_desc = "Requires 3 matter bins, 1 micro-manipulator, and 1 console screen."
	req_components = list(
		/obj/item/stock_part/matter_bin = 3,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/console_screen = 1
	)

/obj/item/circuitboard/protolathe
	name = "circuit board (protolathe)"
	matter_amounts = /datum/design/circuit/protolathe::materials
	origin_tech = /datum/design/circuit/protolathe::req_tech
	build_path = /obj/machinery/r_n_d/protolathe
	board_type = "machine"
	frame_desc = "Requires 2 matter bins, 2 micro-manipulators, and 2 beakers."
	req_components = list(
		/obj/item/stock_part/matter_bin = 2,
		/obj/item/stock_part/manipulator = 2,
		/obj/item/reagent_holder/glass/beaker = 2
	)

/obj/item/circuitboard/circuit_imprinter
	name = "circuit board (circuit imprinter)"
	matter_amounts = /datum/design/circuit/circuit_imprinter::materials
	origin_tech = /datum/design/circuit/circuit_imprinter::req_tech
	build_path = /obj/machinery/r_n_d/circuit_imprinter
	board_type = "machine"
	frame_desc = "Requires 1 matter bin, 1 micro-manipulator, and 2 beakers."
	req_components = list(
		/obj/item/stock_part/matter_bin = 1,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/reagent_holder/glass/beaker = 2
	)

/obj/item/circuitboard/rdserver
	name = "circuit board (R&D server)"
	matter_amounts = /datum/design/circuit/rdserver::materials
	origin_tech = /datum/design/circuit/rdserver::req_tech
	build_path = /obj/machinery/r_n_d/server
	board_type = "machine"
	frame_desc = "Requires 2 pieces of cable, and 1 scanning module."
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/scanning_module = 1
	)

/obj/item/circuitboard/mechfab
	name = "circuit board (exosuit fabricator)"
	matter_amounts = /datum/design/circuit/mechfab::materials
	origin_tech = /datum/design/circuit/mechfab::req_tech
	build_path = /obj/machinery/robotics_fabricator/mecha
	board_type = "machine"
	frame_desc = "Requires 2 matter bins, 1 micro-manipulator, 1 micro-laser and 1 console screen."
	req_components = list(
		/obj/item/stock_part/matter_bin = 2,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/micro_laser = 1,
		/obj/item/stock_part/console_screen = 1
	)

/obj/item/circuitboard/robofab
	name = "circuit board (robotic fabricator)"
	matter_amounts = /datum/design/circuit/robofab::materials
	origin_tech = /datum/design/circuit/robofab::req_tech
	build_path = /obj/machinery/robotics_fabricator/robotic
	board_type = "machine"
	frame_desc = "Requires 2 matter bins, 1 micro-manipulator, 1 micro-laser and 1 console screen."
	req_components = list(
		/obj/item/stock_part/matter_bin = 2,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/micro_laser = 1,
		/obj/item/stock_part/console_screen = 1
	)