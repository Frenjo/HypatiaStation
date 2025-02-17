/*
 * AI Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/aiupload
	name = "circuit board (AI upload console)"
	matter_amounts = /datum/design/circuit/aiupload::materials
	origin_tech = /datum/design/circuit/aiupload::req_tech
	build_path = /obj/machinery/computer/aiupload

/obj/item/circuitboard/borgupload
	name = "circuit board (cyborg upload console)"
	matter_amounts = /datum/design/circuit/borgupload::materials
	origin_tech = /datum/design/circuit/borgupload::req_tech
	build_path = /obj/machinery/computer/borgupload

/obj/item/circuitboard/aifixer
	name = "circuit board (AI system integrity restorer)"
	matter_amounts = /datum/design/circuit/aifixer::materials
	origin_tech = /datum/design/circuit/aifixer::req_tech
	build_path = /obj/machinery/computer/aifixer

/*
 * Machines
 */
/obj/item/circuitboard/aicore
	name = "circuit board (AI core)"
	matter_amounts = /datum/design/circuit/aicore::materials
	origin_tech = /datum/design/circuit/aicore::req_tech
	board_type = "other"