/mob/living/silicon/ai/Logout()
	. = ..()
	var/obj/machinery/computer/communications/comms = pick(GLOBL.communications_consoles) // Change status.
	comms?.post_status("ai_emotion", "Blank")
	if(!isturf(loc))
		if(isnotnull(client))
			client.eye = loc
			client.perspective = EYE_PERSPECTIVE
	view_core()