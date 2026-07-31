//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/law_upload/attack_hand(mob/user)
	if(stat & NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] has no power!"))
		return FALSE
	if(stat & BROKEN)
		to_chat(user, SPAN_WARNING("\The [src] is broken!"))
		return FALSE
	var/area/current_area = GET_AREA(src)
	if(!HAS_AREA_FLAGS(current_area, AREA_FLAG_HAS_SECURE_NETWORK_ACCESS))
		to_chat(user, "[SPAN_DANGER("Unable to establish a connection")][SPAN_WARNING(":")] There is no silicon upload link in this area!")
		return FALSE

/obj/machinery/computer/law_upload/attack_by(obj/item/I, mob/user)
	if(isnotcontactlevel(user.z))
		to_chat(user, "[SPAN_DANGER("Unable to establish a connection")][SPAN_WARNING(":")] You're too far away from the station!")
		return TRUE
	var/area/current_area = GET_AREA(src)
	if(!HAS_AREA_FLAGS(current_area, AREA_FLAG_HAS_SECURE_NETWORK_ACCESS))
		to_chat(user, "[SPAN_DANGER("Unable to establish a connection")][SPAN_WARNING(":")] There is no silicon upload link in this area!")
		return TRUE

	if(istype(I, /obj/item/ai_module))
		var/obj/item/ai_module/M = I
		M.install(src)
		return TRUE
	return ..()

/obj/machinery/computer/law_upload/ai
	name = "\improper AI upload console"
	desc = "Used to upload laws to the AI. It will only function in areas with secure network access."
	icon_state = "command"
	circuit = /obj/item/circuitboard/ai_upload

	var/mob/living/silicon/ai/current = null

/obj/machinery/computer/law_upload/ai/attack_hand(mob/user)
	. = ..()
	if(!.)
		return FALSE

	current = select_active_ai(user)
	if(isnull(current))
		to_chat(user, SPAN_WARNING("No active AIs detected."))
	else
		to_chat(user, SPAN_INFO("[current.name] selected for law changes."))

/obj/machinery/computer/law_upload/robot
	name = "robot upload console"
	desc = "Used to upload laws to Robots. It will only function in areas with secure network access."
	icon_state = "command"
	circuit = /obj/item/circuitboard/robot_upload

	var/mob/living/silicon/robot/current = null

/obj/machinery/computer/law_upload/robot/attack_hand(mob/user)
	. = ..()
	if(!.)
		return FALSE

	current = freeborg()
	if(isnull(current))
		to_chat(user, SPAN_WARNING("No free cyborgs detected."))
	else
		to_chat(user, SPAN_INFO("[current.name] selected for law changes."))