/mob/living/silicon/pai/Life()
	if(stat == DEAD)
		return

	if(isnotnull(cable))
		if(get_dist(src, cable) > 1)
			visible_message(
				SPAN_NOTICE("\The [cable] rapidly retracts back into its spool."),
				SPAN_NOTICE("Your [cable] rapidly retracts back into its spool."),
				SPAN_INFO("You hear a click and the sound of wire spooling rapidly.")
			)
			qdel(cable)

	regular_hud_updates()

	if(secHUD)
		process_sec_hud(src, 1)

	if(medHUD)
		process_med_hud(src, 1)

	if(silence_time)
		if(world.timeofday >= silence_time)
			silence_time = null
			to_chat(src, SPAN_ALIUM("Communication circuit reinitialized. Speech and messaging functionality restored."))

	if(health <= 0)
		death(null, "gives one shrill beep before falling lifeless.")

/mob/living/silicon/pai/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
	else
		health = 100 - getBruteLoss() - getFireLoss()