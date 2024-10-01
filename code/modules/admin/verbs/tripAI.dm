/client/proc/triple_ai()
	set category = PANEL_FUN
	set name = "Create AI Triumvirate"

	if(isnull(global.CTjobs) || isnull(global.PCticker))
		return

	if(global.PCticker.current_state > GAME_STATE_PREGAME)
		to_chat(usr, "This option is currently only usable during pregame. This may change at a later date.")
		return

	var/datum/job/job = global.CTjobs.get_job("AI")
	if(isnull(job))
		to_chat(usr, "Unable to locate the AI job")
		return

	global.PCticker.triai = !global.PCticker.triai
	to_chat(usr, "[global.PCticker.triai ? "There will be an AI Triumvirate" : "Only one AI will be spawned"] at round start.")
	message_admins(SPAN_INFO("[key_name_admin(usr)] has toggled [global.PCticker.triai ? "on" : "off"] triple AIs at round start."), 1)