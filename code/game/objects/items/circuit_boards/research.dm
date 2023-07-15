/*
 * Research Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/robotics
	name = "circuit board (Robotics Control)"
	build_path = /obj/machinery/computer/robotics
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)

/obj/item/circuitboard/rdconsole
	name = "circuit board (RD Console)"
	build_path = /obj/machinery/computer/rdconsole/core

/obj/item/circuitboard/rdconsole/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/screwdriver))
		user.visible_message(
			SPAN_INFO("\the [user] adjusts the jumper on the [src]'s access protocol pins."),
			SPAN_INFO("You adjust the jumper on the access protocol pins.")
		)
		if(ispath(build_path, /obj/machinery/computer/rdconsole/core))
			name = "circuit board (RD Console - Robotics)"
			build_path = /obj/machinery/computer/rdconsole/robotics
			to_chat(user, SPAN_INFO("Access protocols set to robotics."))
		else
			name = "circuit board (RD Console)"
			build_path = /obj/machinery/computer/rdconsole/core
			to_chat(user, SPAN_INFO("Access protocols defaulted."))

/obj/item/circuitboard/mecha_control
	name = "circuit board (Exosuit Control Console)"
	build_path = /obj/machinery/computer/mecha

/obj/item/circuitboard/rdservercontrol
	name = "circuit board (R&D Server Control)"
	build_path = /obj/machinery/computer/rdservercontrol

/obj/item/circuitboard/mech_bay_power_console
	name = "circuit board (Mech Bay Power Control Console)"
	build_path = /obj/machinery/computer/mech_bay_power_console
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_POWERSTORAGE = 3)

/obj/item/circuitboard/research_shuttle
	name = "circuit board (Research Shuttle)"
	build_path = /obj/machinery/computer/shuttle_control/research
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)

/*
 * Machines
 */
/obj/item/circuitboard/destructive_analyzer
	name = "circuit board (Destructive Analyzer)"
	build_path = /obj/machinery/r_n_d/destructive_analyzer
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_MAGNETS = 2, RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_PROGRAMMING = 2)
	frame_desc = "Requires 1 Scanning Module, 1 Micro Manipulator, and 1 Micro-Laser."
	req_components = list(
		/obj/item/stock_part/scanning_module = 1,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/micro_laser = 1
	)

/obj/item/circuitboard/autolathe
	name = "circuit board (Autolathe)"
	build_path = /obj/machinery/autolathe
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_PROGRAMMING = 2)
	frame_desc = "Requires 3 Matter Bins, 1 Micro Manipulator, and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/matter_bin = 3,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/console_screen = 1
	)

/obj/item/circuitboard/protolathe
	name = "circuit board (Protolathe)"
	build_path = /obj/machinery/r_n_d/protolathe
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_PROGRAMMING = 2)
	frame_desc = "Requires 2 Matter Bins, 2 Micro Manipulators, and 2 Beakers."
	req_components = list(
		/obj/item/stock_part/matter_bin = 2,
		/obj/item/stock_part/manipulator = 2,
		/obj/item/reagent_containers/glass/beaker = 2
	)

/obj/item/circuitboard/circuit_imprinter
	name = "circuit board (Circuit Imprinter)"
	build_path = /obj/machinery/r_n_d/circuit_imprinter
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_ENGINEERING = 2, RESEARCH_TECH_PROGRAMMING = 2)
	frame_desc = "Requires 1 Matter Bin, 1 Micro Manipulator, and 2 Beakers."
	req_components = list(
		/obj/item/stock_part/matter_bin = 1,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/reagent_containers/glass/beaker = 2
	)

/obj/item/circuitboard/rdserver
	name = "circuit board (R&D Server)"
	build_path = /obj/machinery/r_n_d/server
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3)
	frame_desc = "Requires 2 pieces of cable, and 1 Scanning Module."
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/scanning_module = 1
	)

/obj/item/circuitboard/mechfab
	name = "circuit board (Exosuit Fabricator)"
	build_path = /obj/machinery/mecha_part_fabricator
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_ENGINEERING = 3)
	frame_desc = "Requires 2 Matter Bins, 1 Micro Manipulator, 1 Micro-Laser and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/matter_bin = 2,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/micro_laser = 1,
		/obj/item/stock_part/console_screen = 1
	)