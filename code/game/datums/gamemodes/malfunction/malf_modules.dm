// TO DO:
/*
epilepsy flash on lights
delay round message
microwave makes robots
dampen radios
reactivate cameras - done
eject engine
core sheild
cable stun
rcd light flash thingy on matter drain
*/

/datum/malf_module
	var/uses = 0
	var/module_name
	var/mod_pick_name
	var/description = ""
	var/engaged = 0

/datum/malf_module/large
	uses = 1

/datum/malf_module/small
	uses = 5

/*
 * Fireproof Core
 */
/datum/malf_module/large/fireproof_core
	module_name = "Core Fireproof Upgrade"
	mod_pick_name = "coreup"

/client/proc/fireproof_core()
	set category = PANEL_MALFUNCTION
	set name = "Fireproof Core"

	for(var/mob/living/silicon/ai/ai in GLOBL.player_list)
		ai.fire_res_on_core = TRUE
	usr.verbs.Remove(/client/proc/fireproof_core)
	to_chat(usr, SPAN_WARNING("Core fireproofed."))

/*
 * Upgrade Turrets
 */
/datum/malf_module/large/upgrade_turrets
	module_name = "AI Turret Upgrade"
	mod_pick_name = "turret"

/client/proc/upgrade_turrets()
	set category = PANEL_MALFUNCTION
	set name = "Upgrade Turrets"

	usr.verbs -= /client/proc/upgrade_turrets
	for(var/obj/machinery/turret/turret in GLOBL.player_list)
		turret.health += 30
		turret.shot_delay = 20

/*
 * RCD Disable
 */
/datum/malf_module/large/disable_rcd
	module_name = "RCD Disable"
	mod_pick_name = "rcd"

/client/proc/disable_rcd()
	set category = PANEL_MALFUNCTION
	set name = "Disable RCDs"

	if(!isAI(usr))
		return
	var/mob/living/silicon/ai/malf = usr

	for(var/datum/malf_module/large/disable_rcd/rcdmod in malf.current_modules)
		if(rcdmod.uses > 0)
			rcdmod.uses --
			for(var/obj/item/rcd/rcd in GLOBL.movable_atom_list)
				rcd.disabled = TRUE
			for(var/obj/item/mecha_equipment/tool/rcd/rcd in GLOBL.movable_atom_list)
				rcd.disabled = TRUE
			to_chat(usr, "RCD-disabling pulse emitted.")
		else
			to_chat(usr, "Out of uses.")

/*
 * Machine overload
 */
/datum/malf_module/small/overload_machine
	module_name = "Machine overload"
	mod_pick_name = "overload"
	uses = 2

/client/proc/overload_machine(obj/machinery/M as anything in global.PCmachinery.machines)
	set category = PANEL_MALFUNCTION
	set name = "Overload Machine"

	if(!isAI(usr))
		return
	var/mob/living/silicon/ai/malf = usr

	if(istype(M, /obj/machinery))
		for(var/datum/malf_module/small/overload_machine/overload in malf.current_modules)
			if(overload.uses > 0)
				overload.uses --
				M.visible_message(blind_message = SPAN_INFO("You hear a loud electrical buzzing sound!"))
				spawn(50)
					explosion(GET_TURF(M), 0, 1, 2, 3)
					qdel(M)
			else
				to_chat(usr, "Out of uses.")
	else
		to_chat(usr, "That's not a machine.")

/*
 * Blackout
 * (Basically overload lighting on all APCs.)
 */
/datum/malf_module/small/blackout
	module_name = "Blackout"
	mod_pick_name = "blackout"
	uses = 3

/client/proc/blackout()
	set category = PANEL_MALFUNCTION
	set name = "Blackout"

	if(!isAI(usr))
		return
	var/mob/living/silicon/ai/malf = usr

	for(var/datum/malf_module/small/blackout/blackout in malf.current_modules)
		if(blackout.uses > 0)
			blackout.uses --
			FOR_MACHINES_SUBTYPED(apc, /obj/machinery/power/apc)
				if(prob(30 * apc.overload))
					apc.overload_lighting()
				else apc.overload++
		else
			to_chat(usr, "Out of uses.")

/*
 * Hack Intercept
 */
/datum/malf_module/small/interhack
	module_name = "Hack intercept"
	mod_pick_name = "interhack"

/client/proc/interhack()
	set category = PANEL_MALFUNCTION
	set name = "Hack Intercept"

	if(!isAI(usr))
		return
	var/mob/living/silicon/ai/malf = usr

	if(!IS_GAME_MODE(/datum/game_mode/malfunction))
		return
	var/datum/game_mode/malfunction/malfunction = global.PCticker.mode

	malf.verbs.Remove(/client/proc/interhack)
	malfunction.hack_intercept()

/*
 * Reactivate Camera
 */
/datum/malf_module/small/reactivate_camera
	module_name = "Reactivate camera"
	mod_pick_name = "recam"
	uses = 10

/client/proc/reactivate_camera(obj/machinery/camera/C as obj in global.CTcameranet.cameras)
	set category = PANEL_MALFUNCTION
	set name = "Reactivate Camera"

	if(!isAI(usr))
		return
	var/mob/living/silicon/ai/malf = usr

	if(istype (C, /obj/machinery/camera))
		for(var/datum/malf_module/small/reactivate_camera/camera in malf.current_modules)
			if(camera.uses > 0)
				if(!C.status)
					C.status = !C.status
					camera.uses--
					C.visible_message(blind_message = SPAN_INFO("You hear a quiet click."))
				else
					to_chat(usr, "This camera is either active, or not repairable.")
			else
				to_chat(usr, "Out of uses.")
	else
		to_chat(usr, "That's not a camera.")

/*
 * Upgrade Camera
 */
/datum/malf_module/small/upgrade_camera
	module_name = "Upgrade Camera"
	mod_pick_name = "upgradecam"
	uses = 10

/client/proc/upgrade_camera(obj/machinery/camera/C as obj in global.CTcameranet.cameras)
	set category = PANEL_MALFUNCTION
	set name = "Upgrade Camera"

	if(!isAI(usr))
		return
	var/mob/living/silicon/ai/malf = usr

	if(istype(C))
		var/datum/malf_module/small/upgrade_camera/UC = locate(/datum/malf_module/small/upgrade_camera) in malf.current_modules
		if(UC)
			if(UC.uses > 0)
				if(C.assembly)
					var/upgraded = 0

					if(!C.isXRay())
						C.upgradeXRay()
						//Update what it can see.
						global.CTcameranet.update_visibility(C)
						upgraded = 1

					if(!C.isEmpProof())
						C.upgradeEmpProof()
						upgraded = 1

					if(!C.isMotion())
						C.upgradeMotion()
						upgraded = 1
						// Add it to machines that process
						global.PCmachinery.register_machine(C)

					if(upgraded)
						UC.uses --
						C.visible_message(SPAN_NOTICE("[html_icon(C)] *beep*"))
						to_chat(usr, "Camera successully upgraded!")
					else
						to_chat(usr, "This camera is already upgraded!")
			else
				to_chat(usr, "Out of uses.")

/*
 * Module Picker
 */
/datum/malf_module/module_picker
	var/temp = null
	var/processing_time = 100
	var/list/possible_modules = null

/datum/malf_module/module_picker/New()
	. = ..()
	possible_modules = list(
		new /datum/malf_module/large/fireproof_core(),
		new /datum/malf_module/large/upgrade_turrets(),
		new /datum/malf_module/large/disable_rcd(),
		new /datum/malf_module/small/overload_machine(),
		new /datum/malf_module/small/interhack(),
		new /datum/malf_module/small/blackout(),
		new /datum/malf_module/small/reactivate_camera(),
		new /datum/malf_module/small/upgrade_camera()
	)

/datum/malf_module/module_picker/proc/use(mob/user)
	var/dat
	if(temp)
		dat = "[temp]<BR><BR><A href='byond://?src=\ref[src];temp=1'>Clear</A>"
	else if(processing_time <= 0)
		dat = "<B> No processing time is left available. No more modules are able to be chosen at this time."
	else
		dat = "<B>Select use of processing time: (currently [processing_time] left.)</B><BR>"
		dat += "<HR>"
		dat += "<B>Install Module:</B><BR>"
		dat += "<I>The number afterwards is the amount of processing time it consumes.</I><BR>"
		for(var/datum/malf_module/large/module in possible_modules)
			dat += "<A href='byond://?src=\ref[src];[module.mod_pick_name]=1'>[module.module_name]</A> (50)<BR>"
		for(var/datum/malf_module/small/module in possible_modules)
			dat += "<A href='byond://?src=\ref[src];[module.mod_pick_name]=1'>[module.module_name]</A> (15)<BR>"
		dat += "<HR>"

	user << browse(dat, "window=modpicker")
	onclose(user, "modpicker")

/datum/malf_module/module_picker/Topic(href, href_list)
	. = ..()

	if(!isAI(usr))
		return
	var/mob/living/silicon/ai/malf = usr

	if(href_list["coreup"])
		var/already = FALSE
		for_no_type_check(var/datum/malf_module/mod, malf.current_modules)
			if(istype(mod, /datum/malf_module/large/fireproof_core))
				already = TRUE
		if(!already)
			malf.verbs.Add(/client/proc/fireproof_core)
			malf.current_modules.Add(new /datum/malf_module/large/fireproof_core())
			temp = "An upgrade to improve core resistance, making it immune to fire and heat. This effect is permanent."
			processing_time -= 50
		else
			temp = "This module is only needed once."

	else if(href_list["turret"])
		var/already = FALSE
		for_no_type_check(var/datum/malf_module/mod, malf.current_modules)
			if(istype(mod, /datum/malf_module/large/upgrade_turrets))
				already = TRUE
		if(!already)
			malf.verbs.Add(/client/proc/upgrade_turrets)
			malf.current_modules.Add(new /datum/malf_module/large/upgrade_turrets())
			temp = "Improves the firing speed and health of all AI turrets. This effect is permanent."
			processing_time -= 50
		else
			temp = "This module is only needed once."

	else if(href_list["rcd"])
		var/already = FALSE
		for_no_type_check(var/datum/malf_module/mod, malf.current_modules)
			if(istype(mod, /datum/malf_module/large/disable_rcd))
				mod.uses += 1
				already = TRUE
		if(!already)
			malf.verbs.Add(/client/proc/disable_rcd)
			malf.current_modules.Add(new /datum/malf_module/large/disable_rcd())
			temp = "Send a specialised pulse to break all RCD devices on the station."
		else
			temp = "Additional use added to RCD disabler."
		processing_time -= 50

	else if(href_list["overload"])
		var/already = FALSE
		for_no_type_check(var/datum/malf_module/mod, malf.current_modules)
			if(istype(mod, /datum/malf_module/small/overload_machine))
				mod.uses += 2
				already = TRUE
		if(!already)
			malf.verbs.Add(/client/proc/overload_machine)
			malf.current_modules.Add(new /datum/malf_module/small/overload_machine())
			temp = "Overloads an electrical machine, causing a small explosion. 2 uses."
		else
			temp = "Two additional uses added to Overload module."
		processing_time -= 15

	else if(href_list["blackout"])
		var/already = FALSE
		for_no_type_check(var/datum/malf_module/mod, malf.current_modules)
			if(istype(mod, /datum/malf_module/small/blackout))
				mod.uses += 3
				already = TRUE
		if(!already)
			malf.verbs.Add(/client/proc/blackout)
			malf.current_modules.Add(new /datum/malf_module/small/blackout())
			temp = "Attempts to overload the lighting circuits on the station, destroying some bulbs. 3 uses."
		else
			temp = "Three additional uses added to Blackout module."
		processing_time -= 15

	else if(href_list["interhack"])
		var/already = FALSE
		for_no_type_check(var/datum/malf_module/mod, malf.current_modules)
			if(istype(mod, /datum/malf_module/small/interhack))
				already = TRUE
		if(!already)
			malf.verbs.Add(/client/proc/interhack)
			malf.current_modules.Add(new /datum/malf_module/small/interhack())
			temp = "Hacks the status upgrade from CentCom, removing any information about malfunctioning electrical systems."
			processing_time -= 15
		else
			temp = "This module is only needed once."

	else if(href_list["recam"])
		var/already = FALSE
		for_no_type_check(var/datum/malf_module/mod, malf.current_modules)
			if(istype(mod, /datum/malf_module/small/reactivate_camera))
				mod.uses += 10
				already = TRUE
		if(!already)
			malf.verbs.Add(/client/proc/reactivate_camera)
			malf.current_modules.Add(new /datum/malf_module/small/reactivate_camera())
			temp = "Reactivates a currently disabled camera. 10 uses."
		else
			temp = "Ten additional uses added to ReCam module."
		processing_time -= 15

	else if(href_list["upgradecam"])
		var/already = FALSE
		for_no_type_check(var/datum/malf_module/mod, malf.current_modules)
			if(istype(mod, /datum/malf_module/small/upgrade_camera))
				mod.uses += 10
				already = TRUE
		if(!already)
			malf.verbs.Add(/client/proc/upgrade_camera)
			malf.current_modules.Add(new /datum/malf_module/small/upgrade_camera())
			temp = "Upgrades a camera to have X-Ray vision, Motion and be EMP-Proof. 10 uses."
		else
			temp = "Ten additional uses added to ReCam module."
		processing_time -= 15

	else
		if(href_list["temp"])
			temp = null

	use(usr)