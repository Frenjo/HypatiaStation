/*
 * AI Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/aiupload
	name = "circuit board (AI upload)"
	build_path = /obj/machinery/computer/aiupload
	origin_tech = list(/decl/tech/programming = 4)

/obj/item/circuitboard/borgupload
	name = "circuit board (cyborg upload)"
	build_path = /obj/machinery/computer/borgupload
	origin_tech = list(/decl/tech/programming = 4)

/obj/item/circuitboard/aifixer
	name = "circuit board (AI integrity restorer)"
	build_path = /obj/machinery/computer/aifixer
	origin_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 3)

/*
 * Machines
 */
/obj/item/circuitboard/aicore
	name = "circuit board (AI core)"
	origin_tech = list(/decl/tech/biotech = 2, /decl/tech/programming = 4)
	board_type = "other"