/mob/living/silicon/ai/death(gibbed)
	if(stat == DEAD)
		return

	if(custom_sprite)//check for custom AI sprite, defaulting to blue screen if no.
		icon_state = "[ckey]-ai-crash"

	eyeobj?.setLoc(get_turf(src))

	var/callshuttle = 0

	for(var/obj/machinery/computer/communications/commconsole in world)
		if(commconsole.z == 2)
			continue
		if(isturf(commconsole.loc))
			break
		callshuttle++

	for(var/obj/item/weapon/circuitboard/communications/commboard in world)
		if(commboard.z == 2)
			continue
		if(isturf(commboard.loc) || istype(commboard.loc, /obj/item/weapon/storage))
			break
		callshuttle++

	for(var/mob/living/silicon/ai/shuttlecaller in GLOBL.player_list)
		if(shuttlecaller.z == 2)
			continue
		if(!shuttlecaller.stat && !isnull(shuttlecaller.client) && isturf(shuttlecaller.loc))
			break
		callshuttle++

	if(global.CTgame_ticker.mode.name == "revolution" || global.CTgame_ticker.mode.name == "AI malfunction" || GLOBL.sent_strike_team)
		callshuttle = 0

	if(callshuttle == 3) //if all three conditions are met
		global.CTemergency.call_evac()
		log_game("All the AIs, comm consoles and boards are destroyed. Shuttle called.")
		message_admins("All the AIs, comm consoles and boards are destroyed. Shuttle called.", 1)
		captain_announce("The emergency shuttle has been called. It will arrive in [round(global.CTemergency.estimate_arrival_time() / 60)] minutes.")
		world << sound('sound/AI/shuttlecalled.ogg')

	if(explosive)
		spawn(10)
			explosion(src.loc, 3, 6, 12, 15)

	var/obj/machinery/computer/communications/comms = locate() in GLOBL.communications_consoles // Change status.
	comms?.post_status("ai_emotion", "BSOD")
	if(istype(loc, /obj/item/device/aicard))
		loc.icon_state = "aicard-404"

	tod = worldtime2text() //weasellos time of death patch
	if(mind)
		mind.store_memory("Time of death: [tod]", 0)

	return ..(gibbed)