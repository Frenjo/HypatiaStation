/*
 * AI Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/aiupload
	name = "circuit board (AI Upload)"
	build_path = /obj/machinery/computer/aiupload
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4)

/obj/item/circuitboard/borgupload
	name = "circuit board (Cyborg Upload)"
	build_path = /obj/machinery/computer/borgupload
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4)

/obj/item/circuitboard/aifixer
	name = "circuit board (AI Integrity Restorer)"
	build_path = /obj/machinery/computer/aifixer
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 3, RESEARCH_TECH_BIOTECH = 2)

/*
 * Machines
 */
/obj/item/circuitboard/aicore
	name = "circuit board (AI core)"
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 4, RESEARCH_TECH_BIOTECH = 2)
	board_type = "other"