/client/proc/triple_ai()
	set category = PANEL_FUN
	set name = "Create AI Triumvirate"

	if(global.CTticker.current_state > GAME_STATE_PREGAME)
		to_chat(usr, "This option is currently only usable during pregame. This may change at a later date.")
		return

	if(global.CTjobs && global.CTticker)
		var/datum/job/job = global.CTjobs.get_job("AI")
		if(!job)
			to_chat(usr, "Unable to locate the AI job")
			return
		if(global.CTticker.triai)
			global.CTticker.triai = 0
			to_chat(usr, "Only one AI will be spawned at round start.")
			message_admins("\blue [key_name_admin(usr)] has toggled off triple AIs at round start.", 1)
		else
			global.CTticker.triai = 1
			to_chat(usr, "There will be an AI Triumvirate at round start.")
			message_admins("\blue [key_name_admin(usr)] has toggled on triple AIs at round start.", 1)
	return
