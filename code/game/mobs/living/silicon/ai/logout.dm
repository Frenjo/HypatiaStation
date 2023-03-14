/mob/living/silicon/ai/Logout()
	. = ..()
	var/obj/machinery/computer/communications/comms = locate() in GLOBL.machines // Change status.
	comms?.post_status("blank")
	if(!isturf(loc))
		if(!isnull(client))
			client.eye = loc
			client.perspective = EYE_PERSPECTIVE
	view_core()