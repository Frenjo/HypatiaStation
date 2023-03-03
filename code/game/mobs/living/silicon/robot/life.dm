/mob/living/silicon/robot/Life()
	set invisibility = 0
	set background = BACKGROUND_ENABLED
	. = ..()

	blinded = null

	//Status updates, death etc.
	clamp_values()
	handle_regular_status_updates()

	if(client)
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

	if(cell && is_component_functioning("power cell") && src.cell.charge > 0)
		if(src.module_state_1)
			src.cell.use(3)
		if(src.module_state_2)
			src.cell.use(3)
		if(src.module_state_3)
			src.cell.use(3)

		src.has_power = 1
	else
		if(src.has_power)
			src << "\red You are now running on emergency backup power."
		src.has_power = 0

/mob/living/silicon/robot/proc/handle_regular_status_updates()
	if(src.camera && !scrambledcodes)
		if(src.stat == DEAD || isWireCut(5))
			src.camera.status = 0
		else
			src.camera.status = 1

	updatehealth()

	if(src.sleeping)
		Paralyse(3)
		src.sleeping--

	if(src.resting)
		Weaken(5)

	if(health < CONFIG_GET(health_threshold_dead) && src.stat != DEAD) //die only once
		death()

	if(src.stat != DEAD) //Alive.
		if(src.paralysis || src.stunned || src.weakened || !src.has_power) //Stunned etc.
			src.stat = 1
			if(src.stunned > 0)
				AdjustStunned(-1)
			if(src.weakened > 0)
				AdjustWeakened(-1)
			if(src.paralysis > 0)
				AdjustParalysis(-1)
				src.blinded = 1
			else
				src.blinded = 0

		else	//Not stunned.
			src.stat = 0

	else //Dead.
		src.blinded = 1
		src.stat = 2

	if (src.stuttering) src.stuttering--

	if (src.eye_blind)
		src.eye_blind--
		src.blinded = 1

	if (src.ear_deaf > 0) src.ear_deaf--
	if (src.ear_damage < 25)
		src.ear_damage -= 0.05
		src.ear_damage = max(src.ear_damage, 0)

	src.density = !( src.lying )

	if ((src.sdisabilities & BLIND))
		src.blinded = 1
	if ((src.sdisabilities & DEAF))
		src.ear_deaf = 1

	if (src.eye_blurry > 0)
		src.eye_blurry--
		src.eye_blurry = max(0, src.eye_blurry)

	if (src.druggy > 0)
		src.druggy--
		src.druggy = max(0, src.druggy)

	//update the state of modules and components here
	if (src.stat != 0)
		uneq_all()

	if(!is_component_functioning("radio"))
		radio.on = 0
	else
		radio.on = 1

	if(is_component_functioning("camera"))
		src.blinded = 0
	else
		src.blinded = 1

	if(!is_component_functioning("actuator"))
		src.Paralyse(3)

	return 1

/mob/living/silicon/robot/proc/handle_regular_hud_updates()
	if(src.stat == DEAD || (XRAY in mutations) || src.sight_mode & BORGXRAY)
		src.sight |= SEE_TURFS
		src.sight |= SEE_MOBS
		src.sight |= SEE_OBJS
		src.see_in_dark = 8
		src.see_invisible = SEE_INVISIBLE_MINIMUM
	else if(src.sight_mode & BORGMESON && src.sight_mode & BORGTHERM)
		src.sight |= SEE_TURFS
		src.sight |= SEE_MOBS
		src.see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
	else if(src.sight_mode & BORGMESON)
		src.sight |= SEE_TURFS
		src.see_in_dark = 8
		see_invisible = SEE_INVISIBLE_MINIMUM
	else if(src.sight_mode & BORGTHERM)
		src.sight |= SEE_MOBS
		src.see_in_dark = 8
		src.see_invisible = SEE_INVISIBLE_LEVEL_TWO
	else if(src.stat != DEAD)
		src.sight &= ~SEE_MOBS
		src.sight &= ~SEE_TURFS
		src.sight &= ~SEE_OBJS
		src.see_in_dark = 8
		src.see_invisible = SEE_INVISIBLE_LEVEL_TWO

	regular_hud_updates()

	var/obj/item/borg/sight/hud/hud = (locate(/obj/item/borg/sight/hud) in src)
	if(hud && hud.hud)
		hud.hud.process_hud(src)
	else
		switch(src.sensor_mode)
			if(SEC_HUD)
				process_sec_hud(src, 0)
			if(MED_HUD)
				process_med_hud(src, 0)

	if(src.healths)
		if(src.stat != DEAD)
			if(isdrone(src))
				switch(health)
					if(35 to INFINITY)
						src.healths.icon_state = "health0"
					if(25 to 34)
						src.healths.icon_state = "health1"
					if(15 to 24)
						src.healths.icon_state = "health2"
					if(5 to 14)
						src.healths.icon_state = "health3"
					if(0 to 4)
						src.healths.icon_state = "health4"
					if(-35 to 0)
						src.healths.icon_state = "health5"
					else
						src.healths.icon_state = "health6"
			else
				switch(health)
					if(200 to INFINITY)
						src.healths.icon_state = "health0"
					if(150 to 200)
						src.healths.icon_state = "health1"
					if(100 to 150)
						src.healths.icon_state = "health2"
					if(50 to 100)
						src.healths.icon_state = "health3"
					if(0 to 50)
						src.healths.icon_state = "health4"
					else
						if(health > CONFIG_GET(health_threshold_dead))
							src.healths.icon_state = "health5"
						else
							src.healths.icon_state = "health6"
		else
			src.healths.icon_state = "health7"

	if(src.syndicate && src.client)
		if(global.CTgame_ticker.mode.name == "traitor")
			for(var/datum/mind/tra in global.CTgame_ticker.mode.traitors)
				if(tra.current)
					var/I = image('icons/mob/mob.dmi', loc = tra.current, icon_state = "traitor")
					src.client.images += I
		if(src.connected_ai)
			src.connected_ai.connected_robots -= src
			src.connected_ai = null
		if(src.mind)
			if(!src.mind.special_role)
				src.mind.special_role = "traitor"
				global.CTgame_ticker.mode.traitors += src.mind

	if(src.cells)
		if(src.cell)
			var/cellcharge = src.cell.charge/src.cell.maxcharge
			switch(cellcharge)
				if(0.75 to INFINITY)
					src.cells.icon_state = "charge4"
				if(0.5 to 0.75)
					src.cells.icon_state = "charge3"
				if(0.25 to 0.5)
					src.cells.icon_state = "charge2"
				if(0 to 0.25)
					src.cells.icon_state = "charge1"
				else
					src.cells.icon_state = "charge0"
		else
			src.cells.icon_state = "charge-empty"

	if(bodytemp)
		switch(src.bodytemperature) //310.055 optimal body temp
			if(335 to INFINITY)
				src.bodytemp.icon_state = "temp2"
			if(320 to 335)
				src.bodytemp.icon_state = "temp1"
			if(300 to 320)
				src.bodytemp.icon_state = "temp0"
			if(260 to 300)
				src.bodytemp.icon_state = "temp-1"
			else
				src.bodytemp.icon_state = "temp-2"


	if(src.pullin)
		src.pullin.icon_state = "pull[src.pulling ? 1 : 0]"
//Oxygen and fire does nothing yet!!
//	if (src.oxygen) src.oxygen.icon_state = "oxy[src.oxygen_alert ? 1 : 0]"
//	if (src.fire) src.fire.icon_state = "fire[src.fire_alert ? 1 : 0]"

	client.screen.Remove(GLOBL.global_hud.blurry, GLOBL.global_hud.druggy, GLOBL.global_hud.vimpaired)

	if((src.blind && src.stat != DEAD))
		if(src.blinded)
			src.blind.invisibility = 0 // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
		else
			src.blind.invisibility = INVISIBILITY_MAXIMUM // Changed blind.layer to blind.invisibility to become compatible with not-2014 BYOND. -Frenjo
			if(src.disabilities & NEARSIGHTED)
				src.client.screen += GLOBL.global_hud.vimpaired

			if(src.eye_blurry)
				src.client.screen += GLOBL.global_hud.blurry

			if(src.druggy)
				src.client.screen += GLOBL.global_hud.druggy

	if(src.stat != DEAD)
		if(src.machine)
			if(!(src.machine.check_eye(src)))
				src.reset_view(null)
		else
			if(client && !client.adminobs)
				reset_view(null)

	return 1

/mob/living/silicon/robot/proc/update_items()
	if(src.client)
		src.client.screen -= src.contents
		for(var/obj/I in src.contents)
			if(I && !(istype(I, /obj/item/weapon/cell) || isradio(I) || istype(I, /obj/machinery/camera) || istype(I, /obj/item/device/mmi)))
				src.client.screen += I
	if(src.module_state_1)
		src.module_state_1:screen_loc = UI_INV1
	if(src.module_state_2)
		src.module_state_2:screen_loc = UI_INV2
	if(src.module_state_3)
		src.module_state_3:screen_loc = UI_INV3
	updateicon()

/mob/living/silicon/robot/proc/process_killswitch()
	if(killswitch)
		killswitch_time --
		if(killswitch_time <= 0)
			if(src.client)
				src << "\red <B>Killswitch Activated"
			killswitch = 0
			spawn(5)
				gib()

/mob/living/silicon/robot/proc/process_locks()
	if(weapon_lock)
		uneq_all()
		weaponlock_time --
		if(weaponlock_time <= 0)
			if(src.client)
				to_chat(src, SPAN_DANGER("Weapon Lock Timed Out!"))
			weapon_lock = 0
			weaponlock_time = 120

/mob/living/silicon/robot/update_canmove()
	if(paralysis || stunned || weakened || buckled || lockcharge)
		canmove = FALSE
	else
		canmove = TRUE

	return canmove