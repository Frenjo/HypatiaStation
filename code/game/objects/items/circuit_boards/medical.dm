/*
 * Medical Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/med_data
	name = "circuit board (medical records)"
	build_path = /obj/machinery/computer/med_data

/obj/item/circuitboard/pandemic
	name = "circuit board (PanD.E.M.I.C. 2200)"
	build_path = /obj/machinery/computer/pandemic
	origin_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 2)

/obj/item/circuitboard/scan_consolenew
	name = "circuit board (DNA machine)"
	build_path = /obj/machinery/computer/scan_consolenew
	origin_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 2)

/obj/item/circuitboard/cloning
	name = "circuit board (cloning)"
	build_path = /obj/machinery/computer/cloning
	origin_tech = list(/datum/tech/biotech = 3, /datum/tech/programming = 3)

/obj/item/circuitboard/crew
	name = "circuit board (crew monitoring computer)"
	build_path = /obj/machinery/computer/crew
	origin_tech = list(/datum/tech/magnets = 2, /datum/tech/biotech = 2, /datum/tech/programming = 3)

/obj/item/circuitboard/operating
	name = "circuit board (operating computer)"
	build_path = /obj/machinery/computer/operating
	origin_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 2)

/obj/item/circuitboard/cure_research_machine
	name = "circuit board (cure research machine)"
	build_path = /obj/machinery/computer/disease_curer

/obj/item/circuitboard/splicer
	name = "circuit board (disease splicer)"
	build_path = /obj/machinery/computer/disease_splicer

/*
 * Machines
 */
/obj/item/circuitboard/clonepod
	name = "circuit board (cloning pod)"
	build_path = /obj/machinery/clonepod
	board_type = "machine"
	origin_tech = list(/datum/tech/biotech = 3, /datum/tech/programming = 3)
	frame_desc = "Requires 2 Manipulator, 2 Scanning Module, 2 pieces of cable and 1 Console Screen."
	req_components = list(
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_part/scanning_module = 2,
		/obj/item/stock_part/manipulator = 2,
		/obj/item/stock_part/console_screen = 1
	)

/obj/item/circuitboard/clonescanner
	name = "circuit board (cloning scanner)"
	build_path = /obj/machinery/dna_scannernew
	board_type = "machine"
	origin_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 2)
	frame_desc = "Requires 1 Scanning module, 1 Micro Manipulator, 1 Micro-Laser, 2 pieces of cable and 1 Console Screen."
	req_components = list(
		/obj/item/stock_part/scanning_module = 1,
		/obj/item/stock_part/manipulator = 1,
		/obj/item/stock_part/micro_laser = 1,
		/obj/item/stock_part/console_screen = 1,
		/obj/item/stack/cable_coil = 2
	)