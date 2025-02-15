/*
 * Command Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/communications
	name = "circuit board (communications console)"
	build_path = /obj/machinery/computer/communications
	origin_tech = list(/decl/tech/magnets = 2, /decl/tech/programming = 2)

/obj/item/circuitboard/communications/Destroy()
	. = ..()
	for_no_type_check(var/obj/machinery/computer/communications/commconsole, GLOBL.communications_consoles)
		if(isturf(commconsole.loc))
			return

	for(var/obj/item/circuitboard/communications/commboard in GLOBL.movable_atom_list)
		if((isturf(commboard.loc) || istype(commboard.loc, /obj/item/storage)) && commboard != src)
			return

	for(var/mob/living/silicon/ai/shuttlecaller in GLOBL.player_list)
		if(!shuttlecaller.stat && isnotnull(shuttlecaller.client) && isturf(shuttlecaller.loc))
			return

	if(IS_GAME_MODE(/datum/game_mode/revolution) || IS_GAME_MODE(/datum/game_mode/malfunction) || GLOBL.sent_strike_team)
		return

	global.PCemergency.call_evac()
	log_game("All the AIs, comm consoles and boards are destroyed. Shuttle called.")
	message_admins("All the AIs, comm consoles and boards are destroyed. Shuttle called.", 1)

/obj/item/circuitboard/card
	name = "circuit board (id computer)"
	build_path = /obj/machinery/computer/card

/obj/item/circuitboard/card/centcom
	name = "circuit board (centcom id computer)"
	build_path = /obj/machinery/computer/card/centcom

/obj/item/circuitboard/teleporter
	name = "circuit board (teleporter control computer)"
	build_path = /obj/machinery/computer/teleporter
	origin_tech = list(/decl/tech/programming = 2, /decl/tech/bluespace = 2)

/obj/item/circuitboard/skills
	name = "circuit board (employment records)"
	build_path = /obj/machinery/computer/skills