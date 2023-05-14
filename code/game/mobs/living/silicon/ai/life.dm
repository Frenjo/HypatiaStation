/mob/living/silicon/ai/Life()
	if(stat == DEAD)
		return
	else //I'm not removing that shitton of tabs, unneeded as they are. -- Urist
		//Being dead doesn't mean your temperature never changes
		var/turf/T = get_turf(src)

		if(stat != CONSCIOUS)
			cameraFollow = null
			reset_view(null)
			unset_machine()

		updatehealth()

		if(malfhack)
			if(malfhack.aidisabled)
				to_chat(src, SPAN_WARNING("ERROR: APC access disabled, hack attempt cancelled."))
				malfhacking = 0
				malfhack = null

		if(health <= CONFIG_GET(health_threshold_dead))
			death()
			return

		if(!isnull(machine))
			if(!machine.check_eye(src))
				reset_view(null)

		// Handle power damage (oxy)
		if(aiRestorePowerRoutine != 0)
			// Lost power
			adjustOxyLoss(1)
		else
			// Gain Power
			adjustOxyLoss(-1)

		//stage = 1
		//if (istype(src, /mob/living/silicon/ai)) // Are we not sure what we are?
		var/blind = 0
		//stage = 2
		var/area/loc = null
		if(isturf(T))
			//stage = 3
			loc = T.loc
			if(isarea(loc))
				//stage = 4
				//if (!loc.master.power_equip && !isitem(loc))
				if(!loc.power_equip && !isitem(loc))
					//stage = 5
					blind = 1

		if(!blind)	//lol? if(!blind)	#if(blind.layer)    <--something here is clearly wrong :P
					//I'll get back to this when I find out  how this is -supposed- to work ~Carn //removed this shit since it was confusing as all hell --39kk9t
			//stage = 4.5
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
/*
			var/area/home = get_area(src)
			if(!home)	return//something to do with malf fucking things up I guess. <-- aisat is gone. is this still necessary? ~Carn
			if(home.powered(EQUIP))
				home.use_power(1000, EQUIP)
*/

			if(aiRestorePowerRoutine == 2)
				to_chat(src, "Alert cancelled. Power has been restored without our assistance.")
				aiRestorePowerRoutine = 0
				src.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
				return
			else if(aiRestorePowerRoutine == 3)
				to_chat(src, "Alert cancelled. Power has been restored.")
				aiRestorePowerRoutine = 0
				src.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
				return
		else

			//stage = 6
			src.blind.screen_loc = "1,1 to 15,15"
			if(src.blind.layer != 18)
				src.blind.invisibility = 0 // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
			sight = sight&~SEE_TURFS
			sight = sight&~SEE_MOBS
			sight = sight&~SEE_OBJS
			see_in_dark = 0
			see_invisible = SEE_INVISIBLE_LIVING

			//if (((!loc.master.power_equip) || isspace(T)) && !isitem(loc))
			if((!loc.power_equip || isspace(T)) && !isitem(loc))
				if(aiRestorePowerRoutine == 0)
					aiRestorePowerRoutine = 1

					to_chat(src, "You've lost power!")
//							world << "DEBUG CODE TIME! [loc] is the area the AI is sucking power from"
					if(!is_special_character(src))
						set_zeroth_law("")
					//clear_supplied_laws() // Don't reset our laws.
					//var/time = time2text(world.realtime,"hh:mm:ss")
					//lawchanges.Add("[time] <b>:</b> [name]'s noncore laws have been reset due to power failure")
					spawn(20)
						to_chat(src, "Backup battery online. Scanners, camera, and radio interface offline. Beginning fault-detection.")
						sleep(50)
						//if (loc.master.power_equip)
						if(loc.power_equip)
							if(!isspace(T))
								to_chat(src, "Alert cancelled. Power has been restored without our assistance.")
								aiRestorePowerRoutine = 0
								src.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
								return
						to_chat(src, "Fault confirmed: missing external power. Shutting down main control system to save power.")
						sleep(20)
						to_chat(src, "Emergency control system online. Verifying connection to power network.")
						sleep(50)
						if(isspace(T))
							to_chat(src, "Unable to verify! No power connection detected!")
							aiRestorePowerRoutine = 2
							return
						to_chat(src, "Connection verified. Searching for APC in power network.")
						sleep(50)
						var/obj/machinery/power/apc/theAPC = null
/*
						for (var/something in loc)
							if (istype(something, /obj/machinery/power/apc))
								if (!(something:stat & BROKEN))
									theAPC = something
									break
*/
						var/PRP //like ERP with the code, at least this stuff is no more 4x sametext
						for(PRP = 1, PRP <= 4, PRP++)
							var/area/AIarea = get_area(src)
							//for(var/area/A in AIarea.master.related)
							//	for (var/obj/machinery/power/apc/APC in A)
							//		if (!(APC.stat & BROKEN))
							//			theAPC = APC
							//			break
							for(var/obj/machinery/power/apc/APC in AIarea)
								if(!(APC.stat & BROKEN))
									theAPC = APC
									break
							if(!theAPC)
								switch(PRP)
									if(1)
										to_chat(src, "Unable to locate APC!")
									else
										to_chat(src, "Lost connection with the APC!")
								aiRestorePowerRoutine = 2
								return
							//if (loc.master.power_equip)
							if(loc.power_equip)
								if(!isspace(T))
									to_chat(src, "Alert cancelled. Power has been restored without our assistance.")
									aiRestorePowerRoutine = 0
									// Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
									src.blind.invisibility = INVISIBILITY_MAXIMUM //This, too, is a fix to issue 603
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
									theAPC.attack_ai(src)
									aiRestorePowerRoutine = 3
									to_chat(src, "Here are your current laws:")
									show_laws()
							sleep(50)
							theAPC = null

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