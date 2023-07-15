/*
 * Medical Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/med_data
	name = "circuit board (Medical Records)"
	build_path = /obj/machinery/computer/med_data

/obj/item/circuitboard/pandemic
	name = "circuit board (PanD.E.M.I.C. 2200)"
	build_path = /obj/machinery/computer/pandemic
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 2)

/obj/item/circuitboard/scan_consolenew
	name = "circuit board (DNA Machine)"
	build_path = /obj/machinery/computer/scan_consolenew
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 2)

/obj/item/circuitboard/cloning
	name = "circuit board (Cloning)"
	build_path = /obj/machinery/computer/cloning
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 3)

/obj/item/circuitboard/crew
	name = "circuit board (Crew monitoring computer)"
	build_path = /obj/machinery/computer/crew
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 2, RESEARCH_TECH_MAGNETS = 2)

/obj/item/circuitboard/operating
	name = "circuit board (Operating Computer)"
	build_path = /obj/machinery/computer/operating
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 2)

/obj/item/circuitboard/curefab
	name = "circuit board (Cure fab)"
	build_path = /obj/machinery/computer/curer

/obj/item/circuitboard/splicer
	name = "circuit board (Disease Splicer)"
	build_path = /obj/machinery/computer/diseasesplicer

/*
 * Machines
 */
/obj/item/circuitboard/clonepod
	name = "circuit board (Clone Pod)"
	build_path = /obj/machinery/clonepod
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 3)
	frame_desc = "Requires 2 Manipulator, 2 Scanning Module, 2 pieces of cable and 1 Console Screen."
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/scanning_module = 2,
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stock_part/console_screen = 1
	)

/obj/item/circuitboard/clonescanner
	name = "circuit board (Cloning Scanner)"
	build_path = /obj/machinery/dna_scannernew
	board_type = "machine"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2, RESEARCH_TECH_BIOTECH = 2)
	frame_desc = "Requires 1 Scanning module, 1 Micro Manipulator, 1 Micro-Laser, 2 pieces of cable and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/scanning_module = 1,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/micro_laser = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 2
	)