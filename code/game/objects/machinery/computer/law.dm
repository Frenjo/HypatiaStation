//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/aiupload
	name = "\improper AI upload"
	desc = "Used to upload laws to the AI."
	icon_state = "command"
	circuit = /obj/item/circuitboard/aiupload
	var/mob/living/silicon/ai/current = null
	var/opened = 0

/obj/machinery/computer/aiupload/verb/AccessInternals()
	set category = PANEL_OBJECT
	set name = "Access Computer's Internals"
	set src in oview(1)

	if(!in_range(src, usr) || usr.restrained() || usr.lying || usr.stat || issilicon(usr))
		return

	opened = !opened
	if(opened)
		usr << "\blue The access panel is now open."
	else
		usr << "\blue The access panel is now closed."
	return

/obj/machinery/computer/aiupload/attack_by(obj/item/I, mob/user)
	if(isnotcontactlevel(user.z))
		to_chat(user, "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!")
		return TRUE

	if(istype(I, /obj/item/ai_module))
		var/obj/item/ai_module/M = I
		M.install(src)
		return TRUE
	return ..()

/obj/machinery/computer/aiupload/attack_hand(mob/user)
	if(src.stat & NOPOWER)
		usr << "The upload computer has no power!"
		return
	if(src.stat & BROKEN)
		usr << "The upload computer is broken!"
		return

	src.current = select_active_ai(user)

	if (!src.current)
		usr << "No active AIs detected."
	else
		usr << "[src.current.name] selected for law changes."
	return


/obj/machinery/computer/borgupload
	name = "cyborg upload"
	desc = "Used to upload laws to Cyborgs."
	icon_state = "command"
	circuit = /obj/item/circuitboard/borgupload
	var/mob/living/silicon/robot/current = null

/obj/machinery/computer/borgupload/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/ai_module))
		var/obj/item/ai_module/module = I
		module.install(src)
		return TRUE
	return ..()

/obj/machinery/computer/borgupload/attack_hand(mob/user)
	if(src.stat & NOPOWER)
		usr << "The upload computer has no power!"
		return
	if(src.stat & BROKEN)
		usr << "The upload computer is broken!"
		return

	src.current = freeborg()

	if (!src.current)
		usr << "No free cyborgs detected."
	else
		usr << "[src.current.name] selected for law changes."
	return