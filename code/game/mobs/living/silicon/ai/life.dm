/mob/living/silicon/ai/Life()
	if(stat == DEAD)
		return

	// Being dead doesn't mean your temperature never changes
	if(stat != CONSCIOUS)
		cameraFollow = null
		reset_view(null)
		unset_machine()

	updatehealth()

	if(malfhack?.aidisabled)
		to_chat(src, SPAN_WARNING("ERROR: APC access disabled, hack attempt cancelled."))
		malfhacking = 0
		malfhack = null

	if(health <= CONFIG_GET(/decl/configuration_entry/health_threshold_dead))
		death()
		return

	if(isnotnull(machine) && !machine.check_eye(src))
		reset_view(null)

	// Handles power damage (oxy)
	if(aiRestorePowerRoutine != AI_POWER_RESTORATION_OFF)
		// Loses power
		adjustOxyLoss(1)
	else
		// Gains power
		adjustOxyLoss(-1)

	check_power_status()

	regular_hud_updates()
	switch(sensor_mode)
		if(SILICON_HUD_SECURITY)
			process_sec_hud(src, 0, eyeobj)
		if(SILICON_HUD_MEDICAL)
			process_med_hud(src, 0, eyeobj)

/mob/living/silicon/ai/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
	else
		if(fire_res_on_core)
			health = maxHealth - getOxyLoss() - getToxLoss() - getBruteLoss()
		else
			health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()

/mob/living/silicon/ai/proc/update_power_status()
	. = FALSE
	if(isspace(loc)) // There's no power in space.
		return .
	if(isitem(loc)) // If we're carded we have power.
		. = TRUE
	var/area/current_area = GET_AREA(src)
	if(current_area.powered(EQUIP)) // If our area is powered then we have power.
		. = TRUE

	if(.) // If we have power, actually use some power.
		current_area.use_power(1000, EQUIP)

/mob/living/silicon/ai/proc/check_power_status()
	if(update_power_status())
		sight |= SEE_TURFS
		sight |= SEE_MOBS
		sight |= SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO

		if(aiRestorePowerRoutine)
			restore_power()
	else
		blind.screen_loc = "1,1 to 15,15"
		blind.invisibility = 0
		sight &= ~SEE_TURFS
		sight &= ~SEE_MOBS
		sight &= ~SEE_OBJS
		see_in_dark = 0
		see_invisible = SEE_INVISIBLE_LIVING

		handle_power_loss()

/mob/living/silicon/ai/proc/handle_power_loss()
	set waitfor = FALSE

	var/area/current_area = GET_AREA(src)
	var/turf/current_turf = GET_TURF(src)
	if(current_area.powered(EQUIP) || isspace(current_turf) || isitem(loc))
		return

	if(!aiRestorePowerRoutine)
		aiRestorePowerRoutine = AI_POWER_RESTORATION_START

		to_chat(src, "You've lost power!")
		to_chat(src, "Backup battery online. Scanners, camera, and radio interface offline. Beginning fault-detection.")
		sleep(5 SECONDS)
		if(current_area.powered(EQUIP))
			restore_power()
			return

		to_chat(src, "Fault confirmed: missing external power. Shutting down main control system to save power.")
		sleep(2 SECONDS)
		to_chat(src, "Emergency control system online. Verifying connection to power network.")
		sleep(5 SECONDS)
		if(isspace(current_turf))
			to_chat(src, "Unable to verify! No power connection detected!")
			aiRestorePowerRoutine = AI_POWER_RESTORATION_SEARCH
			return

		to_chat(src, "Connection verified. Searching for APC in power network.")
		sleep(5 SECONDS)

		var/obj/machinery/power/apc/target_apc = null
		var/PRP //like ERP with the code, at least this stuff is no more 4x sametext
		for(PRP in 1 to 4)
			for(var/obj/machinery/power/apc/temp_apc in current_area)
				if(!(temp_apc.stat & BROKEN))
					target_apc = temp_apc
					break
			if(isnull(target_apc))
				switch(PRP)
					if(1)
						to_chat(src, "Unable to locate APC!")
					else
						to_chat(src, "Lost connection with the APC!")
				aiRestorePowerRoutine = AI_POWER_RESTORATION_SEARCH
				return

			if(current_area.powered(EQUIP))
				restore_power()
				return

			switch(PRP)
				if(1)
					to_chat(src, "APC located. Optimising route to APC to avoid needless power waste.")
				if(2)
					to_chat(src, "Best route identified. Hacking offline APC power port.")
				if(3)
					to_chat(src, "Power port upload access confirmed. Loading control program into APC power port software.")
				if(4)
					to_chat(src, "Transfer complete. Forcing APC to execute program.")
					sleep(5 SECONDS)
					to_chat(src, "Receiving control information from APC.")
					sleep(0.2 SECONDS)
					//bring up APC dialog
					target_apc.attack_ai(src)
					aiRestorePowerRoutine = AI_POWER_RESTORATION_FOUND
					to_chat(src, "Here are your current laws:")
					show_laws()
			sleep(5 SECONDS)
			target_apc = null

/mob/living/silicon/ai/proc/restore_power()
	if(!aiRestorePowerRoutine)
		return
	if(isspace(loc))
		return

	if(aiRestorePowerRoutine == AI_POWER_RESTORATION_FOUND)
		to_chat(src, "Alert cancelled. Power has been restored.")
	else
		to_chat(src, "Alert cancelled. Power has been restored without our assistance.")

	aiRestorePowerRoutine = AI_POWER_RESTORATION_OFF
	blind.invisibility = INVISIBILITY_MAXIMUM // This, too, is a fix to issue 603.