/mob/living/silicon/robot/New(loc, unfinished = 0)
	. = ..()

	spark_system = new /datum/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	ident = rand(1, 999)

	laws = new default_law_type()
	connected_ai = select_active_ai_with_fewest_borgs()
	if(isnotnull(connected_ai) && (isdrone(src) || lawupdate))
		connected_ai.connected_robots.Add(src)
		lawsync()

	if(isnull(radio))
		radio = new /obj/item/radio/borg(src)
	if(!scrambledcodes && isnull(camera))
		camera = new /obj/machinery/camera(src)
		camera.c_tag = real_name
		camera.network = list("SS13","Robots")
		if(isWireCut(5)) // 5 = BORG CAMERA
			camera.status = 0

	transform_to_model(/obj/item/robot_model/default)
	updatename()
	updateicon()

	initialize_components()
	//if(!unfinished)
	// Create all the robot parts.
	for(var/V in components)
		if(V != "power cell")
			var/datum/robot_component/C = components[V]
			C.installed = 1
			C.wrapped = new C.external_type()

	if(isnull(cell))
		cell = new /obj/item/cell/apc(src)

	if(isnotnull(cell))
		var/datum/robot_component/cell_component = components["power cell"]
		cell_component.wrapped = cell
		cell_component.installed = 1

	hud_list[HEALTH_HUD]		= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[STATUS_HUD]		= image('icons/hud/hud.dmi', src, "hudhealth100")
	hud_list[ID_HUD]			= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[WANTED_HUD]		= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[IMPSHIELD_HUD]		= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[IMPLOYAL_HUD]		= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[IMPCHEM_HUD]		= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[IMPTRACK_HUD]		= image('icons/hud/hud.dmi', src, "hudblank")
	hud_list[SPECIALROLE_HUD]	= image('icons/hud/hud.dmi', src, "hudblank")

	if(isdrone(src))
		playsound(src, 'sound/machines/twobeep.ogg', 50, 0)
	else
		playsound(loc, 'sound/voice/liveagain.ogg', 75, 1)

//If there's an MMI in the robot, have it ejected when the mob goes away. --NEO
//Improved /N
/mob/living/silicon/robot/Destroy()
	if(isnotnull(mmi) && isnotnull(mind)) // Safety for when a cyborg gets dust()ed. Or there is no MMI inside.
		var/turf/T = GET_TURF(src) // To hopefully prevent run time errors.
		if(isnotnull(T))
			mmi.forceMove(T)
		if(isnotnull(mmi.brainmob))
			mind.transfer_to(mmi.brainmob)
		else
			to_chat(src, SPAN_DANGER("Oops! Something went very wrong, your MMI was unable to receive your mind. You have been ghosted. Please make a bug report so we can fix this bug."))
			ghostize()
			// ERROR("A borg has been destroyed, but its MMI lacked a brainmob, so the mind could not be transferred. Player: [ckey].")
		mmi = null
	connected_ai?.connected_robots.Remove(src)
	return ..()

// this function shows information about the malf_ai gameplay type in the status screen
/mob/living/silicon/robot/show_malf_ai()
	. = ..()
	if(IS_GAME_MODE(/datum/game_mode/malfunction))
		var/datum/game_mode/malfunction/malf = global.PCticker.mode
		for_no_type_check(var/datum/mind/malfai, malf.malf_ai)
			if(connected_ai?.mind == malfai)
				if(malf.apcs >= 3)
					stat(null, "Time until station control secured: [max(malf.AI_win_timeleft / (malf.apcs / 3), 0)] seconds")
			else if(malf.malf_mode_declared)
				stat(null, "Time left: [max(malf.AI_win_timeleft / (malf.apcs / 3), 0)]")
	return 0

// update the status screen display
/mob/living/silicon/robot/Stat()
	. = ..()
	statpanel(PANEL_STATUS)
	if(client.statpanel == PANEL_STATUS)
		show_cell_power()
		show_jetpack_pressure()

/mob/living/silicon/robot/meteorhit(obj/O)
	visible_message(SPAN_DANGER("[src] has been hit by [O]!"))
	if(health > 0)
		adjustBruteLoss(30)
		if((O.icon_state == "flaming"))
			adjustFireLoss(40)
		updatehealth()

/mob/living/silicon/robot/bullet_act(obj/item/projectile/proj)
	..(proj)
	if(prob(75) && proj.damage > 0)
		spark_system.start()
	return 2

/mob/living/silicon/robot/triggerAlarm(class, area/A, list/cameralist, source)
	if(stat == DEAD)
		return
	. = ..()

/mob/living/silicon/robot/cancelAlarm(class, area/A, obj/origin)
	var/has_alarm = ..()

	if(!has_alarm)
		queueAlarm("--- [class] alarm in [A.name] has been cleared.", class, 0)
//		if (viewalerts) robot_alerts()
	return has_alarm

// Call when target overlay should be added/removed.
/mob/living/silicon/robot/update_targeted()
	if(!targeted_by && target_locked)
		qdel(target_locked)
	updateicon()
	if(targeted_by && target_locked)
		overlays.Add(target_locked)

// setup the PDA and its name
/mob/living/silicon/robot/proc/setup_PDA()
	if(isnull(rbPDA))
		rbPDA = new /obj/item/pda/ai(src)
	rbPDA.set_name_and_job(custom_name, "[model.display_name] [braintype]")

/mob/living/silicon/robot/proc/updatename()
	if(istype(mmi, /obj/item/mmi/posibrain))
		braintype = "Android"
	else
		braintype = "Cyborg"

	var/changed_name = ""
	if(custom_name)
		changed_name = custom_name
	else
		changed_name = "[model.display_name] [braintype]-[num2text(ident)]"
	real_name = changed_name
	name = real_name

	// if we've changed our name, we also need to update the display name for our PDA
	setup_PDA()

	//We also need to update name of internal camera.
	if(isnotnull(camera))
		camera.c_tag = changed_name

	if(!custom_sprite) //Check for custom sprite
		var/file = file2text("config/custom_sprites.txt")
		var/lines = splittext(file, "\n")

		for(var/line in lines)
		// split & clean up
			var/list/Entry = splittext(line, "-")
			for(var/i = 1 to length(Entry))
				Entry[i] = trim(Entry[i])

			if(length(Entry) < 2)
				continue;

			if(Entry[1] == ckey && Entry[2] == real_name) // They're in the list? Custom sprite time, var and icon change required.
				custom_sprite = TRUE
				icon = 'icons/mob/silicon/custom-synthetic.dmi'
				if(icon_state == "robot")
					icon_state = "[ckey]-Standard"

// this function displays jetpack pressure in the stat panel
/mob/living/silicon/robot/proc/show_jetpack_pressure()
	// if you have a jetpack, show the internal tank pressure
	var/obj/item/tank/jetpack/current_jetpack = installed_jetpack()
	if(isnotnull(current_jetpack))
		stat("Internal Atmosphere Info", current_jetpack.name)
		stat("Tank Pressure", current_jetpack.air_contents.return_pressure())

// this function returns the robots jetpack, if one is installed
/mob/living/silicon/robot/proc/installed_jetpack()
	if(isnotnull(model))
		return (locate(/obj/item/tank/jetpack) in model.modules)
	return null

// this function displays the cyborgs current cell charge in the stat panel
/mob/living/silicon/robot/proc/show_cell_power()
	if(isnotnull(cell))
		stat(null, "Charge Left: [cell.charge]/[cell.maxcharge]")
	else
		stat(null, "No Cell Inserted!")

/mob/living/silicon/robot/proc/allowed(mob/M)
	//check if it doesn't require any access at all
	if(check_access(null))
		return 1
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//if they are holding or wearing a card that has access, that works
		if(check_access(H.get_active_hand()) || check_access(H.id_store))
			return 1
	else if(ismonkey(M))
		var/mob/living/carbon/monkey/george = M
		//they can only hold things :(
		if(george.get_active_hand() && istype(george.get_active_hand(), /obj/item/card/id) && check_access(george.get_active_hand()))
			return 1
	return 0

/mob/living/silicon/robot/proc/check_access(obj/item/card/id/I)
	if(!islist(req_access)) //something's very wrong
		return 1

	var/list/L = req_access
	if(!length(L)) //no requirements
		return 1
	if(!I || !istype(I, /obj/item/card/id) || !I.access) //not ID or no access
		return 0
	for(var/req in req_access)
		if(!(req in I.access)) //doesn't have this access
			return 0
	return 1

/mob/living/silicon/robot/Topic(href, href_list)
	. = ..()
	if(href_list["mach_close"])
		var/t1 = "window=[href_list["mach_close"]]"
		unset_machine()
		src << browse(null, t1)
		return

	if(href_list["showalerts"])
		robot_alerts()
		return

	if(href_list["mod"])
		var/obj/item/O = locate(href_list["mod"])
		if(isnotnull(O))
			O.attack_self(src)

	if(href_list["act"])
		var/obj/item/O = locate(href_list["act"])
		if(activated(O))
			to_chat(src, "Module already activated.")
			return
		if(isnull(module_state_1))
			module_state_1 = O
			O.layer_to_hud()
			contents.Add(O)
			if(istype(module_state_1, /obj/item/robot_module/sight))
				var/obj/item/robot_module/sight/sight = module_state_1
				sight_mode |= sight.sight_mode
		else if(isnull(module_state_2))
			module_state_2 = O
			O.layer_to_hud()
			contents.Add(O)
			if(istype(module_state_2, /obj/item/robot_module/sight))
				var/obj/item/robot_module/sight/sight = module_state_2
				sight_mode |= sight.sight_mode
		else if(isnull(module_state_3))
			module_state_3 = O
			O.layer_to_hud()
			contents.Add(O)
			if(istype(module_state_3, /obj/item/robot_module/sight))
				var/obj/item/robot_module/sight/sight = module_state_3
				sight_mode |= sight.sight_mode
		else
			to_chat(src, "You need to disable a module first!")
		installed_modules()

	if(href_list["deact"])
		var/obj/item/O = locate(href_list["deact"])
		if(activated(O))
			if(module_state_1 == O)
				module_state_1 = null
				contents.Remove(O)
			else if(module_state_2 == O)
				module_state_2 = null
				contents.Remove(O)
			else if(module_state_3 == O)
				module_state_3 = null
				contents.Remove(O)
			else
				to_chat(src, "Module isn't activated.")
		else
			to_chat(src, "Module isn't activated.")
		installed_modules()

/mob/living/silicon/robot/proc/radio_menu()
	radio.interact(src) // Just use the radio's Topic() instead of bullshit special-snowflake code.

/mob/living/silicon/robot/proc/self_destruct()
	gib()