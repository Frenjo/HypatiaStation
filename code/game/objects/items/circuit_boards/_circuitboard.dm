/*
 * Circuit Board
 *
 * Common Parts: Igniter, timer, infra-red laser, infra-red sensor, t_scanner, capacitor,
 * valve, sensor unit, micro-manipulator, console screen, beaker, micro-laser, matter bin, power cells.
 *
 * Note: Once everything is added to the public areas, will add m_amt and g_amt to circuit boards since autolathe won't be able
 * to destroy them and players will be able to make replacements.
 */
/obj/item/circuitboard
	name = "circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "id_mod"
	item_state = "electronic"

	density = FALSE
	anchored = FALSE

	w_class = 2.0

	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)

	var/id = null
	var/frequency = null
	var/build_path = null
	var/board_type = "computer"
	var/list/req_components = null
	var/powernet = null
	var/list/records = null
	var/frame_desc = null
	var/contain_parts = TRUE