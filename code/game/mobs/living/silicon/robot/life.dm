/mob/living/silicon/robot/Life()
	set background = BACKGROUND_ENABLED

	. = ..()
	blinded = null

	//Status updates, death etc.
	clamp_values()
	handle_regular_status_updates()

	if(isnotnull(client))
		handle_regular_hud_updates()
		update_items()
	if(stat != DEAD) //still using power
		use_power()
		process_killswitch()
		process_locks()
	update_canmove()

/mob/living/silicon/robot/proc/clamp_values()
//	SetStunned(min(stunned, 30))
	SetParalysis(min(paralysis, 30))
//	SetWeakened(min(weakened, 20))
	sleeping = 0
	adjustBruteLoss(0)
	adjustToxLoss(0)
	adjustOxyLoss(0)
	adjustFireLoss(0)

/mob/living/silicon/robot/proc/use_power()
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		C.update_power_state()

	if(isnotnull(cell) && is_component_functioning("power cell") && cell.charge > 0)
		if(isnotnull(module_state_1))
			cell.use(3)
		if(isnotnull(module_state_2))
			cell.use(3)
		if(isnotnull(module_state_3))
			cell.use(3)

		has_power = TRUE
	else
		if(has_power)
			to_chat(src, SPAN_WARNING("You are now running on emergency backup power."))
		has_power = FALSE

/mob/living/silicon/robot/proc/handle_regular_status_updates()
	if(isnotnull(camera) && !scrambledcodes)
		if(stat == DEAD || isWireCut(5))
			camera.status = 0
		else
			camera.status = 1

	updatehealth()

	if(sleeping)
		Paralyse(3)
		sleeping--

	if(resting)
		Weaken(5)

	if(health < CONFIG_GET(health_threshold_dead) && stat != DEAD) //die only once
		death()

	if(stat != DEAD) //Alive.
		if(paralysis || stunned || weakened || !has_power) //Stunned etc.
			stat = 1
			if(stunned > 0)
				AdjustStunned(-1)
			if(weakened > 0)
				AdjustWeakened(-1)
			if(paralysis > 0)
				AdjustParalysis(-1)
				blinded = 1
			else
				blinded = 0

		else	//Not stunned.
			stat = 0

	else //Dead.
		blinded = 1
		stat = 2

	if(stuttering)
		stuttering--

	if(eye_blind)
		eye_blind--
		blinded = 1

	if(ear_deaf > 0)
		ear_deaf--
	if(ear_damage < 25)
		ear_damage -= 0.05
		ear_damage = max(ear_damage, 0)

	density = !( lying )

	if(sdisabilities & BLIND)
		blinded = 1
	if(sdisabilities & DEAF)
		ear_deaf = 1

	if(eye_blurry > 0)
		eye_blurry--
		eye_blurry = max(0, eye_blurry)

	if(druggy > 0)
		druggy--
		druggy = max(0, druggy)

	//update the state of modules and components here
	if(stat != 0)
		uneq_all()

	if(!is_component_functioning("radio"))
		radio.on = 0
	else
		radio.on = 1

	if(is_component_functioning("camera"))
		blinded = 0
	else
		blinded = 1

	if(!is_component_functioning("actuator"))
		Paralyse(3)

	return 1

/mob/living/silicon/robot/proc/handle_regular_hud_updates()
	if(stat == DEAD || (XRAY in mutations) || sight_mode & BORGXRAY)
		sight |= SEE_TURFS
		sight |= SEE_MOBS
		sight |= SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
	else if(sight_mode & BORGMESON && sight_mode & BORGTHERM)
		sight |= SEE_TURFS
		sight |= SEE_MOBS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
	else if(sight_mode & BORGMESON)
		sight |= SEE_TURFS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
	else if(sight_mode & BORGTHERM)
		sight |= SEE_MOBS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO
	else if(stat != DEAD)
		sight &= ~SEE_MOBS
		sight &= ~SEE_TURFS
		sight &= ~SEE_OBJS
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_LEVEL_TWO

	regular_hud_updates()

	var/obj/item/borg/sight/hud/hud = (locate(/obj/item/borg/sight/hud) in src)
	if(isnotnull(hud?.hud))
		hud.hud.process_hud(src)
	else
		switch(sensor_mode)
			if(SEC_HUD)
				process_sec_hud(src, 0)
			if(MED_HUD)
				process_med_hud(src, 0)

	if(isnotnull(healths))
		if(stat != DEAD)
			if(isdrone(src))
				switch(health)
					if(35 to INFINITY)
						healths.icon_state = "health0"
					if(25 to 34)
						healths.icon_state = "health1"
					if(15 to 24)
						healths.icon_state = "health2"
					if(5 to 14)
						healths.icon_state = "health3"
					if(0 to 4)
						healths.icon_state = "health4"
					if(-35 to 0)
						healths.icon_state = "health5"
					else
						healths.icon_state = "health6"
			else
				switch(health)
					if(200 to INFINITY)
						healths.icon_state = "health0"
					if(150 to 200)
						healths.icon_state = "health1"
					if(100 to 150)
						healths.icon_state = "health2"
					if(50 to 100)
						healths.icon_state = "health3"
					if(0 to 50)
						healths.icon_state = "health4"
					else
						if(health > CONFIG_GET(health_threshold_dead))
							healths.icon_state = "health5"
						else
							healths.icon_state = "health6"
		else
			healths.icon_state = "health7"

	if(syndicate && isnotnull(client))
		if(IS_GAME_MODE(/datum/game_mode/traitor))
			for(var/datum/mind/tra in global.PCticker.mode.traitors)
				if(isnotnull(tra.current))
					var/I = image('icons/mob/mob.dmi', loc = tra.current, icon_state = "traitor")
					client.images.Add(I)
		if(isnotnull(connected_ai))
			connected_ai.connected_robots.Remove(src)
			connected_ai = null
		if(isnotnull(mind))
			if(isnull(mind.special_role))
				mind.special_role = "traitor"
				global.PCticker.mode.traitors += mind

	if(isnotnull(cells))
		if(isnotnull(cell))
			var/cellcharge = cell.charge / cell.maxcharge
			switch(cellcharge)
				if(0.75 to INFINITY)
					cells.icon_state = "charge4"
				if(0.5 to 0.75)
					cells.icon_state = "charge3"
				if(0.25 to 0.5)
					cells.icon_state = "charge2"
				if(0 to 0.25)
					cells.icon_state = "charge1"
				else
					cells.icon_state = "charge0"
		else
			cells.icon_state = "charge-empty"

	if(isnotnull(bodytemp))
		switch(bodytemperature) //310.055 optimal body temp
			if(335 to INFINITY)
				bodytemp.icon_state = "temp2"
			if(320 to 335)
				bodytemp.icon_state = "temp1"
			if(300 to 320)
				bodytemp.icon_state = "temp0"
			if(260 to 300)
				bodytemp.icon_state = "temp-1"
			else
				bodytemp.icon_state = "temp-2"

	if(isnotnull(pullin))
		pullin.icon_state = "pull[pulling ? 1 : 0]"
//Oxygen and fire does nothing yet!!
//	if(oxygen) oxygen.icon_state = "oxy[oxygen_alert ? 1 : 0]"
//	if(fire) fire.icon_state = "fire[fire_alert ? 1 : 0]"

	client.screen.Remove(GLOBL.global_hud.blurry, GLOBL.global_hud.druggy, GLOBL.global_hud.vimpaired)

	if(isnotnull(blind) && stat != DEAD)
		if(blinded)
			blind.invisibility = 0 // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
		else
			blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
			if(disabilities & NEARSIGHTED)
				client.screen.Add(GLOBL.global_hud.vimpaired)

			if(eye_blurry)
				client.screen.Add(GLOBL.global_hud.blurry)

			if(druggy)
				client.screen.Add(GLOBL.global_hud.druggy)

	if(stat != DEAD)
		if(isnotnull(machine))
			if(!machine.check_eye(src))
				reset_view(null)
		else
			if(client && !client.adminobs)
				reset_view(null)

	return 1

/mob/living/silicon/robot/proc/update_items()
	if(isnotnull(client))
		client.screen.Remove(contents)
		for(var/obj/I in contents)
			if(isnotnull(I) && !(istype(I, /obj/item/cell) || isradio(I) || istype(I, /obj/machinery/camera) || istype(I, /obj/item/mmi)))
				client.screen.Add(I)
	if(isnotnull(module_state_1))
		module_state_1:screen_loc = UI_INV1
	if(isnotnull(module_state_2))
		module_state_2:screen_loc = UI_INV2
	if(isnotnull(module_state_3))
		module_state_3:screen_loc = UI_INV3
	updateicon()

/mob/living/silicon/robot/proc/process_killswitch()
	if(killswitch)
		killswitch_time --
		if(killswitch_time <= 0)
			if(isnotnull(client))
				to_chat(src, SPAN_DANGER("Killswitch activated."))
			killswitch = 0
			spawn(5)
				gib()

/mob/living/silicon/robot/proc/process_locks()
	if(weapon_lock)
		uneq_all()
		weaponlock_time --
		if(weaponlock_time <= 0)
			if(isnotnull(client))
				to_chat(src, SPAN_DANGER("Weapon Lock Timed Out!"))
			weapon_lock = FALSE
			weaponlock_time = 120

/mob/living/silicon/robot/update_canmove()
	if(paralysis || stunned || weakened || buckled || lockcharge)
		canmove = FALSE
	else
		canmove = TRUE

	return canmove