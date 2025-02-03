/*
 * Security Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/security
	name = "circuit board (security camera console)"
	req_access = list(ACCESS_SECURITY)
	build_path = /obj/machinery/computer/security

	var/network = list("SS13")
	var/locked = TRUE
	var/emagged = FALSE

/obj/item/circuitboard/security/attack_emag(obj/item/card/emag/emag, mob/user, uses)
	if(emagged)
		to_chat(user, SPAN_WARNING("The circuit lock has already been removed!"))
		return FALSE
	to_chat(user, SPAN_WARNING("You override the circuit lock and open the controls."))
	emagged = TRUE
	locked = FALSE
	return TRUE

/obj/item/circuitboard/security/attack_tool(obj/item/tool, mob/user)
	if(ismultitool(tool))
		if(locked)
			to_chat(user, SPAN_WARNING("The circuit controls are locked."))
			return TRUE
		var/existing_networks = jointext(network, ",")
		var/input = strip_html(input(usr, "Which networks would you like to connect this camera console circuit to? Separate networks with a comma. No Spaces!\nFor example: SS13,Security,Secret ", "Multitool-Circuitboard Interface", existing_networks))
		if(isnull(input))
			to_chat(user, SPAN_WARNING("No input found. Please hang up and try your call again."))
			return TRUE
		var/list/tempnetwork = splittext(input, ",")
		tempnetwork = difflist(tempnetwork, GLOBL.restricted_camera_networks, 1)
		if(!length(tempnetwork))
			to_chat(user, SPAN_WARNING("No network found. Please hang up and try your call again."))
			return TRUE
		network = tempnetwork
		return TRUE

	return ..()

/obj/item/circuitboard/security/attack_by(obj/item/I, mob/user)
	if(istype(I, /obj/item/card/id))
		if(emagged)
			to_chat(user, SPAN_WARNING("The circuit lock does not respond."))
			return TRUE
		if(check_access(I))
			locked = !locked
			to_chat(user, SPAN_INFO("You [locked ? "" : "un"]lock the circuit controls."))
		else
			FEEDBACK_ACCESS_DENIED(user)
		return TRUE

	return ..()

/obj/item/circuitboard/secure_data
	name = "circuit board (security records)"
	build_path = /obj/machinery/computer/secure_data

/obj/item/circuitboard/prisoner
	name = "circuit board (prisoner management)"
	build_path = /obj/machinery/computer/prisoner

/obj/item/circuitboard/prison_shuttle
	name = "circuit board (prison shuttle control console)"
	build_path = /obj/machinery/computer/shuttle_control/prison