//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/aiupload
	name = "AI Upload"
	desc = "Used to upload laws to the AI."
	icon_state = "command"
	circuit = /obj/item/circuitboard/aiupload
	var/mob/living/silicon/ai/current = null
	var/opened = 0

/obj/machinery/computer/aiupload/verb/AccessInternals()
	set category = PANEL_OBJECT
	set name = "Access Computer's Internals"
	set src in oview(1)

	if(get_dist(src, usr) > 1 || usr.restrained() || usr.lying || usr.stat || istype(usr, /mob/living/silicon))
		return

	opened = !opened
	if(opened)
		usr << "\blue The access panel is now open."
	else
		usr << "\blue The access panel is now closed."
	return

/obj/machinery/computer/aiupload/attackby(obj/item/O as obj, mob/user as mob)
	if (user.z > 6)
		user << "\red <b>Unable to establish a connection</b>: \black You're too far away from the station!"
		return
	if(istype(O, /obj/item/aiModule))
		var/obj/item/aiModule/M = O
		M.install(src)
	else
		..()

/obj/machinery/computer/aiupload/attack_hand(var/mob/user as mob)
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
	name = "Cyborg Upload"
	desc = "Used to upload laws to Cyborgs."
	icon_state = "command"
	circuit = /obj/item/circuitboard/borgupload
	var/mob/living/silicon/robot/current = null

/obj/machinery/computer/borgupload/attackby(obj/item/aiModule/module as obj, mob/user as mob)
	if(istype(module, /obj/item/aiModule))
		module.install(src)
	else
		return ..()

/obj/machinery/computer/borgupload/attack_hand(var/mob/user as mob)
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