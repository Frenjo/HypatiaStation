/mob/living/silicon/ai/death(gibbed)
	if(stat == DEAD)
		return

	if(custom_sprite)//check for custom AI sprite, defaulting to blue screen if no.
		icon_state = "[ckey]-ai-crash"

	eyeobj?.setLoc(GET_TURF(src))

	var/callshuttle = 0

	for_no_type_check(var/obj/machinery/computer/communications/commconsole, GLOBL.communications_consoles)
		if(commconsole.z == 2)
			continue
		if(isturf(commconsole.loc))
			break
		callshuttle++

	for(var/obj/item/circuitboard/communications/commboard in GLOBL.movable_atom_list)
		if(commboard.z == 2)
			continue
		if(isturf(commboard.loc) || istype(commboard.loc, /obj/item/storage))
			break
		callshuttle++

	for(var/mob/living/silicon/ai/shuttlecaller in GLOBL.player_list)
		if(shuttlecaller.z == 2)
			continue
		if(!shuttlecaller.stat && isnotnull(shuttlecaller.client) && isturf(shuttlecaller.loc))
			break
		callshuttle++

	if(IS_GAME_MODE(/datum/game_mode/revolution) || IS_GAME_MODE(/datum/game_mode/malfunction) || GLOBL.sent_strike_team)
		callshuttle = 0

	if(callshuttle == 3) //if all three conditions are met
		global.PCemergency.call_evac()
		log_game("All the AIs, comm consoles and boards are destroyed. Shuttle called.")
		message_admins("All the AIs, comm consoles and boards are destroyed. Shuttle called.", 1)
		captain_announce("The emergency shuttle has been called. It will arrive in [round(global.PCemergency.estimate_arrival_time() / 60)] minutes.")
		world << sound('sound/AI/shuttlecalled.ogg')

	if(explosive)
		spawn(10)
			explosion(src.loc, 3, 6, 12, 15)

	var/obj/machinery/computer/communications/comms = pick(GLOBL.communications_consoles) // Change status.
	comms?.post_status("ai_emotion", "BSOD")
	if(istype(loc, /obj/item/aicard))
		loc.icon_state = "aicard-404"

	tod = worldtime2text() //weasellos time of death patch
	mind?.store_memory("Time of death: [tod]", 0)

	return ..(gibbed)