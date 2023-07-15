/*
 * Security Circuit Boards
 */

/*
 * Computers
 */
/obj/item/circuitboard/security
	name = "circuit board (Security)"
	req_access = list(ACCESS_SECURITY)
	build_path = /obj/machinery/computer/security

	var/network = list("SS13")
	var/locked = TRUE
	var/emagged = FALSE

/obj/item/circuitboard/security/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/card/emag))
		if(emagged)
			to_chat(user, "The circuit lock has already been removed.")
			return
		to_chat(user, SPAN_INFO("You override the circuit lock and open the controls."))
		emagged = TRUE
		locked = FALSE
	else if(istype(I, /obj/item/card/id))
		if(emagged)
			to_chat(user, SPAN_WARNING("The circuit lock does not respond."))
			return
		if(check_access(I))
			locked = !locked
			to_chat(user, SPAN_INFO("You [locked ? "" : "un"]lock the circuit controls."))
		else
			FEEDBACK_ACCESS_DENIED(user)
	else if(istype(I, /obj/item/device/multitool))
		if(locked)
			to_chat(user, SPAN_WARNING("The circuit controls are locked."))
			return
		var/existing_networks = jointext(network,",")
		var/input = strip_html(input(usr, "Which networks would you like to connect this camera console circuit to? Separate networks with a comma. No Spaces!\nFor example: SS13,Security,Secret ", "Multitool-Circuitboard interface", existing_networks))
		if(!input)
			to_chat(user, "No input found. Please hang up and try your call again.")
			return
		var/list/tempnetwork = splittext(input, ",")
		tempnetwork = difflist(tempnetwork, GLOBL.restricted_camera_networks, 1)
		if(!length(tempnetwork))
			to_chat(user, "No network found. Please hang up and try your call again.")
			return
		network = tempnetwork

/obj/item/circuitboard/secure_data
	name = "circuit board (Security Records)"
	build_path = /obj/machinery/computer/secure_data

/obj/item/circuitboard/prisoner
	name = "circuit board (Prisoner Management)"
	build_path = /obj/machinery/computer/prisoner

/obj/item/circuitboard/prison_shuttle
	name = "circuit board (Prison Shuttle)"
	build_path = /obj/machinery/computer/shuttle_control/prison
	origin_tech = list(RESEARCH_TECH_PROGRAMMING = 2)