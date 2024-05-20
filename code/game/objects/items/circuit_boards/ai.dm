/*
 * AI Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/aiupload
	name = "circuit board (AI Upload)"
	build_path = /obj/machinery/computer/aiupload
	origin_tech = list(/datum/tech/programming = 4)

/obj/item/circuitboard/borgupload
	name = "circuit board (Cyborg Upload)"
	build_path = /obj/machinery/computer/borgupload
	origin_tech = list(/datum/tech/programming = 4)

/obj/item/circuitboard/aifixer
	name = "circuit board (AI Integrity Restorer)"
	build_path = /obj/machinery/computer/aifixer
	origin_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 3)

/*
 * Machines
 */
/obj/item/circuitboard/aicore
	name = "circuit board (AI core)"
	origin_tech = list(/datum/tech/biotech = 2, /datum/tech/programming = 4)
	board_type = "other"