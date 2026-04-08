/*
 * AI Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/ai_upload
	name = "circuit board (AI upload console)"
	matter_amounts = /datum/design/circuit/ai_upload::materials
	origin_tech = /datum/design/circuit/ai_upload::req_tech
	build_path = /obj/machinery/computer/ai_upload

/obj/item/circuitboard/robot_upload
	name = "circuit board (robot upload console)"
	matter_amounts = /datum/design/circuit/robot_upload::materials
	origin_tech = /datum/design/circuit/robot_upload::req_tech
	build_path = /obj/machinery/computer/robot_upload

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