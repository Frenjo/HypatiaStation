/*
 * Research Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/robotics
	name = "circuit board (robotics control)"
	build_path = /obj/machinery/computer/robotics
	origin_tech = list(/decl/tech/programming = 3)

/obj/item/circuitboard/rdconsole
	name = "circuit board (RD console)"
	build_path = /obj/machinery/computer/rdconsole/core

/obj/item/circuitboard/rdconsole/attack_tool(obj/item/tool, mob/user)
	if(isscrewdriver(tool))
		user.visible_message(
			SPAN_NOTICE("[user] adjusts the jumper on \the [src]'s access protocol pins."),
			SPAN_NOTICE("You adjust the jumper on the access protocol pins."),
			SPAN_INFO("You hear someone using a screwdriver.")
		)
		if(ispath(build_path, /obj/machinery/computer/rdconsole/core))
			name = "circuit board (RD Console - Robotics)"
			build_path = /obj/machinery/computer/rdconsole/robotics
			to_chat(user, SPAN_NOTICE("Access protocols set to robotics."))
		else
			name = "circuit board (RD Console)"
			build_path = /obj/machinery/computer/rdconsole/core
			to_chat(user, SPAN_NOTICE("Access protocols defaulted."))
		return TRUE

	return ..()

/obj/item/circuitboard/mecha_control
	name = "circuit board (exosuit control console)"
	build_path = /obj/machinery/computer/mecha

/obj/item/circuitboard/rdservercontrol
	name = "circuit board (R&D server control)"
	build_path = /obj/machinery/computer/rdservercontrol

/obj/item/circuitboard/mech_bay_power_console
	name = "circuit board (mech bay power control console)"
	build_path = /obj/machinery/computer/mech_bay_power_console
	origin_tech = list(/decl/tech/power_storage = 3, /decl/tech/programming = 2)

/obj/item/circuitboard/research_shuttle
	name = "circuit board (research shuttle)"
	build_path = /obj/machinery/computer/shuttle_control/research
	origin_tech = list(/decl/tech/programming = 2)

/*
 * Machines
 */
/obj/item/circuitboard/destructive_analyser
	name = "circuit board (destructive analyser)"
	build_path = /obj/machinery/r_n_d/destructive_analyser
	board_type = "machine"
	origin_tech = list(/decl/tech/magnets = 2, /decl/tech/engineering = 2, /decl/tech/programming = 2)
	frame_desc = "Requires 1 Scanning Module, 1 Micro Manipulator, and 1 Micro-Laser."
	req_components = list(
		/obj/item/stock_part/scanning_module = 1,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/micro_laser = 1
	)

/obj/item/circuitboard/autolathe
	name = "circuit board (autolathe)"
	build_path = /obj/machinery/autolathe
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 2, /decl/tech/programming = 2)
	frame_desc = "Requires 3 Matter Bins, 1 Micro Manipulator, and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/matter_bin = 3,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/console_screen = 1
	)

/obj/item/circuitboard/protolathe
	name = "circuit board (protolathe)"
	build_path = /obj/machinery/r_n_d/protolathe
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 2, /decl/tech/programming = 2)
	frame_desc = "Requires 2 Matter Bins, 2 Micro Manipulators, and 2 Beakers."
	req_components = list(
		/obj/item/stock_part/matter_bin = 2,
		/obj/item/stock_part/manipulator = 2,
		/obj/item/reagent_holder/glass/beaker = 2
	)

/obj/item/circuitboard/circuit_imprinter
	name = "circuit board (circuit imprinter)"
	build_path = /obj/machinery/r_n_d/circuit_imprinter
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 2, /decl/tech/programming = 2)
	frame_desc = "Requires 1 Matter Bin, 1 Micro Manipulator, and 2 Beakers."
	req_components = list(
		/obj/item/stock_part/matter_bin = 1,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/reagent_holder/glass/beaker = 2
	)

/obj/item/circuitboard/rdserver
	name = "circuit board (R&D server)"
	build_path = /obj/machinery/r_n_d/server
	board_type = "machine"
	origin_tech = list(/decl/tech/programming = 3)
	frame_desc = "Requires 2 pieces of cable, and 1 Scanning Module."
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/scanning_module = 1
	)

/obj/item/circuitboard/mechfab
	name = "circuit board (exosuit fabricator)"
	build_path = /obj/machinery/robotics_fabricator/mecha
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 3, /decl/tech/programming = 3)
	frame_desc = "Requires 2 Matter Bins, 1 Micro Manipulator, 1 Micro-Laser and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/matter_bin = 2,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/micro_laser = 1,
		/obj/item/stock_part/console_screen = 1
	)

/obj/item/circuitboard/robofab
	name = "circuit board (robotic fabricator)"
	build_path = /obj/machinery/robotics_fabricator/robotic
	board_type = "machine"
	origin_tech = list(/decl/tech/engineering = 3, /decl/tech/programming = 3)
	frame_desc = "Requires 2 Matter Bins, 1 Micro Manipulator, 1 Micro-Laser and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/matter_bin = 2,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/micro_laser = 1,
		/obj/item/stock_part/console_screen = 1
	)