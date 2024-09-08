/mob/living/silicon/ai/Life()
	if(stat == DEAD)
		return

	// Being dead doesn't mean your temperature never changes
	if(stat != CONSCIOUS)
		cameraFollow = null
		reset_view(null)
		unset_machine()

	updatehealth()

	if(isnotnull(malfhack))
		if(malfhack.aidisabled)
			to_chat(src, SPAN_WARNING("ERROR: APC access disabled, hack attempt cancelled."))
			malfhacking = 0
			malfhack = null

	if(health <= CONFIG_GET(health_threshold_dead))
		death()
		return

	if(isnotnull(machine) && !machine.check_eye(src))
		reset_view(null)

	// Handle power damage (oxy)
	if(aiRestorePowerRoutine != 0)
		// Lost power
		adjustOxyLoss(1)
	else
		// Gain Power
		adjustOxyLoss(-1)

	power_supply?.update_power()
	check_power_status()

	regular_hud_updates()
	switch(sensor_mode)
		if(SEC_HUD)
			process_sec_hud(src, 0, eyeobj)
		if(MED_HUD)
			process_med_hud(src, 0, eyeobj)

/mob/living/silicon/ai/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
	else
		if(fire_res_on_core)
			health = 100 - getOxyLoss() - getToxLoss() - getBruteLoss()
		else
			health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()

/mob/living/silicon/ai/proc/check_power_status()
	var/has_power = TRUE
	var/area/current_area = get_area(src)
	if(!current_area.powered(EQUIP) && !isitem(loc))
		has_power = FALSE

	if(has_power)
		sight |= SEE_TURFS
		sight |= SEE_MOBS
		sight |= SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO

		//Congratulations!  You've found a way for AI's to run without using power!
		//Todo:  Without snowflaking up master_controller procs find a way to make AI use_power but only when APC's clear the area usage the tick prior
		//       since mobs are in master_controller before machinery.  We also have to do it in a manner where we don't reset the entire area's need to update
		//	 the power usage.
		//
		//	 We can probably create a new machine that resides inside of the AI contents that uses power using the idle_usage of 1000 and nothing else and
		//       be fine.

		if(aiRestorePowerRoutine == 2)
			to_chat(src, "Alert cancelled. Power has been restored without our assistance.")
			aiRestorePowerRoutine = 0
			blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
			return
		else if(aiRestorePowerRoutine == 3)
			to_chat(src, "Alert cancelled. Power has been restored.")
			aiRestorePowerRoutine = 0
			blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
			return
	else
		blind.screen_loc = "1,1 to 15,15"
		if(blind.layer != 18)
			blind.invisibility = 0 // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
		sight = sight & ~SEE_TURFS
		sight = sight & ~SEE_MOBS
		sight = sight & ~SEE_OBJS
		see_in_dark = 0
		see_invisible = SEE_INVISIBLE_LIVING

		handle_power_loss()

/mob/living/silicon/ai/proc/handle_power_loss()
	set waitfor = FALSE

	var/area/current_area = get_area(src)
	var/turf/current_turf = GET_TURF(src)
	if(current_area.powered(EQUIP) || isspace(current_turf) || isitem(loc))
		return

	if(aiRestorePowerRoutine == 0)
		aiRestorePowerRoutine = 1

		to_chat(src, "You've lost power!")
		//to_world("DEBUG CODE TIME! [current_area] is the area the AI is sucking power from")
		if(!is_special_character(src))
			set_zeroth_law("")
		//clear_supplied_laws() // Don't reset our laws.
		//var/time = time2text(world.realtime,"hh:mm:ss")
		//lawchanges.Add("[time] <b>:</b> [name]'s noncore laws have been reset due to power failure")
		spawn(20)
			to_chat(src, "Backup battery online. Scanners, camera, and radio interface offline. Beginning fault-detection.")
			sleep(50)
			if(current_area.powered(EQUIP))
				if(!isspace(current_turf))
					to_chat(src, "Alert cancelled. Power has been restored without our assistance.")
					aiRestorePowerRoutine = 0
					blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
					return
			to_chat(src, "Fault confirmed: missing external power. Shutting down main control system to save power.")
			sleep(20)
			to_chat(src, "Emergency control system online. Verifying connection to power network.")
			sleep(50)
			if(isspace(current_turf))
				to_chat(src, "Unable to verify! No power connection detected!")
				aiRestorePowerRoutine = 2
				return
			to_chat(src, "Connection verified. Searching for APC in power network.")
			sleep(50)
			var/obj/machinery/power/apc/target_apc = null

			var/PRP //like ERP with the code, at least this stuff is no more 4x sametext
			for(PRP = 1, PRP <= 4, PRP++)
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
					aiRestorePowerRoutine = 2
					return

				if(current_area.powered(EQUIP))
					if(!isspace(current_turf))
						to_chat(src, "Alert cancelled. Power has been restored without our assistance.")
						aiRestorePowerRoutine = 0
						// Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
						blind.invisibility = INVISIBILITY_MAXIMUM //This, too, is a fix to issue 603
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
						sleep(50)
						to_chat(src, "Receiving control information from APC.")
						sleep(2)
						//bring up APC dialog
						target_apc.attack_ai(src)
						aiRestorePowerRoutine = 3
						to_chat(src, "Here are your current laws:")
						show_laws()
				sleep(50)
				target_apc = null