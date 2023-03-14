/mob/living/silicon/decoy/death(gibbed)
	if(stat == DEAD)
		return
	icon_state = "ai-crash"
	spawn(10)
		explosion(loc, 3, 6, 12, 15)

	var/obj/machinery/computer/communications/comms = locate() in GLOBL.communications_consoles // Change status.
	comms?.post_status("bsod")
	return ..(gibbed)