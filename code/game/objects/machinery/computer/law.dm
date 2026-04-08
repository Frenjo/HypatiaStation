//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/ai_upload
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI."
	icon_state = "command"
	circuit = /obj/item/circuitboard/ai_upload
	var/mob/living/silicon/ai/current = null
	var/opened = 0

/obj/machinery/computer/ai_upload/verb/AccessInternals()
	set category = null
	set name = "Access Computer's Internals"
	set src in oview(1)

	if(!in_range(src, usr) || usr.restrained() || usr.lying || usr.stat || issilicon(usr))
		return

	opened = !opened
	to_chat(usr, SPAN_INFO("The access panel is now [opened ? "open" : "closed"]."))

/obj/machinery/computer/ai_upload/attack_by(obj/item/I, mob/user)
	if(isnotcontactlevel(user.z))
		to_chat(user, "[SPAN_DANGER("Unable to establish a connection")][SPAN_WARNING(":")] You're too far away from the station!")
		return TRUE
	var/area/current_area = GET_AREA(src)
	if(!HAS_AREA_FLAGS(current_area, AREA_FLAG_IS_SILICON_UPLOAD))
		to_chat(user, "[SPAN_DANGER("Unable to establish a connection")][SPAN_WARNING(":")] There is no silicon upload link in this area!")
		return TRUE

	if(istype(I, /obj/item/ai_module))
		var/obj/item/ai_module/M = I
		M.install(src)
		return TRUE
	return ..()

/obj/machinery/computer/ai_upload/attack_hand(mob/user)
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] has no power!"))
		return
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("\The [src] is broken!"))
		return
	var/area/current_area = GET_AREA(src)
	if(!HAS_AREA_FLAGS(current_area, AREA_FLAG_IS_SILICON_UPLOAD))
		to_chat(user, "[SPAN_DANGER("Unable to establish a connection")][SPAN_WARNING(":")] There is no silicon upload link in this area!")
		return

	current = select_active_ai(user)

	if(!current)
		to_chat(user, SPAN_WARNING("No active AIs detected."))
	else
		to_chat(user, SPAN_INFO("[current.name] selected for law changes."))


/obj/machinery/computer/robot_upload
	name = "robot upload console"
	desc = "Used to upload laws to Robots."
	icon_state = "command"
	circuit = /obj/item/circuitboard/robot_upload
	var/mob/living/silicon/robot/current = null

/obj/machinery/computer/robot_upload/attack_by(obj/item/I, mob/user)
	if(isnotcontactlevel(user.z))
		to_chat(user, "[SPAN_DANGER("Unable to establish a connection")][SPAN_WARNING(":")] You're too far away from the station!")
		return TRUE
	var/area/current_area = GET_AREA(src)
	if(!HAS_AREA_FLAGS(current_area, AREA_FLAG_IS_SILICON_UPLOAD))
		to_chat(user, "[SPAN_DANGER("Unable to establish a connection")][SPAN_WARNING(":")] There is no silicon upload link in this area!")
		return TRUE

	if(istype(I, /obj/item/ai_module))
		var/obj/item/ai_module/module = I
		module.install(src)
		return TRUE
	return ..()

/obj/machinery/computer/robot_upload/attack_hand(mob/user)
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] has no power!"))
		return
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("\The [src] is broken!"))
		return
	var/area/current_area = GET_AREA(src)
	if(!HAS_AREA_FLAGS(current_area, AREA_FLAG_IS_SILICON_UPLOAD))
		to_chat(user, "[SPAN_DANGER("Unable to establish a connection")][SPAN_WARNING(":")] There is no silicon upload link in this area!")
		return

	current = freeborg()

	if(!current)
		to_chat(user, SPAN_WARNING("No free cyborgs detected."))
	else
		to_chat(user, SPAN_INFO("[current.name] selected for law changes."))